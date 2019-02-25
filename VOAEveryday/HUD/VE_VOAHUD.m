//
//  VE_VOAHUD.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_VOAHUD.h"

@implementation VE_VOAHUD
+ (void)showLoading:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMUITips hideAllTips];
        QMUITips *tips = [QMUITips showLoading:msg inView:DefaultTipsParentView];
        QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
        backgroundView.shouldBlurBackgroundView = YES;
        backgroundView.styleColor = [UIColor colorWithWhite:.8 alpha:.8];
        tips.tintColor = darkColor;
        
    });
}
+ (void)showText:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMUITips hideAllTips];
        QMUITips *tips = [QMUITips showInfo:msg];
        QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
        backgroundView.shouldBlurBackgroundView = YES;
        backgroundView.styleColor = [UIColor colorWithWhite:.8 alpha:.8];
        tips.tintColor = darkColor;
    });
}
+ (void)hideHud {
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMUITips hideAllTips];
    });
}
+ (void)hideHudWhen:(NSInteger)time {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [QMUITips hideAllTips];
    });
}

+ (void)showError:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMUITips hideAllTips];
        QMUITips *tips = [QMUITips showError:msg];
        QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
        backgroundView.shouldBlurBackgroundView = YES;
        backgroundView.styleColor = [UIColor colorWithWhite:.8 alpha:.8];
        tips.tintColor = darkColor;
    });
}
+ (void)showSuccess:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMUITips hideAllTips];
        QMUITips *tips = [QMUITips showSucceed:msg];
        QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
        backgroundView.shouldBlurBackgroundView = YES;
        backgroundView.styleColor = [UIColor colorWithWhite:.8 alpha:.8];
        tips.tintColor = darkColor;
    });
}
@end
