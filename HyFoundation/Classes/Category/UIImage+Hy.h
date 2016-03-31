//
//  UIImage+Hy.h
//
//  Created by HyanCat on 15/9/28.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <UIKit/UIKit.h>

UIImage *HyUIImage(NSString *imageName);

UIImage *HyCGImage(CGImageRef image);

@interface UIImage (Hy)

+ (UIImage *)imageWithSize:(CGSize)size
		   backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)imageWithSize:(CGSize)size
			  cornerRadius:(CGFloat)cornerRadius
		   backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)imageWithSize:(CGSize)size
			   borderWidth:(CGFloat)borderWidth
			   borderColor:(UIColor *)borderColor
		   backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)imageWithSize:(CGSize)size
			  cornerRadius:(CGFloat)cornerRadius
			   borderWidth:(CGFloat)borderWidth
			   borderColor:(UIColor *)borderColor
		   backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)imageWithSize:(CGSize)size
			  cornerRadius:(CGFloat)cornerRadius
			   borderWidth:(CGFloat)borderWidth
			   borderColor:(UIColor *)borderColor
		  backgroundColors:(NSArray *)backgroundColors;

/*
 * 等比例缩放图片，尺寸调整为 size*size 范围（最长边 ≤ size）
 */
- (UIImage *)zoomToFitSize:(CGFloat)size;

/*
 * 等比缩小后,裁剪到指定大小
 */
- (UIImage *)scaleAndClipToFillSize:(CGSize)destSize;

/*
 * 等比例缩小
 */
- (UIImage *)shrinkToSize:(CGFloat)size;
/*
 * 等比例放大
 */
- (UIImage *)magnifyToSize:(CGFloat)size;

/**
 * 压缩图片 size 并限制大小
 */
- (UIImage *)compressToFitSize:(CGFloat)size limitFileSize:(NSUInteger)fileSize;

- (UIImage *)imageWithSize:(CGSize)size;
- (UIImage *)imageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
- (UIImage *)imageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth;
- (UIImage *)imageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 * 灰度图
 */
- (UIImage *) grayImage;
- (UIImage *) whiteMaskImage;

@end


@interface UIImage (HyConvert)

- (NSData *)data;

@end
