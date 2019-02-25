//
//  VE_CollectVC.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/7.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_CollectVC.h"
#import "VE_ArticalCell.h"
@interface VE_CollectVC ()
@property (nonatomic, retain) NSMutableArray <VE_ArticalModel *> *models;
@end

@implementation VE_CollectVC

ROUTER_PATH(@"CollectVC")

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"收藏夾", nil);
    
    if (!self.models.count) {
        [self showEmptyViewWithImage:[UIImage imageNamed:@"Star"] text:NSLocalizedString(@"還沒有收藏哦，多去看看吧", nil) detailText:nil buttonTitle:nil buttonAction:nil];
    }
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
    BOOL isVideo = NO;
    VE_ArticalModel *model = self.models[indexPath.row];
    if ([model.title containsString:@"视频"]||[model.title containsString:@"影视"]||[model.title containsString:@"視頻"]||[model.title containsString:@"News Words"]||[model.title containsString:@"影視"]){
        isVideo = YES;
        
    }else{
        isVideo = NO;
    }
    
    if (isVideo) {
        [self.navigationController pushURL:ROUTER_API(@"VideoContentVC") parameters:@{@"model":self.models[indexPath.row]} animated:YES completion:nil];
    }else{
        [self.navigationController pushURL:ROUTER_API(@"NormalContentVC") parameters:@{@"model":self.models[indexPath.row]} animated:YES completion:nil];
    }
}
@end
