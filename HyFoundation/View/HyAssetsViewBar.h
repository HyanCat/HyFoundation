//
//  HyAssetsViewBar.h
//
//  Created by HyanCat on 15/10/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HyAssetsViewBar;

@protocol HyAssetsViewBarDelegate <NSObject>

@optional

- (void)assetsBarPreviewButtonDidTouched:(HyAssetsViewBar *)assetsBar;
- (void)assetsBarConfirmButtonDidTouched:(HyAssetsViewBar *)assetsBar;

@end

@interface HyAssetsViewBar : UIToolbar

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, weak) id <HyAssetsViewBarDelegate> assetsDelegate;

@end
