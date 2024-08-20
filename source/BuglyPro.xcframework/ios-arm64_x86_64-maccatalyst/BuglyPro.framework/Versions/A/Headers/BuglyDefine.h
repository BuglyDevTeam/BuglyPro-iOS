//
//  BuglyDefine.h
//  Bugly
//
//  Created by Tianwu Wang on 2023/2/20.
//  Copyright © 2023 Tencent. All rights reserved.
//

#ifndef BuglyDefine_h
#define BuglyDefine_h

#ifdef __OBJC__
#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const RM_MODULE_MEMORY;
FOUNDATION_EXTERN NSString *const RM_MODULE_LOOPER;
FOUNDATION_EXTERN NSString *const RM_MODULE_LAUNCH;
FOUNDATION_EXTERN NSString *const RM_MODULE_YELLOW;
FOUNDATION_EXTERN NSString *const RM_MODULE_METRICKIT;
FOUNDATION_EXTERN NSString *const RM_MODULE_RESOURCE;
FOUNDATION_EXPORT NSString *const BUGLY_MODUEL_NETWORK API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0), tvos(13.0));
FOUNDATION_EXTERN NSString *const BUGLY_MODULE_CRASH;
FOUNDATION_EXPORT NSString *const BUGLY_MODUEL_PAGE_LAUNCH;
FOUNDATION_EXTERN NSArray  *const RM_MODULE_ALL;

#endif

#ifdef __cplusplus
extern "C" {
#endif

// Log level for Bugly Log
typedef enum BuglyLogLevel {
    BuglyLogLevelSilent  = 0,
    BuglyLogLevelError   = 1,
    BuglyLogLevelWarn    = 2,
    BuglyLogLevelInfo    = 3,
    BuglyLogLevelDebug   = 4,
    BuglyLogLevelVerbose = 5,
} BuglyLogLevel;

typedef enum BuglyBuildConfig {
    BuglyBuildConfigDefault = 0,    //Unknown
    BuglyBuildConfigDebug   = 1,    //Debug
    BuglyBuildConfigGray    = 2,    //Gray
    BuglyBuildConfigRelease = 3,    //Release
} BuglyBuildConfig;

/**
 日志级别
 */
typedef enum RMLoggerLevel {
    ///外发版本log
    RMLogLevelEvent = 0,
    ///灰度和内部版本log
    RMLogLevelInfo = 1,
    ///内部版本log
    RMLogLevelDebug = 2,
} RMLoggerLevel;

/**
 用于输出SDK调试log的回调
 */
typedef void (*RMLogCallback)(RMLoggerLevel level, const char *log);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif /* BuglyDefine_h */
