//
//  AppDelegate.m
//  XunZhi
//
//  Created by 李雷 on 16/5/14.
//  Copyright © 2016年 cn.edu.jlnu.cst. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


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
    
    return YES;
}

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

@end
