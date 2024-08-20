//
//  BuglyPageLoadMonitor.h
//  RaftMonitor
//
//  Created by Tianwu Wang on 2024/8/6.
//

#import <Foundation/Foundation.h>

@class UIViewController;

@class RMSpan;

NS_ASSUME_NONNULL_BEGIN

@interface BuglyPageLoadMonitor : NSObject

/**
 * 标识当前 VC 渲染完成
 * 若始终未调用此方法，则使用 viewDidAppear 为结束时间
 * @param vc 对应 VC 对象
 */
+ (void)endVCRender:(UIViewController *)vc;

/**
 * 添加一组 spans 为当前 vc
 * @param spans 添加的 spans
 * @param vc 对应 VC 对象
 */
+ (void)addSpans:(NSArray<RMSpan *> *)spans forVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
