//
//  HySinglePickAssetsViewController.m
//
//  Created by HyanCat on 15/10/25.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HySinglePickAssetsViewController.h"
#import "HyAlbumViewController.h"
#import "HyAssetCell.h"
#import <HyUIActionEvent/HyUIActionCore.h>

@interface HySinglePickAssetsViewController ()

@end

@implementation HySinglePickAssetsViewController

- (void)loadSubviews
{
	[super loadSubviews];
	
	self.collectionView.contentInset = UIEdgeInsetsMake([self preferNavigationBarHeight], 0, 0, 0);
	self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake([self preferNavigationBarHeight], 0, 0, 0);
}

#pragma mark - Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	[self dispatchHyUIActionEvent:[HyUIActionEvent eventWithTransitionTypeDismissAnimated:YES]];
	
	if (self.albumDelegate && [self.albumDelegate respondsToSelector:@selector(hyAlbumViewController:completedToPickSingleAssetUrl:)]) {
		ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
		[self.albumDelegate hyAlbumViewController:self.albumViewController completedToPickSingleAssetUrl:asset.defaultRepresentation.url];
	}
}

@end
