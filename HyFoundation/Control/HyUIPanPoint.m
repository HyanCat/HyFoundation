//
//  HyUIPanPoint.m
//
//  Created by HyanCat on 15/9/28.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyUIPanPoint.h"

@interface HyUIPanPoint ()

@property (nonatomic, assign) CGPoint historyPoint;

@property (nonatomic, assign, readwrite) CGFloat moveHorizontalOffset;
@property (nonatomic, assign, readwrite) CGFloat moveVerticalOffset;
@property (nonatomic, assign, readwrite) BOOL isMovingHorizontal;
@property (nonatomic, assign, readwrite) BOOL isMovingVertical;

@end

CGFloat const kHyUIPanPointDegree = 30;

@implementation HyUIPanPoint

- (instancetype)init
{
	self = [super init];
	if (self) {
		_beganPoint = CGPointZero;
		_point = CGPointZero;
		_historyPoint = CGPointZero;
		_moveHorizontalOffset = 0;
		_moveVerticalOffset = 0;
	}
	return self;
}

- (void)setBeganPoint:(CGPoint)beganPoint
{
	_beganPoint = beganPoint;
	_historyPoint = beganPoint;
	_point = beganPoint;
}

- (void)setPoint:(CGPoint)point
{
//	NSLog(@"point: %f, %f", point.x, point.y);
	[self _resetDirection];
	if (CGPointEqualToPoint(_point, point)) {
		return;
	}
	_historyPoint = _point;
	_point = point;
	
	CGFloat vectorX = _point.x - _historyPoint.x;
	CGFloat vectorY = _point.y - _historyPoint.y;
	_moveHorizontalOffset = vectorX;
	_moveVerticalOffset = vectorY;
	// 这里按照 30° 划分
	if (fabs(vectorY) / fabs(vectorX) < atan(kHyUIPanPointDegree * M_PI / 180.f)) {
		// move horizontal
		if (vectorX >= 0) {
			_isMovingRight = YES;
		}
		else {
			_isMovingLeft = YES;
		}
	}
	else if (fabs(vectorX) / fabs(vectorY) < atan(kHyUIPanPointDegree * M_PI / 180.f)) {
		if (vectorY >= 0) {
			_isMovingUp = YES;
		}
		else {
			_isMovingDown = YES;
		}
	}
}

- (CGVector)moveOffset
{
	return CGVectorMake(self.moveHorizontalOffset, self.moveVerticalOffset);
}

- (CGFloat)moveHorizontalDistance
{
	return self.point.x - self.beganPoint.x;
}

- (CGFloat)moveVerticalDistance
{
	return self.point.y - self.beganPoint.y;
}

- (BOOL)isMovingHorizontal
{
	return self.isMovingLeft || self.isMovingRight;
}

- (BOOL)isMovingVertical
{
	return self.isMovingUp || self.isMovingDown;
}

- (void)_resetDirection
{
	_isMovingLeft = NO;
	_isMovingRight = NO;
	_isMovingUp = NO;
	_isMovingDown = NO;
}

@end
