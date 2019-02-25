//
//  VE_BaseViewController.m
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_BaseViewController.h"

@interface VE_BaseViewController ()

@end

@implementation VE_BaseViewController

- (void)viewWillDisappear:(BOOL)animated {
    //    [[IQKeyboardManager sharedManager] resignFirstResponder];
    //    self.hideHud();
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.supportedOrientationMask = UIInterfaceOrientationMaskPortrait;
    self.view.backgroundColor = lightColor;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
