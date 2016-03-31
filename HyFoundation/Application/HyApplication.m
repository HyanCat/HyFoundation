//
//  HyApplication.m
//
//  Created by HyanCat on 15/9/24.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyApplication.h"

NSString * const kUIStatusBarWindowClassName = @"UIStatusBarWindow";
NSString * const kUIStatusBarForegroundViewClassName = @"UIStatusBarForegroundView";

NSString *const kHyUIStatusBarTouchedNotificationName = @"HyUIStatusBarTouchedNotificationName";
NSString *const kHyUIStatusBarTouchKey = @"HyUIStatusBarTouchKey";

@implementation HyApplication

- (void)sendEvent:(UIEvent *)event
{
	if (UIEventTypeTouches == event.type) {

		UITouch * statusBarTouch = nil;
		
		for (UITouch * touch in [event allTouches]) {
			if ([touch.window isKindOfClass:NSClassFromString(kUIStatusBarWindowClassName)] && [touch.view isKindOfClass:NSClassFromString(kUIStatusBarForegroundViewClassName)]) {
				statusBarTouch = touch;
				break;
			}
		}
		
		if (statusBarTouch && UITouchPhaseEnded == statusBarTouch.phase) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kHyUIStatusBarTouchedNotificationName
																object:self
															  userInfo:@{kHyUIStatusBarTouchKey: statusBarTouch}];
		}
	}
	
	[super sendEvent:event];
}

@end
