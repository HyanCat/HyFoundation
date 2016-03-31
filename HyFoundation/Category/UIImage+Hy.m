//
//  UIImage+Hy.m
//
//  Created by HyanCat on 15/9/28.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "UIImage+Hy.h"
#import "NSString+Hy.h"
#import "NSArray+Hy.h"

UIImage *HyUIImage(NSString *imageName)
{
	if (HyStringIsEmpty(imageName)) {
		return nil;
	}
	return [UIImage imageNamed:imageName];
}

UIImage *HyCGImage(CGImageRef image)
{
	if (image == nil) {
		return nil;
	}
	return [UIImage imageWithCGImage:image];
}

@implementation UIImage (Hy)

+ (UIImage *)imageWithSize:(CGSize)size
		   backgroundColor:(UIColor *)backgroundColor {
	return [UIImage imageWithSize:size
					 cornerRadius:0
					  borderWidth:0
					  borderColor:nil
				  backgroundColor:backgroundColor];
}

+ (UIImage *)imageWithSize:(CGSize)size
			  cornerRadius:(CGFloat)cornerRadius
		   backgroundColor:(UIColor *)backgroundColor {
	return [UIImage imageWithSize:size
					 cornerRadius:cornerRadius
					  borderWidth:0
					  borderColor:nil
				  backgroundColor:backgroundColor];
}

+ (UIImage *)imageWithSize:(CGSize)size
			   borderWidth:(CGFloat)borderWidth
			   borderColor:(UIColor *)borderColor
		   backgroundColor:(UIColor *)backgroundColor {
	return [UIImage imageWithSize:size
					 cornerRadius:0
					  borderWidth:borderWidth
					  borderColor:borderColor
				  backgroundColor:backgroundColor];
}

+ (UIImage *)imageWithSize:(CGSize)size
			  cornerRadius:(CGFloat)cornerRadius
			   borderWidth:(CGFloat)borderWidth
			   borderColor:(UIColor *)borderColor
		   backgroundColor:(UIColor *)backgroundColor {
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	
	// background
	{
		backgroundColor = backgroundColor?:[UIColor whiteColor];
		UIBezierPath *bgPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth, borderWidth, size.width-2*borderWidth, size.height-2*borderWidth) cornerRadius:cornerRadius-borderWidth];
		[backgroundColor setFill];
		[bgPath fill];
	}
	// border
	if (borderWidth > 0.f && borderColor && [borderColor isKindOfClass:[UIColor class]]) {
		UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
		borderPath.lineWidth = borderWidth * 2;
		[borderColor setStroke];
		[borderPath stroke];
	}
	
	UIImage *drewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return drewImage;
}

