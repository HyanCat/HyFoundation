//
//  ViewController.m
//  HyFoundationDemo
//
//  Created by HyanCat on 16/4/2.
//  Copyright © 2016年 hyancat. All rights reserved.
//

#import "ViewController.h"
#import <HyUIActionEvent/HyUIActionCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6.f, 32.f, 32.f)];
	avatarView.image        = [[UIImage imageNamed:@"menu_icon_article"] imageWithSize:CGSizeMake(32, 32) cornerRadius:16.f];
	avatarView.eventName    = @"leftNavigationBarItem";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:avatarView];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonTouched:)];
	
//	[self setNeedsNavigationBarAppearanceUpdate];
}

- (void)searchButtonTouched:(id)sender
{
	NSLog(@"search button touched.");
}

- (HyUIActionEventResult *)handleLeftNavigationBarItemWithActionEvent:(HyUIActionEvent *)event
{
	NSLog(@"left NavigationBar item touched.");

	return [HyUIActionEventResult resultWithContinueDispatching:NO];
}


@end
