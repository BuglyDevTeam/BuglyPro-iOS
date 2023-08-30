//
//   BuglyDelegate.h
//   RaftMonitor
//
//   Created by engleliu on 2023/4/27
//   Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuglyCustomData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BuglyDelegate <NSObject>

@optional
/// 允许业务带附件到个例上报中
/// @param eventType 个例事件类型
/// @param customData 业务自定义字段
/// @param eventInfo 个例信息，暂为空
- (NSDictionary<NSString *, NSString *> *)attachmentForEvent:(NSString *)eventType
                                                  customData:(BuglyCustomData *)customData
                                                   eventInfo:(NSDictionary *)eventInfo;

/**
 *  发生异常时回调
 *  @param exception 异常信息
 *  @return 返回需上报记录，随异常上报一起上报
 */
- (NSString * __nullable)attachmentForException:(NSException * __nullable)exception;

@end

NS_ASSUME_NONNULL_END
