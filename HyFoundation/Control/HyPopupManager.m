//
//  HyPopupManager.m
//
//  Created by HyanCat on 15/11/17.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyPopupManager.h"

@interface HyPopupManager ()

@property (nonatomic, strong) NSMutableArray <id <HyPopupProtocol>> *popups;

@end

@implementation HyPopupManager

- (instancetype)init
{
	self = [super init];
	if (self) {
		_popups = [NSMutableArray array];
	}
	return self;
}

- (void)addPopuplUI:(id)popupUI
{
	if ([self.popups containsObject:popupUI]) {
		return;
	}
	[self.popups addObject:popupUI];
}

- (void)drop
{
	id <HyPopupProtocol> popup = [self.popups lastObject];
	if ([popup respondsToSelector:@selector(hy_dismiss)]) {
		[popup hy_dismiss];
		[self.popups removeLastObject];
	}
}

- (void)clear
{
	[self.popups enumerateObjectsUsingBlock:^(id<HyPopupProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj respondsToSelector:@selector(hy_dismiss)]) {
			[obj hy_dismiss];
		}
	}];
	
	[self.popups removeAllObjects];
}

@end
