//
//  VE_BaseTableViewController.m
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_BaseTableViewController.h"

@interface VE_BaseTableViewController ()

@end

@implementation VE_BaseTableViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = lightColor;
    self.tableView.backgroundColor = lightColor;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.supportedOrientationMask = UIInterfaceOrientationMaskPortrait;
    
}


- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (nullable UIColor *)titleViewTintColor {
    return lightColor;
}

- (nullable UIColor *)navigationBarBarTintColor {
    return pinkColor;
}

- (nullable UIColor *)navigationBarTintColor {
    return lightColor;
}

@end
