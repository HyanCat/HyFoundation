//
//  HyAssetsViewBar.m
//
//  Created by HyanCat on 15/10/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyAssetsViewBar.h"
#import <HyFoundation/HyFoundation.h>

@interface HyAssetsViewBar ()

@property (strong, nonatomic) IBOutlet UIButton *previewButton;

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation HyAssetsViewBar

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.translucent = YES;
	[self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.confirmButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
	self.confirmButton.layer.cornerRadius = 4.f;
	self.confirmButton.backgroundColor = HyColor(@"#F04848");
	
	_count = 0;
	self.confirmButton.enabled = NO;
	[self _updateWith];
}

- (IBAction)previewButtonTouched:(id)sender
{
	if (self.assetsDelegate && [self.assetsDelegate respondsToSelector:@selector(assetsBarPreviewButtonDidTouched:)]) {
		[self.assetsDelegate assetsBarPreviewButtonDidTouched:self];
	}
}

- (IBAction)confirmButtonTouched:(id)sender
{
	if (self.assetsDelegate && [self.assetsDelegate respondsToSelector:@selector(assetsBarConfirmButtonDidTouched:)]) {
		[self.assetsDelegate assetsBarConfirmButtonDidTouched:self];
	}
}

- (void)setCount:(NSUInteger)count
{
	if (_count == count) {
		return;
	}
	_count = count;
	if (_count == 0) {
		self.confirmButton.enabled = NO;
		self.previewButton.enabled = NO;
		[self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
	}
	else {
		self.confirmButton.enabled = YES;
		self.previewButton.enabled = YES;
		[self.confirmButton setTitle:[NSString stringWithFormat:@"确定(%ld)", (unsigned long)_count] forState:UIControlStateNormal];
	}
	[self _updateWith];
}

- (void)_updateWith
{
	[UIView animateWithDuration:0.3f animations:^{
		self.confirmButton.width = self.confirmButton.intrinsicContentSize.width + self.confirmButton.titleEdgeInsets.left + self.confirmButton.titleEdgeInsets.right;
	}];
}

@end
