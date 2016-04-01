//
//  HyEXTListResult+Accessory.h
//
//  Created by HyanCat on 15/11/20.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import "HyEXTBlock.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyEXTListResult (Accessory)

- (void)presentToContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END