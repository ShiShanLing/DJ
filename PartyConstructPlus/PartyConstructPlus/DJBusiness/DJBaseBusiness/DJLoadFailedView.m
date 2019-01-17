//
//  DJLoadFailedView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJLoadFailedView.h"

@implementation DJLoadFailedView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        UILabel *YCenterLineLabel = [UILabel new];
        [self addSubview:YCenterLineLabel];
        YCenterLineLabel.sd_layout.leftSpaceToView(self, 0).heightIs(1).rightSpaceToView(self, 0).centerYEqualToView(self);
        self.failureImageView = [UIImageView new];
        _failureImageView.image = [UIImage imageNamed:@"DJ_network_load_failure"];
        [self addSubview:_failureImageView];
        CGFloat tempf = (self.height - kFit(315)) / 3;
        _failureImageView.sd_layout.widthIs((kScreenWidth - 60)).heightIs(kFit(315)).centerXEqualToView(self).topSpaceToView(self, tempf);
        _failureImageView.userInteractionEnabled = YES;
        self.promptLabel = [UILabel new];
        _promptLabel.textColor = kColorRGB(136, 136, 136, 1);
        _promptLabel.text = @"网络丢失，请检查网络设置";
        _promptLabel.textAlignment =1 ;
        _promptLabel.numberOfLines = 0;
        _promptLabel.font = MFont(kFit(15));
        [_failureImageView addSubview:_promptLabel];
        _promptLabel.sd_layout.leftSpaceToView(_failureImageView, 0).rightSpaceToView(_failureImageView, 0).heightIs(kFit(45)).topSpaceToView(_failureImageView, kFit(140));
        
        
        self.ReloadLabel = [UILabel new];
        
        self.ReloadLabel.textColor = kColorRGB(255, 255, 255, 1);
        self.ReloadLabel.font = MFont(kFit(16));
        self.ReloadLabel.layer.cornerRadius = kFit(15);
        [_failureImageView addSubview:self.ReloadLabel];
        
        self.ReloadLabel.sd_layout.widthIs(kFit(114)).heightIs(kFit(30)).topSpaceToView(_promptLabel, kFit(5)).centerXEqualToView(_failureImageView);
        [self.ReloadLabel updateLayout];
        
        
        //初始化CAGradientlayer对象，使它的大小为UIView的大小
        self.gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = _ReloadLabel.bounds;
        
        //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
        
        
        //设置渐变区域的起始和终止位置（范围为0-1）
        _gradientLayer.startPoint = CGPointMake(0, 1);
        _gradientLayer.endPoint = CGPointMake(1, 1);
        _gradientLayer.cornerRadius = kFit(15);
        
        //设置颜色数组
        _gradientLayer.colors = @[(__bridge id)kColorRGB(251, 88, 68, 1).CGColor,
                                      (__bridge id)kColorRGB(254, 141, 85, 1).CGColor];
        //设置颜色分割点（范围：0-1）
        _gradientLayer.locations = @[@(0.3f), @(1.0f)];
        [_ReloadLabel.layer addSublayer:_gradientLayer];
        
        _gradientLayer.hidden = YES;
        _gradientLayer.hidden = NO;
        
        self.ReloadBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.ReloadBtn setTitle:@"重新加载" forState:(UIControlStateNormal)];
        [self.ReloadBtn setTitleColor:kColorRGB(255, 255, 255, 1) forState:(UIControlStateNormal)];
        self.ReloadBtn.titleLabel.font = MFont(kFit(16));
        self.ReloadBtn.layer.cornerRadius = kFit(15);
        [_ReloadBtn addTarget:self action:@selector(handleReload) forControlEvents:(UIControlEventTouchUpInside)];
        [_failureImageView addSubview:self.ReloadBtn];
        self.ReloadBtn.sd_layout.widthIs(kFit(114)).heightIs(kFit(30)).topSpaceToView(_promptLabel, kFit(5)).centerXEqualToView(_failureImageView);
    }
    return self;
}

- (void)handleReload {
    self.reloadData(@"");
    
}

@end
