//
//  NSString+Hy.m
//
//  Created by HyanCat on 15/10/17.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "NSString+Hy.h"

@implementation NSString (Hy)

- (NSString *)repeat
{
	NSMutableString * copy = [self mutableCopy];
	[copy appendString:self];
	
	return [copy copy];
}

- (NSUInteger)hexStringToNum
{
	unsigned int num = 0;
	[[NSScanner scannerWithString:self] scanHexInt:&num];
	
	return (NSUInteger)num;
}

+ (NSString *)bundleFileContent:(NSString *)fileName
{
	return [self bundleFileContent:fileName failure:nil];
}

+ (NSString *)bundleFileContent:(NSString *)fileName failure:(HyEXTResultCallback)failure
{
	NSError *error = nil;
	NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@""] encoding:NSUTF8StringEncoding error:&error];
	if (error && failure) {
		failure(error);
	}
	return content;
}

+ (NSString *)stringSizeSemanticly:(NSUInteger)size
{
	NSString *unit = @"B";
	float floatSize = (float)size;
	if (floatSize > 1024) {
		unit = @"KB";
		floatSize /= 1024;
		if (floatSize > 1024) {
			unit = @"MB";
			floatSize /= 1024;
			if (floatSize > 1024) {
				unit = @"GB";
				floatSize /= 1024;
			}
		}
	}
	else {
		floatSize = 0;
	}
	return [NSString stringWithFormat:@"%1.1f %@", floatSize, unit];
}

- (NSString *)toUnderScoreCaseString
{
	if (self.length == 0) return self;

	NSMutableString *underScoreCaseString = [NSMutableString string];

	for (NSUInteger i = 0; i < self.length; i++) {
		
		NSString *scanString = [self substringWithRange:NSMakeRange(i, 1)];
		NSString *scanStringLower = [scanString lowercaseString];
		
		if ([scanString isEqualToString:scanStringLower]) {
			[underScoreCaseString appendString:scanString];
		}
		else {
			[underScoreCaseString appendString:@"_"];
			[underScoreCaseString appendString:scanStringLower];
		}
	}
	return underScoreCaseString;
}

- (NSString *)toCamelCaseString
{
	if (self.length == 0) return self;
	
	NSArray <NSString *> *components = [self componentsSeparatedByString:@"_"];

	__block NSMutableString *camelCaseString = @"".mutableCopy;
	[components enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (idx > 0 && obj.length > 0) {
			[camelCaseString appendString:[obj capitalizedString]];
		}
		else {
			[camelCaseString appendString:obj];
		}
	}];
	return camelCaseString.copy;
}

@end

BOOL HyStringIsNil(NSString *string)
{
	return nil == string || [string isEqual:[NSNull null]] || ![string isKindOfClass:[NSString class]];
}

BOOL HyStringIsNotNil(NSString *string)
{
	return ! HyStringIsNil(string);
}

BOOL HyStringIsEmpty(NSString *string)
{
	return HyStringIsNil(string) || string.length == 0;
}

BOOL HyStringIsNotEmpty(NSString *string)
{
	return !HyStringIsEmpty(string);
}

NSString *HySafeString(NSString *string)
{
	return HyStringIsNil(string) ? @"" : string;
}
