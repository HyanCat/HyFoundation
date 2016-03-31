//
//  NSURL+Hy.m
//
//  Created by HyanCat on 15/10/11.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "NSURL+Hy.h"

@implementation NSURL (Hy)

- (BOOL)isImageUrl
{
	NSString *extension = [[self pathExtension] lowercaseString];
	if ([@[@"jpg", @"jpeg", @"png", @"bmp", @"gif"] containsObject:extension]) {
		return YES;
	}
	return NO;
}

@end