+ (UIImage *)imageWithSize:(CGSize)aSize
			  cornerRadius:(CGFloat)aCornerRadius
			   borderWidth:(CGFloat)aBorderWidth
			   borderColor:(UIColor *)borderColor
		  backgroundColors:(NSArray *)backgroundColors {
	CGFloat m = 2;
	CGSize size = CGSizeMake(aSize.width*m, aSize.height*m);
	CGFloat cornerRadius = aCornerRadius*m;
	CGFloat borderWidth = aBorderWidth*m;
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	
	// border
	if ((borderWidth > 0.0f) && borderColor && [borderColor isKindOfClass:[UIColor class]]) {
		CGFloat halfBorderWidth = borderWidth/2;
		UIBezierPath * borderBezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(halfBorderWidth, halfBorderWidth, size.width-borderWidth, size.height-borderWidth) cornerRadius:cornerRadius-halfBorderWidth];
		[borderColor setStroke];
		[borderBezierPath stroke];
	}
	
	// background
	if (! HyArrayIsEmpty(backgroundColors)) {
		// background bezier path
		CGFloat doubleBorderWidth = borderWidth * 2;
		CGRect backgroundRect = CGRectMake(borderWidth,
										   borderWidth,
										   size.width - doubleBorderWidth,
										   size.height - doubleBorderWidth);
		UIBezierPath * backgroundBezierPath = [UIBezierPath bezierPathWithRoundedRect:backgroundRect
																		 cornerRadius:cornerRadius];
		
		if (backgroundColors.count==1) {
			// pure color
			UIColor * backgroundColor = [backgroundColors firstObject];
			[backgroundColor setFill];
			[backgroundBezierPath fill];
		}
		else {
			// gradient color
			[backgroundBezierPath addClip];
			
			UIColor * myStartColor = [backgroundColors firstObject];
			UIColor * myEndColor = [backgroundColors lastObject];
			
			CGGradientRef myGradient;
			CGColorSpaceRef myColorspace;
			size_t num_locations = 2;
			CGFloat locations[2] = { 0.0, 1.0 };
			
			const CGFloat * startColorComponents = CGColorGetComponents(myStartColor.CGColor);
			size_t num_s = CGColorGetNumberOfComponents(myStartColor.CGColor);
			CGFloat s_red = startColorComponents[0];
			CGFloat s_green = num_s==2?s_red:startColorComponents[1];
			CGFloat s_blue = num_s==2?s_red:startColorComponents[2];
			CGFloat s_alpha = num_s==2?startColorComponents[1]:startColorComponents[3];
			
			const CGFloat * endColorComponents = CGColorGetComponents(myEndColor.CGColor);
			size_t num_e = CGColorGetNumberOfComponents(myEndColor.CGColor);
			CGFloat e_red = endColorComponents[0];
			CGFloat e_green = num_e==2?e_red:endColorComponents[1];
			CGFloat e_blue = num_e==2?e_red:endColorComponents[2];
			CGFloat e_alpha = num_e==2?endColorComponents[1]:endColorComponents[3];
			
			CGFloat components[8] = {
				s_red, s_green, s_blue, s_alpha,  // Start color
				e_red, e_green, e_blue, e_alpha // End color
			};
			
			myColorspace = CGColorSpaceCreateDeviceRGB();
			myGradient = CGGradientCreateWithColorComponents (myColorspace,
															  components,
															  locations,
															  num_locations);
			
			CGContextRef myContext = UIGraphicsGetCurrentContext();
			CGPoint myStartPoint, myEndPoint;
			myStartPoint.x = 0.0;
			myStartPoint.y = 0.0;
			myEndPoint.x = 0.0;
			myEndPoint.y = size.height;
			CGContextDrawLinearGradient (myContext, myGradient, myStartPoint, myEndPoint, 0);
			CFRelease(myColorspace);
			CFRelease(myGradient);
		}
	}
	
	UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return [result imageWithSize:aSize];
}

- (UIImage *)zoomToFitSize:(CGFloat)size
{
	CGFloat originWidth = self.size.width;
	CGFloat originHeight = self.size.height;
	
	CGFloat targetWidth = size;
	CGFloat targetHeight = size;
	
	if (originWidth > originHeight) {
		targetHeight = originHeight * targetWidth/originWidth;
	}
	else {
		targetWidth = originWidth * targetHeight/originHeight;
	}
	
	int width = targetWidth;
	int height = targetHeight;
	
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
	[self drawInRect:CGRectMake(0, 0, width, height)];
	UIImage * resultUIImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resultUIImage;
}

- (UIImage *)scaleAndClipToFillSize:(CGSize)destSize
{
	CGFloat originWidth = self.size.width;
	CGFloat originHeight = self.size.height;
	
	CGFloat widthScale = destSize.width/originWidth;
	CGFloat heightScale = destSize.height/originHeight;
	CGFloat scale = fmaxf(widthScale, heightScale);
	
	UIGraphicsBeginImageContextWithOptions(destSize, NO, 0);
	[self drawInRect:CGRectMake(ceilf(destSize.width - originWidth*scale)/2,
								ceilf(destSize.height - originHeight*scale)/2,
								ceilf(originWidth*scale),
								ceilf(originHeight*scale))];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (UIImage *)shrinkToSize:(CGFloat)size
{
	if (self.size.width > size || self.size.height > size) {
		return [self zoomToFitSize:size];
	}
	else {
		return self;
	}
}

- (UIImage *)magnifyToSize:(CGFloat)size
{
	if (self.size.width > size || self.size.height > size) {
		return self;
	}
	else {
		return [self zoomToFitSize:size];
	}
}

- (UIImage *)compressToFitSize:(CGFloat)size limitFileSize:(NSUInteger)fileSize
{
	UIImage *image = [self shrinkToSize:size];
	CGFloat compression = 1.f, minCompression = 0.5f;
	NSData *imageData = nil;
	do {
		imageData = UIImageJPEGRepresentation(image, compression);
		compression -= 0.1f;
	} while (imageData.length > fileSize && compression >= minCompression);
	
	return [UIImage imageWithData:imageData];
}

- (UIImage *)imageWithSize:(CGSize)size
{
	return [self imageWithSize:size cornerRadius:0];
}

- (UIImage *)imageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
	if (size.width == 0 || size.height == 0) {
		return nil;
	}
	
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	
	[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius] addClip];
	
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

