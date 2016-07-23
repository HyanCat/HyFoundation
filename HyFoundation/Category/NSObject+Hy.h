//
//  NSObject+Hy.h
//
//  Created by HyanCat on 15/9/25.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL isEqualObject(id object1, id object2);

@interface NSObject (Hy)

+ (BOOL)equalToObject1:(id)object1 andObject2:(id)object2;

- (instancetype)mapValueFormObject:(NSObject *)object withMap:(NSDictionary *)map;

- (instancetype)mapCoreDataPropertiesFromObject:(NSDictionary *)object withMap:(NSDictionary *)map;

+ (instancetype)invokeClass:(Class)className selector:(SEL)selector arguments:(NSArray *)arguments;

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)object;
- (void)performSelectorOnNextRunloop:(SEL)aSelector withObject:(id)anArgument;

/**
 * 判断类是否含有某个属性
 */
+ (BOOL)hasProperty:(NSString *)propertyName;

/**
 * 遍历属性
 */
- (void)enumeratePropertiesUsingBlock:(void (^) (NSString *propertyName))block;

/**
 * 属性名列表
 *
 * @return NSArray
 */
- (NSArray <NSString *> *)properties;

/**
 * 类的成员属性的类名
 */
+ (Class)classForProperty:(NSString *)propertyName;

@end


@protocol HyObjectSingleton <NSObject>

+ (instancetype)sharedHyInstance;
+ (void)freeSharedHyInstance;

@end

@interface NSObject (HyObjectSingleton) <HyObjectSingleton>

@end