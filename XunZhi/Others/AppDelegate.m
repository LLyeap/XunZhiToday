//
//  AppDelegate.m
//  XunZhi
//
//  Created by 李雷 on 16/5/14.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "AppDelegate.h"

#import "XZSearchVC.h"
#import "XZMeFavoriteVC.h"
#import "LLQRVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - 程序开始入口
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    // >设置友盟社会化组件appkey
    [UMSocialData setAppKey:@"5750f2e7e0f55a6f1d002179"];
    // ?设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxaff81d0a8e4d1ea8" appSecret:@"7e69494d52080041b3000b0cfcabcd98" url:@"http://www.umeng.com/social"];
//    // >设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
//    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
//    // >打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
//                                              secret:@"04b48b094faeb16683c32669824ebdad"
//                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    /** 添加3Dtouch */
    [self add3Dtouch];
    return YES;
}
#pragma mark - 原带方法
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/**
 *  如果App是从快速入口启动的，则会执行这个方法。该方法的shortcutItem参数携带了从快速入口进入app时的标签参数。
 *
 *  @param application 当前APP应用
 *  @param completionHandler 当执行的处理完成后回调block
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"XZMain" bundle:[NSBundle mainBundle]];
    // >由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UITabBarController *tabBarVC = [story instantiateViewControllerWithIdentifier:@"XZMain"];
//    // >在viewControllers里可以这样推出
//    [self presentViewController:tabBarVC animated:YES completion:^{
//        
//    }];
    // >但是在APPDelegate中不行, 通过设置window来实现
    self.window.rootViewController = tabBarVC;
    if ([shortcutItem.localizedTitle isEqualToString:@"搜索"]) {
        UINavigationController *naviIndexVC = [tabBarVC.viewControllers objectAtIndex:0];
        [naviIndexVC pushViewController:[[XZSearchVC alloc] init] animated:YES];
        tabBarVC.selectedIndex = 0;
    } else if ([shortcutItem.localizedTitle isEqualToString:@"收藏"]) {
        UINavigationController *naviIndexVC = [tabBarVC.viewControllers objectAtIndex:3];
        [naviIndexVC pushViewController:[[XZMeFavoriteVC alloc] init] animated:YES];
        tabBarVC.selectedIndex = 3;
    }  else if ([shortcutItem.localizedTitle isEqualToString:@"扫一扫"]) {
        UINavigationController *naviMeVC = [tabBarVC.viewControllers objectAtIndex:3];
        [naviMeVC pushViewController:[[LLQRVC alloc] init] animated:YES];
        tabBarVC.selectedIndex = 3;
    }
}
#pragma mark - 3D Touch
- (void)add3Dtouch {
    // 动态添加快捷启动
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"shortcutTypeTwo" localizedTitle:@"搜索" localizedSubtitle:nil icon:icon1 userInfo:nil];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"favorite"];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"shortcutTypeTwo" localizedTitle:@"收藏" localizedSubtitle:nil icon:icon2 userInfo:nil];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"saoyisao"];
    UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc] initWithType:@"shortcutTypeTwo" localizedTitle:@"扫一扫" localizedSubtitle:nil icon:icon3 userInfo:nil];
    [[UIApplication sharedApplication] setShortcutItems:@[item1, item2, item3]];
}








@end






