//
//  AppDelegate.m
//  BuglyProDemo
//
//  Created by Hongbo Cui on 2023/5/8.
//

#import "AppDelegate.h"
#import <BuglyPro/Bugly.h>
#import <BuglyPro/BuglyConfig.h>
#import <BuglyPro/BuglyDefine.h>
#import <BuglyPro/BuglyLaunchMonitorPlugin.h>
#import <BuglyPro/BuglyCrashMonitorPlugin.h>
#include <sys/types.h>
#include <sys/sysctl.h>

static void logger_func(RMLoggerLevel level, const char *log) {
    NSLog(@"%s", log);
}

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /// 设置RMonitor日志输出
    [Bugly registerLogCallback:logger_func];
    [BuglyLaunchMonitorPlugin startSpan:@"parentSpan" parentSpanName:nil];
    [BuglyLaunchMonitorPlugin startSpan:@"spanTest" parentSpanName:@"parentSpan"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [BuglyLaunchMonitorPlugin endSpan:@"spanTest"];
        [BuglyLaunchMonitorPlugin endSpanFromLaunch:@"spanFromLaunch"];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [BuglyLaunchMonitorPlugin endSpan:@"parentSpan"];
    });
    
    [BuglyLaunchMonitorPlugin addTag:@"tagTest1"];
    [BuglyLaunchMonitorPlugin addTag:@"tagTest2"];
    
    BuglyConfig* config = [[BuglyConfig alloc] initWithAppId:@"a2031e998b" appKey:@"5f58a9cf-0acc-4c0d-a020-fc8f0bacb3cc"];
 
    [Bugly start:RM_MODULE_ALL config:config];
    
    return YES;
}

+ (void)setupCustomFiles{
    NSString *directoryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"BuglyCustomFileDirectory"];
    [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:nil];
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error) {
        NSLog(@"创建目录时出错: %@", error.localizedDescription);
        return;
    }
    
    NSString *filePath = [directoryPath stringByAppendingPathComponent:@"testFile.file"];
    NSError *writeError;
    NSString *content = @"Hello World!";
    [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    if (writeError) {
        NSLog(@"创建文件时出错: %@", writeError.localizedDescription);
    } else {
        NSLog(@"文件创建成功，路径为: %@", filePath);
    }

    [BuglyCrashMonitorPlugin setAdditionalAttachmentPaths:@[filePath]];
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
