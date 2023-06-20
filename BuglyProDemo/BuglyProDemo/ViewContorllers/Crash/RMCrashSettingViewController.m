//
//  RMCrashSettingViewController.m
//  RMonitorExample
//
//  Created by saiyanren on 2021/11/18.
//  Copyright (c) 2021年 Tencent. All rights reserved.
//

#import "RMCrashSettingViewController.h"
#import "UIButton+Utils.h"
#import "AppDelegate.h"
#import "RMCrashViewController.h"

/// 一般按钮的高度
static CGFloat const RMCrashDemoBtnHeight = 50.f;

/// 一般按钮的宽度
static CGFloat const RMCrashDemoBtnWidth = 350.f;

/// 一般按钮的cornerRadius
static CGFloat const RMCrashDemoBtnCornerRadius = 4.f;

/// 一般label的高度
static CGFloat const RMCrashDemoLabelWidth = 250.f;

/// 一般label的宽度
static CGFloat const RMCrashDemoLabelHeight = 250.f;

/// 一般视图间隔
static CGFloat const RMCrashDemoViewGap = 44.f;

/// alert消失时间（单位：s）
static NSTimeInterval const RMCrashDemoAlertDismissDuration = 2.f;

/// v1开关状态key
static NSString *const RMCrashDemoV1SwitchStatusUserDefaultKey = @"V1SwitchStatusUserDefaultKey";

/// v开关上个状态key
static NSString *const RMCrashDemoV2SwitchLastStatusUserDefaultKey = @"V2SwitchLastStatusUserDefaultKey";

/// v1开关状态key
static NSString *const RMCrashDemoV2SwitchStatusUserDefaultKey = @"V2SwitchStatusUserDefaultKey";

/// 跳转按钮的title
static NSString *const RMCrashDemoJumpToCrashTesterPageBtnTitle = @"跳转至crash测试页面";

/// 跳转按钮的accessibilityIdentifier
static NSString *const RMCrashDemoJumpToCrashTesterPageBtnAccessibilityIdentifier = @"JumpToCrashTesterPageBtn";

/// switchV1按钮的accessibilityIdentifier
static NSString *const RMCrashDemoV1SwitchBtnAccessibilityIdentifier = @"V1SwitchBtn";

/// switchV2按钮的accessibilityIdentifier
static NSString *const RMCrashDemoV2SwitchBtnAccessibilityIdentifier = @"V2SwitchBtn";

/// 被禁击的按钮的title
static NSString *const RMCrashDemoDisabledBtnTitle = @"请在AppDelegate中完善配置";

/// v1状态的字符态
static NSString *const RMCrashDemoMonitorVersionV1String = @"v1";

/// v2状态的字符态
static NSString *const RMCrashDemoMonitorVersionV2String = @"v2";

/// 按钮文案打开状态的字符态
static NSString *const RMCrashDemoBtnTitleOnString = @"ON";

/// 按钮文案关闭状态的字符态
static NSString *const RMCrashDemoBtnTitleOffString = @"OFF";

/// 重启提示尾缀文案
static NSString *const RMCrashDemoRebootTipsSuffixString = @"(重启后生效)";

/// 按钮文案基础监控的字符态
static NSString *const RMCrashDemoBtnTitleBaseString = @"基础监控";

/// 按钮文案高级监控的字符态
static NSString *const RMCrashDemoBtnTitleAdvancedString = @"高级监控";

/// 按钮文案超级监控的字符态
static NSString *const RMCrashDemoBtnTitlePremierString = @"超级监控";

/// 介绍文本
static NSString *const RMCrashDemoInstructionLabelText = @"使用说明：点击顶部两个按钮，可切换监控版本的开关。\n请首先在AppDelegate中配置好哦～";

/// V1开关的状态
typedef NS_OPTIONS(NSUInteger, V1SwitchStatus) {
    // 关闭
    V1SwitchStatusClose = 0,
    
    // 开启（尚未生效）
    V1SwitchStatusOpenButUnenforced,
    
    // 开启
    V1SwitchStatusOpen,
    
    // 关闭（尚未生效）
    V1SwitchStatusCloseButUnenforced,
};


