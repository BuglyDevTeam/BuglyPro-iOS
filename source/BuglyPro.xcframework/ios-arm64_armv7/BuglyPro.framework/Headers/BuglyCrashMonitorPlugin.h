//
//   BuglyCrashMonitorPlugin.h
//   RaftMonitor
//
//   Created by engleliu on 2022/7/20
//   Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BuglyUnhandledCrash) {
    BuglyUnhandledCrash_Default = 0,
    BuglyUnhandledCrash_Kotlin = 1,
};

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
 *
 * @brief 上报自定义 crash 的堆栈
 * 1. 该上报接口会 dump 全部线程信息，解析 stackArr 中堆栈作为 crash 线程的堆栈上报到后台
 * 2. 调用该接口后，会关闭 crash 的监控，但不会主动杀进程，因此业务应该主动杀进程以规避异常。
 * 3. 和“reportException”、“reportError”、“reportExceptionWithCategory”方法不同，该方法会生成一条crash 上报，并算在用户的 crash 率
 * 因此该方法适合一些信息不全的crash上报，例如 “Kotlin Exception”
 * 4. 为了能够识别堆栈地址并上报，stackArr 应该为 "[index] [image name] [address] [others]" 的结构，中间用空格或者tab键隔开
 * 例如 "0   RMonitorExample                     0x102b38347        ThrowArrayIndexOutOfBoundsException + 159",
 * 5. 该接口仅在 bugly sdk 初始化结束后生效
 */
+ (void)reportUnhandledCrash:(BuglyUnhandledCrash)type
                        name:(NSString *)name
                      reason:(NSString *)reason
                   callStack:(NSArray<NSString *> *)stackArr;

/**
 * 设置自定义附件的绝对路径的集合。
 * 文件压缩后的大小不大于10M，二次启动时上报。
 */
+ (void)setAdditionalAttachmentPaths:(NSArray<NSString *>*)pathArray;

@end

NS_ASSUME_NONNULL_END
