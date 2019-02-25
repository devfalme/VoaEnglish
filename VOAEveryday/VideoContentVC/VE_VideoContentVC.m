//
//  VE_VideoContentVC.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_VideoContentVC.h"
#import "ZFPlayer.h"
#import "VE_VideoContentModel.h"
#import "VE_ArticalCell.h"

@interface VE_VideoContentVC () <UIScrollViewDelegate>{
    BOOL shouldAutorotate;
}
@property (nonatomic, retain) ZFPlayerView *playerView;
@property (nonatomic, retain) VE_ArticalModel *model;

@property (nonatomic, retain) VE_VideoContentModel *contentModel;

@property (nonatomic, retain) UIButton *bookButton;

@property (nonatomic, assign) BOOL buttonAnimate;

@end

@implementation VE_VideoContentVC

ROUTER_PATH(@"VideoContentVC")

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.playerView) {
        [self.playerView setNeedsLayout];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.title;
    self.buttonAnimate = NO;
    self.tableView.bounces = YES;
    [self createItems];
    [self.tableView bindHeadRefreshHandler:^{
        loadVideoContent(self.model.url, ^(VE_VideoContentModel *model) {
            self.contentModel = model;
            [self.tableView.headRefreshControl endRefreshingAndNoLongerRefreshingWithAlertText:NSLocalizedString(@"加載完畢", nil)];
            [self loadVideo];
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.buttonAnimate = YES;
                [self scrollViewDidEndScroll];
            });
        }, ^{
            [VE_VOAHUD showError:NSLocalizedString(@"網絡不暢！", nil)];
        });
    } themeColor:pinkColor refreshStyle:KafkaRefreshStyleReplicatorDot];
    [self.tableView registerNib:[UINib nibWithNibName:@"VE_ArticalCell" bundle:nil] forCellReuseIdentifier:@"VE_ArticalCell"];
    [self.tableView.headRefreshControl beginRefreshing];
}

- (void)createItems {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = pinkColor;
    [self.view addSubview:topView];
    [topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(topSafeAera - 64.0);
    }];
    
    self.playerView = [[ZFPlayerView alloc] init];
    [self.view addSubview:self.playerView];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
    }];
    
    
    [self.view addSubview:self.bookButton];
    [self.bookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-50);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    [[self.bookButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [VE_VOAHUD showSuccess:NSLocalizedString(@"已收藏", nil)];
    }];
    
    self.bookButton.hidden = YES;
}

- (void)loadVideo {
    // 设置播放前的占位图（需要在设置视频URL之前设置）
    self.playerView.placeholderImageName = @"VideoHolder";
    self.playerView.videoURL = [NSURL URLWithString: self.contentModel.url];
    
    // 设置标题
    self.playerView.title = self.model.title;
    //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    
    // 如果想从xx秒开始播放视频
    // self.playerView.seekTime = 15;
    [self.playerView autoPlayTheVideo];//自动播放
    __weak typeof(self) weakSelf = self;
    
    self.playerView.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void)layoutTableView {
    if (self.playerView) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playerView.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 20)];
        label.text = NSLocalizedString(@"相關推薦:", nil);
        label.textColor = darkColor;
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        return label;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.contentModel) {
        return 2;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 44.0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        return self.contentModel.relatArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        return self.contentModel.relatArr[indexPath.row].height;
    }else{
        return self.contentModel.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VE_ArticalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VE_ArticalCell"];
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        [(VE_ArticalCell *)cell titleText:self.contentModel.relatArr[indexPath.row].title];
    }else{
        [(VE_ArticalCell *)cell titleText:self.contentModel.videoDes];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        VE_ArticalModel *model = self.contentModel.relatArr[indexPath.row];
        
        NSString *str = [NSString stringWithFormat:@"http://www.51voa.com/VOA_Videos/%@",model.url];

        VE_ArticalModel *relatModel = [VE_ArticalModel title:model.title url:str];
        
        [self.navigationController pushURL:ROUTER_API(@"VideoContentVC") parameters:@{@"model":relatModel} animated:YES completion:nil];
    }
}


- (BOOL)preferredNavigationBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
    
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(NSLocalizedString(@"旋转啦", nil));
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        //if use Masonry,Please open this annotation
        
        
        self.tableView.hidden = NO;
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        //if use Masonry,Please open this annotation

        self.tableView.hidden = YES;
        
    }
}



- (UIButton *)bookButton {
    if (!_bookButton) {
        _bookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bookButton.backgroundColor = [UIColor qmui_colorWithHexString:@"FF5E5E"];
        [_bookButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_bookButton setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
        _bookButton.layer.cornerRadius = 32.0;
        _bookButton.layer.shadowColor = [UIColor qmui_colorWithHexString:@"777777"].CGColor;
        _bookButton.layer.shadowOpacity = .5;
        _bookButton.layer.shadowOffset = CGSizeMake(1, 3);
        _bookButton.layer.shadowRadius = 4;
        _bookButton.adjustsImageWhenHighlighted = NO;
        _bookButton.adjustsImageWhenDisabled = NO;
    }return _bookButton;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.buttonAnimate) {
        self.buttonAnimate = YES;
        [UIView animateWithDuration:.3 animations:^{
            self.bookButton.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
        }];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndScroll];
    }
}

#pragma mark - scrollView 滚动停止
- (void)scrollViewDidEndScroll {
    
    //    NSLog(NSLocalizedString(@"停止滚动了！！！", nil));
    if (self.buttonAnimate) {
        [UIView animateWithDuration:.3 animations:^{
            self.bookButton.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            self.buttonAnimate = NO;
        }];
    }
}
@end
