//
//  HyAssetCell.h
//
//  Created by HyanCat on 15/10/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HyAssetCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, getter=isChecked) BOOL checked;	// default NO.
@property (nonatomic, assign) BOOL shouldShowCheck;	// default YES.

@end
