//
//  VE_ArticalCell.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_ArticalCell.h"
@interface VE_ArticalCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
@implementation VE_ArticalCell

- (void)titleText:(NSString *)title {
    self.title.text = title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
