//
//  HyBaseViewController.m
//
//  Created by HyanCat on 15/9/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyBaseViewController.h"
#import "UIView+Hy.h"
@import Masonry;

const CGFloat kHyNavigationBarHeight = 64.f;
const CGFloat kHyStatusBarHeight = 20.f;

@interface HyBaseViewController ()

@property (nonatomic, assign) BOOL appearFirstTime;

@property (nonatomic, strong, readwrite) __kindof UIView *contentView;
@property (nonatomic, assign, readwrite) HyViewControllerState state;

@end

@implementation HyBaseViewController

#pragma mark - Life Cycle

- (void)dealloc
{
#if DEBUG
	NSLog(@"%@ dealloc.", [self class]);
#endif
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.appearFirstTime = YES;
		self.contentViewClass = [UIView class];
		self.state = HyViewControllerStateInit;
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.state = HyViewControllerStateWillAppear;
	if (self.appearFirstTime) {
		[self viewWillAppearFirstTime:animated];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.state = HyViewControllerStateDidAppear;
	if (self.appearFirstTime) {
		[self viewDidAppearFirstTime:animated];
		self.appearFirstTime = NO;
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	self.state = HyViewControllerStateWillDisappear;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

	self.state = HyViewControllerStateDidDisappear;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self loadSubviews];
	
	[self loadData];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Build View

- (void)loadSubviews
{
	self.view.backgroundColor = [UIColor whiteColor];
	self.contentView = [[self.contentViewClass alloc] init];
	self.contentView.backgroundColor = [UIColor whiteColor];

//    CGFloat navigationBarHeight = [self preferNavigationBarHeight];
	if ([self.contentViewClass isSubclassOfClass:[UIScrollView class]]) {
		UIScrollView *scrollView = self.contentView;
		scrollView.alwaysBounceVertical = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
//        [scrollView setContentInset:UIEdgeInsetsMake(navigationBarHeight, 0, 0, 0)];
//        [scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(navigationBarHeight, 0, 0, 0)];
	}
	[self.view insertSubviewToFill:self.contentView atIndex:0];
}

- (void)loadData
{
	
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
//    [self setNavigationCenterItemWithTitle:title color:[self.navigationBar forgroundColor]];
}

- (BOOL)preferCustomNavigationBar
{
	return YES;
}

- (BOOL)preferNavigationBarHidden
{
	return NO;
}

- (void)viewWillLayoutSubviews
{
	self.contentView.y = 0;	// Adapt for status bar's height change while in call.

	[super viewWillLayoutSubviews];
}

- (CGFloat)preferBottomBarHeight
{
	return 0;
}

#pragma mark - User Interaction

- (BOOL)allowDismissGestureRecognizer
{
	return YES;
}

- (BOOL)allowPopGestureRecognizer
{
	return YES;
}

- (void)handleStatusBarTouched:(NSNotification *)notification
{
	// nothing to do
	// 子类重写
}

#pragma mark - View Transition

- (void)viewWillAppearFirstTime:(BOOL)animated
{
	// nothing to do
	// 子类重写
}

- (void)viewDidAppearFirstTime:(BOOL)animated
{
	// nothing to do
	// 子类重写
}

- (BOOL)viewWillTransitionBack:(BOOL)animated
{
	return YES;
	// 子类重写
}

- (BOOL)viewWillTransitionDismiss:(BOOL)animated
{
	return YES;
	// 子类重写
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)notification
{
	// nothing to do
	// 子类重写
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	// nothing to do
	// 子类重写
}

@end
