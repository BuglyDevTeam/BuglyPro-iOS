//
//   BuglyCrashMonitorPlugin.h
//   RaftMonitor
//
//   Created by engleliu on 2022/7/20
//   Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuglyCrashMonitorPlugin : NSObject

/**
 *  设置关键数据，随崩溃信息上报
 *
 *  @param value KEY
 *  @param key VALUE
 */
+ (void)setUserValue:(NSString *)value forKey:(NSString *)key;


/**
 *  获取关键数据
 *
 *  @return 关键数据
 */
+ (NSDictionary * _Nullable)allUserValues;

/**
 *  上报自定义Objective-C异常
 *
 *  @param exception 异常信息
 */
+ (void)reportException:(NSException *)exception;

/**
 *  上报错误
 *
 *  @param error 错误信息
 */
+ (void)reportError:(NSError *)error;

/**
 *    @brief 上报自定义错误
 *
 *    @param category    类型(Cocoa=3,CSharp=4,JS=5,Lua=6)
 *    @param aName       名称
 *    @param aReason     错误原因
 *    @param aStackArray 堆栈
 *    @param info        附加数据，需要 key、value 均为 NSString 类型
 *    @param terminate   上报后是否退出应用进程
 */
+ (void)reportExceptionWithCategory:(NSUInteger)category
                               name:(NSString *)aName
                             reason:(NSString *)aReason
                          callStack:(NSArray *)aStackArray
                          extraInfo:(NSDictionary <NSString *, NSString *> *)info
                       terminateApp:(BOOL)terminate;

/**
 * 设置自定义附件的绝对路径的集合。
 * 文件压缩后的大小不大于10M，二次启动时上报。
 */
+ (void)setAdditionalAttachmentPaths:(NSArray<NSString *>*)pathArray;

@end

NS_ASSUME_NONNULL_END
