//
//  HyContainerViewController.m
//
//  Created by HyanCat on 15/9/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyContainerViewController.h"
#import "UIView+Hy.h"
#import "NSArray+Hy.h"
#import <HyUIActionEvent/HyUIActionCore.h>
#import "NSObject+Hy.h"
#import "UIImage+Hy.h"
#import "UIGestureRecognizer+Hy.h"
#import "HyUIPanPoint.h"

#define TransitionParallax 1.f/3
#define TransitionDuration 0.5f
#define TransitionAnimationOption UIViewAnimationOptionCurveEaseInOut

@interface HyContainerViewController () <UIGestureRecognizerDelegate>
{
	BOOL _shouldPop, _shouldDismiss;
}
@property (nonatomic, strong, readwrite) HyBaseViewController *rootViewController;

@property (nonatomic, strong) UIView *rootView;

@property (nonatomic, strong) NSMutableArray <NSMutableArray <HyBaseViewController *> *> *viewControllers;
@property (nonatomic, strong) NSMutableArray <NSString *> *viewControllerUrls;		// 控制器 url 数组
@property (nonatomic, strong) NSMutableArray <NSNumber *> *historyTransitionTypes;	// 转场历史记录数组

@property (nonatomic, strong) UIImageView *transitionShadowView;
@property (nonatomic, strong) UIView *transitionMaskView;

@property (nonatomic, assign, readwrite, getter=isHandlingTransition) BOOL handlingTransition;	// 是否正在开始处理转场，主要为了单一处理转场事务，防止冲突
@property (nonatomic, assign) BOOL isAutoTransition;	// 是否处于自动转场过程中，此过程主要用来禁止乱入的手势


@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong, readwrite) HyUIPanPoint *panPoint;


@end

@implementation HyContainerViewController

#pragma mark Override

- (instancetype)initWithRootViewController:(HyBaseViewController *)rootViewController
{
	self = [super init];
	if (self) {
		_rootViewController = rootViewController;
		_rootViewController.containerViewController = self;

        if (rootViewController) {
            _viewControllers = @[@[_rootViewController].mutableCopy].mutableCopy;
            _viewControllerUrls = @[NSStringFromClass(_rootViewController.class)].mutableCopy;
        }
        else {
            _viewControllers = @[@[].mutableCopy].mutableCopy;
            _viewControllerUrls = @[].mutableCopy;
        }
		_historyTransitionTypes = [@[@(HyUITransitionTypeNone)] mutableCopy];
	}
	return self;
}

- (void)loadSubviews
{
    [super loadSubviews];

	// rootView
	UIView *rootView = [[UIView alloc] initWithFrame:self.contentView.bounds];
	[self.contentView addSubviewToFill:rootView];
	self.rootView = rootView;

	// 添加 rootViewController 的 view
	[self.rootView addSubviewToFill:_rootViewController.view];

    // 手势
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
	panGestureRecognizer.delegate = self;
	[self.view addGestureRecognizer:panGestureRecognizer];
	self.panGestureRecognizer = panGestureRecognizer;
}

- (BOOL)preferNavigationBarHidden
{
	return YES;
}

- (HyBaseViewController *)rootViewController
{
    if (!_rootViewController) {
        _rootViewController = [[self.viewControllers firstObject] firstObject];
    }
    return _rootViewController;
}

#pragma mark - self.viewControllers 数组维护

// 最上层的 controllers
- (NSMutableArray <HyBaseViewController *> *)topLevelViewControllers
{
	return self.viewControllers.lastObject;
}
// 第二层的 controllers
- (NSMutableArray <HyBaseViewController *> *)underTopLevelViewControllers
{
	return [self.viewControllers objectAtCirclePosition:-2];
}
// 最上层 当前 controller
- (HyBaseViewController *)currentController
{
	return [self topLevelViewControllers].lastObject;
}
// 最上层 当前下方的 controller
- (HyBaseViewController *)currentBelowController
{
	return [[self topLevelViewControllers] objectAtCirclePosition:-2];
}