// 这里size 是图片的size 不含border
- (UIImage *) imageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth
{
	return [self imageWithSize:size cornerRadius:cornerRadius borderWidth:borderWidth borderColor:[UIColor whiteColor]];
}

- (UIImage *) imageWithSize:(CGSize)size
			   cornerRadius:(CGFloat)cornerRadius
				borderWidth:(CGFloat)borderWidth
				borderColor:(UIColor *)borderColor
{
	if (fabs(borderWidth) < 0.01) {
		return [self imageWithSize:size cornerRadius:cornerRadius];
	}
	else {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width+borderWidth*2, size.height+borderWidth*2), NO, 0);
		CGContextSaveGState(UIGraphicsGetCurrentContext());
		// clip and image
		UIBezierPath * clipPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth,
																					 borderWidth,
																					 size.width,
																					 size.height)
															 cornerRadius:cornerRadius+borderWidth];
		[clipPath addClip];
		[self drawInRect:CGRectMake(borderWidth, borderWidth, size.width, size.height)];
		CGContextRestoreGState(UIGraphicsGetCurrentContext());
		
		// draw border.
		CGFloat halfBorderWidth = borderWidth/2;
		UIBezierPath * borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(halfBorderWidth,
																							 halfBorderWidth,
																							 size.width + borderWidth,
																							 size.height + borderWidth)
																	 cornerRadius:cornerRadius + halfBorderWidth];
		borderPath.lineWidth = borderWidth;
		[borderColor setStroke];
		[borderPath stroke];
		
		UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return image;
	}
}

/**
 * 灰度图
 */
typedef NS_ENUM(NSUInteger, PIXELS)
{
	ALPHA = 0,
	BLUE = 1,
	GREEN = 2,
	RED = 3
};

- (UIImage *)grayImage
{
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	CGSize size = [self size];
	int width = size.width * scale;
	int height = size.height * scale;
	
	// the pixels will be painted to this array
	uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
	
	// clear the pixels so any transparency is preserved
	memset(pixels, 0, width * height * sizeof(uint32_t));
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create a context with RGBA pixels
	CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
	// paint the bitmap to our context which will fill in the pixels array
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
	for(int y = 0; y < height; y++) {
		for(int x = 0; x < width; x++) {
			uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
			
			// convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
			uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
			
			// set the pixels to gray
			rgbaPixel[RED] = gray;
			rgbaPixel[GREEN] = gray;
			rgbaPixel[BLUE] = gray;
		}
	}
	
	// create a new CGImageRef from our context with the modified pixels
	CGImageRef image = CGBitmapContextCreateImage(context);
	
	// we're done with the context, color space, and pixels
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	free(pixels);
	
	// make a new UIImage to return
	UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:scale orientation:UIImageOrientationUp];
	
	// we're done with image now too
	CGImageRelease(image);
	
	return resultUIImage;
}

- (UIImage *)whiteMaskImage
{
	CGSize size = [self size];
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	[self drawAtPoint:CGPointZero];
	UIImage * mask = [UIImage imageWithSize:size cornerRadius:size.width/2.0f backgroundColor:[UIColor colorWithWhite:1 alpha:0.4f]];
	[mask drawAtPoint:CGPointZero];
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

@end

@implementation UIImage (HyConvert)

- (NSData *)data
{
	return UIImageJPEGRepresentation(self, 1);
}

@end