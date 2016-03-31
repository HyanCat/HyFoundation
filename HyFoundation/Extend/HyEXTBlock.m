//
//  HyEXTBlock.m
//
//  Created by HyanCat on 15/9/25.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyEXTBlock.h"


@implementation HyEXTPageableResult

@synthesize total;
@synthesize page;
@synthesize count;
@synthesize list;

@end

@implementation HyEXTListResult

@synthesize expectedCount;
@synthesize count;
@synthesize list;

@end

@implementation HyEXTObjectDataResult

@synthesize data;
@synthesize remoteUrl;
@synthesize localUrl;

@end

@implementation HyEXTImageResult

@synthesize image;
@synthesize remoteUrl;

@end