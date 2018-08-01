//
//  ELMonitorRecorder.h
//  iPadMonitor
//
//  Created by enli on 2018/7/26.
//  Copyright © 2018年 enli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ELMonitorRecorder : NSObject<CLLocationManagerDelegate>
-(instancetype)initWithID:(NSInteger )ID;
-(void)start;

@end
