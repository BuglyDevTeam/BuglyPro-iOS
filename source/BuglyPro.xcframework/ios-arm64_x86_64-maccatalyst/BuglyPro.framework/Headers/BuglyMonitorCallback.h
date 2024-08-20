//
//  BuglyMonitorCallback.h
//  Bugly
//
//  Created by Tianwu Wang on 2024/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BuglyMonitorCallbackEvent) {
    BuglyMonitorCallbackEvent_NULL = 0, // 为定义
    BuglyMonitorCallbackEvent_FPS = 1,  // FPS
};

typedef void (^BuglyMonitorCallback)(BuglyMonitorCallbackEvent event, NSDictionary *eventInfo);


NS_ASSUME_NONNULL_END
