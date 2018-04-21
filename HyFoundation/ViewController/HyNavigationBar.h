//
//  HyNavigationBar.h
//  RGFoundation
//
//  Created by HyanCat on 16/10/2017.
//  Copyright © 2017 ruogu. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class HyNavigationItem;
@interface HyNavigationBar : UIView

@property (nonatomic, strong) HyNavigationItem *navigationItem;

@property (nonatomic, strong, readonly) UIView *backgroundView;

@property (nonatomic, assign) CGFloat preferredStatusBarMargin UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat preferredHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *forgroundColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat scrollOffset;

@end

NS_ASSUME_NONNULL_END
