//
//  AppDelegate.m
//  zb_launch_img_ad
//
//  Created by zyon on 07/04/2017.
//  Copyright © 2017 zyonbao. All rights reserved.
//

#import "AppDelegate.h"
#import "ZBLaunchAD.h"

#define LAUNCH_SCREEN_VC_IDENTIFIER @"LaunchScreenViewController"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    UIWindow *_adwindow;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIView *launchView = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:LAUNCH_SCREEN_VC_IDENTIFIER].view;
    launchView.backgroundColor = [UIColor lightGrayColor];
    
    NSURL *adURL = [NSURL URLWithString:@"https://gss0.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/c83d70cf3bc79f3d04fa12dbb8a1cd11738b29c6.jpg"];
    
    ZBLaunchAD *launchAD = [ZBLaunchAD adImageConfigWithADImgURL:adURL logoImage:[UIImage imageNamed:@"logo.png"] handlerBlock:^(ZBLaunchADCallBackType callBackType) {
        NSLog(@"%ld",callBackType);
    }];
    
    launchAD.logoHeight = 40.0f;
//    ZBLaunchAD *launchAD = [ZBLaunchAD adImageConfigWithADImgURL:adURL handlerBlock:^(ZBLaunchADCallBackType callBackType) {
//        NSLog(@"%ld",callBackType);
//    }];
    
    launchAD.launchView = launchView;//设置背景与启动屏幕保持一致
    [launchAD showADView];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
