//
//  HyEXTListResult+Accessory.m
//
//  Created by HyanCat on 15/11/20.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import "HyEXTListResult+Accessory.h"
#import <CoreData/CoreData.h>

@implementation HyEXTListResult (Accessory)

- (void)presentToContext:(NSManagedObjectContext *)context
{
	NSMutableArray *models = [NSMutableArray arrayWithCapacity:self.list.count];
	[self.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[models addObject:[context objectWithID:[obj objectID]]];
	}];
	self.list = models;
}

- (NSUInteger)minId
{
	// 一般是已排序
	return [[self.list.lastObject id] unsignedIntegerValue];
}

- (NSUInteger)minUpdateTime
{
	__block NSTimeInterval minTime = [NSDate date].timeIntervalSince1970;
	[self.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj respondsToSelector:@selector(updateTime)]) {
			if ([obj updateTime].timeIntervalSince1970 < minTime) {
				minTime = [obj updateTime].timeIntervalSince1970;
			}
		}
	}];
	return minTime;
}

@end
