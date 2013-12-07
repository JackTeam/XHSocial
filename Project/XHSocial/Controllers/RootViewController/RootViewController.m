//
//  RootViewController.m
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-6.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "RootViewController.h"
#import "MenuNavigationController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
#endif
    // Here self.navigationController is an instance of NavigationViewController (which is a root controller for the main window)
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    MenuNavigationController *navigationController = (MenuNavigationController *)self.navigationController;
    [navigationController.menu setNeedsLayout];
}

@end
