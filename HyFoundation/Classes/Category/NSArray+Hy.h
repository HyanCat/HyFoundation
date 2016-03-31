//
//  NSArray+Hy.h
//
//  Created by HyanCat on 15/9/28.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

BOOL HyArrayIsEmpty(NSArray * _Nullable array);
BOOL HyArrayIsNotEmpty(NSArray * _Nullable array);

@interface NSArray (Hy)

- (nullable id)objectAtPosition:(NSUInteger)position;

- (nullable id)objectAtCirclePosition:(NSInteger)position;

- (nullable id)secondObject;
- (nullable id)thirdObject;
- (nullable id)lastButSecondObject;
- (nullable id)lastButThirdObject;

@end

@interface NSMutableArray (Hy)

- (void)replaceAllObjectsTo:(NSArray *)objects;

@end

NS_ASSUME_NONNULL_END