/// V2开关的状态
typedef NS_OPTIONS(NSUInteger, V2SwitchStatus) {
    // 关闭
    V2SwitchStatusClose = 0,
    
    // 开启基础监控（尚未生效）
    V2SwitchStatusOpenBaseButUnenforced,
    
    // 开启高级监控（尚未生效）
    V2SwitchStatusOpenAdvancedButUnenforced,
    
    // 开启超级监控（尚未生效）
    V2SwitchStatusOpenPremierButUnenforced,
    
    // 开启基础监控
    V2SwitchStatusOpenBase,
    
    // 开启高级监控
    V2SwitchStatusOpenAdvanced,
    
    // 开启超级监控
    V2SwitchStatusOpenPremier,
    
    // 关闭（尚未生效）
    V2SwitchStatusCloseButUnenforced,
};

/// 监控的版本
typedef NS_OPTIONS(NSUInteger, MonitorVersion) {
    // v1
    MonitorVersionV1 = 0,
    
    // v2
    MonitorVersionV2 = 1,
};

/// crash设置页vc的扩展
@interface RMCrashSettingViewController ()

/// 控制V1.0监控的开关
@property (nonatomic, strong) UIButton *v1SwitchBtn;

/// V1.0监控的当前状态
@property (nonatomic, assign) V1SwitchStatus currentV1SwitchStatus;

/// 控制V2.0监控的开关
@property (nonatomic, strong) UIButton *v2SwitchBtn;

/// V2.0监控的当前状态
@property (nonatomic, assign) V2SwitchStatus currentV2SwitchStatus;

/// V2.0监控的上个状态（上次启动时）
@property (nonatomic, assign) V2SwitchStatus lastV2SwitchStatus;

/// 跳转至crash测试页按钮
@property (nonatomic, strong) UIButton *jumpToCrashTesterPageBtn;

/// 使用介绍文本
@property (nonatomic, strong) UILabel *instructionLabel;

@end

/// crash设置页vc的实现
@implementation RMCrashSettingViewController

// 是否已经处理过设置monitor
static BOOL gDidHandleSetupMonitor;

/// view已经加载
- (void)viewDidLoad {
    [super viewDidLoad];

    if (!gDidHandleSetupMonitor) {
        // 如果还未处理过设置monitor，则设置一次（每次启动只有一次设置机会，否则就会在下次启动再设置）
        gDidHandleSetupMonitor = YES;
        
        // 存下v2的状态
        [self syncCacheObject:@(self.currentV2SwitchStatus)
                       forKey:RMCrashDemoV2SwitchLastStatusUserDefaultKey];
    } else {
        
        // 配置开关状态
        [self setupSwitchStatus];
    }
    
    // 保存v2的上个状态
    self.lastV2SwitchStatus = [self loadLocalV2SwitchStatusWithKey:RMCrashDemoV2SwitchLastStatusUserDefaultKey];
    
    // 配置视图
    [self setupViews];
}

#pragma mark - Button Action
/// 点击switch切换按钮
- (void)switchBtnClick:(UIButton *)button {
    NSString *alertMessage = @"";
    NSString *newTitle = @"";
    UIColor *nextColor = nil;
    if (button == self.v1SwitchBtn) {
        // 如果是v1切换按钮
        // 存下一个v2切换状态
        self.currentV1SwitchStatus = [self cacheNextV1SwitchStatusWithStatus:self.currentV1SwitchStatus];
        
        // 获得alert提示信息
        alertMessage = [self getV1SwitchAlertMessageWithStatus:self.currentV1SwitchStatus];
        
        // 获得按钮新标题
        newTitle = [self getV1SwitchBtnTitleWithStatus:self.currentV1SwitchStatus];
        
        // 获得按钮新颜色
        nextColor = [self getV1SwitcBtnBackgroundColorWithStatus:self.currentV1SwitchStatus];
    } else if (button == self.v2SwitchBtn) {
        // 如果是v2切换按钮
        // 存下一个v2切换状态
        self.currentV2SwitchStatus = [self cacheNextV2SwitchStatusWithStatus:self.currentV2SwitchStatus
                                                                  lastStatus:self.lastV2SwitchStatus];
        
        // 获得alert提示信息
        alertMessage = [self getV2SwitchAlertMessageWithStatus:self.currentV2SwitchStatus];
        
        // 获得按钮新标题
        newTitle = [self getV2SwitchBtnTitleWithStatus:self.currentV2SwitchStatus];
        
        // 获得按钮新颜色
        nextColor = [self getV2SwitcBtnBackgroundColorWithStatus:self.currentV2SwitchStatus];
    }

    // 展示alert信息
    [self showAlertVcWithMessage:alertMessage];
    
    // 设置按钮新标题和颜色
    [button setTitle:newTitle forState:UIControlStateNormal];
    button.backgroundColor = nextColor;
}

