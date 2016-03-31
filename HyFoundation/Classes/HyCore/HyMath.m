//
//  HyMath.m
//
//  Created by HyanCat on 15/10/7.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyMath.h"

@implementation HyMath

@end

CGFloat HyRadianFromDegree(CGFloat degree)
{
	return degree * M_PI / 180.f;
}

CGFloat HyDegreeFromRadian(CGFloat radian)
{
	return radian * 180.f / M_PI;
}