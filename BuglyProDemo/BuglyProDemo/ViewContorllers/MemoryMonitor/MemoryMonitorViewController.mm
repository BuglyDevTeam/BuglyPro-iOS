//
//  MemoryMonitorViewController.m
//  RMonitorExample
//
//  Created by Tianwu Wang on 2021/5/8.
//

#import "MemoryMonitorViewController.h"

#import <mach/mach_time.h>
#import <sys/mman.h>
#import <malloc/malloc.h>

//#import "RMHeapGraph.h"
//#import "RMMemoryMonitorPlugin.h"
//#import "Bugly2+Private.h"

void malloc50MMemory(void) {
    int size = 50 * 1024 * 1024;
    void *ptr = malloc(size);
    memset(ptr, 0xFF, size);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(0, 0), ^{
        free(ptr);
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int index = 0; index < 10000; index++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                           dispatch_get_global_queue(0, 0), ^{
                void* ptr = mmap(0, vm_page_size*10+1, (PROT_READ|PROT_WRITE), (MAP_ANON|MAP_PRIVATE), 0, 0);
                memset(ptr, 0xF, vm_page_size*10);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                               dispatch_get_global_queue(0, 0), ^{
                    munmap(ptr, vm_page_size);
                });
            });
        }
    });
}

void malloc500MMemory(void) {
    int size = 1*1024*1024;
    void** ptrs = (void**)malloc(500*sizeof(void*));
    for (int index = 0; index < 500; index++) {
        ptrs[index] = malloc(size);
        memset(ptrs[index], 0xEE, size);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.0 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(0, 0), ^{
        for (int index = 0; index < 500; index++) {
            free(ptrs[index]);
        }
        free(ptrs);
    });
}
//
//@interface RMMemoryMonitorPlugin (UITestHelper)
//
//- (NSString *)dumpMemoryGraph;
//
//@end

@interface MemoryMonitorViewController ()

@property (weak, nonatomic) IBOutlet UITextView *logsView;

@property (nonatomic, strong) NSMutableString *logs;

@property (nonatomic, strong) dispatch_queue_t workQueue;

@end

@implementation MemoryMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logs = [[NSMutableString alloc] initWithString:@"logs:\n"];
    self.logsView.text = self.logs;
    
    self.workQueue = dispatch_queue_create("rmonitor.heap.graph", DISPATCH_QUEUE_SERIAL);
}

- (void)viewDidAppear:(BOOL)animated {
    [self scrollLogsViewToBottom];
}

- (void)scrollLogsViewToBottom {
    if(self.logsView.text.length > 0 ) {
        NSRange bottom = NSMakeRange(self.logsView.text.length -1, 1);
        [self.logsView scrollRangeToVisible:bottom];
    }
}

- (IBAction)mallocBigMemory:(id)sender {
    malloc50MMemory();
    
    [self.logs appendString:@"Malloc 50M heap memory.\n"];
    self.logsView.text = self.logs;
}

- (IBAction)memoryOverflow:(id)sender {
    malloc500MMemory();
    
    [self.logs appendString:@"Simulator memory overflow.\n"];
    self.logsView.text = self.logs;
}

- (IBAction)heapGraph:(id)sender {
    dispatch_async(self.workQueue, ^{
        static mach_timebase_info_data_t sTimebaseInfo;
        mach_timebase_info(&sTimebaseInfo);
        
        uint64_t start_time = mach_absolute_time();
        
//        RMMemoryMonitorPlugin *plugin = [Bugly2 instanceForClass:RMMemoryMonitorPlugin.class];
//        NSString *dumpFilePath = [plugin dumpMemoryGraph];
        
        NSString *dumpFilePath;
        
        uint64_t end_time = mach_absolute_time();
        uint64_t dur_millis = ((end_time/1e6)*sTimebaseInfo.numer)/sTimebaseInfo.denom -
                              ((start_time/1e6)*sTimebaseInfo.numer)/sTimebaseInfo.denom;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.logs appendFormat:@"dump heap graph to:%@\n", dumpFilePath];
            [self.logs appendFormat:@"dump heap graph cost:%llums\n", dur_millis];
            self.logsView.text = self.logs;
            [self scrollLogsViewToBottom];
        });
    });
}

@end
