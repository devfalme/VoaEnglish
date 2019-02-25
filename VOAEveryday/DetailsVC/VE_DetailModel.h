//
//  VE_DetailModel.h
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VE_DetailModel : VE_BaseModel
@property (nonatomic, copy) NSString *mp3Url;//音频地址
@property (nonatomic, copy) NSString *contentsStr;//内容
@property (nonatomic, retain) NSArray *relatedArr;//相关推荐ArticalListModel
@end

NS_ASSUME_NONNULL_END
