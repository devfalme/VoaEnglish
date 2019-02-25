//
//  VE_NormalEnglishNavigation.m
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_NormalEnglishNavigation.h"
@interface VE_NormalEnglishNavigation ()
@property (weak, nonatomic) IBOutlet UIButton *returnButton;

@end
@implementation VE_NormalEnglishNavigation

+ (instancetype)back:(void(^)(void))back {
    VE_NormalEnglishNavigation *a = [VE_NormalEnglishNavigation loadFromNib];
    [[a.returnButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        back();
    }];
    return a;
}

@end
