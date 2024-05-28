# SDK更新日志

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
