//
//  VE_ArticalModel.m
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_ArticalModel.h"

@implementation VE_ArticalModel
+ (instancetype)title:(NSString *)title url:(NSString *)url {
    VE_ArticalModel *model = [[self alloc]init];
    if ([title containsString:@"\r"]) {
        title = [title stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    }
    if ([title containsString:@"\n"]) {
        title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    model.title = title;
    model.url = url;

    UIFont *font = [UIFont boldSystemFontOfSize:16.0];
    CGRect sizeToFit = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30.0, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{                                                                                    NSFontAttributeName:font                                                             } context:nil];
    if (sizeToFit.size.height + 20 < 44.0) {
        model.height = 44;
    }else{
        model.height = sizeToFit.size.height + 20;
    }
    
    return model;
}
@end
