#import "AFOAppDelegate.h"
#import "AFOAppTabBarController.h"
#import "AFOAddControllerModel.h"
#import "AFORouterManager.h"

@interface AFOAppDelegate ()

@property (nonatomic, strong) AFOAddControllerModel *addModel;

@end

@implementation AFOAppDelegate

#pragma mark - Accessors

- (AFOAddControllerModel *)addModel {
    if (!_addModel) {
        _addModel = [[AFOAddControllerModel alloc] init];
    }
    return _addModel;
}

- (AFOAppTabBarController *)tabBarController {
    if (!_tabBarController) {
        _tabBarController = [[AFOAppTabBarController alloc] init];
        [self.addModel controllerInitialization:_tabBarController];
    }
    return _tabBarController;
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = self.tabBarController;

#if DEBUG
    NSLog(@"AFOAppDelegate: window.rootViewController: %@", self.window.rootViewController);
    NSLog(@"AFOAppDelegate: window.isKeyWindow: %d", self.window.isKeyWindow);
    NSLog(@"AFOAppDelegate: window.hidden: %d", self.window.hidden);
#endif

    [[AFODelegateForeign shareInstance] addImplementationQueueTarget:(id<UIApplicationDelegate>)[AFORouterManager shareInstance]];
    [self.window makeKeyAndVisible];

#if DEBUG
    NSLog(@"AFOAppDelegate: After makeKeyAndVisible - window.isKeyWindow: %d", self.window.isKeyWindow);
    NSLog(@"AFOAppDelegate: After makeKeyAndVisible - window.hidden: %d", self.window.hidden);
#endif

    return [[AFODelegateForeign shareInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    return [[AFODelegateForeign shareInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (suchs as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
