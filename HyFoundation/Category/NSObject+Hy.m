//
//  NSObject+Hy.m
//
//  Created by HyanCat on 15/9/25.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "NSObject+Hy.h"
#import <objc/runtime.h>

@implementation NSObject (Hy)

+ (BOOL)equalToObject1:(id)object1 andObject2:(id)object2
{
	if (object1 == nil && object2 == nil) {
		return YES;
	}
	else if (object1 == nil && object2 != nil) {
		return NO;
	}
	else {
		return [object1 isEqual:object2];
	}
}

- (instancetype)mapValueFormObject:(NSObject *)object withMap:(NSDictionary *)map
{
	[map enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull mapKey, BOOL * _Nonnull stop) {
		if ([object valueForKey:key] != nil && ![[object valueForKey:key] isEqual:[NSNull null]]) {
			[self setValue:[object valueForKey:key] forKey:mapKey];
		}
	}];
	
	return self;
}

- (instancetype)mapCoreDataPropertiesFromObject:(NSDictionary *)object withMap:(NSDictionary *)map
{
	[map enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull mapKey, BOOL * _Nonnull stop) {
		if (! [[object objectForKey:key] isEqual:[NSNull null]]) {
			[self setValue:[object objectForKey:key] forKey:mapKey];
		}
	}];
	
	return self;
}

+ (instancetype)invokeClass:(Class)className selector:(SEL)selector arguments:(NSArray *)arguments
{
	id returnValue;
	NSMethodSignature *signature = [className methodSignatureForSelector:selector];
	if (! signature) {
		return nil;
	}
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	[invocation setSelector:selector];
	[arguments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[invocation setArgument:&obj atIndex:idx+2];
	}];
	[invocation invokeWithTarget:className];
	void *tempReturnValue;
	[invocation getReturnValue:&tempReturnValue];
	returnValue = (__bridge id)(tempReturnValue);
	return returnValue;
}

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)object
{
	if ([NSThread isMainThread]) {
		IMP imp = [self methodForSelector:selector];
//		imp(self, selector, object);
		void (*action)(id, SEL, id) = (void *)imp;
		action(self, selector, object);
//		((void (*)(id, SEL, id))[self methodForSelector:selector])(self, selector, object);
	}
	else {
		[self performSelectorOnMainThread:selector withObject:object waitUntilDone:NO];
	}
}

+ (BOOL)hasProperty:(NSString *)propertyName
{
	objc_property_t property = class_getProperty([self class], propertyName.UTF8String);
	
	return property != NULL;
}

- (void)enumeratePropertiesUsingBlock:(void (^)(NSString *))block
{
	unsigned int count = 0;
	objc_property_t *properties = class_copyPropertyList([self class], &count);
	for (unsigned int i = 0; i < count; i++) {
		objc_property_t pro = properties[i];
		NSString *propertyName = [NSString stringWithUTF8String:property_getName(pro)];
		block(propertyName);
	}
}

+ (Class)classForProperty:(NSString *)propertyName
{
	objc_property_t property = class_getProperty([self class], propertyName.UTF8String);
	
	NSString* propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
	NSArray* splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@"\""];
	NSString *className = nil;
	if (splitPropertyAttributes.count >= 2) {
		className = [splitPropertyAttributes objectAtIndex:1];
	}
	else {
		// ..
	}
	return NSClassFromString(className);
}

@end

#pragma mark - HyObjectSingleton

static void *NSObjectSharedInstanceKey = &NSObjectSharedInstanceKey;

@implementation NSObject (HyObjectSingleton)

const void *kSharedHyInstanceKey = &kSharedHyInstanceKey;

+ (instancetype)sharedHyInstance
{
	Class selfClass = [self class];
	id instance = objc_getAssociatedObject(selfClass, kSharedHyInstanceKey);
	if (! instance) {
		instance = [[selfClass alloc] init];
		objc_setAssociatedObject(self, kSharedHyInstanceKey, instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return instance;
}

+ (void)freeSharedHyInstance
{
	Class selfClass = [self class];
	objc_setAssociatedObject(selfClass, kSharedHyInstanceKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end