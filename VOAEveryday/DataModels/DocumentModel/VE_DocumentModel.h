//
//  VE_DocumentModel.h
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_BaseModel.h"
#import "VE_ArticalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VE_DocumentModel : VE_BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSMutableArray<VE_ArticalModel *> *list;

@end

NS_ASSUME_NONNULL_END
