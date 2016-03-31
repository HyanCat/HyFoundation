//
//  UITableView+Hy.h
//
//  Created by HyanCat on 15/10/13.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Hy)

- (void)appendRowsAtSection:(NSUInteger)section fromOldData:(NSArray *)oldData appendData:(NSArray *)appendData;
- (void)appendRowsAtSection:(NSUInteger)section fromOldData:(NSArray *)oldData appendData:(NSArray *)appendData withRowAnimation:(UITableViewRowAnimation)rowAnimation;
- (void)appendSectionsFromOldData:(NSArray *)oldData appendData:(NSArray *)appendData;
- (void)appendSectionsFromOldData:(NSArray *)oldData appendData:(NSArray *)appendData withRowAnimation:(UITableViewRowAnimation)rowAnimation;


@end
