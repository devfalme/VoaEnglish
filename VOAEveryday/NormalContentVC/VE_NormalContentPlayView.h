//
//  VE_NormalContentPlayView.h
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VE_NormalContentPlayView : UIView

+ (instancetype)url:(NSString *)url;
- (void)pause;
@end

NS_ASSUME_NONNULL_END
