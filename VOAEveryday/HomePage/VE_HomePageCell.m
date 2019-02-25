//
//  VE_HomePageCell.m
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//

#import "VE_HomePageCell.h"
@interface VE_HomePageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation VE_HomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)imageName:(NSString *)imageName {
    self.imageView.image = [UIImage imageNamed:imageName];
}
@end
