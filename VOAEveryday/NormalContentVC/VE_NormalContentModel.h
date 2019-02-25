//
//  VE_NormalContentModel.h
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VE_NormalContentModel : VE_BaseModel
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) NSArray<VE_ArticalModel *> *relatArr;

@property (nonatomic) CGFloat height;

+ (instancetype)url:(NSString *)url content:(NSString *)content relatArr:(NSArray<VE_ArticalModel *> *)arr;
@end

NS_ASSUME_NONNULL_END
