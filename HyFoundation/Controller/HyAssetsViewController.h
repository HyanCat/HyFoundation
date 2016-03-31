//
//  HyAssetsViewController.h
//
//  Created by HyanCat on 15/10/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@protocol HyAlbumViewControllerDelegate;
@class HyAlbumViewController;

@interface HyAssetsViewController : HyBaseViewController

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, weak) id <HyAlbumViewControllerDelegate> albumDelegate;
@property (nonatomic, weak) HyAlbumViewController *albumViewController;

@property (nonatomic, weak, readonly) UICollectionView *collectionView;

- (NSArray <ALAsset *> *)assets;

@end
