//
//  NSDictionary+Hy.h
//
//  Created by HyanCat on 15/9/25.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL HyDictionaryIsEmpty(NSDictionary *dictionary);
BOOL HyDictionaryIsNotEmpty(NSDictionary *dictionary);

@interface NSDictionary (Hy)

- (BOOL)isKVOValueChanged;

- (instancetype)keepValueForKeys:(NSArray <NSString *> *)keys;

@end
