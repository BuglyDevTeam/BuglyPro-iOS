//
//  BuglyMetricKitMonitorPlugin.h
//  RMonitor
//
//  Created by saiyanren on 2021/8/10.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MetricKit/MetricKit.h>

NS_ASSUME_NONNULL_BEGIN

/// MetricKit 监控模块Plugin，Bugly 初始化时包含 RM_MODULE_METRICKIT 相关逻辑才会生效
/// 因为 iOS 16.0.x 系统注册多个 metrickit 回调时，有概率发生 crash
/// 因此如果业务必须注册 metrickit 回调时，可以使用 +[BuglyMetricKitMonitorPlugin reportMXMetricPayloadArray:] 和 +[BuglyMetricKitMonitorPlugin reportMXDiagnosticPayloadArray:] 单独将 metrickit 数据上报到 bugly 平台
/// 注意，如果使用上述两个接口上报时，需要关闭 bugly metrickit 开关，防止数据重复上报
@interface BuglyMetricKitMonitorPlugin : NSObject

/// 上报 metrickit metric 数据，必须要 +[Bugly startWithConfig:] 或者 +[Bugly start: config:] 后调用才生效
/// 使用该接口上报数据时，需要关闭 bugly metrickit 线上配置开关，防止数据重复上报
/// @param payloads MXMetricManagerSubscriber didReceiveMetricPayloads 接口回调的 payloads
+ (void)reportMXMetricPayloadArray:(NSArray<MXMetricPayload *> *)payloads API_AVAILABLE(ios(13.0));

/// 上报 metrickit diagnostic 数据，必须要 +[Bugly startWithConfig:] 或者 +[Bugly start: config:] 后调用才生效
/// 使用该接口上报数据时，需要关闭 bugly metrickit 线上配置开关，防止数据重复上报
/// @param payloads MXMetricManagerSubscriber didReceiveDiagnosticPayloads 接口回调的 payloads
+ (void)reportMXDiagnosticPayloadArray:(NSArray<MXDiagnosticPayload *> *)payloads API_AVAILABLE(ios(14.0));

@end

NS_ASSUME_NONNULL_END
