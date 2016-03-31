//
//  UIView+Hy.m
//
//  Created by HyanCat on 15/9/24.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "UIView+Hy.h"

@implementation UIView (HyBase)

#pragma mark Getter

- (CGFloat)x
{
	return self.frame.origin.x;
}
- (CGFloat)y
{
	return self.frame.origin.y;
}
- (CGFloat)width
{
	return self.frame.size.width;
}
- (CGFloat)height
{
	return self.frame.size.height;
}
- (CGFloat)top
{
	return CGRectGetMinY(self.frame);
}
- (CGFloat)bottom
{
	return CGRectGetMaxY(self.frame);
}
- (CGFloat)left
{
	return CGRectGetMinX(self.frame);
}
- (CGFloat)right
{
	return CGRectGetMaxX(self.frame);
}
- (CGPoint)origin
{
	return self.frame.origin;
}
- (CGSize)size
{
	return self.frame.size;
}
- (CGPoint)innerCenter
{
	return CGPointMake(self.width/2, self.height/2);
}

#pragma mark Setter

- (void)setX:(CGFloat)x
{
	self.frame = CGRectMake(x, self.y, self.width, self.height);
}
- (void)setY:(CGFloat)y
{
	self.frame = CGRectMake(self.x, y, self.width, self.height);
}
- (void)setWidth:(CGFloat)width
{
	self.frame = CGRectMake(self.x, self.y, width, self.height);
}
- (void)setHeight:(CGFloat)height
{
	self.frame = CGRectMake(self.x, self.y, self.width, height);
}
- (void)setTop:(CGFloat)top
{
	self.frame = CGRectMake(self.x, top, self.width, self.height);
}
- (void)setBottom:(CGFloat)bottom
{
	self.frame = CGRectMake(self.x, bottom-self.height, self.width, self.height);
}
- (void)setLeft:(CGFloat)left
{
	self.frame = CGRectMake(left, self.y, self.width, self.height);
}
- (void)setRight:(CGFloat)right
{
	self.frame = CGRectMake(right-self.width, self.y, self.width, self.height);
}

- (void)setOrigin:(CGPoint)origin
{
	self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}
- (void)setSize:(CGSize)size
{
	self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}
- (void)setOriginZero
{
	[self setOrigin:CGPointZero];
}
- (void)setSizeZero
{
	[self setSize:CGSizeZero];
}

- (void)frameAddPoint:(CGPoint)point
{
	self.frame = CGRectMake(self.x + point.x, self.y + point.y, self.width, self.height);
}
- (void)frameAddSize:(CGSize)size
{
	self.frame = CGRectMake(self.x, self.y, self.width + size.width, self.height + size.height);
}

#pragma mark Operator

- (void)addSubviewToFill:(UIView *)subview
{
	[subview removeFromSuperviewIfExist];
	subview.frame = self.bounds;
	subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:subview];
}

- (void)insertSubviewToFill:(UIView *)subview atIndex:(NSInteger)index
{
	[subview removeFromSuperviewIfExist];
	subview.frame = self.frame;
	subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self insertSubview:subview atIndex:index];
}

- (void)insertSubviewToFill:(UIView *)subview aboveSubview:(UIView *)abovedSubview
{
	[subview removeFromSuperviewIfExist];
	subview.frame = self.frame;
	subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self insertSubview:subview aboveSubview:abovedSubview];
}

- (void)insertSubviewToFill:(UIView *)subview belowSubview:(UIView *)belowedSubview
{
	[subview removeFromSuperviewIfExist];
	subview.frame = self.frame;
	subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self insertSubview:subview belowSubview:belowedSubview];
}

- (void)removeAllSubviewsWhichKindOfClass:(Class)viewClass
{
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperviewIfSelfIsKindOfClass:) withObject:viewClass];
}

- (void)removeFromSuperviewIfSelfIsKindOfClass:(Class)viewClass
{
	if ([self isKindOfClass:viewClass]) {
		[self removeFromSuperview];
	}
}

- (void)removeFromSuperviewIfExist
{
	if (self.superview != nil) {
		[self removeFromSuperview];
	}
}

- (UIView *)superviewWhichKindOfClass:(Class)viewClass
{
	if ([self isKindOfClass:viewClass]) {
		return self;
	}
	if (self.superview != nil) {
		if ([self.superview isKindOfClass:viewClass]) {
			return self.superview;
		}
		else {
			return [self.superview superviewWhichKindOfClass:viewClass];
		}
	}

	return nil;
}

- (NSArray *)subviewsWhichKindOfClass:(Class)viewClass
{
	NSMutableArray *subviews = [self.subviews mutableCopy];
	for (UIView *v in self.subviews) {
		if ([v isKindOfClass:viewClass]) {
			[subviews addObject:v];
		}
	}

	return [subviews copy];
}

- (NSArray *)subviewsWhichMemberOfClass:(Class)viewClass
{
	NSMutableArray *subviews = [self.subviews mutableCopy];
	for (UIView *v in self.subviews) {
		if ([v isMemberOfClass:viewClass]) {
			[subviews addObject:v];
		}
	}

	return [subviews copy];
}

@end

@implementation UIView (HyLayout)

- (CGSize)systemLayoutSizeWithPreferredMaxLayoutWidth:(CGFloat)preferedWidth
{
	if (self.superview == nil) {
		return CGSizeZero;
	}
	NSLayoutConstraint *widthConstraints = [NSLayoutConstraint constraintWithItem:self
																		attribute:NSLayoutAttributeWidth
																		relatedBy:NSLayoutRelationEqual
																		   toItem:nil
																		attribute:NSLayoutAttributeNotAnAttribute
																	   multiplier:1
																		 constant:preferedWidth];
	[self.superview addConstraint:widthConstraints];
	
	CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
	
	[self.superview removeConstraint:widthConstraints];

	return size;
}

@end


@implementation UIView (HySnapshot)

- (UIImage *)snapshot;
{
	return [self snapshot:YES];
}

- (UIImage *)snapshot:(BOOL)opaque;
{
	UIGraphicsBeginImageContextWithOptions(self.frame.size, opaque, [[UIScreen mainScreen] scale]);
	[[self layer] renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * snapshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return snapshot;
}

- (UIView *)snapshotView;
{
	return [self snapshotView:YES];
}

- (UIView *)snapshotView:(BOOL)opaque
{
	return [[UIImageView alloc] initWithImage:[self snapshot:opaque]];
}

@end
