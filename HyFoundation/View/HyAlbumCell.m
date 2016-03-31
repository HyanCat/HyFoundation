//
//  HyAlbumCell.m
//
//  Created by HyanCat on 15/10/23.
//  Copyright © 2015年 HyanCat. All rights reserved.
//

#import "HyAlbumCell.h"
#import "UIView+Hy.h"

@implementation HyAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
	if (self) {
		self.separatorInset = UIEdgeInsetsZero;
		if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
			self.layoutMargins = UIEdgeInsetsZero;
		}
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.imageView.x = 0;
	self.textLabel.x = self.imageView.width + 10;
}


@end