// 推进一个新的控制器
- (void)pushANewViewController:(HyBaseViewController *)viewController
{
	[[self topLevelViewControllers] addObject:viewController];
}

// 压入一个新的控制器层
- (void)presentANewViewController:(HyBaseViewController *)viewController
{
	NSMutableArray *newLevel = @[viewController].mutableCopy;
	[self.viewControllers addObject:newLevel];
}

- (NSUInteger)viewControllersCount
{
	__block NSUInteger count = 0;
	[self.viewControllers enumerateObjectsUsingBlock:^(NSMutableArray<HyBaseViewController *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		count += obj.count;
	}];
	return count;
}

#pragma mark - Handler Event

- (HyUIActionEventResult *)handleTransitionWithActionEvent:(HyUIActionEvent *)event
{
	if (_handlingTransition) {
		return [HyUIActionEventResult resultWithContinueDispatching:NO];
	}
	
	NSString *newControllerUrl = [event transitionToViewControllerURL];
	if ([[self.viewControllerUrls lastObject] isEqualToString:newControllerUrl]) {
		// 防止死循环
		return [HyUIActionEventResult resultWithContinueDispatching:NO];
	}
	
	_handlingTransition = YES;
	HyBaseViewController * toViewController = nil;
	if (event.transitionType == HyUITransitionTypeNone || event.transitionType == HyUITransitionTypePush || event.transitionType == HyUITransitionTypePresent) {
		
		NSString *toViewControllerClassString = [[event.transitionToViewControllerURL componentsSeparatedByString:@"?"] firstObject];
		Class ToViewControllerClass = NSClassFromString(toViewControllerClassString);
		SEL initial = [event transitionToViewControllerInstanceMethod];
		NSArray *initialObjects = [event transitionToViewControllerInstanceObjects];
		
		if (initial) {
			toViewController = (HyBaseViewController *)[NSObject invokeClass:ToViewControllerClass selector:initial arguments:initialObjects];
		}
		else {
			toViewController = [[ToViewControllerClass alloc] init];
		}
		if ([toViewController respondsToSelector:@selector(setContainerViewController:)]) {
			toViewController.containerViewController = self;
		}
		[[event transitionToViewControllerInfo] enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([ToViewControllerClass hasProperty:key]) {
                [toViewController setValue:obj forKey:key];
            }
		}];
	}

	switch ([event transitionType]) {
		case HyUITransitionTypeNone:
			[toViewController setNavigationLeftItemWithTitle:@"关闭" color:[UIColor grayColor] highlightColor:[UIColor lightGrayColor] target:self action:@selector(handleNavigationBarDismissItemTouched:)];
			[self AppearToViewController:toViewController
								animated:event.transitionIsAnimated
					   viewControllerUrl:event.transitionToViewControllerURL
							  completion:event.transitionCompletionBlock];
			break;
		case HyUITransitionTypePush:
			[toViewController setNavigationLeftItemWithImage:HyUIImage(@"icon_navigation_back") highlightImage:HyUIImage(@"icon_navigation_back") target:self action:@selector(handleNavigationBarBackItemTouched:)];
			[self pushToViewController:toViewController
							  animated:event.transitionIsAnimated
					 viewControllerUrl:event.transitionToViewControllerURL
							completion:event.transitionCompletionBlock];
			break;
		case HyUITransitionTypePresent:
			[toViewController setNavigationLeftItemWithTitle:@"关闭" color:[UIColor whiteColor] highlightColor:[UIColor lightGrayColor] target:self action:@selector(handleNavigationBarDismissItemTouched:)];
			[self presentToViewController:toViewController
								 animated:event.transitionIsAnimated
						viewControllerUrl:event.transitionToViewControllerURL
							   completion:event.transitionCompletionBlock];
			break;
		case HyUITransitionTypeBack:
			[self popToBackWithAnimated:event.transitionIsAnimated
							 completion:event.transitionCompletionBlock];
			break;
		case HyUITransitionTypeDismiss:
			[self dismissWithAnimated:event.transitionIsAnimated
						   completion:event.transitionCompletionBlock];
			break;
		case HyUITransitionTypeDisAppear:
			[self disAppearWithAnimated:event.transitionIsAnimated
							 completion:event.transitionCompletionBlock];
			break;
		case HyUITransitionTypeInsertBelow:
			break;
		case HyUITransitionTypeRemoveBelow:
			break;
		case HyUITransitionTypeRemoveBelowAll:
			break;
		default:
			_handlingTransition = NO;
			break;
	}
	
	return [HyUIActionEventResult resultWithContinueDispatching:NO];
}

