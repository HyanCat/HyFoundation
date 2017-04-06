//
//  HyBaseViewController.m
//
//  Created by HyanCat on 15/9/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyBaseViewController.h"
#import "UIView+Hy.h"

const CGFloat kHyNavigationBarHeight = 64.f;
const CGFloat kHyStatusBarHeight = 20.f;

@interface HyBaseViewController ()

@property (nonatomic, assign) BOOL appearFirstTime;

@property (nonatomic, strong, readwrite) __kindof UIView *contentView;
@property (nonatomic, assign, readwrite) HyViewControllerState state;

@property (nonatomic, strong, readwrite) UINavigationBar *navigationBar;
@property (nonatomic, assign, readwrite) BOOL navigationBarHidden;

@property (nonatomic, weak, readwrite) __kindof UIView *navigationLeftCustomView;
@property (nonatomic, weak, readwrite) __kindof UIView *navigationRightCustomView;

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
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:kRGUIStatusBarTouchedNotificationName object:nil];
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
	
	[self setNeedsNavigationBarAppearanceUpdate];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusBarTouched:) name:kRGUIStatusBarTouchedNotificationName object:nil];
}


#pragma mark - Build View

- (void)loadSubviews
{
	self.view.backgroundColor = [UIColor whiteColor];
	self.contentView = [[self.contentViewClass alloc] init];
	self.contentView.backgroundColor = [UIColor whiteColor];

    CGFloat navigationBarHeight = [self preferNavigationBarHeight];
	if ([self.contentViewClass isSubclassOfClass:[UIScrollView class]]) {
		UIScrollView *scrollView = self.contentView;
		scrollView.alwaysBounceVertical = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		[scrollView setContentInset:UIEdgeInsetsMake(navigationBarHeight, 0, 0, 0)];
		[scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(navigationBarHeight, 0, 0, 0)];
	}
	[self.view insertSubviewToFill:self.contentView atIndex:0];

    if ([self preferCustomNavigationBar]) {
        // 使用自定义 navigationBar
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), navigationBarHeight)];
        navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:navigationBar];
        self.navigationBar = navigationBar;
	}
	else if (self.navigationController.navigationBar) {
        self.navigationBar = self.navigationController.navigationBar;
	}
}

- (void)loadData
{
	
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

- (CGFloat)preferNavigationBarHeight
{
	return kHyNavigationBarHeight;
}

- (CGFloat)preferBottomBarHeight
{
	return 0;
}

- (void)showNavigationBarAnimated:(BOOL)animated
{
    self.navigationBarHidden = YES;
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.navigationBar.y = 0;
                         self.navigationBar.height = [self preferNavigationBarHeight];
                         [self.navigationBar setItems:@[self.navigationItem]];
                     }];
}

- (void)hideNavigationBarAnimated:(BOOL)animated
{
    self.navigationBarHidden = NO;
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.navigationBar.y = kHyStatusBarHeight - [self preferNavigationBarHeight];
                     }
                     completion:^(BOOL finished) {
                         [self.navigationBar setItems:nil];
                     }];
}

- (void)setNeedsNavigationBarAppearanceUpdate
{
	if ([self preferCustomNavigationBar]) {
		// 使用自定义 navigationBar 则更新
		self.navigationBar.height = [self preferNavigationBarHeight];
		self.navigationBar.hidden = [self preferNavigationBarHidden];
        [self.navigationBar setItems:@[self.navigationItem]];
        [self.view bringSubviewToFront:self.navigationBar];
	}
}

- (void)setNavigationCenterItemWithTitle:(NSString *)title color:(UIColor *)color
{
    UILabel * titleLabel     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text          = title;
    titleLabel.textColor     = color;
    titleLabel.font          = [UIFont boldSystemFontOfSize:16.f];

	[self setNavigationCenterItemWithCustomView:titleLabel];
}

- (void)setNavigationCenterItemWithCustomView:(UIView *)view
{
	self.navigationItem.titleView = view;
}

- (void)setNavigationLeftItemWithTitle:(NSString *)title
								 color:(UIColor *)color
						highlightColor:(UIColor *)highlightColor
								target:(id)target
								action:(SEL)action
{
	UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
	[leftButton setTitle:title forState:UIControlStateNormal];
	[leftButton setTitleColor:color forState:UIControlStateNormal];
	[leftButton setTitleColor:highlightColor forState:UIControlStateHighlighted];
	leftButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
	[leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	[self setNavigationLeftItemWithCustomView:leftButton];
}

- (void)setNavigationLeftItemWithImage:(UIImage *)image
						highlightImage:(UIImage *)highlightImage
								target:(id)target
								action:(SEL)action
{
	UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
	[leftButton setImage:image forState:UIControlStateNormal];
	[leftButton setImage:highlightImage forState:UIControlStateHighlighted];
	[leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

	[self setNavigationLeftItemWithCustomView:leftButton];
}

- (void)setNavigationRightItemWithTitle:(NSString *)title
								  color:(UIColor *)color
						 highlightColor:(UIColor *)highlightColor
								 target:(id)target
								 action:(SEL)action
{
	UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
	[rightButton setTitle:title forState:UIControlStateNormal];
	[rightButton setTitleColor:color forState:UIControlStateNormal];
	[rightButton setTitleColor:highlightColor forState:UIControlStateHighlighted];
	rightButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
	[rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	[self setNavigationRightItemWithCustomView:rightButton];
}

- (void)setNavigationRightItemWithImage:(UIImage *)image
						 highlightImage:(UIImage *)highlightImage
								 target:(id)target
								 action:(SEL)action
{
	UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
	[rightButton setImage:image forState:UIControlStateNormal];
	[rightButton setImage:highlightImage forState:UIControlStateHighlighted];
	[rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

	[self setNavigationRightItemWithCustomView:rightButton];
}

- (void)setNavigationLeftItemWithCustomView:(UIView *)customView
{
    self.navigationLeftCustomView = customView;
	self.navigationItem.leftBarButtonItems = [self _navigationLeftItemsWithCustomView:customView];
}

- (void)setNavigationRightItemWithCustomView:(UIView *)customView
{
    self.navigationRightCustomView = customView;
	self.navigationItem.rightBarButtonItems = [self _navigationRightItemsWithCustomView:customView];
}

- (NSArray *)_navigationLeftItemsWithCustomView:(UIView *)customView
{
	UIBarButtonItem * leftCustomItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
	
	CGFloat leftPaddingItemWidth = -16.f;

	UIBarButtonItem * leftPaddingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	leftPaddingItem.width = leftPaddingItemWidth;

	return @[leftPaddingItem, leftCustomItem];
}

- (NSArray *)_navigationRightItemsWithCustomView:(UIView *)customView
{
	UIBarButtonItem * rightCustomItem = [[UIBarButtonItem alloc] initWithCustomView:customView];

	CGFloat rightPaddingItemWidth = -16.f;

	UIBarButtonItem * rightPaddingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	rightPaddingItem.width = rightPaddingItemWidth;

	return @[rightPaddingItem, rightCustomItem];
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
