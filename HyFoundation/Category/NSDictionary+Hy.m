//
//  NSDictionary+Hy.m
//
//  Created by HyanCat on 15/9/25.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "NSDictionary+Hy.h"

BOOL HyDictionaryIsEmpty(NSDictionary *dictionary)
{
	return dictionary == nil || [dictionary isEqual:[NSNull null]] || dictionary.count == 0;
}

BOOL HyDictionaryIsNotEmpty(NSDictionary *dictionary)
{
	return !HyDictionaryIsEmpty(dictionary);
}

@implementation NSDictionary (Hy)

- (BOOL)isKVOValueChanged
{
	id newValue = [self valueForKey:NSKeyValueChangeNewKey];
	id oldValue = [self valueForKey:NSKeyValueChangeOldKey];
	if (oldValue == nil) {
		return YES;
	}
	
	if (newValue && [newValue isKindOfClass:[NSNull class]]) {
		newValue = nil;
	}
	if (oldValue && [oldValue isKindOfClass:[NSNull class]]) {
		oldValue = nil;
	}
	
	if (!newValue && !oldValue) {
		return NO;
	}
	
	if ((newValue && !oldValue) || (!newValue && oldValue)) {
		return YES;
	}
	
	if ([newValue isKindOfClass:[NSString class]] &&
		[oldValue isKindOfClass:[NSString class]]) {
		return ![newValue isEqualToString:oldValue];
	}
	
	if ([newValue isKindOfClass:[NSNumber class]] &&
		[oldValue isKindOfClass:[NSNumber class]]) {
		return ![newValue isEqualToNumber:oldValue];
	}
	
	return ![newValue isEqual:oldValue];
}

- (instancetype)filterKeys:(NSArray<NSString *> *)keys
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		if ([keys containsObject:key]) {
			[dictionary setObject:obj forKey:key];
		}
	}];
	return dictionary.copy;
}

@end
