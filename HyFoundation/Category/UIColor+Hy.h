//
//  UIColor+Hy.h
//
//  Created by HyanCat on 15/9/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hy)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)randomColor;

@end

UIColor *HyColor(NSString *hexColor);

// random color
UIColor *HyRandomColor(void);

// random alpha
UIColor *HyRandomColorWithAlpha(CGFloat alpha);

// clear color
UIColor *HyClearColor(void);

// r g b
UIColor *HyColorWithRGB(NSUInteger red, NSUInteger green, NSUInteger blue);

// r g b a
UIColor *HyColorWithRGBA(NSUInteger red, NSUInteger green, NSUInteger blue, CGFloat alpha);

// Hex color:
// RGB
// RGBA
// RRGGBB
// RRGGBBAA
UIColor *HyColorWithHexString(NSString *hexString);
