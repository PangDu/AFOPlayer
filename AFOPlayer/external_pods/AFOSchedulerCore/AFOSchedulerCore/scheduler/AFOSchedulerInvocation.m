//
//  AFOSchedulerInvocation.m
//  AFORouter
//
//  Created by xianxueguang on 2019/10/9.
//  Copyright © 2019年 AFO. All rights reserved.
//

#import "AFOSchedulerInvocation.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
//---
#define CompareTypeAndReturn(type) \
if (strcmp(returnType, @encode(type)) == 0) {\
type result = 0;\
[invocation getReturnValue:&result];\
}
//---
#define CompareTypeAndSetArgument(type,typeValue) \
else if (strcmp(currentArgumentType, @encode(type)) == 0){\
type argumentValue = [(NSNumber *)obj typeValue];\
[invocation setArgument:&argumentValue atIndex:(2 + idx)];\
}
@interface AFOSchedulerInvocation ()

@end

@implementation AFOSchedulerInvocation
+ (instancetype)shareSchedulerCore{
    static AFOSchedulerInvocation *schedulerCore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schedulerCore = [[self alloc]init];
    });
    return schedulerCore;
}
#pragma mark ------ 实例方法
- (nullable id)schedulerInstanceMethod:(nonnull SEL)method
                                target:(nonnull id)target
                                params:(NSArray *)params{
    __block NSError *result;
    [self schedulerInvocationMethodTarget:target selector:method params:params block:^(NSError *error) {
        result = error;
    }];
    return result;
}
#pragma mark ------ 类方法
- (nullable id)schedulerClassMethod:(nonnull SEL)method
                             target:(nonnull char *)target
                             params:(NSArray *)params{
    Class class = [self getClassForName:target];
    return [self schedulerInstanceMethod:method target:class params:params];
}
- (nullable Class)getClassForName:(nonnull char*)className{
    if (className == nil || className ==NULL) {
        return nil;
    }
    Class class = objc_getClass(className);
    if (class == nil) {
        return nil;
    }
    return class;
}
#pragma mark ------ NSInvocation
- (void)schedulerInvocationMethodTarget:(id)target
                               selector:(SEL)selector
                                 params:(NSArray *)params
                                  block:(void(^)(NSError *error))block{
    [self schedulerCheckErrorForMethod:selector target:target params:params block:^(NSError *error) {
        if (error.code != AFO_SCHEDULER_ERROR_CODES_NONE) {
            block(error);
        }
    }];
    //---
    __block NSMethodSignature *method;
    [self schedulerTarget:target selector:selector params:params MethodSignature:^(NSError *error, NSMethodSignature *signature) {
        if (error.code != AFO_SCHEDULER_ERROR_CODES_METHODSIGNATURE_SECESS) {
            block(error);
        }else{
            method = signature;
        }
    }];
    //---
    const char *returnType = [method methodReturnType];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:method];
    //---返回基本数据类型
    [self settingReturnType:returnType invocation:invocation];
    //---设置参数
    [params enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == [NSNull null]) {
            obj = nil;
        }
        const char *currentArgumentType = [method getArgumentTypeAtIndex:2 + idx];
        if (strcmp(currentArgumentType, @encode(id)) == 0){
            // 入参是对象类型的处理 非 number
            [invocation setArgument:&obj atIndex:(2 + idx)];
        }else if (strcmp(currentArgumentType, @encode(CGFloat)) == 0){
#if defined(__LP64__) && __LP64__
            CGFloat argumentValue = [(NSNumber *)obj doubleValue];
#else
            CGFloat argumentValue = [(NSNumber *)obj floatValue];
#endif
            [invocation setArgument:&argumentValue atIndex:(2 + idx)];
        }
        //---基本数据类型
        CompareTypeAndSetArgument(int, intValue)
        CompareTypeAndSetArgument(BOOL, boolValue)
        CompareTypeAndSetArgument(NSInteger, integerValue)
        CompareTypeAndSetArgument(long long, longLongValue)
        CompareTypeAndSetArgument(float, floatValue)
        CompareTypeAndSetArgument(double, doubleValue)
        CompareTypeAndSetArgument(short, shortValue)
        CompareTypeAndSetArgument(unsigned short, unsignedShortValue)
        CompareTypeAndSetArgument(unsigned int, unsignedIntValue)
        CompareTypeAndSetArgument(NSUInteger, unsignedIntegerValue)
        CompareTypeAndSetArgument(unsigned long long, unsignedLongLongValue)
        CompareTypeAndSetArgument(char, charValue)
        CompareTypeAndSetArgument(unsigned char, unsignedCharValue)
        else{
            [invocation setArgument:&obj atIndex:(2 + idx)];
        }
    }];
    //---
    [invocation setSelector:selector];
    [invocation setTarget:target];
    [invocation invoke];
}
- (void)settingReturnType:(const char *)returnType
               invocation:(NSInvocation *)invocation{
    CompareTypeAndReturn(NSInteger)
    CompareTypeAndReturn(NSUInteger)
    CompareTypeAndReturn(CGFloat)
    CompareTypeAndReturn(char)
    CompareTypeAndReturn(short)
    CompareTypeAndReturn(float)
    CompareTypeAndReturn(double)
    CompareTypeAndReturn(long long)
    CompareTypeAndReturn(BOOL)
    CompareTypeAndReturn(unsigned char)
    CompareTypeAndReturn(unsigned short)
    CompareTypeAndReturn(unsigned long long)
    // 返回值为Class类型
    if (strcmp(returnType, @encode(Class)) == 0) {
        __autoreleasing Class class = nil;
        [invocation getReturnValue:&class];
    }
    // 能到这里的id，就是参数数量多于2个的
    if (strcmp(returnType, @encode(id)) == 0) {
        __autoreleasing id obj = nil;
        [invocation getReturnValue:&obj];
    }
}
- (void)settingParameterType:(const char *)returnType
               invocation:(NSInvocation *)invocation{
    
}
- (void)schedulerCheckErrorForMethod:(nonnull SEL)method
                              target:(nonnull id)target
                              params:(NSArray *)params
                               block:(void(^)(NSError * error))block{
    if (method == NULL) {
        block([self errorDomain:@"选择子为空!" code:AFO_SCHEDULER_ERROR_CODES_SELECTOR_NULL info:nil]);
    }
    if (![target respondsToSelector:method]){
        block([self errorDomain:@"方法未实现!" code:AFO_SCHEDULER_ERROR_CODES_SELECTOR_UNREALIZED info:nil]);
    }
    if (target == NULL || target == nil){
        block([self errorDomain:@"对象为空!" code:AFO_SCHEDULER_ERROR_CODES_TARGET_NULL info:nil]);
    }
    block([self errorDomain:@"传入参数正常!" code:AFO_SCHEDULER_ERROR_CODES_NONE info:nil]);
}
- (void)schedulerTarget:(id)target
               selector:(SEL)selector
                 params:(NSArray *)params
        MethodSignature:(void(^) (NSError *error,
                                           NSMethodSignature *signature))block{
    NSMethodSignature *method = [target methodSignatureForSelector:selector];
    if (method == nil) {
        block([self errorDomain:@"获取方法签名失败!" code:AFO_SCHEDULER_ERROR_CODES_METHODSIGNATURE_NULL info:nil],method);
    }
    if ([method numberOfArguments] - 2 != params.count){
        block([self errorDomain:@"方法参数个数不一致!" code:AFO_SCHEDULER_ERROR_CODES_METHODSIGNATURE_ARGUMENTWROG info:nil],method);
    }
    block([self errorDomain:@"获取方法签名成功!" code:AFO_SCHEDULER_ERROR_CODES_METHODSIGNATURE_SECESS info:nil],method);
}
- (NSError *)errorDomain:(NSString *)domain
                    code:(NSInteger)code
                    info:(NSDictionary<NSErrorUserInfoKey,id> *)info{
    NSError *error =[NSError errorWithDomain:domain code:code userInfo:info];
    return error;
}
@end
