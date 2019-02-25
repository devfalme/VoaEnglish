//
//  VE_HomePageVC.m
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_HomePageVC.h"
#import <OC_CWCarousel/CWCarousel.h>
#import "VE_HomePageCell.h"
@interface VE_HomePageVC () <CWCarouselDatasource, CWCarouselDelegate>
@property (nonatomic, retain) CWCarousel *carousel;
@property (nonatomic, retain) UIButton *bookButton;
@end

@implementation VE_HomePageVC

ROUTER_PATH(@"HomePageVC")


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
    [self.view addSubview:self.bookButton];
    [self.bookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(88, 88));
    }];
    
    [[self.bookButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController pushURL:ROUTER_API(@"CollectVC") parameters:@{} animated:YES completion:nil];
    }];
}

- (void)loadDatas {
    [self showEmptyViewWithLoading:YES image:nil text:NSLocalizedString(@"加載數據中...", nil) detailText:nil buttonTitle:nil buttonAction:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loadDatas(^{
            [self createItems];
            [self hideEmptyView];
        }, ^{
            [self showEmptyViewWithImage:[UIImage imageNamed:@"Empty"] text:NSLocalizedString(@"加載失敗", nil) detailText:NSLocalizedString(@"檢查一下網絡再試試吧", nil) buttonTitle:NSLocalizedString(@"重試", nil) buttonAction:@selector(loadDatas)];
        });        
    });
}

- (void)createItems {
    CWFlowLayout *flowLayout = [[CWFlowLayout alloc] initWithStyle:CWCarouselStyle_H_2];
    self.carousel = [[CWCarousel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.75 / 3.0 * 4.0)
                                             delegate:self
                                           datasource:self
                                           flowLayout:flowLayout];
    [self.carousel registerNibView:@"VE_HomePageCell" identifier:@"VE_HomePageCell"];
    self.carousel.pageControl.hidden = YES;
    self.carousel.backgroundColor = UIColor.clearColor;
    CGPoint center = self.view.center;
    center.y = center.y - 44;
    self.carousel.center = center;
    [self.view addSubview:self.carousel];
    [self.carousel freshCarousel];
    
   
    
}

#pragma mark - Delegate

- (UICollectionViewCell *)viewForCarousel:(CWCarousel *)carousel indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
    VE_HomePageCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:@"VE_HomePageCell" forIndexPath:indexPath];
    [cell imageName:[NSString stringWithFormat:@"Item%d", (int)index+1]];
    return cell;
}

- (void)CWCarousel:(CWCarousel *)carousel didSelectedAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [self.navigationController pushURL:ROUTER_API(@"SlowEnglishVC")  parameters:@{@"model":documentArr[1]} animated:YES completion:nil];
            break;
        case 1:
            [self.navigationController pushURL:ROUTER_API(@"VideoEnglishVC") parameters:@{@"model":documentArr[2]} animated:YES completion:nil];
            break;
        case 2:
            [self.navigationController pushURL:ROUTER_API(@"NormalEnglishVC") parameters:@{@"model":documentArr[0]} animated:YES completion:nil];
            break;
        case 3:
            [self.navigationController pushURL:ROUTER_API(@"LearnEnglishVC") parameters:@{@"model":documentArr[3]} animated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (NSInteger)numbersForCarousel {
    return 4;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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

- (BOOL)preferredNavigationBarHidden {
    return YES;
}

@end
