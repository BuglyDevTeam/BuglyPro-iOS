//
//  RMVCLeakExampleSubViewController.m
//  RMonitorExample
//
//  Created by Tianwu Wang on 2021/12/28.
//  Copyright © 2021年 Tencent. All rights reserved.
//

#import "RMVCLeakExampleSubViewController.h"

@interface RMVCLeakExampleSubViewController ()

@property (nonatomic, assign) NSUInteger times;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation RMVCLeakExampleSubViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)startTimer {
    self.times = 5;
    [self performSelector:@selector(updateTime)
               withObject:nil afterDelay:1.0];
}

- (void)updateTime {
    self.times--;
    self.timeLabel.text = [NSString stringWithFormat:@"%lu", self.times];
    if (self.times <= 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSelector:@selector(updateTime)
                   withObject:nil afterDelay:1.0];
    }
    
}

@end