- (BOOL)isHandlingTransition
{
	return _handlingTransition;
}

- (void)handleNavigationBarBackItemTouched:(id)sender
{
	if ([[self currentController] viewWillTransitionBack:YES]) {
		[self dispatchHyUIActionEvent:[HyUIActionEvent eventWithTransitionTypeBackAnimated:YES]];
	}
}
- (void)handleNavigationBarDismissItemTouched:(id)sender
{
	if ([[self currentController] viewWillTransitionDismiss:YES]) {
		[self dispatchHyUIActionEvent:[HyUIActionEvent eventWithTransitionTypeDismissAnimated:YES]];
	}
}

// 手势处理
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
	if (_isAutoTransition) {
		return [recognizer cancel];
	}
	if ([self viewControllersCount] <= 1) {
		return [recognizer cancel];
	}
	if (recognizer.numberOfTouches >= 2) {
		return [recognizer cancel];
	}
	
	// 由 delegate 决定是否需要继续处理手势
	if (self.panGestureDelegate && [self.panGestureDelegate respondsToSelector:@selector(hyContainerView:panned:)]) {
		BOOL shouldContinue = [self.panGestureDelegate hyContainerView:self panned:recognizer];
		_shouldPop = _shouldPop && shouldContinue;
		_shouldDismiss = _shouldDismiss && shouldContinue;
	}
	
	switch (recognizer.state) {
		case UIGestureRecognizerStateBegan:
		{
			// 转场过程中开启的手势无效
			if (_handlingTransition || _isAutoTransition) {
				return [recognizer cancel];
			}
			_panPoint = [[HyUIPanPoint alloc] init];
			_panPoint.beganPoint = [recognizer locationInView:self.contentView];
			
			// 手势开启时，决定是 pop 还是 dismiss
			_shouldPop = NO, _shouldDismiss = NO;
			HyBaseViewController *currentViewController = [self currentController];
			if (currentViewController.allowPopGestureRecognizer && [[_historyTransitionTypes lastObject] unsignedIntegerValue] == HyUITransitionTypePush) {
				_shouldPop = YES;
			}
			if (currentViewController.allowDismissGestureRecognizer && [[_historyTransitionTypes lastObject] unsignedIntegerValue] == HyUITransitionTypePresent) {
				_shouldDismiss = YES;
			}
			
			[self handleWhenShouldPop:^{
				[self _preparePopTransition];
			} orShouldDismiss:^{
				[self _prepareDismissTransition];
			}];
		}
			break;
		case UIGestureRecognizerStateChanged:
		{
			_panPoint.point = [recognizer locationInView:self.contentView];
			[self handleWhenShouldPop:^{
				[self _handlePopGesture];
			} orShouldDismiss:^{
				[self _handleDismissGesture];
			}];
		}
			break;
		case UIGestureRecognizerStateEnded:
		{
			_panPoint = nil;
			[self handleWhenShouldPop:^{
				[self _handlePopGestureEnd];
			} orShouldDismiss:^{
				[self _handleDismissGestureEnd];
			}];
		}
			break;
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed:
		{
			_panPoint = nil;
			[self handleWhenShouldPop:^{
				[self _handlePopGestureCancel];
			} orShouldDismiss:^{
				[self _handleDismissGestureCancel];
			}];
		}
			break;
		default:
			break;
	}
}

