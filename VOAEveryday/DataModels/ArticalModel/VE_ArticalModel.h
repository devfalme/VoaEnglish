//
//  VE_ArticalModel.h
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VE_ArticalModel : VE_BaseModel
@property (nonatomic, copy) NSString *title;//文章标题
@property (nonatomic, copy) NSString *url;//文章地址
@property (nonatomic) CGFloat height;

+ (instancetype)title:(NSString *)title url:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
