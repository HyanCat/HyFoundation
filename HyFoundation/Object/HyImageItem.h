//
//  HyImageItem.h
//
//  Created by HyanCat on 15/10/29.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;

/**
 * 图片元素
 */
@protocol HyImageItem <NSObject>

@property (nonatomic, strong) UIImage *image;		// 原始图
@property (nonatomic, strong) UIImage *thumbnail;	// 缩略图
@property (nonatomic, copy) NSURL *imageUrl;		// 图片的本地 url

@end

/**
 * 相册图片元素
 */
@protocol HyImageAssetItem <HyImageItem>

@property (nonatomic, strong) ALAsset *asset;	// 相册中的 asset

- (instancetype)initWithAsset:(ALAsset *)asset;

- (BOOL)loadImage;	// 加载原始图

@end

/**
 * 远程图片元素
 */
@protocol HyImageRemoteItem <HyImageItem>

@property (nonatomic, copy) NSURL *remoteUrl;	// 远程图片 url

@end


//************************ Interface ************************//


@interface HyImageItem : NSObject <HyImageItem>

@end

@interface HyImageAssetItem : HyImageItem <HyImageAssetItem>

@end

@interface HyImageRemoteItem : HyImageItem <HyImageRemoteItem>

@end