//
//  AFOAudioOutPut.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/6.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOAudioOutPut.h"
#import <AudioToolbox/AudioToolbox.h>
static const AudioUnitElement inputElement = 1;
@interface AFOAudioOutPut (){
    SInt16 *outData;
}
@property (nonatomic, assign) Float64       sampleRate;
@property (nonatomic, assign) Float64       channel;
@property (nonatomic, assign) AUGraph       auGraph;
@property (nonatomic, assign) AUNode        ioNNode;
@property (nonatomic, assign) AudioUnit     ioUnit;
@property (nonatomic, assign) AUNode        convertNote;
@property (nonatomic, assign) AudioUnit     convertUnit;
@property (nonatomic, weak) id<AFOAudioFillDataDelegate> delegate;
@end

@implementation AFOAudioOutPut
- (instancetype)initWithChannel:(NSInteger)channel
                     sampleRate:(NSInteger)sampleRate
                 bytesPerSample:(NSInteger)bytesPerSample
                       delegate:(id<AFOAudioFillDataDelegate>)delegate{
    if (self = [super init]) {
        outData = (SInt16 *)calloc(8*1024, sizeof(SInt16));
        _delegate = delegate;
        _sampleRate = sampleRate;
        _channel = channel;
        [self createAudioUnitGrap];
    }
    return self;
}
#pragma mark ------ method
- (void)createAudioUnitGrap{
    OSStatus status = noErr;
    status = NewAUGraph(&_auGraph);
    CheckStatus(status, @"NewAUGraph create Error", YES);
    ///---
    status = AUGraphOpen(_auGraph);
    CheckStatus(status, @"AUGraphOpen open Error", YES);
    ///---
    [self createAudioUnitNodes];
    ///---
    [self createAudioUnitProPerties];
    ///---
    [self createNodeConnections];
    ///---
    CAShow(_auGraph);
    status = AUGraphInitialize(_auGraph);
    CheckStatus(status, @"Could not initialize AUGraph", YES);
}
#pragma mark ------ Step 1: create an audio component description
- (void)createAudioUnitNodes{
    OSStatus status = noErr;
    
    AudioComponentDescription ioDescription;
    bzero(&ioDescription, sizeof(ioDescription));
    ioDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    ioDescription.componentType = kAudioUnitType_Output;
    ioDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    
    status = AUGraphAddNode(_auGraph,
                            &ioDescription,
                            &_ioNNode);
    CheckStatus(status, @"AUGraphAddNode create error", YES);
    
    status = AUGraphNodeInfo(_auGraph, _ioNNode, NULL, &_ioUnit);
    CheckStatus(status, @"AUGraphNodeInfo _ioUnit Error", YES);
    ///---
    AudioComponentDescription converDescription;
    bzero(&converDescription, sizeof(converDescription));
    converDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    converDescription.componentType = kAudioUnitType_FormatConverter;
    converDescription.componentSubType = kAudioUnitSubType_AUConverter;
    
    status = AUGraphAddNode(_auGraph,
                            &converDescription,
                            &_convertNote);
    CheckStatus(status, @"AUGraphAddNode _convertNote create error", YES);
    
    status = AUGraphNodeInfo(_auGraph, _convertNote, NULL, &_convertUnit);
    CheckStatus(status, @"AUGraphNodeInfo _convertUnit Error", YES);
}
#pragma mark ------ Step 2: create audioUnit ProPerties
- (void)createAudioUnitProPerties{
    OSStatus status = noErr;
    
    AudioStreamBasicDescription streamFormat = [self nonInterleavedPCMFormatWithChannels:_channel];
    status = AudioUnitSetProperty(_ioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  inputElement,
                                  &streamFormat,
                                  sizeof(streamFormat));
    CheckStatus(status, @"Could not set stream format on I/O unit output scope", YES);
    
    AudioStreamBasicDescription _clientFormat16int;
    UInt32 bytesPersample = sizeof(SInt16);
    bzero(&_clientFormat16int, sizeof(_clientFormat16int));
    _clientFormat16int.mFormatID = kAudioFormatLinearPCM;
    _clientFormat16int.mSampleRate = _sampleRate;
    _clientFormat16int.mChannelsPerFrame = _channel;
    _clientFormat16int.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    _clientFormat16int.mFramesPerPacket = 1;
    _clientFormat16int.mBytesPerPacket = bytesPersample * _channel;
    _clientFormat16int.mBytesPerFrame = bytesPersample * _channel;
    _clientFormat16int.mBitsPerChannel = 8 * bytesPersample;
    
    status = AudioUnitSetProperty(_convertUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &streamFormat, sizeof(streamFormat));
    CheckStatus(status, @"augraph recorder normal unit set client format error", YES);
    
    status = AudioUnitSetProperty(_convertUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &_clientFormat16int, sizeof(_clientFormat16int));
    CheckStatus(status, @"augraph recorder normal unit set client format error", YES);
}
- (AudioStreamBasicDescription)nonInterleavedPCMFormatWithChannels:(UInt32)channels{
    UInt32 bytesPerSample = sizeof(Float32);
    AudioStreamBasicDescription asbd;
    bzero(&asbd, sizeof(asbd));
    asbd.mSampleRate = _sampleRate;
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    asbd.mBitsPerChannel = 8*bytesPerSample;
    asbd.mBytesPerFrame = bytesPerSample;
    asbd.mBytesPerPacket = bytesPerSample;
    asbd.mFramesPerPacket = 1;
    asbd.mChannelsPerFrame = channels;
    return asbd;
}
#pragma mark --- Step 3: create callback function
- (void)createNodeConnections{
    OSStatus status = noErr;

    status = AUGraphConnectNodeInput(_auGraph, _convertNote, 0, _ioNNode, 0);
    CheckStatus(status, @"Could not connect I/O node input to mixer node input", YES);
    
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = &renderCallback;
    callbackStruct.inputProcRefCon = (__bridge void *)self;
    
    status = AudioUnitSetProperty(_convertUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &callbackStruct, sizeof(callbackStruct));
    CheckStatus(status, @"Could not set render callback on mixer input scope, element 1", YES);
}
static OSStatus renderCallback(void * inRefCon,
                                      AudioUnitRenderActionFlags *    ioActionFlags,
                                      const AudioTimeStamp *            inTimeStamp,
                                      UInt32                            inBusNumber,
                                      UInt32                            inNumberFrames,
                                      AudioBufferList * __nullable    ioData){
    AFOAudioOutPut *audioOutput = (__bridge id)inRefCon;
    return [audioOutput renderData:ioData
                       atTimeStamp:inTimeStamp
                        forElement:inBusNumber
                      numberFrames:inNumberFrames
                             flags:ioActionFlags];
}
- (OSStatus)renderData:(AudioBufferList *)ioData
           atTimeStamp:(const AudioTimeStamp *)timeStamp
            forElement:(UInt32)element
          numberFrames:(UInt32)numFrames
                 flags:(AudioUnitRenderActionFlags *)flags{
    for (int iBuffer = 0; iBuffer < ioData->mNumberBuffers; ++iBuffer) {
    memset(ioData->mBuffers[iBuffer].mData, 0, ioData->mBuffers[iBuffer].mDataByteSize);
    }
    ///---
    if (_delegate) {
        [_delegate fillAudioData:outData frames:numFrames channels:_channel];
        for (int iBuffer = 0; iBuffer < ioData->mNumberBuffers;  ++iBuffer) {
            memcpy((SInt16 *)ioData->mBuffers[iBuffer].mData, outData, ioData->mBuffers[iBuffer].mDataByteSize);
        }
    }
    return noErr;
}
- (BOOL)audioPlay{
    OSStatus status = AUGraphStart(_auGraph);
    CheckStatus(status, @"Could not start AUGraph", YES);
    return YES;
}
- (void)audioStop{
    OSStatus status = AUGraphStop(_auGraph);
    AudioOutputUnitStop(_ioUnit);
    AudioOutputUnitStop(_convertUnit);
    CheckStatus(status, @"Could not stop AUGraph", YES);
}
#pragma mark ------ C language method
static void CheckStatus(OSStatus status, NSString *message, BOOL fatal){
    if(status != noErr){
        char fourCC[16];
        *(UInt32 *)fourCC = CFSwapInt32HostToBig(status);
        fourCC[4] = '\0';
        
        if(isprint(fourCC[0]) && isprint(fourCC[1]) && isprint(fourCC[2]) && isprint(fourCC[3])){
            NSLog(@"%@: %s", message, fourCC);
        }else{
            NSLog(@"%@: %d", message, (int)status);
        }
        if(fatal){
            exit(-1);
        }
    }
}
@end
