//
//  ViewController.m
//  iPadMonitor
//
//  Created by enli on 2018/7/26.
//  Copyright © 2018年 enli. All rights reserved.
//

#import "ViewController.h"
#import "ELMonitorRecorder.h"

@interface ViewController (){
    UIButton *btn;
    ELMonitorRecorder *recorder;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    recorder = [[ELMonitorRecorder alloc] initWithID:0];
    
    btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    btn.frame = CGRectMake(20, 100, 100, 20);
    [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"测试" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
    [recorder start];
}

-(IBAction)onBtnClick:(id)sender{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
