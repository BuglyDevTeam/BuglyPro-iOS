//
//  Crasher.m
//
//  Created by Karl Stenerud on 2012-01-28.
//

#import "Crasher.h"
//#import <QAPM/KSCrash.h>
#import <pthread.h>
#import <exception>
#import <os/lock.h>
#import <UIKit/UIKit.h>
#include <sys/time.h>
#import <BuglyPro/BuglyCrashMonitorPlugin.h>

static void sigroutine(int signo) {
    switch (signo) {
        case SIGALRM:
            NSLog(@"Catch a signal -- SIGALRM\n ");
            break;
            return;
    }
}
    
static void timerSignal(void) {
    struct itimerval value;

    NSLog(@"process id is %d\n ", getpid());
    signal(SIGALRM, sigroutine);
    value.it_value.tv_sec = 0;
    value.it_value.tv_usec = 1e6 / 60;
    value.it_interval.tv_sec = 0;
    value.it_interval.tv_usec = 1e6 / 60;
    setitimer(ITIMER_REAL, &value, NULL);
}

static os_unfair_lock hashmap_unfair_lock = OS_UNFAIR_LOCK_INIT;

class MyException : public std::exception {
public:
    virtual const char *what() const noexcept;
};

const char *MyException::what() const noexcept {
    return "Something bad happened...";
}

class MyCPPClass {
public:
    void throwAnException() {
        throw MyException();
    }
};

@interface MyClass : NSObject
@end
@implementation MyClass
@end

@interface MyProxy : NSProxy
@end
@implementation MyProxy
@end

@interface RefHolder : NSObject {
    __unsafe_unretained id _ref;
}
@property (nonatomic, readwrite, assign) id ref;

@end

@implementation RefHolder

- (id)ref {
    return _ref;
}

- (void)setRef:(id)ref {
    _ref = ref;
}

@end

@interface RefClass : NSObject
@end

@implementation RefClass

- (void)dealloc{
    __weak __typeof(self)wself = self;
    NSLog(@"%@",wself);
}
@end


@interface Crasher ()

@property (nonatomic, readwrite, retain) NSLock *lock;
@property (nonatomic, assign) RefHolder *holder;
@property (nonatomic, assign) RefClass *refClass;

@end

@implementation Crasher

@synthesize lock = _lock;

- (id)init {
    if ((self = [super init])) {
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

int *g_crasher_null_ptr = NULL;
int g_crasher_denominator = 0;

- (void)throwUncaughtNSException {
    id data = [NSArray arrayWithObject:@"Hello World"];
    [(NSDictionary *)data objectForKey:@""];
}

- (void)throwUndefineSelectorException {
    NSObject *objc = [[NSObject alloc] init];
    [objc performSelector:@selector(unknownSelector)];
}

- (void)dereferenceBadPointer {
    char *ptr = (char *)-1;
    *ptr = 1;
}

- (void)dereferenceNullPointer {
    *g_crasher_null_ptr = 1;
}

- (void)useCorruptObject {
    // From http://landonf.bikemonkey.org/2011/09/14

    // Random data
    void *pointers[] = { NULL, NULL, NULL };
    void *randomData[] = { (void *)"a", (void *)"b", (void *)pointers, (void *)"d", (void *)"e", (void *)"f" };

    // A corrupted/under-retained/re-used piece of memory
    struct {
        void *isa;
    } corruptObj = { randomData };

    // Message an invalid/corrupt object.
    // This will deadlock if called in a crash handler.
    [(__bridge id) & corruptObj class];
}

- (void)spinRunloop {
    // From http://landonf.bikemonkey.org/2011/09/14

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"ERROR: Run loop should be dead but isn't!");
    });
    *g_crasher_null_ptr = 1;
}

- (void)causeStackOverflow {
    [self causeStackOverflow];
}

- (void)doAbort {
    abort();
}

- (void)doDiv0 {
    //    int value = 10;
    //    value /= g_crasher_denominator;
    //    NSLog(@"%d", value);
    NSDecimalNumber *i = [NSDecimalNumber decimalNumberWithDecimal:[@(1) decimalValue]];
    NSDecimalNumber *o = [NSDecimalNumber decimalNumberWithDecimal:[@(0) decimalValue]];
    NSDecimalNumber *x = [i decimalNumberByDividingBy:o];
    NSLog(@"%@", x);
}

