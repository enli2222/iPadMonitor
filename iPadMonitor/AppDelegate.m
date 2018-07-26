//
//  AppDelegate.m
//  iPadMonitor
//
//  Created by enli on 2018/7/26.
//  Copyright © 2018年 enli. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate (){
    UIBackgroundTaskIdentifier bgTask;
    CLLocationManager *locationManager;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *vc = [[ViewController alloc] init];
//    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [self comeToBackgroundMode];
    [locationManager startUpdatingLocation];

}

-(void)comeToBackgroundMode{
    UIApplication *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask: self->bgTask];
        self->bgTask = UIBackgroundTaskInvalid;
    }];
    //开启定时器 不断向系统请求后台任务执行的时间
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(applyForMoreTime) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)applyForMoreTime {
    //如果系统给的剩余时间小于60秒 就终止当前的后台任务，再重新初始化一个后台任务，重新让系统分配时间，这样一直循环下去，保持APP在后台一直处于active状态。
    NSLog(@"applyForMoreTime");
    if ([UIApplication sharedApplication].backgroundTimeRemaining < 60) {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self->bgTask];
            self->bgTask = UIBackgroundTaskInvalid;
        }];
    }
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
