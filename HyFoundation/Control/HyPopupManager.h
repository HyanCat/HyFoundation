//
//  HyPopupManager.h
//
//  Created by HyanCat on 15/11/17.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "NSObject+Hy.h"
/**
 * 弹出层界面管理器
 */
@interface HyPopupManager : NSObject <HyObjectSingleton>

- (void)addPopuplUI:(id)popupUI;

- (void)drop;

@end


/**
 * 弹出层协议 <br />
 * 交由 HyPopupManager 管理的弹出界面都需要实现 HyPopupProtocol 协议方法 <br />
 * 对于 UIAlertView 和 UIActionSheet 等原生控件可以派生出子类来实现
 */
@protocol HyPopupProtocol <NSObject>

- (void)hy_present;

- (void)hy_dismiss;

@end