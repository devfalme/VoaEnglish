//
//  VE_NormalContentVC.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_NormalContentVC.h"
#import "VE_NormalContentModel.h"
#import "VE_NormalContentPlayView.h"
#import "VE_ArticalCell.h"

@interface VE_NormalContentVC () <UIScrollViewDelegate>
@property (nonatomic, retain) VE_NormalContentModel *contentModel;
@property (nonatomic, retain) VE_ArticalModel *model;

@property (nonatomic, retain) VE_NormalContentPlayView *playView;

@property (nonatomic, retain) UIButton *bookButton;

@property (nonatomic, assign) BOOL buttonAnimate;
@end

@implementation VE_NormalContentVC

ROUTER_PATH(@"NormalContentVC")

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.playView) {
        [self.playView pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.title;
    self.buttonAnimate = NO;
    self.tableView.bounces = YES;

    [self.tableView bindHeadRefreshHandler:^{
        loadNormalContent(self.model.url, ^(VE_NormalContentModel *model) {
            self.contentModel = model;
            [self.tableView.headRefreshControl endRefreshingAndNoLongerRefreshingWithAlertText:NSLocalizedString(@"加載完畢", nil)];
            [self createItems];
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
    if (self.contentModel.url) {
        self.playView = [VE_NormalContentPlayView url:self.contentModel.url];
        [self.view addSubview:self.playView];
        [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.mas_equalTo(bottomSafeAera + 49);
        }];
    }
    
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

- (void)layoutTableView {
    if (self.playView) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.playView.mas_top);
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
    if (section==0) {
        return 0.01;
    }else{
        return 44.0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
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
       [(VE_ArticalCell *)cell titleText:self.contentModel.content];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        VE_ArticalModel *model = self.contentModel.relatArr[indexPath.row];
        
        NSArray *arr = [self.model.url componentsSeparatedByString:@"/"];
        NSString *str;
        if (arr.count>3) {
            str = [NSString stringWithFormat:@"%@/%@/%@",VoaEnglish,arr[3],model.url];
        }
        
        VE_ArticalModel *relatModel = [VE_ArticalModel title:model.title url:str];
        
        [self.navigationController pushURL:ROUTER_API(@"NormalContentVC") parameters:@{@"model":relatModel} animated:YES completion:nil];
        
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
