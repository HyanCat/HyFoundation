//
//  UIColor+Hy.m
//
//  Created by HyanCat on 15/9/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "UIColor+Hy.h"
#import "NSString+Hy.h"

@implementation UIColor (Hy)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
	return HyColorWithHexString(hexString);
}

+ (UIColor *)randomColor {
	return HyRandomColor();
}

@end

UIColor *HyColor(NSString *hexColor)
{
	return HyColorWithHexString(hexColor);
}

UIColor *HyRandomColor(void)
{
#if TARGET_IPHONE_SIMULATOR
	return HyColorWithRGB(arc4random() % 255, arc4random() % 255, arc4random() % 255);
#elif TARGET_OS_IPHONE
	return HyClearColor();
#endif
}

UIColor *HyRandomColorWithAlpha(CGFloat alpha)
{
	return HyColorWithRGBA(arc4random() % 255, arc4random() % 255, arc4random() % 255, alpha);
}

UIColor *HyClearColor(void)
{
	return [UIColor clearColor];
}

// r g b
UIColor *HyColorWithRGB(NSUInteger red, NSUInteger green, NSUInteger blue)
{
	return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1.f];
}

// r g b a
UIColor *HyColorWithRGBA(NSUInteger red, NSUInteger green, NSUInteger blue, CGFloat alpha)
{
	return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

void hexStringColorToRGBA(NSString *hexString, NSUInteger *red, NSUInteger *green, NSUInteger *blue, NSUInteger *alpha);

UIColor *HyColorWithHexString(NSString *hexString)
{
	NSUInteger red = 0, green = 0, blue = 0, alpha = 0;
	hexStringColorToRGBA(hexString, &red, &green, &blue, &alpha);
	
	return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha/255.f];
}

void hexStringColorToRGBA(NSString *hexString, NSUInteger *red, NSUInteger *green, NSUInteger *blue, NSUInteger *alpha)
{
	NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
	switch ([colorString length]) {
		case 3: // RGB
			*red   = [[[colorString substringWithRange:NSMakeRange(0, 1)] repeat] hexStringToNum];
			*green = [[[colorString substringWithRange:NSMakeRange(1, 1)] repeat] hexStringToNum];
			*blue  = [[[colorString substringWithRange:NSMakeRange(2, 1)] repeat] hexStringToNum];
			*alpha = 255;
			break;
		case 4: // RGBA
			*red   = [[[colorString substringWithRange:NSMakeRange(0, 1)] repeat] hexStringToNum];
			*green = [[[colorString substringWithRange:NSMakeRange(1, 1)] repeat] hexStringToNum];
			*blue  = [[[colorString substringWithRange:NSMakeRange(2, 1)] repeat] hexStringToNum];
			*alpha = [[[colorString substringWithRange:NSMakeRange(3, 1)] repeat] hexStringToNum];
			break;
		case 6: // RRGGBB
			*red   = [[colorString substringWithRange:NSMakeRange(0, 2)] hexStringToNum];
			*green = [[colorString substringWithRange:NSMakeRange(2, 2)] hexStringToNum];
			*blue  = [[colorString substringWithRange:NSMakeRange(4, 2)] hexStringToNum];
			*alpha = 255;
			break;
		case 8: // RRGGBBAA
			*red   = [[colorString substringWithRange:NSMakeRange(0, 2)] hexStringToNum];
			*green = [[colorString substringWithRange:NSMakeRange(2, 2)] hexStringToNum];
			*blue  = [[colorString substringWithRange:NSMakeRange(4, 2)] hexStringToNum];
			*alpha = [[colorString substringWithRange:NSMakeRange(6, 2)] hexStringToNum];
			break;
		default:
			break;
	}
}