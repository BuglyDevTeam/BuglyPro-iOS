//
//   Locker.m
//   RMonitorExample
//
//   Created by engleliu on 2023/3/14
//   Copyright © 2023 Tencent. All rights reserved.
//

#import "Locker.h"
#import <pthread.h>
#import <libkern/OSSpinLockDeprecated.h>
#import <os/lock.h>

@implementation Locker

- (void)OSSpinLock {
    OSSpinLock lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&lock);
    NSLog(@"%s", __FUNCTION__);
    OSSpinLockUnlock(&lock);
}

- (void)osUnfairLock {
    os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
    os_unfair_lock_lock(&lock);
    NSLog(@"%s", __FUNCTION__);
    os_unfair_lock_unlock(&lock);
}

- (void)pthreadMutex {
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    pthread_mutex_lock(&mutex);
    pthread_mutex_lock(&mutex);
    NSLog(@"%s", __FUNCTION__);
    pthread_mutex_unlock(&mutex);
}

- (void)pthreadRecursiveMutex {
    pthread_mutex_t mutex = PTHREAD_RECURSIVE_MUTEX_INITIALIZER;
    pthread_mutex_lock(&mutex);
    NSLog(@"%s", __FUNCTION__);
    pthread_mutex_unlock(&mutex);
}

- (void)dispatchSemaphore {
    dispatch_semaphore_t lock =  dispatch_semaphore_create(1);
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    NSLog(@"%s", __FUNCTION__);
    dispatch_semaphore_signal(lock);
}

- (void)dispatchQueue {
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"%s", __FUNCTION__);
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%s", __FUNCTION__);
        });
    });
}

- (void)nscondition {
    NSCondition *lock = [NSCondition new];
    [lock lock];
    NSLog(@"%s", __FUNCTION__);
    [lock unlock];
}

- (void)nsconditionLock {
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:1];
    [lock lock];
    NSLog(@"%s", __FUNCTION__);
    [lock unlock];
}

- (void)nsconditionLockTryLock {
    NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:1];
    [lock tryLock];
    NSLog(@"%s", __FUNCTION__);
    [lock unlock];
}

- (void)nslock {
    NSLock *lock = [NSLock new];
    [lock lock];
    NSLog(@"%s", __FUNCTION__);
    [lock unlock];
}

- (void)nsRecursiveLock {
    NSRecursiveLock *lock = [NSRecursiveLock new];
    [lock lock];
    NSLog(@"%s", __FUNCTION__);
    [lock unlock];
}

- (void)synchronized {
    NSObject *lock = [NSObject new];
    @synchronized (lock) {
        NSLog(@"%s", __FUNCTION__);
    }
}

@end