- (void)handleWhenShouldPop:(void (^)())shouldPop orShouldDismiss:(void (^)())shouldDismiss
{
	if (_shouldPop) shouldPop();
	else if (_shouldDismiss) shouldDismiss();
	else;
}

- (void)_handlePopGesture
{
	if (_panPoint.isMovingHorizontal && _panPoint.moveHorizontalDistance > 20) {
		_handlingTransition = YES;
		HyBaseViewController *currentController = [self currentController];
		HyBaseViewController *backController = [self currentBelowController];
		if (currentController.view.x + _panPoint.moveHorizontalOffset < 0) {
			return;
		}
		[self _moveController:currentController withVector:CGVectorMake(_panPoint.moveHorizontalOffset, 0) withShadow:YES withMask:NO];
		[self _moveController:backController withVector:CGVectorMake(_panPoint.moveHorizontalOffset * TransitionParallax, 0) withShadow:NO withMask:YES];
	}
}

- (void)_handlePopGestureEnd
{
	_panPoint = nil;
	HyBaseViewController *currentController = [self currentController];
	if (currentController.view.x > 60.f) {
		[currentController viewWillTransitionBack:YES];
		[self _popControllerWithCompletion:nil];
	}
	else {
		[self _cancelPopController];
	}
}

- (void)_handlePopGestureCancel
{
	// 是否正在转场过程中那个
	if (! _isAutoTransition) {
		[self _cancelPopController];
	}
}

- (void)_handleDismissGesture
{
	if (_panPoint.isMovingVertical && _panPoint.moveVerticalDistance > 20) {
		_handlingTransition = YES;
		HyBaseViewController *currentController = [self currentController];
		if (currentController.view.y + _panPoint.moveVerticalOffset < 0) {
			return;
		}
		[self _moveController:currentController withVector:CGVectorMake(0, _panPoint.moveVerticalOffset) withShadow:NO withMask:YES];
	}
}

- (void)_handleDismissGestureEnd
{
	_panPoint = nil;
	HyBaseViewController *currentController = [self currentController];
	if (currentController.view.y > 120.f) {
		[currentController viewWillTransitionDismiss:YES];
		[self _dismissControllerWithCompletion:nil];
	}
	else {
		[self _cancelDismissController];
	}
}

- (void)_handleDismissGestureCancel
{
	if (! _isAutoTransition) {
		[self _cancelDismissController];
	}
}


#pragma mark - Delegate



#pragma mark - Transition Methods

- (void)pushToViewController:(HyBaseViewController *)viewController
					animated:(BOOL)animated
		   viewControllerUrl:(NSString *)viewControllerUrl
				completion:(HyUITransitionCompletionBlock)completion
{
	if (viewController == nil) {
		if (completion) {
			completion();
		}
		_handlingTransition = NO;
		return;
	}
	// 将新的 controller 添加进来
	[self addChildViewController:viewController];	// 会调用 willMoveToParentViewController
	[self pushANewViewController:viewController];
	[self.viewControllerUrls addObject:viewControllerUrl];
	
	if (animated) {
		// 准备工作
		[self _preparePushTransition];
		// 开始 push
		[self _pushControllerWithCompletion:completion];
	}
	else {
		
	}
}

- (void)popToBackWithAnimated:(BOOL)animated completion:(HyUITransitionCompletionBlock)completion
{
	HyBaseViewController *currentController = [self currentController];
	HyBaseViewController *backController = [self currentBelowController];
	if (backController == nil || [backController isEqual:currentController]) {
		if (completion) {
			completion();
		}
		_handlingTransition = NO;
		return;
	}
	
	[self _preparePopTransition];
	
	[self _popControllerWithCompletion:completion];
}

