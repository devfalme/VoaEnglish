//
//  VE_VideoEnglishVC.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_VideoEnglishVC.h"
#import "VE_ArticalCell.h"
@interface VE_VideoEnglishVC ()
@property (nonatomic, retain) VE_DocumentModel *model;
@end

@implementation VE_VideoEnglishVC

ROUTER_PATH(@"VideoEnglishVC")

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = self.model.title;
    [self.tableView registerNib:[UINib nibWithNibName:@"VE_ArticalCell" bundle:nil] forCellReuseIdentifier:@"VE_ArticalCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.model.list[indexPath.row].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VE_ArticalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VE_ArticalCell"];
    [cell updateCellAppearanceWithIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(VE_ArticalCell *)cell titleText:self.model.list[indexPath.row].title];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //@"hidesBottomBarWhenPushed":@(YES),
    [self.navigationController pushURL:ROUTER_API(@"DetailLestVC") parameters:@{@"model":self.model.list[indexPath.row]} animated:YES completion:nil];
}

@end
