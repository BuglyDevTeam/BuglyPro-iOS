//
//  Bugly.h
//
//  Version: 2.0(1)
//
//  Copyright (c) 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BuglyDefine.h"
#import "BuglyConfig.h"
#import "BuglyMonitorCallback.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bugly : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

/**
 * 初始化 Bugly
 *
 * !!!: 整个进程生命周期中，仅可以调用和初始化一次 Bugly SDK！！！
 *
 * @param config 传入配置的 BuglyConfig
 */
+ (void)startWithConfig:(BuglyConfig *)config;

/**
 * 初始化 Bugly
 *
 * @param pluginArr 启用的模块，默认使用 RM_MODULE_ALL
 * @param config 传入配置的 BuglyConfig
 */
+ (void)start:(NSArray<NSString *> *)pluginArr config:(BuglyConfig *)config;
+ (void)start:(NSArray<NSString *> *)pluginArr
       config:(BuglyConfig *)config completeHandler:(nullable void (^)(void))completionHandler;

/**
 * 是否允许 Bugly 进行数据上报，未调用过此接口时，数据上报正常打开
 * !!!: 仅当前进程设置有效，下次重新启动后，会恢复默认打开状态，SDK 初始化完成前设置无效
 * 在必要时，可通过设置为 NO 禁止/恢复 SDK 产生数据上报
 * 若设置为 NO 时，内部数据上报及产生的数据全部丢弃，若之后重新设置为 YES 时，之后产生数据会恢复上报
 */
+ (void)setBuglyDataReportEnable:(BOOL)isEnable;

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

/**
 * 更新 shiply sdk 相关标签，需要在 bugly sdk 完成初始化（Bugly setup completeHandler 回调）后调用，否则可能导致数据丢失
 * @params tagArr 字符串数组，字符串限长 1024 字节，数组限长 30
 */
+ (void)updateShiplyTags:(NSArray<NSString *> *)tagArr;

/**
 * 更新个例标签，需要在 bugly sdk 完成初始化（Bugly setup completeHandler 回调）后调用，否则可能导致数据丢失
 * @params tagArr 字符串数组，字符串限长 1024 字节，数组限长 30
 */
+ (void)updateCaseTags:(NSArray<NSString *> *)tagArr;

/**
 * 更新实验标签，需要在 bugly sdk 完成初始化（Bugly setup completeHandler 回调）后调用，否则可能导致数据丢失
 * @params tagArr 字符串数组，字符串限长 1024 字节，数组限长 30
 */
+ (void)updateTestTags:(NSArray<NSString *> *)tagArr;

/**
 * 设置 app 扩展版本号
 */
+ (void)setAppDynamicExtendVersion:(NSString *)extendVersion;

/**
 * 设置监控回调
 * 监控回调用于实时回调对应监控项的实时数据
 * @params callback 对应的回调，因实时回调，因此 callback 中的处理需要尽可能的快速, 空表示清楚上次设置
 * @params event 对应的监控项目
 */
+ (void)setBuglyMonitorCallback:(nullable BuglyMonitorCallback)callback
                       forEvent:(BuglyMonitorCallbackEvent)event;

@end

NS_ASSUME_NONNULL_END

#if defined __has_include
    #if __has_include("Bugly+Deprecated.h")
        #import "Bugly+Deprecated.h"
    #endif
#endif
#if defined __has_include
    #if __has_include("BuglyExceptionReportInfo.h")
        #import "BuglyExceptionReportInfo.h"
    #endif
#endif
