//
//  BuglyNetworkDefines.h
//  RaftMonitor
//
//  Created by Tianwu Wang on 2023/8/25.
//  Copyright © 2023 Tencent. All rights reserved.
//

#ifndef BuglyNetworkDefines_h
#define BuglyNetworkDefines_h

typedef enum BuglyNetworkConnectState {
    BuglyNetworkConnectNetworkUnknown = 0,         // 未知网络状态
    BuglyNetworkConnectNetworkCellular = 1,        // 蜂窝网络
    BuglyNetworkConnectNetworkWifi = 2,            // Wifi 网络

    BuglyNetworkConnectAppStateUnknown = 0 << 2,    // 未知App状态
    BuglyNetworkConnectAppStateActive = 1 << 2,     // App 前台活跃
    BuglyNetworkConnectAppStateBackground = 2 << 2, // App 后台
} BuglyNetworkConnectState;

typedef enum BuglyNetworkConnectType {
    BuglyNetworkConnectUNKNOWN = 0, // 未知

    BuglyNetworkConnectAuto = 1,        // Bugly 自动收集
    BuglyNetworkConnectCustom = 2,      // 业务上报

    BuglyNetworkConnectUDP = 1 << 4,     // UDP， 从 UDP 记录
    BuglyNetworkConnectTCP = 2 << 4,     // TCP， 从 TCP 链接记录
    BuglyNetworkConnectHTTP = 4 << 4,    // HTTP，记录到的是 HTTP 请求
} BuglyNetworkConnectType;


#endif /* BuglyNetworkDefines_h */
