//
//  VE_RequestTool.h
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VE_NormalContentModel.h"
#import "VE_VideoContentModel.h"

//#import "VE_DetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VE_RequestTool : NSObject

+ (VE_RequestTool *)shareTool;
@property (nonatomic,copy)NSString *mp3Url;
@property (nonatomic,copy)NSString *contentStr;
@property (nonatomic,strong)NSMutableArray *RelatedArticles;

- (NSArray<VE_DocumentModel *> *)loadDatas;
- (NSArray<VE_ArticalModel *> *)loadArtical:(NSString *)url;
- (void)loadNormalContent:(NSString *)url success:(void(^)(VE_NormalContentModel * model))success fail:(void(^)(void))fail;
- (void)loadVideoContent:(NSString *)url success:(void(^)(VE_VideoContentModel * model))success fail:(void(^)(void))fail;



@end

NS_ASSUME_NONNULL_END
