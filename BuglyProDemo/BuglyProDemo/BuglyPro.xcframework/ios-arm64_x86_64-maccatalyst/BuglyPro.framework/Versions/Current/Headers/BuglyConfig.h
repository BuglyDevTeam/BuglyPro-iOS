//
//   BuglyConfig.h
//   RaftMonitor
//
//   Created by engleliu on 2023/4/27
//   Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuglyDefine.h"
#import "BuglyDelegate.h"

NS_ASSUME_NONNULL_BEGIN

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
@property (nonatomic, assign) id<BuglyDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// @brief init
/// @param appId 详见 http://bugly.oa.com/, 项目管理 - 产品配置 - appid
/// @param appKey 详见 http://bugly.oa.com/, 项目管理 - 产品配置 - appkey
- (instancetype)initWithAppId:(NSString *)appId appKey:(NSString *)appKey;

+ (BuglyConfig *)paramWithAppId:(NSString *)appId appKey:(NSString *)appKey;

@end

NS_ASSUME_NONNULL_END
