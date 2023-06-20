//
//  ConfigViewController.m
//  RMonitorExample
//
//  Created by Tianwu Wang on 2021/5/8.
//  Copyright (c) 2021年 Tencent. All rights reserved.
//

#import "ConfigViewController.h"

//#import "BuglyAppInfo.h"

@interface ConfigViewController ()

@property (weak, nonatomic) IBOutlet UITextField *reportURLTextField;
@property (weak, nonatomic) IBOutlet UITextField *reportAppKeyTextField;

@end

@implementation ConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Config";
    
//    self.reportURLTextField.text = [BuglyAppInfo currentAppInfo].host;
//    self.reportAppKeyTextField.text = [BuglyAppInfo currentAppInfo].appId;
}

- (IBAction)updateConfig:(id)sender {
//    [BuglyAppInfo currentAppInfo].host = self.reportURLTextField.text;
//    [BuglyAppInfo currentAppInfo].appId = self.reportAppKeyTextField.text;
    
    [self.reportURLTextField resignFirstResponder];
    [self.reportAppKeyTextField resignFirstResponder];
}


@end
