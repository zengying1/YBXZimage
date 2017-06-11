//
//  AppDelegate.m
//  ybxzicon
//
//  Created by Oreal51 on 2017/6/11.
//  Copyright © 2017年 Oreal51. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [UIWindow alloc];
    window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //注册一个后台任务，这样可以使应用程序一直存在。等到我们告诉系统任务完成了，终止运行
    UIBackgroundTaskIdentifier backgroundTask = [application beginBackgroundTaskWithExpirationHandler:nil];
    //创建一个新的后台队列来运行我们的后台代码
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc]init];
    [backgroundQueue addOperationWithBlock:^{
        //发送通知到服务器
        //准备URL
        NSURL *notificationURL = [NSURL URLWithString:@"http://oreilly.com/"];
        //准备URL请求
        NSURLRequest *notificationURLRequest = [NSURLRequest requestWithURL:notificationURL];
        //发送请求并记录回复
        NSData *loadedDate = [NSURLConnection sendSynchronousRequest:notificationURLRequest returningResponse:nil error:nil];
        //将数据转换为字符串
        NSString *loadedString = [[NSString alloc]initWithData:loadedDate encoding:NSUTF8StringEncoding];
        NSLog(@"Loaded:%@",loadedString);
        //告诉系统，后台任务完成
        [application endBackgroundTask:backgroundTask];
    }];
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
