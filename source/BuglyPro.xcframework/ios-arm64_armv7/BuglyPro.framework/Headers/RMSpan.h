//
//  RMSpan.h
//  RaftMonitor
//
//  Created by engleliu on 2021/10/13.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// span 信息
@interface RMSpan : NSObject

/// traceId，16-byte array
@property (nonatomic, readonly, copy) NSString *traceId;
/// spanId，8-byte array
@property (nonatomic, readonly, copy) NSString *spanId;
/// span name
@property (nonatomic, copy) NSString *spanName;
/// 8-byte array，为根span时为空
@property (nonatomic, nullable, copy) NSString *parentSpanId;
/// unix 时间戳，单位ms
@property (nonatomic, assign) NSInteger startTimeMs;
/// unix 时间戳，单位ms
@property (nonatomic, assign) NSInteger endTimeMs;
///
@property (nonatomic, copy) NSString *kind;

/// create new span
/// @param spanName spanName
/// @param parentSpan parentSpan
+ (RMSpan *)spanWithName:(NSString *)spanName parent:(nullable RMSpan *)parentSpan;

+ (NSInteger)currentSpanTime;

- (void)endSpan;

@end

NS_ASSUME_NONNULL_END