/// 点击jump按钮
- (void)jumpToCrashTesterPageBtnClick {
    // 跳转至crash测试页
    UIViewController *vc = [[RMCrashViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Utils

/// 获得v1按钮的alert信息
/// @param status v1状态
- (NSString *)getV1SwitchAlertMessageWithStatus:(V1SwitchStatus)status {
    NSString *versionString = RMCrashDemoMonitorVersionV1String;
    if (status == V1SwitchStatusClose) {
        // 如果是v1关闭状态
        return [NSString stringWithFormat:@"%@已取消%@", versionString, RMCrashDemoBtnTitleOnString];
    }
    if (status == V1SwitchStatusOpenButUnenforced) {
        // 如果是v1开启（尚未生效）状态
        return [NSString stringWithFormat:@"%@ %@成功%@", versionString, RMCrashDemoBtnTitleOnString, RMCrashDemoRebootTipsSuffixString];
    }
    if (status == V1SwitchStatusOpen) {
        // 如果是v1开启状态
        return [NSString stringWithFormat:@"%@已取消%@", versionString, RMCrashDemoBtnTitleOffString];
    }
    if (status == V1SwitchStatusCloseButUnenforced) {
        // 如果是v1关闭（尚未生效）状态
        return [NSString stringWithFormat:@"%@ %@成功%@", versionString, RMCrashDemoBtnTitleOffString, RMCrashDemoRebootTipsSuffixString];
    }
    return @"";
}

/// 获得v2按钮的alert信息
/// @param status v2状态
- (NSString *)getV2SwitchAlertMessageWithStatus:(V2SwitchStatus)status {
    NSString *versionString = RMCrashDemoMonitorVersionV2String;
    if (status == V2SwitchStatusClose) {
        // 如果是v2关闭状态
        return [NSString stringWithFormat:@"%@已取消%@", versionString, RMCrashDemoBtnTitleOnString];
    }
    if (status == V2SwitchStatusOpenBaseButUnenforced) {
        // 如果是v2开启基础监控（尚未生效）状态
        return [NSString stringWithFormat:@"%@ %@%@成功%@",
                versionString,
                RMCrashDemoBtnTitleBaseString,
                RMCrashDemoBtnTitleOnString,
                RMCrashDemoRebootTipsSuffixString];
    }
    if (status == V2SwitchStatusOpenAdvancedButUnenforced) {
        // 如果是v2开启高级监控（尚未生效）状态
        return [NSString stringWithFormat:@"%@ %@%@成功%@",
                versionString,
                RMCrashDemoBtnTitleAdvancedString,
                RMCrashDemoBtnTitleOnString,
                RMCrashDemoRebootTipsSuffixString];
    }
    if (status == V2SwitchStatusOpenPremierButUnenforced) {
        // 如果是v2开启超级监控（尚未生效）状态
        return [NSString stringWithFormat:@"%@ %@%@成功%@",
                versionString,
                RMCrashDemoBtnTitlePremierString,
                RMCrashDemoBtnTitleOnString,
                RMCrashDemoRebootTipsSuffixString];
    }
    if (status == V2SwitchStatusOpenBase) {
        // 如果是v2开启基础监控状态
        return [NSString stringWithFormat:@"%@ %@%@成功%@",
                versionString,
                RMCrashDemoBtnTitleBaseString,
                RMCrashDemoBtnTitleOnString,
                RMCrashDemoRebootTipsSuffixString];
    }
    if (status == V2SwitchStatusOpenAdvanced) {
        // 如果是v2开启高级监控状态
        return [NSString stringWithFormat:@"%@ %@%@成功%@",
                versionString,
                RMCrashDemoBtnTitleAdvancedString,
                RMCrashDemoBtnTitleOnString,
                RMCrashDemoRebootTipsSuffixString];
    }
    if (status == V2SwitchStatusOpenPremier) {
        // 如果是v2开启超级监控状态
        return [NSString stringWithFormat:@"%@ %@%@成功%@",
                versionString,
                RMCrashDemoBtnTitlePremierString,
                RMCrashDemoBtnTitleOnString,
                RMCrashDemoRebootTipsSuffixString];
    }
    if (status == V2SwitchStatusCloseButUnenforced) {
        // 如果是v2关闭（尚未生效）状态
        return [NSString stringWithFormat:@"%@ %@成功%@",
                versionString,
                RMCrashDemoBtnTitleOffString,
                RMCrashDemoRebootTipsSuffixString];
    }
    return @"";
}

/// 获得v1切换按钮的title
- (NSString *)getV1SwitchBtnTitleWithStatus:(V1SwitchStatus)status {
    NSString *versionString = RMCrashDemoMonitorVersionV1String;
    
    if (status == V1SwitchStatusClose) {
        // 如果是v1关闭状态
        return [NSString stringWithFormat:@"%@:%@", versionString, RMCrashDemoBtnTitleOffString];
    }
    if (status == V1SwitchStatusOpenButUnenforced) {
        // 如果是v1开启（尚未生效）状态
        return [NSString stringWithFormat:@"%@:%@%@", versionString, RMCrashDemoBtnTitleOnString, RMCrashDemoRebootTipsSuffixString];
    }
    if (status == V1SwitchStatusOpen) {
        // 如果是v1开启状态
        return [NSString stringWithFormat:@"%@:%@", versionString, RMCrashDemoBtnTitleOnString];
    }
    if (status == V1SwitchStatusCloseButUnenforced) {
        // 如果是v1关闭（尚未生效）状态
        return [NSString stringWithFormat:@"%@:%@%@", versionString, RMCrashDemoBtnTitleOffString, RMCrashDemoRebootTipsSuffixString];
    }
    return @"";
}

/// 获得v2切换按钮的title
- (NSString *)getV2SwitchBtnTitleWithStatus:(V2SwitchStatus)status {
    NSString *versionString = RMCrashDemoMonitorVersionV2String;
    
    if (status == V2SwitchStatusClose) {
        // 如果是v2关闭状态
        return [NSString stringWithFormat:@"%@:%@", versionString, RMCrashDemoBtnTitleOffString];
    }
    if (status == V2SwitchStatusOpenBaseButUnenforced) {
        // 如果是v2开启基础监控（尚未生效）状态
        return [NSString stringWithFormat:@"%@:%@%@%@",
                versionString,
                RMCrashDemoBtnTitleBaseString,
                RMCrashDemoBtnTitleOnString,
                RMCrashDemoRebootTipsSuffixString];
    }
    if (status == V2SwitchStatusOpenAdvancedButUnenforced) {
        // 如果是v2开启高级监控（尚未生效）状态
        return [NSString stringWithFormat:@"%@:%@%@%@",
                versionString,
                RMCrashDemoBtnTitleAdvancedString,
                RMCrashDemoBtnTitleOnString,
                RMCrashDemoRebootTipsSuffixString];
    }
    if (status == V2SwitchStatusOpenPremierButUnenforced) {
        // 如果是v2开启超级监控（尚未生效）状态
        return [NSString stringWithFormat:@"%@:%@%@%@",
                versionString,
                RMCrashDemoBtnTitlePremierString,
                RMCrashDemoBtnTitleOnString,
                RMCrashDemoRebootTipsSuffixString];
    }
    if (status == V2SwitchStatusOpenBase) {
        // 如果是v2开启基础监控状态
        return [NSString stringWithFormat:@"%@:%@%@",
                versionString,
                RMCrashDemoBtnTitleBaseString,
                RMCrashDemoBtnTitleOnString];
    }
    if (status == V2SwitchStatusOpenAdvanced) {
        // 如果是v2开启高级监控状态
        return [NSString stringWithFormat:@"%@:%@%@",
                versionString,
                RMCrashDemoBtnTitleAdvancedString,
                RMCrashDemoBtnTitleOnString];
    }
    if (status == V2SwitchStatusOpenPremier) {
        // 如果是v2开启超级监控状态
        return [NSString stringWithFormat:@"%@:%@%@",
                versionString,
                RMCrashDemoBtnTitlePremierString,
                RMCrashDemoBtnTitleOnString];
    }
    if (status == V2SwitchStatusCloseButUnenforced) {
        // 如果是v2关闭（尚未生效）状态
        return [NSString stringWithFormat:@"%@:%@%@",
                versionString,
                RMCrashDemoBtnTitleOffString,
                RMCrashDemoRebootTipsSuffixString];
    }
    return @"";
}

/// 获得v1切换按钮的背景色
- (UIColor *)getV1SwitcBtnBackgroundColorWithStatus:(V1SwitchStatus)status {
    if (status == V1SwitchStatusClose) {
        // 如果是v1关闭状态
        return [UIColor redColor];
    }
    if (status == V1SwitchStatusOpen) {
        // 如果是v1开启状态
        return [UIColor greenColor];
    }
    return [UIColor yellowColor];
}


/// 获得v2切换按钮的背景色
- (UIColor *)getV2SwitcBtnBackgroundColorWithStatus:(V2SwitchStatus)status {
    if (status == V2SwitchStatusClose) {
        // 如果是v2关闭状态
        return [UIColor redColor];
    }
    if (status == V2SwitchStatusOpenBase) {
        // 如果是v2开启基础监控状态
        return [UIColor greenColor];
    }
    if (status == V2SwitchStatusOpenAdvanced) {
        // 如果是v2开启高级监控状态
        return [UIColor greenColor];
    }
    if (status == V2SwitchStatusOpenPremier) {
        // 如果是v2开启超级监控状态
        return [UIColor greenColor];
    }
    return [UIColor yellowColor];
}


#pragma mark - Private
/// 根据传入的v1状态获得并缓存下一个v1状态
/// @param status 当前的v1状态
/// @return 返回下一个v1状态
- (V1SwitchStatus)cacheNextV1SwitchStatusWithStatus:(V1SwitchStatus)status {
    V1SwitchStatus nextV1SwitchStatus = V1SwitchStatusClose;
    do {
        if (status == V1SwitchStatusClose) {
            // 如果是v1关闭状态
            nextV1SwitchStatus = V1SwitchStatusOpenButUnenforced;
            break;
        }
        if (status == V1SwitchStatusOpenButUnenforced) {
            // 如果是v1开启（尚未生效）状态
            nextV1SwitchStatus = V1SwitchStatusClose;
            break;
        }
        if (status == V1SwitchStatusOpen) {
            // 如果是v1开启状态
            nextV1SwitchStatus = V1SwitchStatusCloseButUnenforced;
            break;
        }
        if (status == V1SwitchStatusCloseButUnenforced) {
            // 如果是v1关闭（尚未生效）状态
            nextV1SwitchStatus = V1SwitchStatusOpen;
            break;
        }
    } while (0);
    
    // 保存下一个v1状态
    [self syncCacheObject:@(nextV1SwitchStatus)
                   forKey:RMCrashDemoV1SwitchStatusUserDefaultKey];
    
    return nextV1SwitchStatus;
}

/// 根据传入的v2状态获得并缓存下一个v2状态
/// @param status 当前的v2状态
/// @param lastStatus 上一个v2状态
- (V2SwitchStatus)cacheNextV2SwitchStatusWithStatus:(V2SwitchStatus)status
                                         lastStatus:(V2SwitchStatus)lastStatus {
    V2SwitchStatus nextV2SwitchStatus = V2SwitchStatusClose;
    do {
        if (status == V2SwitchStatusClose) {
            // 如果是v2关闭状态，则下一个一定是：开启基础监控（尚未生效）状态
            nextV2SwitchStatus = V2SwitchStatusOpenBaseButUnenforced;
            break;
        }
        if (status == V2SwitchStatusOpenBaseButUnenforced) {
            // 如果是v2开启基础监控（尚未生效）状态
            if (lastStatus == V2SwitchStatusOpenAdvanced) {
                // 如果上一个v2状态是开启高级监控状态，则下一个是：开启高级监控状态
                nextV2SwitchStatus = V2SwitchStatusOpenAdvanced;
            } else {
                // 如果上一个v2状态不是开启高级监控状态，则下一个是：开启高级监控（尚未生效）状态
                nextV2SwitchStatus = V2SwitchStatusOpenAdvancedButUnenforced;
            }
            break;
        }
        if (status == V2SwitchStatusOpenAdvancedButUnenforced) {
            // 如果是v2开启高级监控（尚未生效）状态
            if (lastStatus == V2SwitchStatusOpenPremier) {
                // 如果上一个v2状态是开启超级监控状态，则下一个是：开启超级监控状态
                nextV2SwitchStatus = V2SwitchStatusOpenPremier;
            } else {
                // 如果上一个v2状态不是开启超级监控状态，则下一个是：开启超级监控（尚未生效）状态
                nextV2SwitchStatus = V2SwitchStatusOpenPremierButUnenforced;
            }
            break;
        }
        if (status == V2SwitchStatusOpenPremierButUnenforced) {
            // 如果是v2开启超级监控（尚未生效）状态
            if (lastStatus == V2SwitchStatusClose) {
                // 如果上一个v2状态是关闭状态，则下一个是：关闭状态
                nextV2SwitchStatus = V2SwitchStatusClose;
            } else {
                // 如果上一个v2状态不是关闭状态，则下一个是：关闭（尚未生效）状态
                nextV2SwitchStatus = V2SwitchStatusCloseButUnenforced;
            }
            break;
        }
        if (status == V2SwitchStatusCloseButUnenforced) {
            // 如果是v2关闭（尚未生效）状态
            if (lastStatus == V2SwitchStatusOpenBase) {
                // 如果上一个v2状态是开启基础监控状态，则下一个是：开启基础监控状态
                nextV2SwitchStatus = V2SwitchStatusOpenBase;
            } else {
                // 如果上一个v2状态不是开启基础监控状态，则下一个是：开启基础监控（尚未生效）状态
                nextV2SwitchStatus = V2SwitchStatusOpenBaseButUnenforced;
            }
        }
        if (status == V2SwitchStatusOpenBase) {
            // 如果是v2开启基础监控状态，则下一个一定是：开启高级监控（尚未生效）状态
            nextV2SwitchStatus = V2SwitchStatusOpenAdvancedButUnenforced;
            break;
        }
        if (status == V2SwitchStatusOpenAdvanced) {
            // 如果是v2开启高级监控状态，则下一个一定是：开启超级监控（尚未生效）状态
            nextV2SwitchStatus = V2SwitchStatusOpenPremierButUnenforced;
            break;
        }
        if (status == V2SwitchStatusOpenPremier) {
            // 如果是v2开启超级监控状态，则下一个一定是：关闭（尚未生效）状态
            nextV2SwitchStatus = V2SwitchStatusCloseButUnenforced;
            break;
        }
    } while (0);
    // 保存下一个v2状态
    [self syncCacheObject:@(nextV2SwitchStatus)
                   forKey:RMCrashDemoV2SwitchStatusUserDefaultKey];
    return nextV2SwitchStatus;
}

/// 存储
/// @param object object
/// @param key key
- (void)syncCacheObject:(id)object
                 forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:object
                                              forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 获得V1开关状态
- (V1SwitchStatus)loadLocalV1SwitchStatus {
    NSNumber *status = [[NSUserDefaults standardUserDefaults] objectForKey:RMCrashDemoV1SwitchStatusUserDefaultKey];
    if (!status) {
        // 如果本地不存在记录，则返回关闭状态（默认）
        return V1SwitchStatusClose;
    }
    if (![status isKindOfClass:[NSNumber class]]) {
        NSAssert(NO, @"illegal classs!");
        // 如果存储非法，则返回关闭状态（默认）
        return V1SwitchStatusClose;
    }
    return [status unsignedIntegerValue];
}

/// 获得V2开关状态
- (V2SwitchStatus)loadLocalV2SwitchStatusWithKey:(NSString *)key {
    NSNumber *status = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!status) {
        // 如果本地不存在记录，则返回关闭状态（默认）
        return V2SwitchStatusClose;
    }
    if (![status isKindOfClass:[NSNumber class]]) {
        NSAssert(NO, @"illegal classs!");
        // 如果存储非法，则返回关闭状态（默认）
        return V2SwitchStatusClose;
    }
    return [status unsignedIntegerValue];
}

/// 更新按钮为不可点击
/// @param button 按钮
- (void)updateBtnDisabled:(UIButton *)button {
    button.enabled = NO;
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:RMCrashDemoDisabledBtnTitle forState:UIControlStateNormal];
}

// 更新v1按钮的状态
- (void)updateV1SwitchStatus {
    // 读取上次存储值
    V1SwitchStatus lastV1SwitchStatus = [self loadLocalV1SwitchStatus];
    
    if (lastV1SwitchStatus == V1SwitchStatusClose) {
        // 如果v1是关闭状态，这种情况不用更新存储值
        return;
    }
    
    if (lastV1SwitchStatus == V1SwitchStatusOpen) {
        // 如果v1是开启状态，更新当前v1状态为开启
        self.currentV1SwitchStatus = V1SwitchStatusOpen;
        // 这种情况不用更新存储值
        return;
    }
    
    V1SwitchStatus currentV1SwitchStatus = V1SwitchStatusClose;
    if (lastV1SwitchStatus == V1SwitchStatusOpenButUnenforced) {
        // 如果v1是开启（尚未生效）状态，更新当前v1状态为开启
        currentV1SwitchStatus = V1SwitchStatusOpen;
    }
    
    self.currentV1SwitchStatus = currentV1SwitchStatus;
    
    // 更新存储值
    [self syncCacheObject:@(currentV1SwitchStatus)
                   forKey:RMCrashDemoV1SwitchStatusUserDefaultKey];
}

// 更新v2按钮的状态
- (void)updateV2SwitchStatus {
    // 读取上次存储值
    V2SwitchStatus lastV2SwitchStatus = [self loadLocalV2SwitchStatusWithKey:RMCrashDemoV2SwitchStatusUserDefaultKey];
    
    if (lastV2SwitchStatus == V2SwitchStatusClose) {
        // 如果v2是关闭状态，这种情况不用更新存储值
        return;
    }
    
    if (lastV2SwitchStatus == V2SwitchStatusOpenBase) {
        // 如果v2是开启基础监控状态，这种情况不用更新存储值，更新当前v2状态为开启基础监控状态
        self.currentV2SwitchStatus = V2SwitchStatusOpenBase;
        return;
    }
    
    if (lastV2SwitchStatus == V2SwitchStatusOpenAdvanced) {
        // 如果v2是开启高级监控状态，这种情况不用更新存储值，更新当前v2状态为开启高级监控状态
        self.currentV2SwitchStatus = V2SwitchStatusOpenAdvanced;
        return;
    }
    
    if (lastV2SwitchStatus == V2SwitchStatusOpenPremier) {
        // 如果v2是开启超级监控状态，这种情况不用更新存储值，更新当前v2状态为开启超级监控状态
        self.currentV2SwitchStatus = V2SwitchStatusOpenPremier;
        return;
    }
    
    V2SwitchStatus currentV2SwitchStatus = V2SwitchStatusClose;
    if (lastV2SwitchStatus == V2SwitchStatusOpenBaseButUnenforced) {
        // 如果v2是开启基础监控（尚未生效）状态，更新当前v2状态为开启基础监控状态
        currentV2SwitchStatus = V2SwitchStatusOpenBase;
    }
    
    if (lastV2SwitchStatus == V2SwitchStatusOpenAdvancedButUnenforced) {
        // 如果v2是开启高级监控（尚未生效）状态，更新当前v2状态为开启高级监控状态
        currentV2SwitchStatus = V2SwitchStatusOpenAdvanced;
    }
    
    if (lastV2SwitchStatus == V2SwitchStatusOpenPremierButUnenforced) {
        // 如果v2是开启高级监控（尚未生效）状态，更新当前v2状态为开启高级监控状态
        currentV2SwitchStatus = V2SwitchStatusOpenPremier;
    }
    self.currentV2SwitchStatus = currentV2SwitchStatus;
    
    // 更新存储值
    [self syncCacheObject:@(currentV2SwitchStatus)
                   forKey:RMCrashDemoV2SwitchStatusUserDefaultKey];
}

/// 配置开关状态
- (void)setupSwitchStatus {
    self.currentV1SwitchStatus = [self loadLocalV1SwitchStatus];
    self.currentV2SwitchStatus = [self loadLocalV2SwitchStatusWithKey:RMCrashDemoV2SwitchStatusUserDefaultKey];
}

/// 设置视图
- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.v1SwitchBtn];
    [self.view addSubview:self.v2SwitchBtn];
    [self.view addSubview:self.jumpToCrashTesterPageBtn];
    [self.view addSubview:self.instructionLabel];
}

