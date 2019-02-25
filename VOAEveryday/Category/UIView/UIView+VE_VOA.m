//
//  UIView+VE_VOA.m
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "UIView+VE_VOA.h"

@implementation UIView (VE_VOA)
+ (UIView *)loadFromNib {
    NSString *nibNameOrNil = NSStringFromClass(self);
    return [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:nil options:nil] firstObject];
}
@end