- (void)presentToViewController:(HyBaseViewController *)toViewController
					   animated:(BOOL)animated
			  viewControllerUrl:(NSString *)viewControllerUrl
					 completion:(HyUITransitionCompletionBlock)completion
{
	if (toViewController == nil) {
		if (completion) {
			completion();
		}
		_handlingTransition = NO;
		return;
	}
	[self addChildViewController:toViewController];
	[self presentANewViewController:toViewController];
	[self.viewControllerUrls addObject:viewControllerUrl];
	
	if (animated) {
		[self _preparePresentTransition];
		[self _presentControllerWithCompletion:completion];
	}
	else {
		
	}
}

- (void)dismissWithAnimated:(BOOL)animated completion:(HyUITransitionCompletionBlock)completion
{
	// 如果只有 1 层就不会 dismiss
	if (self.viewControllers.count == 1 || [self underTopLevelViewControllers].lastObject == nil) {
		if (completion) {
			completion();
		}
		_handlingTransition = NO;
		return;
	}
	
	[self _prepareDismissTransition];
	
	[self _dismissControllerWithCompletion:completion];
}

- (void)AppearToViewController:(HyBaseViewController *)toViewController
					  animated:(BOOL)animated
			 viewControllerUrl:(NSString *)viewControllerUrl
					completion:(HyUITransitionCompletionBlock)completion
{
	if (toViewController == nil) {
		if (completion) {
			completion();
		}
		_handlingTransition = NO;
		return;
	}
	HyBaseViewController *oldController = [self currentController];
	
	[self addChildViewController:toViewController];
	[self pushANewViewController:toViewController];
	[self.viewControllerUrls addObject:viewControllerUrl];
	
	[self.rootView addSubviewToFill:toViewController.view];
	if (animated) {
		_isAutoTransition = YES;
		toViewController.view.alpha = 0.f;
		
		[UIView transitionWithView:self.view duration:TransitionDuration options:TransitionAnimationOption animations:^{
			toViewController.view.alpha = 1.f;
		} completion:^(BOOL finished) {
			[self _didFinishedTransitionWithOldController:oldController newController:toViewController];
			[self.historyTransitionTypes addObject:@(HyUITransitionTypeNone)];
			if (completion) {
				completion();
			}
		}];
	}
	else {
		[self _didFinishedTransitionWithOldController:oldController newController:toViewController];
		[self.historyTransitionTypes addObject:@(HyUITransitionTypeNone)];
		if (completion) {
			completion();
		}
	}
}

- (void)disAppearWithAnimated:(BOOL)animated completion:(HyUITransitionCompletionBlock)completion
{
	HyBaseViewController *currentController = [self currentController];
	HyBaseViewController *backController = [self currentBelowController];
	if (backController == nil || [backController isEqual:currentController]) {
		if (completion) {
			completion();
		}
		_handlingTransition = NO;
		return;
	}
	
	[self.rootView insertSubviewToFill:backController.view belowSubview:currentController.view];
	if (animated) {
		_isAutoTransition = YES;
		[UIView transitionWithView:self.view duration:TransitionDuration options:TransitionAnimationOption animations:^{
			currentController.view.alpha = 0.f;
		} completion:^(BOOL finished) {
			[self _didFinishedTransitionBack];
			if (completion) {
				completion();
			}
		}];
	}
	else {
		[self _didFinishedTransitionBack];
		if (completion) {
			completion();
		}
	}
}

- (void)_preparePushTransition
{
	// Push 准备
	// 1. 新 controller 视图插入，并置在最右侧边缘
	// 2. 新 controller 视图加阴影
	// 3. 旧 controller 视图加遮罩
	HyBaseViewController *oldController = [self currentBelowController];
	HyBaseViewController *willShowController = [self currentController];
	[self.rootView addSubviewToFill:willShowController.view];
	willShowController.view.x = self.view.width;
	
	// 添加边界阴影遮罩
	[self.rootView addSubview:self.transitionShadowView];
	self.transitionShadowView.frame = CGRectMake(willShowController.view.x - self.transitionShadowView.width, 0, self.transitionShadowView.width, willShowController.view.height);
	// 添加遮罩
	[self.rootView insertSubview:self.transitionMaskView aboveSubview:oldController.view];
	self.transitionMaskView.frame = oldController.view.bounds;
}

