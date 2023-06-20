//
//  RMVCLeakExampleViewController.m
//  RMonitorExample
//
//  Created by tianwuwang on 2021/12/28.
//  Copyright © 2021年 Tencent. All rights reserved.
//

#import "RMVCLeakExampleViewController.h"

@interface RMVCLeakExampleViewController ()

@property (nonatomic, strong) UIViewController *holdVC;

@end

@implementation RMVCLeakExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)createVCLeakExample:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RMVCLeakExample"
                                                         bundle:[NSBundle mainBundle]];
    
    UIViewController * subVC = [storyboard instantiateViewControllerWithIdentifier:@"rm.vcleak.subvc"];
    
    [self.navigationController pushViewController:subVC animated:YES];
    
    self.holdVC = subVC;
}

@end
