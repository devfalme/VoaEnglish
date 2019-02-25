//
//  VE_VideoContentModel.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_VideoContentModel.h"

@implementation VE_VideoContentModel
+ (instancetype)url:(NSString *)url imgUrl:(NSString *)imgUrl content:(NSString *)content relatArr:(NSArray<VE_ArticalModel *> *)arr {
    VE_VideoContentModel *model = [[self alloc]init];
    model.videoDes = content;
    model.url = url;
    model.imgUrl = imgUrl;
    model.relatArr = arr;
    UIFont *font = [UIFont boldSystemFontOfSize:16.0];
    CGRect sizeToFit = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{                                                                                    NSFontAttributeName:font                                                             } context:nil];
    if (sizeToFit.size.height + 20 < 44.0) {
        model.height = 44;
    }else{
        model.height = sizeToFit.size.height + 20;
    }
    return model;
}
@end