- (void)_preparePopTransition
{
	// pop 准备
	// 1. 上一个 controller 视图插入，并置在左侧 TransitionParallax 处
	// 2. 当前 controller 视图加阴影
	// 3. 上一个 controller 视图加遮罩

	HyBaseViewController *currentController = [self currentController];
	HyBaseViewController *backController = [self currentBelowController];
	[self.rootView insertSubviewToFill:backController.view belowSubview:currentController.view];
	backController.view.origin = CGPointMake(-self.view.width * TransitionParallax, 0);
	
	// 添加边界阴影
	[self.rootView addSubview:self.transitionShadowView];
	self.transitionShadowView.frame = CGRectMake(-_transitionShadowView.width, 0, _transitionShadowView.width, self.view.height);
	// 添加遮罩
	[self.rootView insertSubviewToFill:self.transitionMaskView aboveSubview:backController.view];
	self.transitionMaskView.layer.opacity = 0.5;
}

- (void)_preparePresentTransition
{
	// Present 准备
	// 1. 新 controller 视图插入，并置在最下侧边缘
	// 2. 旧 controller 视图加遮罩
	HyBaseViewController *oldController = [self underTopLevelViewControllers].lastObject;
	HyBaseViewController *willShowController = [self currentController];
	[self.rootView addSubviewToFill:willShowController.view];
	willShowController.view.y = self.view.height;
	// 添加遮罩
	[self.rootView insertSubviewToFill:self.transitionMaskView aboveSubview:oldController.view];
}

- (void)_prepareDismissTransition
{
	// Dismiss 准备
	// 1. 上一个 controller 视图插入，并置在正常位置
	// 2. 上一个 controller 视图加遮罩
	HyBaseViewController *currentController = [self currentController];
	HyBaseViewController *backController = [self underTopLevelViewControllers].lastObject;
	[self.rootView insertSubviewToFill:backController.view belowSubview:currentController.view];
	// 添加遮罩
	[self.rootView insertSubviewToFill:self.transitionMaskView aboveSubview:backController.view];
	self.transitionMaskView.layer.opacity = 0.5;
}

- (void)_pushControllerWithCompletion:(HyUITransitionCompletionBlock)completion
{
	_isAutoTransition = YES;
	HyBaseViewController *willController = [self currentController];
	HyBaseViewController *oldController = [self currentBelowController];
	[self transitionAnimation:^{
		[self _moveControllerToVisible:willController];
		[self _moveControllerToLeftHide:oldController];
		[self _makeTransitionShadowViewToLeft];
		[self _makeTransitionMaskViewDarker];
	} completion:^(BOOL finished) {
		[self _didFinishedTransitionWithOldController:oldController newController:willController];
		[self.historyTransitionTypes addObject:@(HyUITransitionTypePush)];
		if (completion) {
			completion();
		}
	}];
}

- (void)_popControllerWithCompletion:(HyUITransitionCompletionBlock)completion
{
	_isAutoTransition = YES;
	HyBaseViewController *currentController = [self currentController];
	HyBaseViewController *backController = [self currentBelowController];
	[self transitionAnimation:^{
		[self _moveControllerToRightHide:currentController];
		[self _moveControllerToVisible:backController];
		[self _makeTransitionShadowViewToRight];
		[self _makeTransitionMaskViewLighter];
	} completion:^(BOOL finished) {
		[self _clearView];
		[self _didFinishedTransitionBack];
		if (completion) {
			completion();
		}
	}];
}

