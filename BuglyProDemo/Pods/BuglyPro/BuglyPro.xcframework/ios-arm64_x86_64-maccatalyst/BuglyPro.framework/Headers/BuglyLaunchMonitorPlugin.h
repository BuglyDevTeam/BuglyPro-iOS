//
//  BuglyLaunchMonitorPlugin.h
//  RaftMonitor
//
//  Created by ttttjiang on 2021/5/19.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 启动耗时监控对外暴露API
@interface BuglyLaunchMonitorPlugin : NSObject

/// main 函数执行时调用，仅用于打点获取时间戳
+ (void)didEnterMain DEPRECATED_MSG_ATTRIBUTE("deprecated");

/// 更新 main 函数执行时间点，如果在 main 函数中调用了 +[BuglyLaunchMonitorPlugin didEnterMain] 方法，则不需要再调用该方法更新 main 函数执行时间点。
/// @param unixTimeInterval unix 时间戳，即从1970-01-01 00:00:00 开始计时的时间戳，单位s，精度需要到ms
/// @param systemUpTime 系统自上次重新启动以来一直处于唤醒状态的时间，单位s，精度需要到ms
+ (void)setMainUnixTimeInterval:(NSTimeInterval)unixTimeInterval systemUpTime:(NSTimeInterval)systemUpTime
DEPRECATED_MSG_ATTRIBUTE("deprecated");

/// 插入一个span，span 的结构可以想象为一个 n 叉树，一个简化版的火焰图，endColdLaunch 或者默认启动时间点结束后调用不会起作用
/// @param spanName span 名，相同 span 名会被覆盖
/// @param parentSpanName 父节点的 span 名
+ (void)startSpan:(NSString *)spanName parentSpanName:(nullable NSString *)parentSpanName;
/// 结束一个span，如果 spanName 不存在则不添加到上报，endColdLaunch 或者默认启动时间点结束后调用不会起作用。
/// 启动上报后会清空缓存的 span 列表。
+ (void)endSpan:(NSString *)spanName;
/// 从进程开始作为起始时间，添加一个 span 上报
/// 因为前后台切换不包含进程创建时间，所以前后台切换调用时无效
+ (void)endSpanFromLaunch:(NSString *)spanName;
/// 设置“冷启动”结束
+ (void)endColdLaunch;

/// 添加一个tag
+ (void)addTag:(NSString *)tagName;
/// 移除一个tag
+ (void)removeTag:(NSString *)tagName;

@end

NS_ASSUME_NONNULL_END
