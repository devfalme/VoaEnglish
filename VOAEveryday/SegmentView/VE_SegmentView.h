//
//  VE_SegmentView.h
//  VOAEveryday
//
//  Created by devfalme on 2018/12/31.
//  Copyright © 2018 devfalme. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface VE_SegmentView : UIView
/*!@brief 选中的背景色视图*/
@property (nonatomic,strong) UIView *selectedBgView;

/*!@brief 外部的滚动视图*/
@property(nonatomic,strong) UIScrollView *outScrollView;
/*!@brief 标题数组*/
@property (nonatomic,strong) NSArray *titleArray;
/*!@brief 滑块颜色*/
@property (nonatomic,strong) UIColor *sliderColor;
/*!@brief 底部Label文字颜色*/
@property (nonatomic,strong) UIColor *bottomLabelTextColor;
/*!@brief 顶部Label文字颜色*/
@property (nonatomic,strong) UIColor *topLabelTextColor;
/*!@brief 选中标题背景色*/
@property (nonatomic,strong) UIColor *selectedBackgroundColor;
/*!@brief 选中背景色视图的圆角*/
@property (nonatomic,assign) CGFloat selectedBgViewCornerRadius;
/*!@brief 标题字体*/
@property (nonatomic,strong) UIFont *labelFont;
/*!@brief 标题间距*/
@property (nonatomic,assign) CGFloat titleSpacing;
/*!@brief 滑块顶部外边距*/
@property (nonatomic,assign) CGFloat sliderTopMargin;
/*!@brief 滑块高度*/
@property (nonatomic,assign) CGFloat sliderHeight;
/*!@brief 动画时间*/
@property (nonatomic,assign) NSTimeInterval duration;


- (void)setButtonSelected:(NSInteger)index;

- (instancetype)initWithAction:(void(^)(NSInteger index))action;
    
    
@end
