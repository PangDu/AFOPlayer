//
//  AFOOPMainController+AFOAppURLCache.m
//  AFOPlayer
//
//  原 AFOOnlinePlayURLCache Pod：在线播放页记住/恢复 URL。移除独立 Pod 后并入主工程。
//

#import <AFOOnlinePlay/AFOOPMainController.h>

#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static NSString * const kAFOCachedOnlineVideoURLStringKey = @"AFOCachedOnlineVideoURLString";

@implementation AFOOPMainController (AFOAppURLCache)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [AFOOPMainController class];

        Method originalVDL = class_getInstanceMethod(cls, @selector(viewDidLoad));
        Method swizzledVDL = class_getInstanceMethod(cls, @selector(afo_appURLCache_viewDidLoad));
        if (originalVDL && swizzledVDL) {
            method_exchangeImplementations(originalVDL, swizzledVDL);
        }

        Method originalPlay = class_getInstanceMethod(cls, @selector(onPlayTapped:));
        Method swizzledPlay = class_getInstanceMethod(cls, @selector(afo_appURLCache_onPlayTapped:));
        if (originalPlay && swizzledPlay) {
            method_exchangeImplementations(originalPlay, swizzledPlay);
        }
    });
}

- (void)afo_appURLCache_viewDidLoad {
    [self afo_appURLCache_viewDidLoad];

    NSString *cached = [[NSUserDefaults standardUserDefaults] stringForKey:kAFOCachedOnlineVideoURLStringKey];
    if (cached.length == 0) {
        return;
    }

    id field = [self valueForKey:@"urlField"];
    if ([field isKindOfClass:[UITextField class]]) {
        [(UITextField *)field setText:cached];
    }
}

- (void)afo_appURLCache_onPlayTapped:(id)sender {
    id field = [self valueForKey:@"urlField"];
    if ([field isKindOfClass:[UITextField class]]) {
        NSString *raw = [[(UITextField *)field text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (raw.length > 0) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:raw forKey:kAFOCachedOnlineVideoURLStringKey];
            [defaults synchronize];
        }
    }

    [self afo_appURLCache_onPlayTapped:sender];
}

@end
