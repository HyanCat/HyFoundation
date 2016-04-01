//
//  HyAlbumViewController.m
//
//  Created by HyanCat on 15/10/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyAlbumViewController.h"
#import "HySinglePickAssetsViewController.h"
#import "HyMultiplePickAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "HyAlbumCell.h"
#import "UIView+Hy.h"
#import <HyUIActionEvent/HyUIActionCore.h>

@interface HyAlbumViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <ALAssetsGroup *> *albums;
@property (nonatomic, strong) NSMutableArray <ALAsset *> *assets;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@end

static NSString *const kHyAlbumViewCellIdentifier = @"hyAlbumViewCellIdentifier";

@implementation HyAlbumViewController

- (void)loadSubviews
{
	[super loadSubviews];
	[self setNavigationCenterItemWithTitle:@"我的相册" color:[UIColor whiteColor]];
	
	UITableView *tableView = [[UITableView alloc] init];
	tableView.contentInset = UIEdgeInsetsMake([self preferNavigationBarHeight], 0, 0, 0);
	tableView.scrollIndicatorInsets = UIEdgeInsetsMake([self preferNavigationBarHeight], 0, 0, 0);
	tableView.separatorInset = UIEdgeInsetsZero;
	if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		tableView.layoutMargins = UIEdgeInsetsZero;
	}
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.estimatedRowHeight = 64.f;
	tableView.rowHeight = 64.f;
	tableView.tableFooterView = [[UIView alloc] init];
	[self.contentView addSubviewToFill:tableView];
	self.tableView = tableView;
	[self.tableView registerClass:[HyAlbumCell class] forCellReuseIdentifier:kHyAlbumViewCellIdentifier];
}

- (void)loadData
{
	[super loadData];
	_assetsLibrary = [[ALAssetsLibrary alloc] init];
	_albums = [NSMutableArray array];
	_assets = [NSMutableArray array];
	if (!_selectedAssetUrls) {
		_selectedAssetUrls = [NSMutableArray array];
	}
	
	__weak typeof(self) weakSelf = self;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		__strong typeof(weakSelf) strongSelf = weakSelf;
		[strongSelf.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
											  usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
												  if (! group || group.numberOfAssets <= 0) return ;
												  [group setAssetsFilter:[ALAssetsFilter allPhotos]];
												  [group enumerateAssetsWithOptions:NSEnumerationReverse
																		 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
																			 if (result) {
																				 // only find the latest asset.
																				 [strongSelf.assets addObject:result];
																				 [strongSelf.albums addObject:group];
																				 *stop = YES;
																			 }
																		 }];
												  dispatch_async(dispatch_get_main_queue(), ^{
													  [self.tableView reloadData];
												  });
											  }
											  failureBlock:^(NSError *error) {
												  NSLog(@"Error to enumerate assets library!");
											  }];
	});
}


#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HyAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:kHyAlbumViewCellIdentifier forIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.imageView.image = [self imageAtIndexPath:indexPath];
	cell.textLabel.text = [[self.albums objectAtIndex:indexPath.row] valueForProperty:ALAssetsGroupPropertyName];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.albums objectAtIndex:indexPath.row].numberOfAssets];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ALAssetsGroup *group = [self.albums objectAtIndex:indexPath.row];
	HyUIActionEvent *event = nil;
	if (self.singlePick) {
		event = [HyUIActionEvent eventWithTransitionType:HyUITransitionTypePush
												animated:YES
											  completion:nil
									 toViewControllerURL:NSStringFromClass([HySinglePickAssetsViewController class])
								  toViewControllerValues:@{@"assetsLibrary": self.assetsLibrary,
														   @"assetsGroup": group,
														   @"albumDelegate": self.delegate,
														   @"albumViewController": self,
														   }];
	}
	else {
		event = [HyUIActionEvent eventWithTransitionType:HyUITransitionTypePush
												animated:YES
											  completion:nil
									 toViewControllerURL:NSStringFromClass([HyMultiplePickAssetsViewController class])
								  toViewControllerValues:@{@"assetsLibrary": self.assetsLibrary,
														   @"assetsGroup": group,
														   @"selectedAssetUrls": self.selectedAssetUrls,
														   @"albumDelegate": self.delegate,
														   @"albumViewController": self,
														   }];
	}
	[self dispatchHyUIActionEvent:event];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath
{
	ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
	return [UIImage imageWithCGImage:asset.thumbnail];
}

@end