- (void)_presentControllerWithCompletion:(HyUITransitionCompletionBlock)completion
{
	_isAutoTransition = YES;
	HyBaseViewController *willController = [self currentController];
	HyBaseViewController *oldController = [self underTopLevelViewControllers].lastObject;
	[self transitionAnimation:^{
		[self _moveControllerToVisible:willController];
		[self _makeTransitionMaskViewDarker];
	} completion:^(BOOL finished) {
		[self _didFinishedTransitionWithOldController:oldController newController:willController];
		[self.historyTransitionTypes addObject:@(HyUITransitionTypePresent)];
		if (completion) {
			completion();
		}
	}];
}

- (void)_dismissControllerWithCompletion:(HyUITransitionCompletionBlock)completion
{
	_isAutoTransition = YES;
	NSArray <HyBaseViewController *> *willDismissControllers = [self topLevelViewControllers];
	[self transitionAnimation:^{
		[willDismissControllers enumerateObjectsUsingBlock:^(HyBaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			[self _moveControllerToBottomHide:obj];
		}];
		[self _makeTransitionMaskViewLighter];
	} completion:^(BOOL finished) {
		[self _clearView];
		[self _didFinishedTransitionDismiss];
		if (completion) {
			completion();
		}
	}];
}

- (void)_cancelPopController
{
	HyBaseViewController *currentController = [self currentController];
	HyBaseViewController *backController = [self currentBelowController];
	
	[self transitionAnimation:^{
		[self _moveControllerToLeftHide:backController];
		[self _moveControllerToVisible:currentController];
		[self _makeTransitionShadowViewToLeft];
		[self _makeTransitionMaskViewDarker];
	} completion:^(BOOL finished) {
		[self _clearView];
		[backController.view removeFromSuperview];
		[backController removeFromParentViewController];
		_handlingTransition = NO;
	}];
}

- (void)_cancelDismissController
{
	NSArray <HyBaseViewController *> *willDismissControllers = [self topLevelViewControllers];
	HyBaseViewController *backController = [self underTopLevelViewControllers].lastObject;
	
	[self transitionAnimation:^{
		[willDismissControllers enumerateObjectsUsingBlock:^(HyBaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			[self _moveControllerToVisible:obj];
		}];
		[self _makeTransitionMaskViewDarker];
	} completion:^(BOOL finished) {
		[self _clearView];
		[backController.view removeFromSuperview];
		[backController removeFromParentViewController];
		_handlingTransition = NO;
	}];
}

- (void)_didFinishedTransitionWithOldController:(HyBaseViewController *)oldController newController:(HyBaseViewController *)newController
{
	[self _clearView];
	[oldController.view removeFromSuperview];			// retain -1
	[newController didMoveToParentViewController:self];	// 会调用 viewDidAppear
	_handlingTransition = NO;
	_isAutoTransition = NO;
}

- (void)_didFinishedTransitionBack
{
	HyBaseViewController *currentController = [self currentController];
	HyBaseViewController *backController = [self currentBelowController];
	
	[currentController.view removeFromSuperview];
	[currentController removeFromParentViewController];
	[backController didMoveToParentViewController:self];
	[[self topLevelViewControllers] removeObject:currentController];
	[self.viewControllerUrls removeLastObject];
	[self.historyTransitionTypes removeLastObject];
	_handlingTransition = NO;
	_isAutoTransition = NO;
}

- (void)_didFinishedTransitionDismiss
{
	NSArray <HyBaseViewController *> *dismissedViewControllers = [self topLevelViewControllers];
	HyBaseViewController *backController = [self underTopLevelViewControllers].lastObject;
	
	// 这里最好是逆序遍历
	[dismissedViewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(HyBaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj.view removeFromSuperview];
		[obj removeFromParentViewController];
		[self.viewControllerUrls removeLastObject];
		[self.historyTransitionTypes removeLastObject];
	}];
	[self.viewControllers removeLastObject];
	
	[backController didMoveToParentViewController:self];
	_handlingTransition = NO;
	_isAutoTransition = NO;
}

