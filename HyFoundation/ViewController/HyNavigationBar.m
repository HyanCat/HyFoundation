//
//  HyNavigationBar.m
//  RGFoundation
//
//  Created by HyanCat on 16/10/2017.
//  Copyright © 2017 ruogu. All rights reserved.
//

#import "HyNavigationBar.h"
#import "HyNavigationItem.h"
#import <Masonry/Masonry.h>

@interface HyNavigationBar ()

@end

@implementation HyNavigationBar
@synthesize navigationItem = _navigationItem;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _preferredStatusBarMargin = 20.f;
    _preferredHeight = 44.f;
}

- (void)setNavigationItem:(HyNavigationItem *)navigationItem
{
    _navigationItem = navigationItem;
    [self setNeedsUpdateConstraints];
}

- (HyNavigationItem *)navigationItem
{
    if (!_navigationItem) {
        _navigationItem = [[HyNavigationItem alloc] init];
    }
    return _navigationItem;
}

- (void)updateConstraints
{
    [super updateConstraints];

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];

    CGFloat margin = self.navigationItem.preferMargin;

    CGSize leftViewSize = CGSizeZero;
    UIView *leftView = self.navigationItem.leftView;
    if (leftView) {
        [self addSubview:leftView];
        leftViewSize = [leftView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topLayoutGuide);
            make.height.mas_equalTo(self.preferredHeight);
            if (leftViewSize.width > 44) {
                make.left.mas_equalTo(margin);
                make.width.mas_equalTo(leftViewSize.width);
            } else {
                // 保证视觉效果的 margin，但是点击区域最小 44
                CGFloat realMargin = 16-(44-leftViewSize.width)/2;
                make.left.mas_equalTo(realMargin);
                make.width.mas_equalTo(44);
            }
        }];
    }
    CGSize rightViewSize = CGSizeZero;
    UIView *rightView = self.navigationItem.rightView;
    if (rightView) {
        [self addSubview:rightView];
        rightViewSize = [rightView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topLayoutGuide);
            make.height.mas_equalTo(self.preferredHeight);
            if (rightViewSize.width > 44) {
                make.right.mas_equalTo(-margin);
                make.width.mas_equalTo(rightViewSize.width);
            } else {
                // 保证视觉效果的 margin，但是点击区域最小 44
                CGFloat realMargin = 16-(44-rightViewSize.width)/2;
                make.right.mas_equalTo(-realMargin);
                make.width.mas_equalTo(44);
            }
        }];
    }

    UIView *titleView = self.navigationItem.titleView;
    if (titleView) {
        [self addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.topLayoutGuide);
            make.height.mas_equalTo(self.preferredHeight);
            CGFloat width = MAX(MAX(leftViewSize.width, rightViewSize.width), margin);
            make.left.mas_equalTo(width);
        }];
    }

    UIView *extendView = self.navigationItem.extendView;
    if (extendView) {
        if (!extendView.superview) {
            [self addSubview:extendView];
            [extendView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                if (titleView) {
                    make.top.equalTo(titleView.mas_bottom);
                } else {
                    make.top.mas_equalTo(self.topLayoutGuide);
                }
                make.bottom.mas_equalTo(0);
            }];
        }
    }
}

- (CGFloat)topLayoutGuide
{
    return _preferredStatusBarMargin;
}

@end
