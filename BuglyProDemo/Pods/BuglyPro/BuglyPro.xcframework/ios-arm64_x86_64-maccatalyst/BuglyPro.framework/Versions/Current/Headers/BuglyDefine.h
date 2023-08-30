//
//  BuglyDefine.h
//  Bugly
//
//  Created by Tianwu Wang on 2023/2/20.
//  Copyright © 2023 Tencent. All rights reserved.
//

#ifndef BuglyDefine_h
#define BuglyDefine_h

#define RM_MODULE_MEMORY    @"RMMemoryMonitorPlugin"
#define RM_MODULE_LOOPER    @"BuglyLooperMonitorPlugin"
#define RM_MODULE_LAUNCH    @"BuglyLaunchMonitorPlugin"
#define RM_MODULE_YELLOW    @"RMYellowMonitorPlugin"
#define RM_MODULE_METRICKIT @"BuglyMetricKitMonitorPlugin"
#define RM_MODULE_RESOURCE  @"RMResourceMonitorPlugin"
#define BUGLY_MODULE_CRASH  @"BuglyCrashMonitorPlugin"

#define RM_MODULE_ALL \
    @[BUGLY_MODULE_CRASH, RM_MODULE_MEMORY, RM_MODULE_LOOPER, RM_MODULE_LAUNCH, \
      RM_MODULE_YELLOW, RM_MODULE_METRICKIT, RM_MODULE_RESOURCE]

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
