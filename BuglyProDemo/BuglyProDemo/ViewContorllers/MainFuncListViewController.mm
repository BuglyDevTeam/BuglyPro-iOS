//
//  MainFuncListViewController.mm
//  RMonitorExample
//
//  Created by wakeen on 2018/4/10.
//  Copyright © 2018年 testcgd. All rights reserved.
//

#import "MainFuncListViewController.h"

#import "RMVCLeakExampleViewController.h"
#import "QAPMSigkillViewController.h"
#import "QAPMResourceMonitorViewController.h"
#import "RMMetricKitViewController.h"
#import "RMDeadlockSimulatorViewController.h"
#import "RMCrashSettingViewController.h"
#import "BuglyLockViewController.h"

typedef void (^RaftMonitorFuncAction)(UIViewController *viewController,
                                      UITableView *tableview, NSIndexPath *indexPath);

@interface RaftMonitorFuncItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, copy) RaftMonitorFuncAction action;

+ (RaftMonitorFuncItem*)itemWithTitle:(NSString *)title bgColor:(UIColor *)bgColor
                               action:(RaftMonitorFuncAction)action;

@end

@implementation RaftMonitorFuncItem

+ (RaftMonitorFuncItem*)itemWithTitle:(NSString *)title bgColor:(UIColor *)bgColor
                               action:(RaftMonitorFuncAction)action {
    RaftMonitorFuncItem *item = [[RaftMonitorFuncItem alloc] init];
    item.title = title;
    item.backgroundColor =bgColor;
    item.action = action;
    return item;
}

@end


@interface MainFuncListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *funcList;

@end

@implementation MainFuncListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Function";
    
    [self initFuncList];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)initFuncList {
    self.funcList = @[
        // 卡顿监控
        [RaftMonitorFuncItem itemWithTitle:@"Looper(滑动卡顿)" bgColor:[UIColor systemBlueColor]
                                    action:^(UIViewController *viewController, UITableView *tableview, NSIndexPath *indexPath) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TableViewExample" bundle:[NSBundle mainBundle]];
            UIViewController *vc = [storyboard instantiateInitialViewController];
            [viewController.navigationController pushViewController:vc animated:YES];
        }],
        // deadlock监控
        [RaftMonitorFuncItem itemWithTitle:@"卡顿(Deadlock&Hitches)" bgColor:[UIColor lightGrayColor]
                                    action:^(UIViewController *viewController, UITableView *tableview, NSIndexPath *indexPath) {
            UIViewController *vc = [[RMDeadlockSimulatorViewController alloc] init];
            [viewController.navigationController pushViewController:vc animated:YES];
        }],
        // 资源监控
        [RaftMonitorFuncItem itemWithTitle:@"ResourceMonitor(资源监控)" bgColor:[UIColor purpleColor]
                                    action:^(UIViewController *viewController, UITableView *tableview, NSIndexPath *indexPath) {
            UIViewController *vc = [[QAPMResourceMonitorViewController alloc] init];
            [viewController.navigationController pushViewController:vc animated:YES];
        }],
        // VC泄漏监控
        [RaftMonitorFuncItem itemWithTitle:@"VCLeak(VC泄露监控)" bgColor:[UIColor yellowColor]
                                    action:^(UIViewController *viewController, UITableView *tableview, NSIndexPath *indexPath) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RMVCLeakExample" bundle:[NSBundle mainBundle]];
            UIViewController *vc = [storyboard instantiateInitialViewController];
            [viewController.navigationController pushViewController:vc animated:YES];
        }],
        // 内存监控
        [RaftMonitorFuncItem itemWithTitle:@"MemoryMonitor(内存监控)" bgColor:[UIColor greenColor]
                                    action:^(UIViewController *viewController, UITableView *tableview, NSIndexPath *indexPath) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MemoryMonitor" bundle:[NSBundle mainBundle]];
            UIViewController *vc = [storyboard instantiateInitialViewController];
            [viewController.navigationController pushViewController:vc animated:YES];
        }],
        [RaftMonitorFuncItem itemWithTitle:@"Sigkill(FOOM与卡死Crash)" bgColor:[UIColor redColor]
                                    action:^(UIViewController *viewController, UITableView *tableview, NSIndexPath *indexPath) {
            UIViewController *vc = [[QAPMSigkillViewController alloc] init];
            [viewController.navigationController pushViewController:vc animated:YES];
        }],
        [RaftMonitorFuncItem itemWithTitle:@"QQLeak(内存泄露监控)" bgColor:[UIColor orangeColor]
                                    action:^(UIViewController *viewController, UITableView *tableview, NSIndexPath *indexPath) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LeakExample" bundle:[NSBundle mainBundle]];
            UIViewController *vc = [storyboard instantiateInitialViewController];
            [viewController.navigationController pushViewController:vc animated:YES];
        }],
        // Crash监控
        [RaftMonitorFuncItem itemWithTitle:@"Crash(Crash监控)" bgColor:[UIColor darkGrayColor]
                                    action:^(UIViewController *viewController, UITableView *tableview, NSIndexPath *indexPath) {
            UIViewController *vc = [[RMCrashSettingViewController alloc] init];
            [viewController.navigationController pushViewController:vc animated:YES];
        }],
        // MetricKit监控
        [RaftMonitorFuncItem itemWithTitle:@"MeticKit(Apple 性能监控)" bgColor:[UIColor lightGrayColor]
                                    action:^(UIViewController *viewController, UITableView *tableview, NSIndexPath *indexPath) {
            UIViewController *vc = [[RMMetricKitViewController alloc] init];
            [viewController.navigationController pushViewController:vc animated:YES];
        }],
        // Locker 测试
        [RaftMonitorFuncItem itemWithTitle:@"Locker" bgColor:[UIColor systemGrayColor]
                                    action:^(UIViewController *viewController, UITableView *tableview, NSIndexPath *indexPath) {
            UIViewController *vc = [[BuglyLockViewController alloc] init];
            [viewController.navigationController pushViewController:vc animated:YES];
        }],
    ];
}

#pragma mark - TableView datasource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.funcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"funcitme"];
    RaftMonitorFuncItem *item = [self.funcList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.backgroundColor = item.backgroundColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RaftMonitorFuncItem *item = [self.funcList objectAtIndex:indexPath.row];
    item.action(self, tableView, indexPath);
}

@end
