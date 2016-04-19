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

- (void)prependRows:(NSUInteger)rows atSection:(NSUInteger)section
{
    [self prependRows:rows atSection:section withRowAnimation:UITableViewRowAnimationFade];
}

- (void)prependRows:(NSUInteger)rows atSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
    if (rows == 0) {
        return;
    }
    NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:rows];
    for (NSUInteger i = 0; i < rows; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexPaths.copy withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
}

- (void)appendRows:(NSUInteger)rows atSection:(NSUInteger)section
{
    [self appendRows:rows atSection:section withRowAnimation:UITableViewRowAnimationFade];
}

- (void)appendRows:(NSUInteger)rows atSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
    if (rows == 0) {
        return;
    }
    NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:rows];
    NSUInteger rowCount = [self numberOfRowsInSection:section];
    for (NSUInteger i = 0; i < rows; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:rowCount+i inSection:section]];
    }
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexPaths.copy withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
}

- (void)insertRowsWithRange:(NSRange)range atSection:(NSUInteger)section
{
    [self insertRowsWithRange:range atSection:section withRowAnimation:UITableViewRowAnimationFade];
}

- (void)insertRowsWithRange:(NSRange)range atSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation
{
    if (range.length == 0) {
        return;
    }
    NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray arrayWithCapacity:range.length];
    NSUInteger rowCount = [self numberOfRowsInSection:section];
    for (NSUInteger i = 0; i < range.length; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:range.location+i inSection:section]];
    }
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexPaths.copy withRowAnimation:UITableViewRowAnimationFade];
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
