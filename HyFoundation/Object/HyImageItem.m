//
//  HyImageItem.m
//
//  Created by HyanCat on 15/10/29.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyImageItem.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSString+Hy.h"
#import <FCFileManager/FCFileManager.h>

@implementation HyImageItem
@synthesize image;
@synthesize thumbnail;
@synthesize imageUrl;

@end

@implementation HyImageAssetItem
@synthesize asset = _asset;

- (instancetype)initWithAsset:(ALAsset *)asset
{
	self = [super init];
	if (self) {
		_asset = asset;
		self.imageUrl = asset.defaultRepresentation.url;
		self.thumbnail = [UIImage imageWithCGImage:asset.thumbnail];
	}
	return self;
}

- (BOOL)loadImage
{
	if (HyStringIsNil(self.imageUrl.absoluteString)) {
		return NO;
	}
	
	if ([FCFileManager isReadableItemAtPath:self.imageUrl.absoluteString]) {
		self.image = [UIImage imageWithContentsOfFile:self.imageUrl.absoluteString];
	}
	
	return !!self.image;
}

@end

@implementation HyImageRemoteItem
@synthesize remoteUrl;

@end
