//
//  APMQQLeakViewController.m
//  ApmDemo
//
//  Created by cass on 2018/4/10.
//  Copyright © 2018年 testcgd. All rights reserved.
//

#import "RMLeakExampleViewController.h"
#import "UIButton+Utils.h"
//#import "RMMemoryMonitorPlugin.h"

@interface RMLeakExampleViewController ()

@property (weak, nonatomic) IBOutlet UITextView *logView;

@property (nonatomic, strong) NSMutableString *logs;

@end

@implementation RMLeakExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.logs = [[NSMutableString alloc] initWithString:@"logs:\n"];
    self.logView.text = self.logs;
}

- (IBAction)openLeak:(id)sender {
//    [RMMemoryMonitorPlugin startStackLogging];

    [self.logs appendString:@"Leak opend.\n"];
    self.logView.text = self.logs;
}

- (IBAction)createLeakObj:(id)sender {
    NSObject *testObject = [[NSObject alloc] init];
    [testObject class];
    
    void* ptr = malloc(20);
    memset(ptr, 0xFF, 20);
    
    [self.logs appendString:@"Create leak obj.\n"];
    self.logView.text = self.logs;
}

- (IBAction)checkLeak:(id)sender {
//    [RMMemoryMonitorPlugin executeLeakCheck];

    [self.logs appendString:@"Checking leak.\n"];
    self.logView.text = self.logs;
}

- (IBAction)stopLeak:(id)sender {
//    [RMMemoryMonitorPlugin stopStackLogging];

    [self.logs appendString:@"Leak stop.\n"];
    self.logView.text = self.logs;
}

@end
