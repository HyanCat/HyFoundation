//
//  HyAlbumViewController.h
//
//  Created by HyanCat on 15/10/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyBaseViewController.h"

@class HyAlbumViewController;

@protocol HyAlbumViewControllerDelegate <NSObject>

@optional

- (NSUInteger)numberOfPicturesLimitedToPickByAlbumViewController:(HyAlbumViewController *)albumViewController;

- (void)hyAlbumViewController:(HyAlbumViewController *)albumViewController completedToPickMultipleAssetUrls:(NSArray <NSURL *> *)assetUrls;

- (void)hyAlbumViewController:(HyAlbumViewController *)albumViewController completedToPickSingleAssetUrl:(NSURL *)assetUrl;

@end

@interface HyAlbumViewController : HyBaseViewController

@property (nonatomic, strong) NSMutableArray <NSURL *> *selectedAssetUrls;

@property (nonatomic, weak) id <HyAlbumViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL singlePick;

@end