- (void)doIllegalInstruction {
    unsigned int data[] = { 0x11111111, 0x11111111 };
    void (*funcptr)() = (void (*)())data;
    funcptr();
}

- (void)accessDeallocatedObject {
    //    NSArray* array = [[NSArray alloc] initWithObjects:@"", nil];
    //    [array release];
    //    void* ptr = array;
    //    memset(ptr, 0xe1, 16);
    //    [array objectAtIndex:10];
    //    return;

    RefHolder *ref = [RefHolder new];
    ref.ref = [NSArray arrayWithObjects:@"test1", @"test2", nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Object = %@", [ref.ref objectAtIndex:1]);
    });
}

- (void)accessDeallocatedPtrProxy {
    RefHolder *ref = [RefHolder new];
    ref.ref = [MyProxy alloc];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Object = %@", ref.ref);
    });
}

- (void)zombieNSException {
//    @try {
//        NSString *value = @"This is a string";
//        [NSException raise:@"TurboEncabulatorException"
//                    format:@"Spurving bearing failure: Barescent skor motion non-sinusoidal for %p", value];
//    } @catch (NSException *exception) {
//        RefHolder *ref = [RefHolder new];
//        ref.ref = exception;
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"Exception = %@", ref.ref);
//        });
//    }
    {
        RefHolder* h = [RefHolder new];
        self.holder = h;
    }
    id ref = [UIView new];
    self.holder.ref = ref;
}

- (void)corruptMemory {
    size_t stringsize = sizeof(uintptr_t) * 2 + 2;
    NSString *string = [NSString stringWithFormat:@"%d", 1];
    NSLog(@"%@", string);
    void *cast = (__bridge void *)string;
    uintptr_t address = (uintptr_t)cast;
    void *ptr = (char *)address + stringsize;
    memset(ptr, 0xa1, 500);
}

- (void)deadlock {
    [self.lock lock];
    [NSThread sleepForTimeInterval:0.2f];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.lock lock];
    });
}

- (void)pthreadAPICrash {
    // http://landonf.bikemonkey.org/code/crashreporting
    pthread_getname_np(pthread_self(), (char *)0x1, 1);
}

- (void)userDefinedCrash {
    NSError *error = [NSError errorWithDomain:@"Error Test" code:-2 userInfo:nil];
    [BuglyCrashMonitorPlugin reportError:error];
    //    NSString* name = @"Script Error";
    //    NSString* reason = @"fragment is not defined";
    //    NSString* language = @"karlscript";
    //    NSString* lineOfCode = @"string.append(fragment)";
    //    NSArray* stackTrace = [NSArray arrayWithObjects:
    //                           @"Printer.script, line 174: in function assembleComponents",
    //                           @"Printer.script, line 209: in function print",
    //                           @"Main.script, line 10: in function initialize",
    //                           nil];
    //
    //    [[KSCrash sharedInstance] reportUserException:name
    //                                           reason:reason
    //                                         language:language
    //                                       lineOfCode:lineOfCode
    //                                       stackTrace:stackTrace
    //                                    logAllThreads:YES
    //                                 terminateProgram:NO];
}

- (void)throwUncaughtCPPException {
    MyCPPClass instance;
    instance.throwAnException();
}

- (void)recursivelyUnfairLock {
    os_unfair_lock_lock(&hashmap_unfair_lock);
    os_unfair_lock_lock(&hashmap_unfair_lock);
    NSLog(@"Is locking...Thread : %@", [NSThread currentThread]);
    os_unfair_lock_unlock(&hashmap_unfair_lock);
}

- (void)testErrorTranslate{
    [self A];
}
- (void)A{
    [self B];
}

- (void)B{
    NSArray * arr = [NSThread callStackSymbols];
    NSDictionary *myDictionary = @{
        @"key1": @"value1",
        @"key2": @"value2",
        @"key3": @"value3"
    };
    [BuglyCrashMonitorPlugin reportExceptionWithCategory:3 name:@"translateTest" reason:@"hh" callStack:arr extraInfo:myDictionary terminateApp:false];
}

- (void)deallocLockAbort {
    timerSignal();
    
    NSLog(@"begin");
    for (long long index = 0; index < 9999; index++) {
        self.vc.title = [NSString stringWithFormat:@"%lld", index];
    }
    NSLog(@"end");
}

- (void)objcStoreWeakCrash {
    //objc_storeWeak类型Crash
    RefClass* h = [RefClass new];
    self.refClass = h;
}

@end
