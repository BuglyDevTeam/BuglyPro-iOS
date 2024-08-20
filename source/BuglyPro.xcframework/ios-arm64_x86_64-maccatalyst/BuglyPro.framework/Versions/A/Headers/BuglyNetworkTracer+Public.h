//
//  BuglyNetworkTracer+Public.h
//  RaftMonitor
//
//  Created by Tianwu Wang on 2023/9/12.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BuglyNetworkDefines.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 网络监控 tracer 类
 * 可以通过此对象，自定义跟踪网络连接，实现对网络流量的监控
 */
@interface BuglyNetworkTracer : NSObject

/**
 * 使用后面的类方法直接创建实力对象
 */
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

/**
 * 创建并返回对象
 * @param peerName 网络连接的对等名称
 */
+ (BuglyNetworkTracer *)tracerWithPeerName:(NSString *)peerName;
/**
 * @param type 类型
 */
+ (BuglyNetworkTracer *)tracerWithPeerName:(NSString *)peerName type:(BuglyNetworkConnectType)type;

/**
 * 用户将 tracer 注册到相关的对象中，后续可以直接从对象中获取 tracer
 */
- (void)injectToObj:(id)obj;
+ (BuglyNetworkTracer *)tracerFromObj:(id)obj;

/**
 * 连接开始
 */
- (void)connectStart;
/**
 * 记录连接收发数据，内部会自动累加
 */
- (void)connectSendAppend:(int64_t)bytes;
- (void)connectRecvAppend:(int64_t)bytes;
/**
 * 直接设置收发数据，会覆盖之前已记录的数据
 */
- (void)setConnectSend:(int64_t)bytes;
- (void)setConnectRecv:(int64_t)bytes;
- (void)setConnectTotalSend:(int64_t)sendBytes totalRecv:(int64_t)recvBytes;
/**
 * 连接结束，调用后，该 tracer 会被 Bugly 记录并
 */
- (void)connectComplete;

@end

NS_ASSUME_NONNULL_END
