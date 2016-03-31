//
//  HyUIPanPoint.h
//
//  Created by HyanCat on 15/9/28.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HyUIPanPoint : NSObject

@property (nonatomic, assign) CGPoint beganPoint;
@property (nonatomic, assign) CGPoint point;

@property (nonatomic, assign, readonly) BOOL isMovingLeft;
@property (nonatomic, assign, readonly) BOOL isMovingRight;
@property (nonatomic, assign, readonly) BOOL isMovingUp;
@property (nonatomic, assign, readonly) BOOL isMovingDown;

@property (nonatomic, assign, readonly) CGVector moveOffset;		// 位移
@property (nonatomic, assign, readonly) CGFloat moveHorizontalOffset;	// 横向位移
@property (nonatomic, assign, readonly) CGFloat moveVerticalOffset;		// 纵向位移

@property (nonatomic, assign, readonly) CGFloat moveHorizontalDistance;	// 横向距离
@property (nonatomic, assign, readonly) CGFloat moveVerticalDistance;	// 纵向距离

- (BOOL)isMovingHorizontal;
- (BOOL)isMovingVertical;

@end
