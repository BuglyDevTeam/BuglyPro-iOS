//
//  PerfTestViewController.m
//  RMonitorExample
//
//  Created by Tianwu Wang on 2021/4/19.
//  Copyright (c) 2021年 Tencent. All rights reserved.
//

#import "PerfTestViewController.h"

#import <mach/mach_time.h>
#import <pthread/pthread.h>

//#import "CThreadStack.h"
//#import "BuglyMallocLogger.h"
//#import "RMCPUProfileUtils.h"

//using namespace raft_monitor;

@interface PerfTestViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stackResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *mallocResultLabel;
@property (weak, nonatomic) IBOutlet UISwitch *oomSwitch;

@end

@implementation PerfTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Performance";
    
    [self.oomSwitch setOn:NO animated:YES];
}

- (IBAction)stackPerformanceTest:(id)sender {
    
//    mach_port_t thread = pthread_mach_thread_np(pthread_self());
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        static mach_timebase_info_data_t sTimebaseInfo;
//        mach_timebase_info(&sTimebaseInfo);
//        
//        CThreadStack ts;
//        
//        uint64_t startCpuCycCnt = rm_cpu_cycles_count();
//        uint64_t start_time = mach_absolute_time();
//        for(int i = 0; i < 100000; i++) {
//            CThreadStackFrame stack = ts.getThreadStack((thread_t)thread);
//        }
//        uint64_t end_time = mach_absolute_time();
//        uint64_t endCpuCycCnt = rm_cpu_cycles_count();
//        uint64_t dur_millis = ((end_time/1e6)*sTimebaseInfo.numer)/sTimebaseInfo.denom - ((start_time/1e6)*sTimebaseInfo.numer)/sTimebaseInfo.denom;
//        uint64_t cpuCycCnt = endCpuCycCnt - startCpuCycCnt;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.stackResultLabel.text = [NSString stringWithFormat:@"cost:%lld ms, %lld, %lld", dur_millis, cpuCycCnt, cpuCycCnt/dur_millis ];
//        });
//    });
//    
}

- (IBAction)oomSwitchChange:(id)sender {
    if ([self.oomSwitch isOn]) {
        NSString *uuid = [[NSUUID UUID] UUIDString];
    } else {
       
    }
}

- (IBAction)mallocPerformanceTest:(id)sender {
    
    static mach_timebase_info_data_t sTimebaseInfo;
    mach_timebase_info(&sTimebaseInfo);
    
    void *ptrs[100000];
    
    uint64_t start_time = mach_absolute_time();
    for (int i = 0; i < 100000; i++) {
        void* ptr = malloc(2*1024);
        memset(ptr, 0xBB, 2*1024);
        *(ptrs + i) = ptr;
    }
    for (int i = 0; i < 100000; i++) {
        free(*(ptrs + i));
    }
    
    uint64_t end_time = mach_absolute_time();
    uint64_t dur_millis = ((end_time/1e6)*sTimebaseInfo.numer)/sTimebaseInfo.denom - ((start_time/1e6)*sTimebaseInfo.numer)/sTimebaseInfo.denom;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mallocResultLabel.text = [NSString stringWithFormat:@"malloc cost time:%lld ms", dur_millis];
    });

}

@end
