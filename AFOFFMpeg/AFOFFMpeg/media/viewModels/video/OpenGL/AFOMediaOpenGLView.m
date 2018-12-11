//
//  AFOMediaOpenGLView.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/2/3.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOMediaOpenGLView.h"

#define VERTEX_ATTRIBUTE_POSITION   0
#define VERTEX_ATTRIBUTE_TEXCOORD   1

@interface  AFOMediaOpenGLView (){
    GLfloat          vertices[8];
    GLfloat          position[8];
    GLfloat          texcoord[8];
}
/**
 上下文
 */
@property (nonatomic, strong)   EAGLContext     *context;

/**
 显示任意的OpenGL图形
 */
@property (nonatomic, strong)   CAEAGLLayer     *eaglLayer;
/**
 帧缓冲区
 */
@property (nonatomic, assign)   GLuint           frameBuffer;
/**
 渲染缓冲区
 */
@property (nonatomic, assign)   GLuint           renderBuffer;
/**
 渲染程序
 */
@property (nonatomic, assign)   GLuint           program;
@property (nonatomic, assign)   GLint            backingWidth;
@property (nonatomic, assign)   GLint            backingHeight;
@property (nonatomic, assign)   GLint            uniformMatrix;
@property (nonatomic, assign)   GLint            positionSlot;
@property (nonatomic, assign)   GLint            projection;
@property (nonatomic, assign)   GLint            programHandle;
@property (nonatomic, assign)   BOOL             isYUV;
@end

@implementation AFOMediaOpenGLView
#pragma mark ------------   layerClass
+ (Class) layerClass
{
    return [CAEAGLLayer class];
}
#pragma mark ------------   init
- (instancetype)init{
    if (self = [super init]) {
        if (! [self settingGLView]) {
            self = nil;
            return nil;
        }
    }
    return self;
}
#pragma mark ------------   initWithFrame
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        if (![self settingGLView]) {
//            self = nil;
//            return nil;
//        };
    }
    return self;
}
#pragma mark ------
- (BOOL)settingGLView{
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
    _eaglLayer.drawableProperties = @{ kEAGLDrawablePropertyRetainedBacking : @(NO),
                                      kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8
                                      };
    ///------
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (! _context) {
        return NO;
    }
    if (! [EAGLContext setCurrentContext:_context]) {
        return NO;
    }
    ///------
    [self initVertex];
    ///------
    [self initTexCord];
    
    return YES;
}
#pragma mark ------ init Vertex
- (void)initVertex{
    position[0] = -1.0f;  // x0
    position[1] = -1.0f;  // y0
    position[2] =  1.0f;  // ..
    position[3] = -1.0f;
    position[4] = -1.0f;
    position[5] =  1.0f;
    position[6] =  1.0f;  // x3
    position[7] =  1.0f;  // y3
}
#pragma mark ------ init TexCord
- (void)initTexCord{
    texcoord[0] = 0;
    texcoord[1] = 1;
    texcoord[2] = 1;
    texcoord[3] = 1;
    texcoord[4] = 0;
    texcoord[5] = 0;
    texcoord[6] = 1;
    texcoord[7] = 0;
}
#pragma mark ------ layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    [self deleteGLBuffer];
    [self deleteGLProgram];
}
#pragma mark ------
- (void)deleteGLBuffer{
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    ///------
    if (_renderBuffer) {
        glDeleteRenderbuffers(1, &_renderBuffer);
        _renderBuffer = 0;
    }
}
#pragma mark ------
- (void)deleteGLProgram{
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}
#pragma mark ------
- (void)createGLBuffer{
    // render buffer
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    
    // frame buffer
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
}
#pragma mark ------
- (void)createGLProgram{
    // Create program
    GLuint program = glCreateProgram();
    if (program == 0) {
        NSLog(@"FAILED to create program.");
        return;
    }
    
    // Load shaders
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *vertexShaderFile = [NSBundle imageNameFromBundle:@"AFOPlayer.bundle" source:@"AFOPlayerVertexShader.glsl"];
    GLuint vertexShader = [AFOMediaOpenGLView loadShader:GL_VERTEX_SHADER withFile:vertexShaderFile];
    NSString *fragmentShaderResource = _isYUV ? @"DLGPlayerYUVFragmentShader" : @"DLGPlayerRGBFragmentShader";
    NSString *fragmentShaderFile = [bundle pathForResource:fragmentShaderResource ofType:@"glsl"];
    GLuint fragmentShader = [AFOMediaOpenGLView loadShader:GL_FRAGMENT_SHADER withFile:fragmentShaderFile];
    
    // Attach shaders
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    // Bind
    glBindAttribLocation(program, VERTEX_ATTRIBUTE_POSITION, "position");
    glBindAttribLocation(program, VERTEX_ATTRIBUTE_TEXCOORD, "texcoord");
    
    // Link program
    glLinkProgram(program);
    
    // Check status
    GLint linked = 0;
    glGetProgramiv(program, GL_LINK_STATUS, &linked);
    if (linked == 0) {
        GLint length = 0;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &length);
        if (length > 1) {
            char *log = malloc(sizeof(char) * length);
            glGetProgramInfoLog(program, length, NULL, log);
            NSLog(@"FAILED to link program, error: %s", log);
            free(log);
        }
        
        glDeleteProgram(program);
        return;
    }
    
    glUseProgram(program);
    
    _positionSlot = glGetAttribLocation(program, "position");
    _projection = glGetUniformLocation(program, "projection");
    _programHandle = program;
}
#pragma mark ------
+ (GLuint)loadShader:(GLenum)type withString:(NSString *)shaderString {
    // 1. Create shader
    GLuint shader = glCreateShader(type);
    if (shader == 0) {
        NSLog(@"FAILED to create shader.");
        return 0;
    }
    
    // 2. Load shader source
    const char *shaderUTF8String = [shaderString UTF8String];
    glShaderSource(shader, 1, &shaderUTF8String, NULL);
    
    // 3. Compile shader
    glCompileShader(shader);
    
    // 4. Check status
    GLint compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    
    if (compiled == 0) {
        GLint length = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &length);
        if (length > 1) {
            char *log = malloc(sizeof(char) * length);
            glGetShaderInfoLog(shader, length, NULL, log);
            NSLog(@"FAILED to compile shader, error: %s", log);
            free(log);
        }
        glDeleteShader(shader);
        return 0;
    }
    
    return shader;
}
+ (GLuint)loadShader:(GLenum)type withFile:(NSString *)shaderFile {
    NSError *error = nil;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderFile encoding:NSUTF8StringEncoding error:&error];
    if (shaderString == nil) {
        NSLog(@"FAILED to load shader file: %@, Error: %@", shaderFile, error);
        return 0;
    }
    
    return [self loadShader:type withString:shaderString];
}
#pragma mark ------ free
- (void)free{
    ///------
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    ///------
    if (_renderBuffer) {
        glDeleteRenderbuffers(1, &_renderBuffer);
        _renderBuffer = 0;
    }
    ///------
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
    ///------
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
    _context = nil;
}
#pragma mark ------------
- (void)dealloc{
    NSLog(@"dealloc AFOMediaOpenGLView");
    [self free];
}
@end
