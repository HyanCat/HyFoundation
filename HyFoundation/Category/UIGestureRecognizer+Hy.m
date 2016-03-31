//
//  UIGestureRecognizer+Hy.m
//
//  Created by HyanCat on 15/9/24.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "UIGestureRecognizer+Hy.h"

@implementation UIGestureRecognizer (Hy)

- (void)cancel
{
	self.enabled = NO;
	self.enabled = YES;
}

@end
