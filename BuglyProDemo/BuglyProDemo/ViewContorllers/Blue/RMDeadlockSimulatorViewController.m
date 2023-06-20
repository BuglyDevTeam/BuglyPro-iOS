//
//  RMDeadlockSimulatorViewController.m
//  RMonitorExample
//
//  Created by engleliu on 2021/8/24.
//  Copyright © 2021年 testcgd. All rights reserved.
//

#import "RMDeadlockSimulatorViewController.h"
#include <sys/time.h>
#include <pthread/pthread.h>
#include <mach/thread_act.h>

static void sigroutine(int signo) {
    switch (signo) {
        case SIGALRM:
            printf("Catch a signal -- SIGALRM\n ");
            break;
            return;
    }
}
    
static void timerSignal(void) {
    struct itimerval value;

    NSLog(@"process id is %d\n ", getpid());
    signal(SIGALRM, sigroutine);
    value.it_value.tv_sec = 0;
    value.it_value.tv_usec = 1e6 / 60;
    value.it_interval.tv_sec = 0;
    value.it_interval.tv_usec = 1e6 / 60;
    setitimer(ITIMER_REAL, &value, NULL);
}

@interface RMDeadlockSimulatorViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSLock *lock;

@end

@implementation RMDeadlockSimulatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleArray = @[
        @"simulateSuspend", @"simulateSleep", @"simulateDeadLock1", @"simulateEndlessLoop", @"simulateLargeHitches"
    ];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];

    [self.tableView reloadData];
    
//    timerSignal();
}

#pragma mark - Tableview DataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"CrashCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *methodName = _titleArray[indexPath.row];
    SEL selector = NSSelectorFromString(methodName);
    [self performSelector:selector];
}

- (void)simulateSuspend {
    NSLog(@"%s", __FUNCTION__);
    thread_t thread = pthread_mach_thread_np(pthread_self());
    if (KERN_SUCCESS != thread_suspend(thread)) {
        NSLog(@"%s fail", __FUNCTION__);
    }
}

- (void)simulateSleep {
    NSLog(@"sleep some sec");
    [NSThread sleepForTimeInterval:6.0];
    NSLog(@"sleep end");
}

- (void)simulateDeadLock1 {
    self.lock = [[NSLock alloc] init];
    [self.lock lock];
    [NSThread sleepForTimeInterval:1.f];
    [self doSomething];
    [self.lock unlock];
}

- (void)doSomething {
    [self.lock lock];
    NSLog(@"do something");
    [NSThread sleepForTimeInterval:1.f];
    [self.lock unlock];
}

- (void)simulateEndlessLoop {
    int i = 0;
    while (true) {
        i++;
        NSLog(@"%d", i);
        [NSThread sleepForTimeInterval:0.01];
    }
}

- (void)simulateLargeHitches {
    NSLog(@"begin");
    for (long long index = 0; index < 9999; index++) {
        self.title = [NSString stringWithFormat:@"%lld", index];
    }
    NSLog(@"end");
}


@end
