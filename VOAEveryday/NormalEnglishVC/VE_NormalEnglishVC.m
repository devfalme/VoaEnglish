//
//  VE_NormalEnglishVC.m
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_NormalEnglishVC.h"
#import "VE_SegmentView.h"
#import "VE_NormalEnglishNavigation.h"

@interface VE_NormalEnglishVC ()
@property (nonatomic, retain) VE_SegmentView *segmentView;
@property (nonatomic, retain) VE_NormalEnglishNavigation *navigationView;

@property (nonatomic, retain) UIViewController *oldVC;
@property (nonatomic, retain) UIViewController *newVC;

@property (nonatomic, retain) VE_DocumentModel *model;

@property (nonatomic, retain) UIViewController *currentVC;
@end

@implementation VE_NormalEnglishVC

ROUTER_PATH(@"NormalEnglishVC")

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView = [VE_NormalEnglishNavigation back:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.navigationView];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(topSafeAera);
    }];
    
    self.segmentView = [[VE_SegmentView alloc]initWithAction:^(NSInteger index) {
        if (index) {
            [self turnTo:self.oldVC];
        } else {
            [self turnTo:self.newVC];
        }
    }];
    self.segmentView.frame = CGRectMake(0, 30, 150, 30);
    self.segmentView.titleArray = @[NSLocalizedString(@"最新", nil),NSLocalizedString(@"以往", nil)];
    
    self.segmentView.selectedBackgroundColor = yellowColor;
    self.segmentView.selectedBgViewCornerRadius = 15;
    self.segmentView.labelFont = [UIFont systemFontOfSize:14];
    
    self.segmentView.backgroundColor = lightColor;
    self.segmentView.layer.cornerRadius = 15;
    self.segmentView.layer.masksToBounds = YES;
    [self.navigationView.contentView addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigationView.contentView);
        make.size.mas_equalTo(CGSizeMake(150.0, 30.0));
    }];
    
    [self turnTo:self.newVC];
}

- (BOOL)preferredNavigationBarHidden {
    return YES;
}

- (void)turnTo:(UIViewController *)vc {
    if (self.currentVC) {
        [self.currentVC.view removeFromSuperview];
    }
    
    self.currentVC = vc;
    [self.view addSubview:self.currentVC.view];
    [self.currentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (UIViewController *)oldVC {
    if (!_oldVC) {
        _oldVC = [Router search:ROUTER_API(@"OldNormalEnglishVC") parameters:@{@"model":self.model.list[1]}];
        [self addChildViewController:_oldVC];
    }return _oldVC;
}

- (UIViewController *)newVC {
    if (!_newVC) {
        _newVC = [Router search:ROUTER_API(@"NewNormalEngLishVC") parameters:@{@"model":self.model.list[0]}];
        [self addChildViewController:_newVC];
    }return _newVC;
}

@end
