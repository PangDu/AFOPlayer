//
//  AFOAppCompositionRoot.m
//  AFOPlayer
//

#import "AFOAppCompositionRoot.h"
#import "AFOAppTabBarController.h"
#import "AFOAddControllerModel.h"

@implementation AFOAppCompositionRoot

+ (AFOAppTabBarController *)makeRootTabBarController {
    AFOAppTabBarController *tabBarController = [[AFOAppTabBarController alloc] init];
    AFOAddControllerModel *addModel = [[AFOAddControllerModel alloc] init];
    [addModel controllerInitialization:tabBarController];
    return tabBarController;
}

@end
