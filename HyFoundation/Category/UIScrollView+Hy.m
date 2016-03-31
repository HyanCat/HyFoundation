//
//  UIScrollView+Hy.m
//
//  Created by HyanCat on 15/10/22.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "UIScrollView+Hy.h"

@implementation UIScrollView (Hy)

- (void)updateContentSize
{
	CGRect contentRect = CGRectZero;
	for (UIView *view in self.subviews) {
		contentRect = CGRectUnion(contentRect, view.frame);
	}
	self.contentSize = contentRect.size;
//	self.contentSize = CGSizeMake(contentRect.size.width + self.contentInset.left + self.contentInset.right, contentRect.size.height + self.contentInset.top + self.contentInset.bottom);
}

@end
