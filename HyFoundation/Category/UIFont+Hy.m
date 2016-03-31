//
//  UIFont+Hy.m
//
//  Created by HyanCat on 15/9/27.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "UIFont+Hy.h"

@implementation UIFont (Hy)

@end

UIFont *HyFont(CGFloat fontSize)
{
	return [UIFont systemFontOfSize:fontSize];
}

UIFont *HyBoldFont(CGFloat fontSize)
{
	return [UIFont boldSystemFontOfSize:fontSize];
}