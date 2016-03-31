//
//  NSDate+Hy.h
//
//  Created by HyanCat on 15/10/6.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Hy)

+ (NSDate *)dateFromSqlTimestamp:(NSString *)timestamp;

- (NSString *)semanticDate;

@end
