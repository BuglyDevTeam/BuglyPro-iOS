//
//  BuglyCustomData.h
//  RaftMonitor
//
//  Created by Tianwu Wang on 2022/3/23.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


FOUNDATION_EXPORT NSString * const RMUserDefaultCustomDataStoreKey;

typedef NSString * BuglyEventTypeName NS_TYPED_EXTENSIBLE_ENUM;

FOUNDATION_EXTERN BuglyEventTypeName const BuglyEventTypeHang;
FOUNDATION_EXTERN BuglyEventTypeName const BuglyEventTypeFOOM;
FOUNDATION_EXTERN BuglyEventTypeName const BuglyEventTypeDeadlock;
FOUNDATION_EXTERN BuglyEventTypeName const BuglyEventTypeVCLeak;
FOUNDATION_EXTERN BuglyEventTypeName const BuglyEventTypeBadMalloc;
FOUNDATION_EXTERN BuglyEventTypeName const BuglyEventTypeVMGraph;

typedef NSString * BuglyCustomNumberDataKey NS_STRING_ENUM;

FOUNDATION_EXPORT BuglyCustomNumberDataKey const BuglyCustomNumberDataKey1;
FOUNDATION_EXPORT BuglyCustomNumberDataKey const BuglyCustomNumberDataKey2;
FOUNDATION_EXPORT BuglyCustomNumberDataKey const BuglyCustomNumberDataKey3;
FOUNDATION_EXPORT BuglyCustomNumberDataKey const BuglyCustomNumberDataKey4;
FOUNDATION_EXPORT BuglyCustomNumberDataKey const BuglyCustomNumberDataKey5;
FOUNDATION_EXPORT BuglyCustomNumberDataKey const BuglyCustomNumberDataKey6;
FOUNDATION_EXPORT BuglyCustomNumberDataKey const BuglyCustomNumberDataKey7;
FOUNDATION_EXPORT BuglyCustomNumberDataKey const BuglyCustomNumberDataKey8;
FOUNDATION_EXPORT BuglyCustomNumberDataKey const BuglyCustomNumberDataKey9;
FOUNDATION_EXPORT BuglyCustomNumberDataKey const BuglyCustomNumberDataKey10;

typedef NSString * BuglyCustomStringDataKey NS_STRING_ENUM;

FOUNDATION_EXPORT BuglyCustomStringDataKey const BuglyCustomStringDataKey1;
FOUNDATION_EXPORT BuglyCustomStringDataKey const BuglyCustomStringDataKey2;
FOUNDATION_EXPORT BuglyCustomStringDataKey const BuglyCustomStringDataKey3;
FOUNDATION_EXPORT BuglyCustomStringDataKey const BuglyCustomStringDataKey4;
FOUNDATION_EXPORT BuglyCustomStringDataKey const BuglyCustomStringDataKey5;
FOUNDATION_EXPORT BuglyCustomStringDataKey const BuglyCustomStringDataKey6;
FOUNDATION_EXPORT BuglyCustomStringDataKey const BuglyCustomStringDataKey7;
FOUNDATION_EXPORT BuglyCustomStringDataKey const BuglyCustomStringDataKey8;
FOUNDATION_EXPORT BuglyCustomStringDataKey const BuglyCustomStringDataKey9;
FOUNDATION_EXPORT BuglyCustomStringDataKey const BuglyCustomStringDataKey10;

typedef NSString * BuglyCustomArrayDataKey NS_STRING_ENUM;

FOUNDATION_EXPORT BuglyCustomArrayDataKey const BuglyCustomArrayDataKey1;
FOUNDATION_EXPORT BuglyCustomArrayDataKey const BuglyCustomArrayDataKey2;
FOUNDATION_EXPORT BuglyCustomArrayDataKey const BuglyCustomArrayDataKey3;
FOUNDATION_EXPORT BuglyCustomArrayDataKey const BuglyCustomArrayDataKey4;
FOUNDATION_EXPORT BuglyCustomArrayDataKey const BuglyCustomArrayDataKey5;
FOUNDATION_EXPORT BuglyCustomArrayDataKey const BuglyCustomArrayDataKey6;
FOUNDATION_EXPORT BuglyCustomArrayDataKey const BuglyCustomArrayDataKey7;
FOUNDATION_EXPORT BuglyCustomArrayDataKey const BuglyCustomArrayDataKey8;
FOUNDATION_EXPORT BuglyCustomArrayDataKey const BuglyCustomArrayDataKey9;
FOUNDATION_EXPORT BuglyCustomArrayDataKey const BuglyCustomArrayDataKey10;

