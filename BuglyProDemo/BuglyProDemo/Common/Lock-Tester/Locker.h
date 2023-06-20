//
//   Locker.h
//   RMonitorExample
//
//   Created by engleliu on 2023/3/14
//   Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Locker : NSObject

- (void)OSSpinLock;

- (void)osUnfairLock;

- (void)pthreadMutex;

- (void)pthreadRecursiveMutex;

- (void)dispatchSemaphore;

- (void)nscondition;

- (void)nsconditionLock;

- (void)nsconditionLockTryLock;

- (void)nslock;

- (void)nsRecursiveLock;

- (void)synchronized;

- (void)dispatchQueue;

@end

NS_ASSUME_NONNULL_END
