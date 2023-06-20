//
//  Bugly.h
//
//  Version: 2.0(1)
//
//  Copyright (c) 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BuglyConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bugly : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

/**
 *  初始化Bugly
 *
 *  @param config 传入配置的 BuglyConfig
 */
+ (void)startWithConfig:(BuglyConfig *)config;

/**
 * 初始化Bugly
 *
 * @param pluginArr 启用的模块，默认使用 RM_MODULE_ALL
 * @param config 传入配置的 BuglyConfig
 */
+ (void)start:(NSArray<NSString *> *)pluginArr config:(BuglyConfig *)config;

+ (void)start:(NSArray<NSString *> *)pluginArr
       config:(BuglyConfig *)config completeHandler:(nullable void (^)(void))completionHandler;

/// 注册日志函数指针
/// @param logger 日志函数
+ (void)registerLogCallback:(RMLogCallback)logger;

/// 更新userId
/// @param userId 用户id
+ (void)updateUserIdentifier:(NSString *)userId;

/// 更新设备id
/// @param deviceId 设备id
+ (void)updateDeviceIdentifier:(NSString *)deviceId;

/// 更新场景信息
/// @param scene 场景id，卡顿、内存、资源监控等功能会根据该值进行聚类
+ (void)setScene:(NSString *)scene;

/// 重置自定义场景信息，继续使用 RMonitor 自动获取的场景信息
+ (void)resetScene;

/**
 *  获取 SDK 版本信息
 *  @return SDK版本号
 */
+ (NSString *)sdkVersion;

/**
 * 添加自定义上报的tag, SDK初始化前调用无效
 * @param data 需要更新的自定义字段
 */
+ (void)updateCustomData:(BuglyCustomData *)data;

/**
 * 获取当前自定标签的副本信息，若未设置，返回空
 * @return 已设置的用户自定义字段
 */
+ (nullable BuglyCustomData *)currentCustomData;

/**
 * 添加自定义数据为特定的事件上报
 * @param data 需要更新的自定义字段
 * @param eventType 对应的事件类型
 */
+ (void)updateCustomData:(BuglyCustomData *)data forEvent:(BuglyEventTypeName)eventType;

/**
 * 获取特定事件的当前自定义数据
 * @param eventType 需要获取的事件类型
 * @return 对应已设置的自定义字段
*/
+ (nullable BuglyCustomData *)currentCustomDataForEvent:(BuglyEventTypeName)eventType;

@end

NS_ASSUME_NONNULL_END
