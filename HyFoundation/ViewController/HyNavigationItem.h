//
//  HyNavigationItem.h
//  RGFoundation
//
//  Created by HyanCat on 16/10/2017.
//  Copyright © 2017 ruogu. All rights reserved.
//

@import UIKit;

@interface HyNavigationItem : NSObject

@property (nonatomic, strong) __kindof UIView *titleView;
@property (nonatomic, strong) __kindof UIView *leftView;
@property (nonatomic, strong) __kindof UIView *rightView;

@property (nonatomic, strong) __kindof UIView *extendView;

@property (nonatomic, assign) CGFloat preferMargin; // default 16.f

@end
