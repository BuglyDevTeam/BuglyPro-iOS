//
//   BuglyConfig.h
//   Bugly
//
//   Created by engleliu on 2023/4/27
//   Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuglyDefine.h"
#import "BuglyDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class BuglyAppLifeCycleProvider;

@interface BuglyConfig : NSObject

/// appid, 详见 https://bugly.oa.com/ 产品配置 - appid
@property (nonatomic, copy) NSString *appId;

/// appkey, 详见 https://bugly.oa.com/ 产品配置 - appkey
@property (nonatomic, copy) NSString *appKey;
/// 设置自定义版本号
@property (nonatomic, copy) NSString *appVersion;
/// 设置自定义设备唯一标识
@property (nonatomic, copy) NSString *deviceIdentifier;
/// 自定义用户id
@property (nonatomic, copy) NSString *userIdentifier;
/// build config，用于拉取不同的配置
@property (nonatomic, assign) BuglyBuildConfig buildConfig;

/// Bugly Delegate
@property (nonatomic, weak) id<BuglyDelegate> delegate;

/// 可以提供自定义的生命周期 provider
@property (nonatomic, strong) BuglyAppLifeCycleProvider *appLifeCycleProvider;

/// 是否预初始化 Crash 监控, 默认为 NO
/// 开启后，可以同步提前初始化 Crash 监控模块，增加启动阶段的 Crash 捕获成功率
/// 但会增加一定的启动耗时，同时基础的 Crash 监控的开启不再接受 Bugly 平台的配置的控制
/// (但 Crash 上报依然接受配置控制）
@property (atomic, assign) BOOL isSyncInitCrashMonitor;

/// 设置自定义渠道标识
@property (nonatomic, copy) NSString *channel;
 
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// @brief init
/// @param appId 详见 http://bugly.oa.com/, 项目管理 - 产品配置 - appid
/// @param appKey 详见 http://bugly.oa.com/, 项目管理 - 产品配置 - appkey
- (instancetype)initWithAppId:(NSString *)appId appKey:(NSString *)appKey;

+ (BuglyConfig *)paramWithAppId:(NSString *)appId appKey:(NSString *)appKey;

@end

NS_ASSUME_NONNULL_END

#if defined __has_include
    #if __has_include("BuglyConfig+Deprecated.h")
        #import "BuglyConfig+Deprecated.h"
    #endif
#endif
