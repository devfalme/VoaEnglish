//
//  VE_Client.h
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VE_DocumentModel.h"
#import "VE_NormalContentModel.h"
#import "VE_VideoContentModel.h"


extern void safeDisable(void);

extern CGFloat topSafeAera;
extern CGFloat bottomSafeAera;

extern UIColor *yellowColor;
extern UIColor *lightColor;
extern UIColor *darkColor;
extern UIColor *pinkColor;

extern NSArray<VE_DocumentModel *> *documentArr;

extern void appSetup(NSDictionary *option);

extern UIViewController * rootVC(void);

extern void loadDatas(void(^success)(void), void(^fail)(void));
extern void loadArticals(NSString *url, void(^success)(NSArray<VE_ArticalModel *> *arr), void(^fail)(void));

extern void loadNormalContent(NSString *url, void(^success)(VE_NormalContentModel * model), void(^fail)(void));
extern void loadVideoContent(NSString *url, void(^success)(VE_VideoContentModel * model), void(^fail)(void));

//extern void loadData(NSString *url, void(^success)(NSString *sign), void(^fail)(NSUInteger flag));


