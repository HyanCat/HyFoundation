//
//  UINib+Hy.m
//
//  Created by HyanCat on 15/10/24.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "UINib+Hy.h"

@implementation UINib (Hy)

+ (id)loadViewWithNibName:(NSString *)nibName
{
	return [[self nibWithNibName:nibName bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
}

@end
