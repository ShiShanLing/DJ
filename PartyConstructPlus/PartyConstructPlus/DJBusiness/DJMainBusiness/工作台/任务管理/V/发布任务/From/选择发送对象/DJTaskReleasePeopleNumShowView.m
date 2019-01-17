//
//  DJTaskReleasePeopleNumShowView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskReleasePeopleNumShowView.h"

@interface DJTaskReleasePeopleNumShowView  ()



@end

@implementation DJTaskReleasePeopleNumShowView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(60)+kTabbarSafeBottomMargin)];
        backgroundView.image = [UIImage imageNamed:@"DJ_TaskRelePolpelNum"];
        [self addSubview:backgroundView];
        
        
        self.determineBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [_determineBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        _determineBtn.titleLabel.font = MFont(kFit(14));
        [_determineBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _determineBtn.layer.cornerRadius = kFit(15);
//        _determineBtn.layer.masksToBounds = YES;
        _determineBtn.backgroundColor = kColorRGB(215, 215, 215, 1);
        [_determineBtn addTarget:self action:@selector(handleDetermineBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_determineBtn];
        
        _determineBtn.sd_layout.rightSpaceToView(self, 15).topSpaceToView(self, kFit(20)).widthIs(kFit(110)).heightIs(kFit(30));
        [_determineBtn updateLayout];
        
        
        //初始化CAGradientlayer对象，使它的大小为UIView的大小
        self.gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = _determineBtn.bounds;
        //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
        [self.determineBtn.layer addSublayer:_gradientLayer];
        //设置渐变区域的起始和终止位置（范围为0-1）
        _gradientLayer.startPoint = CGPointMake(0, 1);
        _gradientLayer.endPoint = CGPointMake(1, 1);
        _gradientLayer.cornerRadius = kFit(15);
        //设置颜色数组
        _gradientLayer.colors = @[(__bridge id)kColorRGB(251, 88, 68, 1).CGColor,(__bridge id)kColorRGB(254, 141, 85, 1).CGColor];
        //设置颜色分割点（范围：0-1）
        _gradientLayer.locations = @[@(0.3f), @(1.0f)];
        _gradientLayer.hidden  = YES;
        
        self.determineLabel= [UILabel new];
        _determineLabel.text = @"确定";
        _determineLabel.textAlignment = 1;
        _determineLabel.font = MFont(kFit(15));
        _determineLabel.textColor = [UIColor whiteColor];
        [self addSubview:_determineLabel];
        _determineLabel.sd_layout.rightSpaceToView(self, 15).topSpaceToView(self, kFit(20)).widthIs(kFit(110)).heightIs(kFit(30));
        
//        _determineLabel.hidden = YES;
        self.numShowLabel = [UILabel new];
        _numShowLabel.text = @"未选择";
        _numShowLabel.textColor = kColorRGB(173, 173, 173, 1);
        _numShowLabel.font  = MFont(kFit(15));
        [self addSubview:_numShowLabel];
        _numShowLabel.sd_layout.leftSpaceToView(self, 15).topSpaceToView(self, kFit(20)).rightSpaceToView(_determineBtn, kFit(15)).heightIs(kFit(30));
    }
    return self;
}

- (void)handleDetermineBtn {
    
    
    
}

@end
