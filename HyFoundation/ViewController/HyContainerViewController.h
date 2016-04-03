//
//  HyContainerViewController.h
//
//  Created by HyanCat on 15/9/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyBaseViewController.h"
#import "HyUIPanPoint.h"

@class HyUIActionEvent, HyUIActionEventResult;
@protocol HyContainerViewControllerPanGestureDelegate;

/**
 * controller 容器，负责处理 viewController 的切换关系
 */
@interface HyContainerViewController : HyBaseViewController

- (instancetype)initWithRootViewController:(HyBaseViewController *)rootViewController;

// 层叠的 controllers
@property (nonatomic, strong, readonly) HyBaseViewController *rootViewController;
@property (nonatomic, strong, readonly) NSMutableArray <NSMutableArray <HyBaseViewController *> *> *viewControllers;	// 控制器二维数组

// 让外部处理额外的手势响应
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong, readonly) HyUIPanPoint *panPoint;
@property (nonatomic, weak) id <HyContainerViewControllerPanGestureDelegate> panGestureDelegate;

// 转场状态
@property (nonatomic, assign, readonly, getter=isHandlingTransition) BOOL handlingTransition;

@end



@protocol HyContainerViewControllerPanGestureDelegate <NSObject>

@optional

/**
 * 手势委托，让外部控制器按需添加手势响应
 *
 * @param containerViewController 容器控制器
 * @param panGestureRecognizer    拖动手势
 *
 * @return 是否继续完成容器手势事件（这里指转场）
 */
- (BOOL)hyContainerView:(HyContainerViewController *)containerViewController panned:(UIPanGestureRecognizer *)panGestureRecognizer;

@end