/// 展示一个alert
/// @param message 内容
- (void)showAlertVcWithMessage:(NSString * _Nonnull)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:^{
        // 设定自动消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RMCrashDemoAlertDismissDuration * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:NO completion:nil];
        });
    }];
    
}


/// 创建一个标准的按钮
/// @param point CGPoint
/// @param title 标题
/// @param titleColor 标题颜色
/// @param backgroundColor 背景颜色
/// @param accessibilityIdentifier accessibilityIdentifier
/// @param clickActionSelection 点击事件SEL
- (UIButton *)createStandardBtnWithPoint:(CGPoint)point
                                   title:(NSString *)title
                              titleColor:(UIColor *)titleColor
                         backgroundColor:(UIColor *)backgroundColor
                 accessibilityIdentifier:(NSString *)accessibilityIdentifier
                    clickActionSelection:(SEL)clickActionSelection {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, RMCrashDemoBtnWidth, RMCrashDemoBtnHeight)];
    [btn setBackgroundColor:backgroundColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.accessibilityIdentifier = accessibilityIdentifier;
    btn.layer.cornerRadius = RMCrashDemoBtnCornerRadius;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:clickActionSelection forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - Getter & Setter
/// 切换v1监控开关按钮
- (UIButton *)v1SwitchBtn {
    if (!_v1SwitchBtn) {
        CGFloat contentX = (self.view.frame.size.width - RMCrashDemoBtnWidth) / 2;
        CGFloat contentY = (self.view.frame.size.height) / 5;
        NSString *title = [self getV1SwitchBtnTitleWithStatus:self.currentV1SwitchStatus];
        UIColor *backgroundColor = [self getV1SwitcBtnBackgroundColorWithStatus:self.currentV1SwitchStatus];
        NSString *accessibilityIdentifier = RMCrashDemoV1SwitchBtnAccessibilityIdentifier;
        SEL clickActionSelection = @selector(switchBtnClick:);
        // 传入各项按钮配置参数，获得一个标准按钮
        _v1SwitchBtn = [self createStandardBtnWithPoint:CGPointMake(contentX, contentY)
                                                  title:title
                                             titleColor:[UIColor blackColor]
                                        backgroundColor:backgroundColor
                                accessibilityIdentifier:accessibilityIdentifier
                                   clickActionSelection:clickActionSelection];
    }
    return _v1SwitchBtn;
}


/// 切换v2监控开关按钮
- (UIButton *)v2SwitchBtn {
    if (!_v2SwitchBtn) {
        CGFloat contentX = (self.view.frame.size.width - RMCrashDemoBtnWidth) / 2;
        CGFloat contentY = (self.view.frame.size.height) / 3;
        NSString *title = [self getV2SwitchBtnTitleWithStatus:self.currentV2SwitchStatus];
        UIColor *backgroundColor = [self getV2SwitcBtnBackgroundColorWithStatus:self.currentV2SwitchStatus];
        NSString *accessibilityIdentifier = RMCrashDemoV2SwitchBtnAccessibilityIdentifier;
        SEL clickActionSelection = @selector(switchBtnClick:);
        // 传入各项按钮配置参数，获得一个标准按钮
        _v2SwitchBtn = [self createStandardBtnWithPoint:CGPointMake(contentX, contentY)
                                                  title:title
                                             titleColor:[UIColor blackColor]
                                        backgroundColor:backgroundColor
                                accessibilityIdentifier:accessibilityIdentifier
                                   clickActionSelection:clickActionSelection];
    }
    return _v2SwitchBtn;
}

/// 跳转按钮
- (UIButton *)jumpToCrashTesterPageBtn {
    if (!_jumpToCrashTesterPageBtn) {
        CGFloat contentX = (self.view.frame.size.width - RMCrashDemoBtnWidth) / 2;
        CGFloat contentY = (self.view.frame.size.height) / 2;
        NSString *title = RMCrashDemoJumpToCrashTesterPageBtnTitle;
        UIColor *backgroundColor = [UIColor darkGrayColor];
        NSString *accessibilityIdentifier = RMCrashDemoJumpToCrashTesterPageBtnAccessibilityIdentifier;
        SEL clickActionSelection = @selector(jumpToCrashTesterPageBtnClick);
        // 传入各项按钮配置参数，获得一个标准按钮
        _jumpToCrashTesterPageBtn = [self createStandardBtnWithPoint:CGPointMake(contentX, contentY)
                                                               title:title
                                                          titleColor:[UIColor whiteColor]
                                                     backgroundColor:backgroundColor
                                             accessibilityIdentifier:accessibilityIdentifier
                                                clickActionSelection:clickActionSelection];
    }
    return _jumpToCrashTesterPageBtn;
}

/// 介绍文本
- (UILabel *)instructionLabel {
    if (!_instructionLabel) {
        CGFloat labelX = (self.view.frame.size.width - RMCrashDemoBtnWidth) / 2;
        CGFloat contentY = self.jumpToCrashTesterPageBtn.frame.origin.y + RMCrashDemoBtnHeight + RMCrashDemoViewGap;
        _instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, contentY, RMCrashDemoLabelWidth, RMCrashDemoLabelHeight)];
        NSMutableParagraphStyle *paragrahStyle = [NSMutableParagraphStyle new];
        paragrahStyle.lineSpacing = 8;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
            initWithString:RMCrashDemoInstructionLabelText];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle
                                 range:NSMakeRange(0, [attributedString length])];
        _instructionLabel.attributedText = attributedString;
        _instructionLabel.numberOfLines = 0;
        [_instructionLabel sizeToFit];
    }
    return _instructionLabel;;
}
@end
