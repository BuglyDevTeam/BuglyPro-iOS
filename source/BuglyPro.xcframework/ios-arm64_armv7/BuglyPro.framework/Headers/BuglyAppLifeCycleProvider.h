//
//  BuglyAppLifeCycleProvider.h
//  RaftMonitor
//
//  Created by Tianwu Wang on 2023/12/15.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuglyAppLifeCycleNotifyInfos : NSObject

@property (nonatomic, copy) NSNotificationName appDidFinishLaunchingNotifyName;
@property (nonatomic, copy) NSNotificationName appWillEnterForgroundNotifyName;
@property (nonatomic, copy) NSNotificationName appDidBecomeActiveNotifyName;
@property (nonatomic, copy) NSNotificationName appDidEnterBackgroundNotifyName;
@property (nonatomic, copy) NSNotificationName appWillResignActiveNotifyName;
@property (nonatomic, copy) NSNotificationName appDidReceiveMemoryWarningNotifyName;
@property (nonatomic, copy) NSNotificationName appWillTerminateNotifyName;

@end

@interface BuglyAppLifeCycleProvider : NSObject

/**
 * 是否启用 app delegate swizzle，默认开启
 * 开启后，会提高 SDK 对前后台状态判定的准确性
 */
- (BOOL)useAppLifeCycleSwizzle;

/**
 * 确保 BuglyAppLifeCycleNotifyInfos 值都是有效值
 */
- (BuglyAppLifeCycleNotifyInfos *)appLifeCycleNotifyInfos;

/**
 * SDK 内部会随时调用此方法，因此需要确保其实现安全高效
 */
- (UIApplicationState)currentAppState;

@end

NS_ASSUME_NONNULL_END
