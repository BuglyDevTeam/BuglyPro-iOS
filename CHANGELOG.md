# SDK更新日志

## 2.8.1

Release On 2025.05.28

### Update
* 支持分模块构建和发布产物
* 增加 Bugly SDK 初始化异常恢复机制（SDK 初始化失败清理缓存和配置）
* 启动监控支持 prewarm 类型启动类型的区分
* 构建产物关闭 bitcode 等编译选项
* 个例上报增加启动时间上报
* 增加 buglyid 生成上报，提高联网设备数的计算准确性
* 增加 malloc_logger 对已有接口的调用
* 优化 DAU 上报包体大小
* 适配 keyboard extension FOOM 在新机型中的判断逻辑
* GWP-ASan 优化，可监控更多内存分配对象
* 优化 FOOM 判断，改善在内存快速增长场景下的 FOOM 判断
* Crash mach 层监控改为默认开启
* 增加 BuglyLogger 模块，允许业务打印部分日志到 Bugly Crash 中

### Fix
* 修复卡顿监控中出现的数据存储越界问题（历史问题）
* 修复 mach exception 捕获 fault addr 获取错误的问题
* 大内存分配监控缓存数据上报堆栈地址错误问题
* 修复网络监控中 host 字段获取失败的问题
* ANR 个例上报增加抓栈间隔字段
* BuglySwizzleCache 中多线程访问的线程安全问题
* Crash/异常退出监控对 SIGPIPE 信号的处理问题
* 启动监控中存在自定义 span 和 tag 丢失的问题
* 调整 Bugly 内部数据持久化逻辑，减少 ANR 堆栈序列化失败的问题

## Version 2.8.0.12

Release on 2025.05.27

### Fix
* 修复分模块构建产物中版本号默认域名等注入错误的问题；

## Version 2.8.0.11

Release on 2025.05.22

### Fix
* 卡顿监控问题修复；

## Version 2.8.0.10

Release on 2025.05.13

### Update
* 发布产物支持分模块接入；


## Version 2.8.0.6

Release on 2025.03.18

### Fix
* ANR 个例上报增加抓栈间隔字段；
* Crash 捕获中 SIGPIPE 信号的处理问题；
* 修复 BuglySwizzlerCache 中存在的多线程访问问题；

## Version 2.8.0

Release on 2025.01.13

### Update
* 支持网络质量监控；
* 支持页面加载耗时监控；
* 支持 GWP-ASan；
* 增加监控数据实时回调接口支持；
* 支持渠道联网数据下钻；
* 支持附件上报加密；
* 数据上报加密支持配置管理；
* 数据上报增加 buildConfig 字段，支持上报数据后台过滤；
* 优化获取 C++ 异常调用栈的逻辑；
* 优化数据上报及缓存逻辑，提高缓存效率；

### Fix
* 优化 UISceneDelegate 管理下生命周期获取不及时的问题；
* 优化 MachOImageList 重复拷贝引起的内存占用问题；
* 修复卡顿监控场景字段存在非线程安全访问的问题；
* 修复流量监控中阈值判断问题；
* 修复流量监控中 swizzle 网络接口存在的异常问题；
* 修复主线程访问 NSUserDefault 在部分场景下造成性能影响问题；
* 修复内存图 dump 时 dirty 部分计算错误的问题；
* VC 泄漏白名单 mangle 部分系统私有类名；
* 修复 setUserValue 中出现的空指针异常；
* 修复使用 kotlin 异常监控时，部分 kotlin 异常会通过 C++ 异常上报的问题；
* 解决 kotlin 异常上报堆栈为空的问题；
* 修复 Bugly Dispatch Recording 与系统 ASan 的兼容问题；


## Version 2.7.55.6

Release on 2024.10.25

### Update:
* 支持设置上报域名；

## Version 2.7.55.5

Release on 2024.10.21

### Fix:
* 优化数据上报及缓存逻辑，提高缓存效率；
* 修复卡顿监控场景字段存在非线程安全访问的问题；
* 修复流量监控中阈值判断问题；
* 修复流量监控中 swizzle 网络接口存在的异常问题；
* 修复主线程访问 NSUserDefault 在部分场景下造成性能影响问题；


## Version 2.7.55.1

Release on 2024.08.14

### Fix:
* 限制网络监控仅支持 iOS 13.0 及以上系统

## Version 2.7.55

Release on 2024.08.09

### Update
* SDK 支持 minidump 信息采集；
* 增加 C++ 异常的抛异常调用栈；
* 支持 mach 异常捕获；
* 上报增加 hotpatch 字段；
* 优化 ANR 无堆栈问题；
* coredump 增加上传能力；
* 优化异步堆栈回溯实现；
* 优化 foom 退出判定条件；
* footprint 采集频率增加配置控制&增加 wakeup 的数据收集；
* 优化内存图触发时采集系统内存信息的方式；
* AppEventTracker 中增加 VC 内存信息数据；
* 优化 vmmapgraph dump 效率；
* MetricKit 支持按照配置类型进行上报；
* 支持 Crash 监控模块单独预初始化；
* 支持业务主动关闭 Bugly 网络上报；

## Version 2.7.53.12

Release on 2024.07.29

### Fix:
* 解决未初始化 Crash 模块时，更新用户名异常的问题；
* 解决自定义文件上传处理超大文件异常的问题；

## Version 2.7.53.10

Release on 2024.05.28

### Fix:
* 解决 SDK 与业务符号冲突问题；

## Version 2.7.53.9

Release on 2024.05.08

### Fix:
* 重定义 rapidjson 中命名空间名称，解决因符号冲突导致的地址异常问题；

## Version 2.7.53.5

Release on 2024.04.09

### Fix:
* 适配苹果隐私清单；

## Version 2.7.53.3

Release on 2024.02.04

### Fix:
* 解决个例标签与实验标签字段命名问题；
* 解决VC 泄漏检查中可能存在的死循环问题；

## Version 2.7.53.2

Release on 2024.02.01

* 2.7.53-beta更新版本号至正式版

## Version 2.7.53-beta.9

Release on 2024.01.24

### Update

* SDK 支持流量监控数据的采集和上报；
* Crash 上报支持场景字段；
* Kotlin 异常上报支持；
* 优化 Crash & 错误附件上报逻辑；
* FOOM 内存堆栈记录性能优化 & 支持 extension 中的堆栈记录；
* 内存图上报关联 FOOM 和 VC 泄漏上报；
* VC 泄漏支持白名单配置，通过白名单配置，排除业务不需要监控的 VC；
* 调整 SDK 数据上报及配置拉取逻辑，减少配置覆盖的延迟问题；
* 支持个例标签和实验标签；

### Fix:

* 修复 VC 泄漏中存在的误判问题；
* 修复 Xcode 15 编译及 iOS 17 适配问题；
* 修复内存图配置存在的区间问题，解决部分情况下配置不生效的情况；
* 修复数据上报序列化存在异常的问题；
* 修复数据上报中因断言引发的异常问题；
* 修复退后台后卡顿模块抓栈问题；
* 优化 crash 漏报问题；
* 修复 ns/c++ crash.log 中 crash 线程堆栈回溯异常问题；
* 增加 zombie 检测保护；
* 优化 VC 操作日志，增加默认值，便于确认是否存在 VC 变化等操作；

## Version 2.7.51.2

Release on 2023.12.12

### Fix

* 解决三方SDK重写uuid_unparse方法导致uuid处理异常的问题


## Version 2.7.51

Release on 2023.08.24

### Update

* Bugly专业版发布