// 字符串不能超过1024个字符
FOUNDATION_EXPORT int const BUGLY_CUSTOM_DATA_MAX_STRING_VALUE_LENGTH;
// 字符串数组的最大长度
FOUNDATION_EXPORT int const BUGLY_CUSTOM_DATA_MAX_STRING_ARRAY_LENGTH;

/**
 * 业务自定义标签接口
 * 可根据使用方的需求，在标签中添加自定义字段：
 * 标签字段必须是string类型，且限制最大长度不超过128字符，超过部分会被截断；
 * 标签数量不超过10个，超过部分会被丢弃；
 *
 * 标签会随数据上报一并上报到后台，按照标签传入顺序，依次被存储在'k1', 'k2', 'k3' ...列下，数据均以string的方式存储
 */
@interface BuglyCustomData : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSDictionary *)customDataDictInfo;

/**
 * 使用新的自定义字段更新此自定义数据
 * @param dict 符合BuglyCustomData存储格式的字典信息
 * @return 返回在次数据基础上更新后的新数据
 */
- (BuglyCustomData *)customDataByUpdateDict:(NSDictionary *)dict;

/**
  * 获取设置的数字类型的自定义数据
  * @param key 如果KEY不在NumberParamKey定义中，直接返回0.0
  * @return 如果有设置，则返回当前值，如果没有设置，返回0.0
  */
- (nullable NSNumber *)getNumberParam:(BuglyCustomNumberDataKey)key;

/**
 * 设置数字类型的自定义数据
 * @param key 如果KEY不在NumberParamKey定义中，则添加失败
 * @param param NUMBER VALUE
 */
- (BOOL)putNumberParam:(nullable NSNumber *)param forKey:(BuglyCustomNumberDataKey)key;

/**
  * 获取设置的字符串类型的自定义数据
  * @param key 如果KEY不在StringParamKey定义中，直接返回""
  * @return 如果有设置，则返回当前值，如果没有设置，返回""
  */
- (nullable NSString *)getStringParam:(BuglyCustomStringDataKey)key;

/**
 * 设置字符串类型的自定义数据
 * @param key 如果KEY不在StringParamKey定义中，则添加失败
 * @param param 长度不能超过 BUGLY_CUSTOM_DATA_MAX_STRING_VALUE_LENGTH
 *     value = null, 则会设置空串
 *     value = 长度超标字符串，则会截取前BUGLY_CUSTOM_DATA_MAX_STRING_VALUE_LENGTH个字符设置
 */
- (BOOL)putStringParam:(nullable NSString *)param forKey:(BuglyCustomStringDataKey)key;

/**
 * 获取字符串数组类型的自定义数据
 * @param key 如果KEY不在StringArrayParamKey定义中，则直接返回空列表
 * @return 如果有设置，则返回相关设置数据，如果没有设置，则直接返回空列表, 返回的List不可以修改。
 */
- (nullable NSArray<NSString *> *)getStringArrayParam:(BuglyCustomArrayDataKey)key;

/**
 * 添加顺序是：A1 -> A2 -> A2 -> A3 -> A4, 这个接口产生的结果类似：[A1, A2, A3, A4]
 * 为字符串数组类型的自定义数据，增加VALUE
 * @param key 如果KEY不在StringArrayParamKey定义中，则添加失败
 * @param param 非空值，非空串，如果value不存在，则添加，如果存在，则直接返回，长度不能超过 BUGLY_CUSTOM_DATA_MAX_STRING_VALUE_LENGTH
 */
- (BOOL)addStringToStringArrayParam:(NSString *)param forKey:(BuglyCustomArrayDataKey)key;

/**
 * 从字符串数组类型的自定义数据中，移除VALUE
 * @param key 如果KEY不在StringArrayParamKey定义中，则移除失败
 * @param param 如果value存在，则移除，如果不存在，则直接返回
 */
- (BOOL)removeStringFromStringArrayParam:(NSString *)param forKey:(BuglyCustomArrayDataKey)key;

/**
 * 添加顺序是：A1 -> A2 -> A2 -> A3 -> A4, 这个接口产生的结果类似：[A1, A2, A2, A3, A4]
 * 为字符串数组类型的自定义数据，增加VALUE
 * @param key 如果KEY不在StringArrayParamKey定义中，则添加失败
 * @param param 长度不能超过 BUGLY_CUSTOM_DATA_MAX_STRING_VALUE_LENGTH, 无论是否存在，都会添加，即可以存在重复的value
 * @return value是空值，空串，或者超长，或者已经达字符串数组最大值，返回失败，否则还回成功
 */
- (BOOL)addStringToSequence:(NSString *)param forKey:(BuglyCustomArrayDataKey)key;

@end

NS_ASSUME_NONNULL_END
