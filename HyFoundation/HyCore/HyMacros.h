//
//  HyMacros.h
//
//  Created by HyanCat on 15/9/24.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#ifndef HyMacros_h
#define HyMacros_h


// 判断系统版本号
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#define HY_DEVICE_NAME									[[UIDevice currentDevice] model]
#define HY_SYSTEM_NAME									[[UIDevice currentDevice] systemName]
#define HY_SYSTEM_VERSION								[[UIDevice currentDevice] systemVersion]
#define HY_SYSTEM_VERSION_EQUAL_TO(v)					([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define HY_SYSTEM_VERSION_GREATER_THAN(v)				([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define HY_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)	([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define HY_SYSTEM_VERSION_LESS_THAN(v)					([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define HY_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)		([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// Shortly Usage.
#define IOS6_OR_LATER HY_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6")
#define IOS7_OR_LATER HY_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")
#define IOS8_OR_LATER HY_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")
#define IOS9_OR_LATER HY_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")
#define IOS6_OR_BEFORE HY_SYSTEM_VERSION_LESS_THAN(@"7")
#define IOS7_OR_BEFORE HY_SYSTEM_VERSION_LESS_THAN(@"8")
#define IOS8_OR_BEFORE HY_SYSTEM_VERSION_LESS_THAN(@"9")
#define IOS9_OR_BEFORE HY_SYSTEM_VERSION_LESS_THAN(@"10")

#define IOS6 (IOS6_OR_LATER && IOS6_OR_BEFORE)
#define IOS7 (IOS7_OR_LATER && IOS7_OR_BEFORE)
#define IOS8 (IOS8_OR_LATER && IOS8_OR_BEFORE)
#define IOS9 (IOS9_OR_LATER && IOS9_OR_BEFORE)

#define IPhone5Width	(HyScreenScale == 320.f)
#define IPhone6Width	(HyScreenScale == 375.f)
#define IPhone6PWidth	(HyScreenScale == 621.f)

#else
//
#endif // #if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR


// 应用程序版本号
#define HyShortAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define HyBuildAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
// 判断版本号是否有效
#define HyShortAppVersionIsReleaseVersion ([[HyShortAppVersion componentsSeparatedByString:@"."] count] == 3 ? YES : NO)


// Layout
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#define HyOnePixel		(1.f/HyScreenScale)
#define HyScreenScale	[[UIScreen mainScreen] scale]
#define HyScreenWidth	[UIScreen mainScreen].bounds.size.width
#define HyScreenHeight	[UIScreen mainScreen].bounds.size.height

#define HyStatusBarHeight		22.f
#define HyNavigationBarHeight	44.f
#define HyTabBarHeight			50.f
#define HyToolBarHeight			44.f

#else
//
#endif // #if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR


#define weakify(var) __weak typeof(var) AHKWeak_##var = var;

#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = AHKWeak_##var; \
_Pragma("clang diagnostic pop")

#define SELF [self class]

#endif /* HyMacros_h */
