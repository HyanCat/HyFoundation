//
//  HyAssetCell.m
//
//  Created by HyanCat on 15/10/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyAssetCell.h"
#import "UIImage+Hy.h"

@interface HyAssetCell ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIImageView *checkImageView;

@end

@implementation HyAssetCell
@synthesize checked = _checked;

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.backgroundColor = [UIColor redColor];
	self.shouldShowCheck = YES;
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	self.checked = NO;
}

- (void)setImage:(UIImage *)image
{
	_image = image;
	self.imageView.image = _image;
}

- (void)setChecked:(BOOL)checked
{
	if (_checked == checked) {
		return;
	}
	_checked = checked;
	
	if (_checked) {
		CGAffineTransform scaleTransorm = CGAffineTransformMakeScale(0.8, 0.8);
		self.checkImageView.transform = scaleTransorm;
		
		CGAffineTransform reverseTransorm = CGAffineTransformMakeScale(1, 1);
		[UIView animateWithDuration:0.5f
							  delay:0
			 usingSpringWithDamping:0.2f
			  initialSpringVelocity:10
							options:0
						 animations:^{
							 self.checkImageView.transform = reverseTransorm;
						 }
						 completion:^(BOOL finished) {
							 
						 }];
	}
	self.checkImageView.image = _checked ? HyUIImage(@"icon_select_checked") : HyUIImage(@"icon_select_unchecked");
}

- (BOOL)isChecked
{
	return _checked;
}

- (void)setShouldShowCheck:(BOOL)shouldShowCheck
{
	_shouldShowCheck = shouldShowCheck;
	self.checkImageView.hidden = ! self.shouldShowCheck;
}

@end
