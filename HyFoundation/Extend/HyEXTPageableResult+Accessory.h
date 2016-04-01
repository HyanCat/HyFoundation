//
//  HyEXTPageableResult+Accessory.h
//
//  Created by HyanCat on 15/11/15.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import "HyEXTBlock.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyEXTPageableResult (Accessory)

- (void)presentToContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END