- (UIImageView *)transitionShadowView
{
	if (_transitionShadowView == nil) {
		UIImage *shadowImage = HyUIImage(@"transition_shadow");
		_transitionShadowView = [[UIImageView alloc] initWithImage:[shadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(4, 0, 4, 0)]];
	}
	return _transitionShadowView;
}

- (UIView *)transitionMaskView
{
	if (_transitionMaskView == nil) {
		_transitionMaskView = [[UIView alloc] initWithFrame:self.view.bounds];
		_transitionMaskView.backgroundColor = [UIColor blackColor];
		_transitionMaskView.layer.opacity = 0;
	}
	return _transitionMaskView;
}

- (void)_clearView
{
	if (_transitionMaskView) {
		[_transitionMaskView removeFromSuperview];
		_transitionMaskView = nil;
	}
	if (_transitionShadowView) {
		[_transitionShadowView removeFromSuperview];
		_transitionShadowView = nil;
	}
}

- (void)transitionAnimation:(void (^)(void))animation completion:(void(^ __nullable)(BOOL finished))completion
{
	[UIView animateWithDuration:TransitionDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:TransitionAnimationOption animations:^{
		if (animation) {
			animation();
		}
	} completion:^(BOOL finished) {
		if (completion) {
			completion(finished);
		}
	}];
}

#pragma mark Move Controller

// controller 逐渐移动，手势拖动的时候
- (void)_moveController:(HyBaseViewController *)controller withVector:(CGVector)vector withShadow:(BOOL)shadow withMask:(BOOL)mask
{
	[self _moveController:controller toOrigin:CGPointMake(controller.view.x + vector.dx, controller.view.y + vector.dy)];
	if (shadow) {
		_transitionShadowView.origin = CGPointMake(controller.view.x - _transitionShadowView.width, controller.view.y);
	}
	if (mask) {
		if (vector.dx != 0) {
			self.transitionMaskView.layer.opacity -= vector.dx / (self.view.width/TransitionParallax)*0.5;
		}
		if (vector.dy != 0) {
			self.transitionMaskView.layer.opacity -= vector.dy / (self.view.height)*0.5;
		}
		
	}
}

// controller 移到左侧隐藏
- (void)_moveControllerToLeftHide:(HyBaseViewController *)controller
{
	CGPoint origin = CGPointMake(-self.view.width * TransitionParallax, 0);
	[self _moveController:controller toOrigin:origin];
//	self.transitionMaskView.origin = origin;
}

// controller 移到最右侧边缘隐藏，阴影跟随
- (void)_moveControllerToRightHide:(HyBaseViewController *)controller
{
	[self _moveController:controller toOrigin:CGPointMake(self.view.width, 0)];
}

- (void)_moveControllerToBottomHide:(HyBaseViewController *)controller
{
	[self _moveController:controller toOrigin:CGPointMake(0, self.view.height)];
}

// controller 移到可视区
// 如果从右边一过来的，阴影跟随
- (void)_moveControllerToVisible:(HyBaseViewController *)controller
{
	[self _moveController:controller toOrigin:CGPointZero];
}

- (void)_moveController:(HyBaseViewController *)controller toOrigin:(CGPoint)origin
{
	controller.view.origin = origin;
}

- (void)_makeTransitionShadowViewToLeft
{
	self.transitionShadowView.origin = CGPointMake(-self.transitionShadowView.width, 0);
}

- (void)_makeTransitionShadowViewToRight
{
	self.transitionShadowView.origin = CGPointMake(self.view.width - self.transitionShadowView.width, 0);
}

- (void)_makeTransitionMaskViewLighter
{
	self.transitionMaskView.layer.opacity = 0;
}

- (void)_makeTransitionMaskViewDarker
{
	self.transitionMaskView.layer.opacity = 0.5;
}

@end
