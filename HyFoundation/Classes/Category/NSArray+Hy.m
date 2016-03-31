//
//  NSArray+Hy.m
//
//  Created by HyanCat on 15/9/28.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "NSArray+Hy.h"

BOOL HyArrayIsEmpty(NSArray *array)
{
	return array == nil || [array isEqual:[NSNull null]] || array.count == 0;
}

BOOL HyArrayIsNotEmpty(NSArray *array)
{
	return !HyArrayIsEmpty(array);
}

@implementation NSArray (Hy)

- (id)objectAtPosition:(NSUInteger)position
{
	NSUInteger count = self.count;
	if (position < count) {
		return [self objectAtIndex:position];
	}
	return nil;
}

- (id)objectAtCirclePosition:(NSInteger)position
{
	NSUInteger count = self.count;
	if (count <= 1) {
		return [self firstObject];
	}

	while (position < 0) {
		position += count;
	}
	position = position % count;

	return [self objectAtPosition:position];
}

- (id)secondObject
{
	return [self objectAtPosition:1];
}

- (id)thirdObject
{
	return [self objectAtPosition:2];
}

- (id)lastButSecondObject
{
	if (self.count < 2) {
		return nil;
	}
	return [self objectAtIndex:self.count - 2];
}

- (id)lastButThirdObject
{
	if (self.count < 3) {
		return nil;
	}
	return [self objectAtIndex:self.count - 3];
}

@end

@implementation NSMutableArray (Hy)

- (void)replaceAllObjectsTo:(NSArray *)objects
{
	[self removeAllObjects];
	if (HyArrayIsNotEmpty(objects)) {
		[self addObjectsFromArray:objects];
	}
}

@end
