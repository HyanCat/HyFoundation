//
//  UITableView+Hy.m
//
//  Created by HyanCat on 15/10/13.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "UITableView+Hy.h"

@implementation UITableView (Hy)

- (void)appendRowsAtSection:(NSUInteger)section fromOldData:(NSArray *)oldData appendData:(NSArray *)appendData
{
	[self appendRowsAtSection:section fromOldData:oldData appendData:appendData withRowAnimation:UITableViewRowAnimationTop];
}

- (void)appendRowsAtSection:(NSUInteger)section fromOldData:(NSArray *)oldData appendData:(NSArray *)appendData withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
	NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:appendData.count];
	[appendData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[indexPaths addObject:[NSIndexPath indexPathForRow:oldData.count+idx inSection:section]];
	}];
	[self beginUpdates];
	[self insertRowsAtIndexPaths:indexPaths.copy withRowAnimation:rowAnimation];
	[self endUpdates];
}

- (void)appendSectionsFromOldData:(NSArray *)oldData appendData:(NSArray *)appendData
{
	[self appendSectionsFromOldData:oldData appendData:appendData withRowAnimation:UITableViewRowAnimationTop];
}

- (void)appendSectionsFromOldData:(NSArray *)oldData appendData:(NSArray *)appendData withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
	NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(oldData.count, appendData.count)];
	[self beginUpdates];
	[self insertSections:sections withRowAnimation:rowAnimation];
	[self endUpdates];
}

@end
