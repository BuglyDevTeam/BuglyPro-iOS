#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BuglyDefine.h"
#import "Bugly.h"
#import "BuglyConfig.h"
#import "BuglyCustomData.h"
#import "BuglyDelegate.h"
#import "BuglyAppLifeCycleProvider.h"
#import "BuglyCrashMonitorPlugin.h"
#import "BuglyLaunchMonitorPlugin.h"
#import "BuglyMetricKitMonitorPlugin.h"

FOUNDATION_EXPORT double BuglyProVersionNumber;
FOUNDATION_EXPORT const unsigned char BuglyProVersionString[];

