//
//  DJCalendarTimeShowHeadView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/28.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJCalendarTimeShowHeadView.h"

@interface DJCalendarTimeShowHeadView ()

/**
 开始时间状态label
 */
@property (nonatomic, strong)UILabel *startStateLabel;
/**
 *结束时间状态label
 */
@property (nonatomic, strong)UILabel *endStateLabel;


@end

@implementation DJCalendarTimeShowHeadView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化CAGradientlayer对象，使它的大小为UIView的大小
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        
        //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
        [self.layer addSublayer:gradientLayer];
        
        //设置渐变区域的起始和终止位置（范围为0-1）
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        
        //设置颜色数组
        gradientLayer.colors = @[(__bridge id)kColorRGB(251, 88, 68, 1).CGColor,(__bridge id)kColorRGB(254, 141, 85, 1).CGColor];
        //设置颜色分割点（范围：0-1）
        gradientLayer.locations = @[@(0.3f), @(1.0f)];
        
        UIView *leftView = [[UIView alloc] init];
        leftView.tag = 100;
        leftView.userInteractionEnabled = YES;
        [self addSubview:leftView];
        leftView.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, 0).widthIs(self.width/2).heightIs(70);
        
        UIView *rightView = [[UIView alloc] init];
        rightView.tag = 101;
        [self addSubview:rightView];
        rightView.sd_layout.leftSpaceToView(leftView, 0).heightIs(70).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        UILabel *dividerLine = [[UILabel alloc] init];
        dividerLine.backgroundColor = kColorRGB(237, 237, 237, 1);
        [self addSubview:dividerLine];
        dividerLine.sd_layout.bottomSpaceToView(self, kFit(25)).widthIs(kFit(0.7)).heightIs(kFit(15)).centerXEqualToView(self);
        
        self.startStateLabel = [UILabel new];
        _startStateLabel.text = @"开始时间";
        _startStateLabel.textAlignment = 1;
        _startStateLabel.userInteractionEnabled = NO;
        _startStateLabel.textColor = kColorRGB(255, 255, 255, 1);
        _startStateLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        [leftView  addSubview:_startStateLabel];
        _startStateLabel.sd_layout.leftSpaceToView(leftView, kFit(15)).rightSpaceToView(leftView, kFit(15)).heightIs(20).topSpaceToView(leftView, kFit(17));
        
        self.endStateLabel = [UILabel new];
        _endStateLabel.text = @"结束时间";
        _endStateLabel.textAlignment = 1;
        _endStateLabel.textColor = kColorRGB(255, 255, 255, 1);
        _endStateLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        [rightView  addSubview:_endStateLabel];
        _endStateLabel.sd_layout.leftSpaceToView(rightView, kFit(15)).rightSpaceToView(rightView, kFit(15)).heightIs(20).topSpaceToView(rightView, kFit(17));
        
        
        self.startTimeShowLabel = [[UILabel alloc] init];
        _startTimeShowLabel.textColor = [UIColor whiteColor];
        _startTimeShowLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        _startTimeShowLabel.alpha = 0;
        _startTimeShowLabel.userInteractionEnabled = NO;
        _startTimeShowLabel.textAlignment = 1;
        [leftView addSubview:_startTimeShowLabel];
        _startTimeShowLabel.sd_layout.leftSpaceToView(leftView, kFit(10)).bottomSpaceToView(leftView, kFit(15)).rightSpaceToView(leftView, kFit(10)).heightIs(16);
        
        self.endTimeShowLabel = [[UILabel alloc] init];
        _endTimeShowLabel.textColor = [UIColor whiteColor];
        _endTimeShowLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        _endTimeShowLabel.alpha = 0;
        _endTimeShowLabel.textAlignment = 1;
        [rightView addSubview:_endTimeShowLabel];
        _endTimeShowLabel.sd_layout.leftSpaceToView(rightView, kFit(10)).bottomSpaceToView(rightView, kFit(15)).rightSpaceToView(rightView, kFit(10)).heightIs(16);
     
        
        
        UITapGestureRecognizer *leftViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleViewTap:)];
        leftViewTap.numberOfTouchesRequired = 1; //手指数
        leftViewTap.numberOfTapsRequired = 1; //tap次数
        
        [leftView addGestureRecognizer:leftViewTap];
        
        UITapGestureRecognizer *rightViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleViewTap:)];
        rightViewTap.numberOfTouchesRequired = 1; //手指数
        rightViewTap.numberOfTapsRequired = 1; //tap次数
        
        [rightView addGestureRecognizer:rightViewTap];
        
    }
    return self;
}

- (void)handleViewTap:(UITapGestureRecognizer *)tap {
    
    NSLog(@"tap.view.tag%d", tap.view.tag);
    
    if ([_delegate respondsToSelector:@selector(timeChoose:)]) {
        [_delegate timeChoose:tap.view.tag - 100];
    }
    
}
-(void)layoutSubviews {
    [super layoutSubviews];

}


/**
 显示时间
 */
- (void)show {
    self.startTimeShowLabel.alpha = 1;
    self.endTimeShowLabel.alpha = 1;
    
    CGRect frame = _startStateLabel.frame;
    frame.origin.y = 17;
    self.startStateLabel.frame = frame;
    self.endStateLabel.frame = frame;

//    _endStateLabel
}

/**
 隐藏时间  这个基本用不到
 */
- (void)hidden {
    
    
}
@end
