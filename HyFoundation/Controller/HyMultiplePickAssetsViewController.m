//
//  HyMultiplePickAssetsViewController.m
//
//  Created by HyanCat on 15/10/25.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyMultiplePickAssetsViewController.h"
#import "HyAlbumViewController.h"
#import "HyAssetsViewBar.h"
#import "HyAssetCell.h"
#import "UINib+Hy.h"
#import <Masonry/Masonry.h>
#import <HyUIActionEvent/HyUIActionCore.h>

@interface HyMultiplePickAssetsViewController () <HyAssetsViewBarDelegate>

@property (nonatomic, weak) HyAssetsViewBar *assetsBar;

@end

static NSString *const kHyMultipleAssetsViewCellIdentifier = @"hyMultipleAssetsViewCellIdentifier";

@implementation HyMultiplePickAssetsViewController

- (void)loadSubviews
{
	[super loadSubviews];
	
	CGFloat toolBarHeight = 49.f;
	self.collectionView.contentInset = UIEdgeInsetsMake([self preferNavigationBarHeight], 0, toolBarHeight, 0);
	self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake([self preferNavigationBarHeight], 0, toolBarHeight, 0);
	[self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HyAssetCell class]) bundle:nil] forCellWithReuseIdentifier:kHyMultipleAssetsViewCellIdentifier];
	
	HyAssetsViewBar *assetsBar = [UINib loadViewWithNibName:NSStringFromClass([HyAssetsViewBar class])];
	assetsBar.assetsDelegate = self;
	[self.contentView addSubview:assetsBar];
	[assetsBar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(0);
		make.right.mas_equalTo(0);
		make.bottom.mas_equalTo(0);
		make.height.mas_equalTo(toolBarHeight);
	}];
	self.assetsBar = assetsBar;
	self.assetsBar.count = self.selectedAssetUrls.count;
}

#pragma mark - Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	HyAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHyMultipleAssetsViewCellIdentifier forIndexPath:indexPath];
	cell.image = [UIImage imageWithCGImage:[self.assets objectAtIndex:indexPath.row].thumbnail];
	
	if ([self.selectedAssetUrls containsObject:[[self.assets objectAtIndex:indexPath.row] valueForProperty:ALAssetPropertyAssetURL]]) {
		cell.checked = YES;
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	HyAssetCell *cell = (HyAssetCell *)[collectionView cellForItemAtIndexPath:indexPath];
	if (!cell.isChecked && self.selectedAssetUrls.count >= [self assetsLimitCount]) {
		NSLog(@"select count is beyond of the limit.");
		return;
	}
	
	cell.checked = ! cell.isChecked;
	if (cell.isChecked) {
		[self.selectedAssetUrls addObject:[[self.assets objectAtIndex:indexPath.row] valueForProperty:ALAssetPropertyAssetURL]];
		self.assetsBar.count ++;
	}
	else {
		[self.selectedAssetUrls removeObject:[[self.assets objectAtIndex:indexPath.row] valueForProperty:ALAssetPropertyAssetURL]];
		self.assetsBar.count --;
	}
}

- (void)assetsBarConfirmButtonDidTouched:(HyAssetsViewBar *)assetsBar
{
	[self dispatchHyUIActionEvent:[HyUIActionEvent eventWithTransitionTypeDismissAnimated:YES]];
	
	if (self.albumDelegate &&
		[self.albumDelegate respondsToSelector:@selector(hyAlbumViewController:completedToPickMultipleAssetUrls:)]) {
		[self.albumDelegate hyAlbumViewController:self.albumViewController completedToPickMultipleAssetUrls:self.selectedAssetUrls];
	}
}

- (void)assetsBarPreviewButtonDidTouched:(HyAssetsViewBar *)assetsBar
{
	// TODO: goto images' preview page.
}

- (NSUInteger)assetsLimitCount
{
	if (self.albumDelegate && [self.albumDelegate respondsToSelector:@selector(numberOfPicturesLimitedToPickByAlbumViewController:)]) {
		return [self.albumDelegate numberOfPicturesLimitedToPickByAlbumViewController:self.albumViewController];
	}
	return NSUIntegerMax;
}

@end
