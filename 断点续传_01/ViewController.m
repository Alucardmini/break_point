//
//  ViewController.m
//  断点续传_01
//
//  Created by 吴锡坤 on 5/12/18.
//  Copyright © 2018 吴锡坤. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Hash.h"
#import "DownLoadManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton* startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"start" forState:UIControlStateNormal];
    [startBtn setFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, 30)];
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.view addSubview:startBtn];
    
    UIButton* stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    [stopBtn setFrame:CGRectMake(0, CGRectGetMaxY(startBtn.frame) + 100.f, [UIScreen mainScreen].bounds.size.width, 30)];
    [stopBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)start{

    
    // 启动任务
    NSString * downLoadUrl =  @"http://audio.xmcdn.com/group11/M01/93/AF/wKgDa1dzzJLBL0gCAPUzeJqK84Y539.m4a";

    [[DownLoadManager shareInstance] downLoadWithURL:downLoadUrl progress:^(float progress) {
        NSLog(@"###%f",progress);

    } success:^(NSString *fileStorePath) {
        NSLog(@"###%@",fileStorePath);

    } failed:^(NSError *error) {
        NSLog(@"###%@",error.userInfo[NSLocalizedDescriptionKey]);

    }];
    
}

- (void)stop{
    [[DownLoadManager shareInstance] stopTask];

}


@end
