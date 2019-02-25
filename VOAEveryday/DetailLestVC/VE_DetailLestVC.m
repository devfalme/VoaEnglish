//
//  VE_DetailLestVC.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_DetailLestVC.h"
#import "VE_ArticalCell.h"
@interface VE_DetailLestVC ()

@property (nonatomic, retain) VE_ArticalModel *model;
@property (nonatomic, retain) NSMutableArray <VE_ArticalModel *> *models;
@property (nonatomic, retain) NSNumber *page;

@property (nonatomic) BOOL isVideo;
@end

@implementation VE_DetailLestVC

ROUTER_PATH(@"DetailLestVC")

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.model.title containsString:NSLocalizedString(@"视频", nil)]||[self.model.title containsString:@"News Words"]||[self.model.title containsString:NSLocalizedString(@"影视", nil)]||[self.model.title containsString:@"Videos"]){
        self.isVideo = YES;
        
    }else{
        self.isVideo = NO;
    }
    self.title = self.model.title;
    [self.tableView bindHeadRefreshHandler:^{
        self.page = @1;
        NSString *url = [NSString stringWithFormat:@"%@%@",VoaEnglish,[self configUrl]];
        loadArticals(url, ^(NSArray<VE_ArticalModel *> *arr) {
            self.models = [arr mutableCopy];
            [self.tableView reloadData];
            [self.tableView.headRefreshControl endRefreshing];
        }, ^{
            [self.tableView.headRefreshControl endRefreshing];
        });
    } themeColor:pinkColor refreshStyle:KafkaRefreshStyleReplicatorDot];
    
    [self.tableView bindFootRefreshHandler:^{
        self.page = @(self.page.integerValue + 1);
        NSString *url = [NSString stringWithFormat:@"%@%@",VoaEnglish,[self configUrl]];
        loadArticals(url, ^(NSArray<VE_ArticalModel *> *arr) {
            [self.models addObjectsFromArray:arr];
            [self.tableView reloadData];
            [self.tableView.footRefreshControl endRefreshing];
        }, ^{
            [self.tableView.footRefreshControl endRefreshing];
        });
    } themeColor:pinkColor refreshStyle:KafkaRefreshStyleReplicatorDot];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VE_ArticalCell" bundle:nil] forCellReuseIdentifier:@"VE_ArticalCell"];
    
    [self.tableView.headRefreshControl beginRefreshing];
}

- (NSString *)configUrl {
    NSString *ResultUrl = [NSString new];
    NSString *frontStr = [NSString new];
    NSString *behindStr = [NSString new];
    NSString *TheLastStr = [NSString new];
    if (self.model.url) {
        NSString *str = [self.model.url stringByDeletingPathExtension];//去掉.html
        NSArray *arr = [str componentsSeparatedByString:@"_"];
        if ([self.model.url containsString:@"archiver"]) {
            for (int i=0; i<arr.count; i++) {
                if (i < arr.count-2) {
                    NSString *addStr = [arr[i] stringByAppendingString:@"_"];
                    frontStr = [frontStr stringByAppendingString:addStr];
                }else if (i == arr.count-2){
                    
                }else{
                    if (i == arr.count-1) {//如果是最后一个，不追加_
                        NSString *addStr = [arr[i] stringByAppendingString:@""];
                        behindStr = [behindStr stringByAppendingString:addStr];
                    }else{
                        NSString *addStr = [arr[i] stringByAppendingString:@"_"];
                        behindStr = [behindStr stringByAppendingString:addStr];
                    }
                }
                
            }
            
            TheLastStr = [NSString stringWithFormat:@"%@%@_%@.html",frontStr,self.page,behindStr];
        }else{
            for (NSString *str in arr) {
                if (str ==[arr lastObject]) {
                    
                }else{
                    NSString *addStr = [str stringByAppendingString:@"_"];
                    ResultUrl = [ResultUrl stringByAppendingString:addStr];
                }
            }
            
            TheLastStr = [NSString stringWithFormat:@"%@%@.html",ResultUrl,self.page];
        }
        
    }
    return TheLastStr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.models[indexPath.row].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VE_ArticalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VE_ArticalCell"];
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(VE_ArticalCell *)cell titleText:self.models[indexPath.row].title];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isVideo) {
        [self.navigationController pushURL:ROUTER_API(@"VideoContentVC") parameters:@{@"model":self.models[indexPath.row]} animated:YES completion:nil];
    }else{
        [self.navigationController pushURL:ROUTER_API(@"NormalContentVC") parameters:@{@"model":self.models[indexPath.row]} animated:YES completion:nil];
    }
}
@end
