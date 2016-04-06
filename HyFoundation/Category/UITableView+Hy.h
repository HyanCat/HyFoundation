//
//  UITableView+Hy.h
//
//  Created by HyanCat on 15/10/13.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Hy)

- (void)appendRowsAtSection:(NSUInteger)section fromOldData:(NSArray *)oldData appendData:(NSArray *)appendData NS_DEPRECATED_IOS(2_0, 3_0);
- (void)appendRowsAtSection:(NSUInteger)section fromOldData:(NSArray *)oldData appendData:(NSArray *)appendData withRowAnimation:(UITableViewRowAnimation)rowAnimation NS_DEPRECATED_IOS(2_0, 3_0);
- (void)appendRows:(NSUInteger)rows atSection:(NSUInteger)section;
- (void)appendRows:(NSUInteger)rows atSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)appendSectionsFromOldData:(NSArray *)oldData appendData:(NSArray *)appendData;
- (void)appendSectionsFromOldData:(NSArray *)oldData appendData:(NSArray *)appendData withRowAnimation:(UITableViewRowAnimation)rowAnimation;


@end
