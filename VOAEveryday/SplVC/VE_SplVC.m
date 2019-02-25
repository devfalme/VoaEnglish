//
//  VE_SplVC.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_SplVC.h"
#import "VE_BaseNavigationController.h"

@interface VE_SplVC ()

@end

@implementation VE_SplVC

ROUTER_PATH(@"SplVC")


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"FFE543"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self turnToHomePage];
    });
    
}

- (void)turnToHomePage {
    typedef void (^Animation)(void);
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = [Router search:ROUTER_API(@"TabbarVC")];
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
