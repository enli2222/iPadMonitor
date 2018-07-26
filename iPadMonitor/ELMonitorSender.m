//
//  ELMonitorSender.m
//  iPadMonitor
//
//  Created by enli on 2018/7/26.
//  Copyright © 2018年 enli. All rights reserved.
//

#import "ELMonitorSender.h"
#import "AFNetworking.h"

@interface ELMonitorSender(){
    NSString *requestURL;
    AFURLSessionManager *manager;
    NSMutableURLRequest *request;
}
@end

@implementation ELMonitorSender

-(instancetype)initWithURL:(NSString *)url{
    self = [super init];
    if (self) {
        requestURL = url;
        manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        request = [[AFHTTPRequestSerializer serializer]requestWithMethod:@"POST" URLString:requestURL parameters:nil error:nil];
        request.timeoutInterval = 40;
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

-(void)sendMsg:(NSString *)msg{
    [request setHTTPBody:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"返回:%@",responseObject);
        }else{
            NSLog(@"请求失败:%@",error.description);
        }
    }] resume];
}

@end
