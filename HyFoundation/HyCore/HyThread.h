//
//  HyThread.h
//
//  Created by HyanCat on 15/11/12.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyEXTBlock.h"
/**
 * 主线程执行 block，当前非主线程则异步回主线程执行
 */
void HyPerformOnMainThreadElseAsync(HyEXTVoidBlock block);

/**
 * 主线程同步执行 block
 */
void HyPerformOnMainThreadSync(HyEXTVoidBlock block);

