//
//  HyBaseViewController.h
//
//  Created by HyanCat on 15/9/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HyViewControllerState)
{
	HyViewControllerStateInit = 0,
	HyViewControllerStateWillAppear,
	HyViewControllerStateDidAppear,
	HyViewControllerStateWillDisappear,
	HyViewControllerStateDidDisappear,
};

@class HyContainerViewController;

/**
 * controller 基础框架
 */
@interface HyBaseViewController : UIViewController

@property (nonatomic, strong) Class contentViewClass;
@property (nonatomic, strong, readonly) __kindof UIView *contentView;
@property (nonatomic, strong, readonly) CALayer *maskLayer;
@property (nonatomic, weak) HyContainerViewController *containerViewController;

#pragma mark - Build View

- (void)loadSubviews;

- (void)loadData;

#pragma mark Navigation Bar

@property (nonatomic, strong, readonly) UINavigationBar *navigationBar;

- (BOOL)preferNavigationBarHidden;		// default NO

- (CGFloat)preferNavigationBarHeight;	// default 64.0f

- (CGFloat)preferBottomBarHeight;		// default 0

- (void)setNeedsNavigationBarAppearanceUpdate;

- (void)setNavigationCenterItemWithTitle:(NSString *)title color:(UIColor *)color;

- (void)setNavigationCenterItemWithCustomView:(UIView *)view;

- (void)setNavigationLeftItemWithTitle:(NSString *)title
								 color:(UIColor *)color
						highlightColor:(UIColor *)highlightColor
								target:(id)target
								action:(SEL)action;

- (void)setNavigationLeftItemWithImage:(UIImage *)image
						highlightImage:(UIImage *)highlightImage
								target:(id)target
								action:(SEL)action;

- (void)setNavigationRightItemWithTitle:(NSString *)title
								  color:(UIColor *)color
						 highlightColor:(UIColor *)highlightColor
								 target:(id)target
								 action:(SEL)action;

- (void)setNavigationRightItemWithImage:(UIImage *)image
						 highlightImage:(UIImage *)highlightImage
								 target:(id)target
								 action:(SEL)action;

#pragma mark - User Interaction

- (BOOL)allowDismissGestureRecognizer;	// 允许 dismiss 手势
- (BOOL)allowPopGestureRecognizer;		// 允许 pop 手势

- (void)handleStatusBarTouched:(UITouch *)touch;	// 处理状态栏的点击事件

#pragma mark - View Transition

@property (nonatomic, assign, readonly) HyViewControllerState state;

- (void)viewWillAppearFirstTime:(BOOL)animated;		// 视图将要第一次显示
- (void)viewDidAppearFirstTime:(BOOL)animated;		// 视图已经第一次显示

- (BOOL)viewWillTransitionBack:(BOOL)animated;		// 转场视图将要返回, return YES 则返回，NO 则不返回
- (BOOL)viewWillTransitionDismiss:(BOOL)animated;	// 转场视图将要消失, return YES 则消失，NO 则不消失

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end
