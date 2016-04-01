//
//  HyEXTPageableResult+Accessory.m
//
//  Created by HyanCat on 15/11/15.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import "HyEXTPageableResult+Accessory.h"
#import <CoreData/CoreData.h>

@implementation HyEXTPageableResult (Accessory)

- (void)presentToContext:(NSManagedObjectContext *)context
{
	NSMutableArray *models = [NSMutableArray arrayWithCapacity:self.list.count];
	[self.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[models addObject:[context objectWithID:[obj objectID]]];
	}];
	self.list = models;
}

@end
