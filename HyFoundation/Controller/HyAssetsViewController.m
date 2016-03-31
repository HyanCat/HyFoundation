//
//  HyAssetsViewController.m
//
//  Created by HyanCat on 15/10/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyAssetsViewController.h"
#import "HyAlbumViewController.h"
#import "HyAssetsViewBar.h"
#import "HyAssetCell.h"
#import "HyMacros.h"
#import "UIView+Hy.h"

@interface HyAssetsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak, readwrite) UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) NSMutableArray <ALAsset *> *mutableAssets;

@end

static NSString *const kHyAssetsViewCellIdentifier = @"hyAssetsViewCellIdentifier";

@implementation HyAssetsViewController

- (void)loadSubviews
{
	[super loadSubviews];
	[self setNavigationCenterItemWithTitle:[self.assetsGroup valueForProperty:ALAssetsGroupPropertyName] color:[UIColor whiteColor]];
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	CGFloat margin = 4.f;
	layout.minimumInteritemSpacing = margin;
	layout.minimumLineSpacing = margin;
	layout.itemSize = CGSizeMake((HyScreenWidth - margin*5) / 4, (HyScreenWidth - margin*5) / 4);
	layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
	
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
	collectionView.backgroundColor = [UIColor whiteColor];
	collectionView.delegate = self;
	collectionView.dataSource = self;
	[self.contentView addSubviewToFill:collectionView];
	self.collectionView = collectionView;
	[self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HyAssetCell class]) bundle:nil] forCellWithReuseIdentifier:kHyAssetsViewCellIdentifier];
}

- (void)loadData
{
	[super loadData];
	_mutableAssets = [NSMutableArray array];
	
	weakify(self);
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		strongify(self);
		[self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
			if (result) {
				[self.mutableAssets addObject:result];
			}
		}];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.collectionView reloadData];
		});
	});
}

- (NSArray<ALAsset *> *)assets
{
	return self.mutableAssets.copy;
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	HyAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHyAssetsViewCellIdentifier forIndexPath:indexPath];
	cell.shouldShowCheck = NO;
	cell.image = [UIImage imageWithCGImage:[self.assets objectAtIndex:indexPath.row].thumbnail];
	return cell;
}

- (NSUInteger)assetsLimitCount
{
	if (self.albumDelegate && [self.albumDelegate respondsToSelector:@selector(numberOfPicturesLimitedToPickByAlbumViewController:)]) {
		return [self.albumDelegate numberOfPicturesLimitedToPickByAlbumViewController:self.albumViewController];
	}
	return NSUIntegerMax;
}

@end
