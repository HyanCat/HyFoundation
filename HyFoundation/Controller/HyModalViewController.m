//
//  HyModalViewController.m
//
//  Created by HyanCat on 15/11/17.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyModalViewController.h"
#import "UIColor+Hy.h"
#import "UIView+Hy.h"

@interface HyModalViewController ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, weak) UIView *backgroundView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) HyModalViewAnimate animate;

@end

NSTimeInterval const kHyModalViewAnimateDuration = 0.5f;

@implementation HyModalViewController

+ (instancetype)controllerWithModalView:(__kindof UIView *)view
{
	UIWindow *window = [[UIWindow alloc] init];
	window.backgroundColor = HyClearColor();
	window.windowLevel = UIWindowLevelAlert + 1;
	window.hidden = NO;
	
	HyModalViewController *controller = [[HyModalViewController alloc] init];
	controller.contentView = view;
	controller.window = window;
	
	window.rootViewController = controller;
	
	return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIView *backgroundView = [[UIView alloc] init];
	backgroundView.backgroundColor = [UIColor blackColor];
	[self.view addSubviewToFill:backgroundView];
	self.backgroundView = backgroundView;
	self.backgroundView.alpha = 0.f;
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
	[self.backgroundView addGestureRecognizer:tapGesture];
	
	[self.view addSubview:self.contentView];
	self.contentView.origin = CGPointMake(0, self.view.height);
}

- (void)showWithAnimate:(HyModalViewAnimate)animate
{
	self.animate = animate;
	self.window.hidden = NO;
	
	switch (animate) {
		case HyModalViewAnimatePresent:
		{
			[self makeAnimations:^{
				self.backgroundView.alpha = 0.5f;
				self.contentView.origin = CGPointMake(0, self.view.height-self.contentView.height);
			} completion:^(BOOL finished) {
				
			}];
		}
			break;
		case HyModalViewAnimateFallDown:
			break;
		case HyModalViewAnimateFadeInOut:
			break;
		default:
			break;
	}
}

- (void)dismiss
{
	switch (self.animate) {
		case HyModalViewAnimatePresent:
		{
			[self makeAnimations:^{
				self.backgroundView.alpha = 0.f;
				self.contentView.origin = CGPointMake(0, self.view.height);
			} completion:^(BOOL finished) {
				[self.window setHidden:YES];
			}];
		}
			break;
		case HyModalViewAnimateFallDown:
			break;
		case HyModalViewAnimateFadeInOut:
			break;
		default:
			break;
	}
}

- (void)hy_present
{
	
}

- (void)hy_dismiss
{
	
}

- (void)backgroundTapped:(UITapGestureRecognizer *)tapGesture
{
	[self dismiss];
}

- (void)makeAnimations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
	[UIView animateWithDuration:kHyModalViewAnimateDuration
						  delay:0
		 usingSpringWithDamping:1.f
		  initialSpringVelocity:1.f
						options:0
					 animations:^{
						 animations();
					 }
					 completion:^(BOOL finished) {
						 completion(finished);
					 }];
}

@end
