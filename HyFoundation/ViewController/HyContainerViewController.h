//
//  HyContainerViewController.h
//
//  Created by HyanCat on 15/9/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyBaseViewController.h"

@class HyUIActionEvent, HyUIActionEventResult, HyUIPanPoint;
@protocol HyContainerViewControllerPanGestureDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 * controller 容器，负责处理 viewController 的切换关系
 */
@interface HyContainerViewController : HyBaseViewController

/**
 * 容器初始化方法
 *
 * @param rootViewController 根视图控制器
 *
 * @return 容器控制器实例
 *
 * @notice 出于安全考虑，必须设置一个 rootViewController，哪怕是个 empty 的 ViewController
 */
- (instancetype)initWithRootViewController:(HyBaseViewController *)rootViewController;

/**
 * 根视图控制器
 */
@property (nullable, nonatomic, strong, readonly) HyBaseViewController *rootViewController;

/**
 * 控制器二维数组
 * 每 push 一次，在最上层维度数组增加一个 ViewController
 * 每 present 一次，数组增加一层，新层为 present 的 ViewController
 */
@property (nonatomic, strong, readonly) NSMutableArray <NSMutableArray <HyBaseViewController *> *> *viewControllers;

#pragma mark - Gesture

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nullable, nonatomic, strong, readonly) HyUIPanPoint *panPoint;
/**
 * 让外部处理额外的手势响应
 */
@property (nullable, nonatomic, weak) id <HyContainerViewControllerPanGestureDelegate> panGestureDelegate;

/**
 * 转场状态
 */
@property (nonatomic, assign, readonly, getter=isHandlingTransition) BOOL handlingTransition;


#pragma mark - Drop Methods

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

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

NS_ASSUME_NONNULL_END
