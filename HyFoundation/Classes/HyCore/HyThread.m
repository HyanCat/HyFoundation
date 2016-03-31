//
//  HyThread.m
//  ruogu
//
//  Created by HyanCat on 15/11/12.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import "HyThread.h"

void HyPerformOnMainThreadElseAsync(HyEXTVoidBlock block)
{
	if ([NSThread isMainThread]) {
		block();
	}
	else {
		dispatch_async(dispatch_get_main_queue(), ^{
			block();
		});
	}
}

void HyPerformOnMainThreadSync(HyEXTVoidBlock block)
{
	if ([NSThread isMainThread]) {
		block();
	}
	else {
		dispatch_sync(dispatch_get_main_queue(), ^{
			block();
		});
	}
}
