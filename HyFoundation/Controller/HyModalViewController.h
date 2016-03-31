//
//  HyModalViewController.h
//
//  Created by HyanCat on 15/11/17.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyPopupManager.h"

typedef NS_ENUM(NSUInteger, HyModalViewAnimate) {
	HyModalViewAnimatePresent = 0,
	HyModalViewAnimateFallDown,
	HyModalViewAnimateFadeInOut,
};

/**
 * 模态视图控制器
 */
@interface HyModalViewController : UIViewController <HyPopupProtocol>

+ (instancetype)controllerWithModalView:(__kindof UIView *)view;

- (void)showWithAnimate:(HyModalViewAnimate)animate;

- (void)dismiss;

@end