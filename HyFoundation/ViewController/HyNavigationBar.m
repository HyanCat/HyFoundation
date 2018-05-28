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
{
@private
    Boolean _leftCompacted;
    Boolean _rightCompacted;
}
@property (nonatomic, assign) CGFloat preferredStatusBarMargin;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong, readwrite) UIView *backgroundView;
@property (nonatomic, strong, readwrite) UIView *containerView;

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
    _contentHeight = 44.f;

    self.backgroundView = [[UIView alloc] init];
    self.containerView = [[UIView alloc] init];

    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(self.topLayoutGuide);
        }
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(self.contentHeight);
        make.bottom.mas_equalTo(0);
    }];
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

- (void)setBackgroundView:(UIView * _Nonnull)backgroundView
{
    if (_backgroundView) {
        [_backgroundView removeFromSuperview];
    }
    _backgroundView = backgroundView;
    [self addSubview:backgroundView];
    [self sendSubviewToBack:backgroundView];
    backgroundView.frame = self.bounds;
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setScrollOffset:(CGFloat)scrollOffset
{
    _scrollOffset = scrollOffset;
    if (scrollOffset >=0 && scrollOffset <= 40.f) {
        self.layer.shadowOpacity = scrollOffset / 50.f;
    }
    else if (scrollOffset >= 40.f) {
        self.layer.shadowOpacity = 0.8f;
    }
}

- (void)updateConstraints
{
    [super updateConstraints];

    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:self.backgroundView]) {
            [obj removeFromSuperview];
        }
    }];

    CGFloat margin = self.navigationItem.preferMargin;
    UIView *extendView = self.navigationItem.extendView;

    CGSize leftViewSize = CGSizeZero;
    UIView *leftView = self.navigationItem.leftView;
    if (leftView) {
        [self.containerView addSubview:leftView];
        leftViewSize = [leftView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        if (!_leftCompacted) {
            self.navigationItem.leftCompactSize = leftViewSize;
        }
        _leftCompacted = YES;
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.contentHeight);
            if (leftViewSize.width > 44) {
                make.left.mas_equalTo(margin);
                make.width.mas_equalTo(leftViewSize.width);
            } else {
                // 保证视觉效果的 margin，但是点击区域最小 44
                CGFloat realMargin = 16-(44-self.navigationItem.leftCompactSize.width)/2;
                make.left.mas_equalTo(realMargin);
                make.width.mas_equalTo(44);
            }
            if (!extendView) {
                make.bottom.mas_equalTo(0);
            }
        }];
    }
    CGSize rightViewSize = CGSizeZero;
    UIView *rightView = self.navigationItem.rightView;
    if (rightView) {
        [self.containerView addSubview:rightView];
        rightViewSize = [rightView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        if (!_rightCompacted) {
            self.navigationItem.rightCompactSize = rightViewSize;
        }
        _rightCompacted = YES;
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.contentHeight);
            if (rightViewSize.width > 44) {
                make.right.mas_equalTo(-margin);
                make.width.mas_equalTo(rightViewSize.width);
            } else {
                // 保证视觉效果的 margin，但是点击区域最小 44
                CGFloat realMargin = 16-(44-self.navigationItem.rightCompactSize.width)/2;
                make.right.mas_equalTo(-realMargin);
                make.width.mas_equalTo(44);
            }
            if (!extendView) {
                make.bottom.mas_equalTo(0);
            }
        }];
    }

    UIView *titleView = self.navigationItem.titleView;
    if (titleView) {
        [self.containerView addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.contentHeight);
            CGFloat width = MAX(MAX(leftViewSize.width, rightViewSize.width), 44+margin);
            make.left.mas_equalTo(width);
            if (!extendView) {
                make.bottom.mas_equalTo(0);
            }
        }];
    }

    if (extendView) {
        if (!extendView.superview) {
            [self.containerView addSubview:extendView];
            [extendView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                if (titleView) {
                    make.top.equalTo(titleView.mas_bottom);
                } else {
                    make.top.mas_equalTo(0);
                }
                make.bottom.mas_equalTo(0);
            }];
        }
    }

    [self sendSubviewToBack:self.backgroundView];
}

- (CGFloat)topLayoutGuide
{
    return _preferredStatusBarMargin;
}

@end
