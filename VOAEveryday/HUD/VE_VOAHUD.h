//
//  VE_VOAHUD.h
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VE_VOAHUD : NSObject

+ (void)showLoading:(NSString *)msg;
+ (void)showText:(NSString *)msg;
+ (void)hideHud;
+ (void)hideHudWhen:(NSInteger)time;

+ (void)showError:(NSString *)msg;
+ (void)showSuccess:(NSString *)msg;


@end

NS_ASSUME_NONNULL_END
