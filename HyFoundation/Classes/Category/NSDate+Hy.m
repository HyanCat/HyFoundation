//
//  NSDate+Hy.m
//
//  Created by HyanCat on 15/10/6.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "NSDate+Hy.h"
#import "NSString+Hy.h"
#import <DateTools/DateTools.h>

@implementation NSDate (Hy)

+ (NSDate *)dateFromSqlTimestamp:(NSString *)timestamp
{
	if (HyStringIsNil(timestamp)) {
		return nil;
	}
	return [NSDate dateWithString:timestamp formatString:@"YYYY-MM-dd HH:mm:ss"];
}

- (NSString *)semanticDate
{
	NSDate *now = [NSDate date];
	if ([self compare:now] == NSOrderedDescending) {
		return @"未来";
	}
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *difference = [calendar components:NSCalendarUnitMinute | NSCalendarUnitSecond
											   fromDate:self
												 toDate:now
												options:0];
	NSDateComponents *componentsOfSelf = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
	NSDateComponents *componentsOfNow = [calendar components:NSCalendarUnitYear | NSCalendarUnitDay fromDate:now];
	
	if (difference.minute == 0 && difference.second < 60) {
		return [NSString stringWithFormat:@"%ld 秒前", (long)difference.second];
	}
	else if (difference.minute < 60) {
		return [NSString stringWithFormat:@"%ld 分钟前", (long)difference.minute];
	}
	else if (componentsOfSelf.year == componentsOfNow.year && componentsOfSelf.day == componentsOfNow.day) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"HH:mm";
		return [dateFormatter stringFromDate:self];
	}
	else if (componentsOfSelf.year == componentsOfNow.year) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"MM-dd";
		return [dateFormatter stringFromDate:self];
	}
	else {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd";
		return [dateFormatter stringFromDate:self];
	}
	
	return @"123";
}

@end
