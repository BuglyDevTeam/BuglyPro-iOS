//
//  Crasher.h
//
//  Created by Karl Stenerud on 2012-01-28.
//  Copyright (c) 2021年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Crasher : NSObject

@property (nonatomic, strong) UIViewController *vc;

- (void)throwUncaughtNSException;

- (void)throwUndefineSelectorException;

- (void)dereferenceBadPointer;

- (void)dereferenceNullPointer;

- (void)useCorruptObject;

- (void)spinRunloop;

- (void)causeStackOverflow;

- (void)doAbort;

- (void)doDiv0;

- (void)doIllegalInstruction;

- (void)accessDeallocatedObject;

- (void)accessDeallocatedPtrProxy;

- (void)zombieNSException;

- (void)corruptMemory;

- (void)deadlock;

- (void)pthreadAPICrash;

- (void)userDefinedCrash;

- (void)throwUncaughtCPPException;

- (void)recursivelyUnfairLock;

- (void)deallocLockAbort;

- (void)objcStoreWeakCrash;

@end
