//
//  ELMonitorSender.h
//  iPadMonitor
//
//  Created by enli on 2018/7/26.
//  Copyright © 2018年 enli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELMonitorSender : NSObject
-(instancetype)initWithURL:(NSString *)url;
-(void)sendMsg:(NSString *)msg;
@end
