//
//  VE_TabbarVC.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/8.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_TabbarVC.h"
#import "VE_BaseNavigationController.h"

@interface VE_TabbarVC ()
@property (nonatomic, retain) UIButton *bookButton;
@end

@implementation VE_TabbarVC

ROUTER_PATH(@"TabbarVC")


- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *news1 = [Router search:ROUTER_API(@"SlowEnglishVC") parameters:@{@"model":documentArr[1]}];
    [self setViewController:news1 title:NSLocalizedString(@"慢速英語", nil) image:@"Tab1High" selectImage:@"Tab1"];
    
    UIViewController *news2 = [Router search:ROUTER_API(@"NormalEnglishVC") parameters:@{@"model":documentArr[0]}];
    [self setViewController:news2 title:NSLocalizedString(@"常速英語", nil) image:@"Tab2High" selectImage:@"Tab2"];
    
    UIViewController *news3 = [Router search:ROUTER_API(@"LearnEnglishVC") parameters:@{@"model":documentArr[3]}];
    [self setViewController:news3 title:NSLocalizedString(@"英語教學", nil) image:@"Tab3High" selectImage:@"Tab3"];
    
    UIViewController *news4 = [Router search:ROUTER_API(@"VideoEnglishVC") parameters:@{@"model":documentArr[2]}];
    [self setViewController:news4 title:NSLocalizedString(@"視頻教學", nil) image:@"Tab4High" selectImage:@"Tab4"];
   
    
    [self.view addSubview:self.bookButton];
    [self.bookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-60);
        make.size.mas_equalTo(CGSizeMake(88, 88));
    }];
    
    [[self.bookButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self presentURL:ROUTER_API(@"CollectVC") animated:YES completion:nil];
    }];
    
    self.bookButton.hidden = YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self.view bringSubviewToFront:self.bookButton];
}

#pragma mark - 添加子控制器
-(void)setViewController:(UIViewController *)viewController title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    static NSInteger index = 0;
    viewController.tabBarItem.title = title;
    viewController.title = title;
    viewController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.tag = index;
    index++;
    

    VE_BaseNavigationController *nav = [[VE_BaseNavigationController alloc]initWithRootViewController:viewController];
//    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor qmui_colorWithHexString:@"9FA4AC"]} forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor qmui_colorWithHexString:@"222222"]} forState:UIControlStateSelected];
    
    [self addChildViewController:nav];
}

- (UIButton *)bookButton {
    if (!_bookButton) {
        _bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bookButton.backgroundColor = [UIColor qmui_colorWithHexString:@"FF5E5E"];
        [_bookButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_bookButton setImage:[UIImage imageNamed:@"Book"] forState:UIControlStateNormal];
        _bookButton.layer.cornerRadius = 44.0;
        _bookButton.layer.shadowColor = [UIColor qmui_colorWithHexString:@"777777"].CGColor;
        _bookButton.layer.shadowOpacity = .5;
        _bookButton.layer.shadowOffset = CGSizeMake(1, 3);
        _bookButton.layer.shadowRadius = 4;
        _bookButton.adjustsImageWhenHighlighted = NO;
        _bookButton.adjustsImageWhenDisabled = NO;
    }return _bookButton;
}
@end
