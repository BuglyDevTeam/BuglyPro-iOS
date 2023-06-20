//
//   BuglyLockViewController.m
//   RMonitorExample
//
//   Created by engleliu on 2023/3/14
//   Copyright © 2023 Tencent. All rights reserved.
//

#import "BuglyLockViewController.h"
#import "Locker.h"

@interface BuglyLockViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BuglyLockViewController {
    NSArray *_titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _titleArray = @[
        @"OSSpinLock", @"osUnfairLock", @"pthreadMutex", @"pthreadRecursiveMutex",
        @"dispatchSemaphore", @"nscondition", @"nsconditionLock", @"nsconditionLockTryLock", @"nslock",
        @"nsRecursiveLock", @"synchronized", @"dispatchQueue",
    ];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];

    [self.tableView reloadData];
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
    Locker *locker = [[Locker alloc] init];
    [locker performSelector:selector withObject:nil afterDelay:0.1];
}
@end
