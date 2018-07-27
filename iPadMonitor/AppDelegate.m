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
    CLLocationManager *locationManager;
    dispatch_source_t timer;
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
    
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.allowsBackgroundLocationUpdates = YES;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self stratBadgeNumberCount];
    [self startBgTask];
}

- (void)startBgTask{
    UIApplication *application = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        //这里延迟的系统时间结束
        [application endBackgroundTask:bgTask];
        NSLog(@"%f",application.backgroundTimeRemaining);
    }];
    
}

- (void)stratBadgeNumberCount{

    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个定时器
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(1.0* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(timer, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber++;
        });
        [self->locationManager startUpdatingLocation];
    });
    //由于定时器默认是暂停的所以我们启动一下
    //启动定时器
    dispatch_resume(timer);
}

/** 苹果_用户位置更新后，会调用此函数 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    NSLog(@"success");
}

/** 苹果_定位失败后，会调用此函数 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    NSLog(@"error");
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
