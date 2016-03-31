//
//  NSString+Hy.h
//
//  Created by HyanCat on 15/10/17.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyEXTBlock.h"

#define STRING_SEL(x) NSStringFromSelector(@selector(x))
#define STRING_CLASS(x) NSStringFromClass([x class])

@interface NSString (Hy)

- (NSString *)repeat;

- (NSUInteger)hexStringToNum;

+ (NSString *)bundleFileContent:(NSString *)fileName;
+ (NSString *)bundleFileContent:(NSString *)fileName failure:(HyEXTResultCallback)failure;

+ (NSString *)stringSizeSemanticly:(NSUInteger)size;

// 字符串驼峰转下划线
- (NSString *)toUnderScoreCaseString;
// 字符串下划线转驼峰
- (NSString *)toCamelCaseString;

@end

BOOL HyStringIsNil(NSString *string);
BOOL HyStringIsNotNil(NSString *string);
BOOL HyStringIsEmpty(NSString *string);
BOOL HyStringIsNotEmpty(NSString *string);
NSString *HySafeString(NSString *string);