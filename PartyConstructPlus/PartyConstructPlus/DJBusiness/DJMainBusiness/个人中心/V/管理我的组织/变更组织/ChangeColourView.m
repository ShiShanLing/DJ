//
//  ChangeColourView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "ChangeColourView.h"

@implementation ChangeColourView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        //继续按钮
        [self.ContinueBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [self addSubview:self.ContinueBtn];
        self.ContinueBtn.sd_layout.leftSpaceToView(self, kFit(15)).rightSpaceToView(self, kFit(15)).topSpaceToView(self, kFit(20)).heightIs(kFit(45));
        [self.ContinueBtn updateLayout];
        [self.ContinueBtn.layer addSublayer:self.gradientLayer];
    }
    return self;
}

-(UIButton *)ContinueBtn {
    if (!_ContinueBtn) {
        _ContinueBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_ContinueBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _ContinueBtn.backgroundColor = kColorRGB(215, 215, 215, 1);
        [_ContinueBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        _ContinueBtn.font = MFont(kFit(16));
        [_ContinueBtn addTarget:self action:@selector(handleContinueBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        _ContinueBtn.layer.cornerRadius = kFit(45)/2;
        
        _ContinueBtn.userInteractionEnabled = NO;
        
    }
    return _ContinueBtn;
    
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        //初始化CAGradientlayer对象，使它的大小为UIView的大小
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = _ContinueBtn.bounds;
        //设置渐变区域的起始和终止位置（范围为0-1）
        _gradientLayer.startPoint = CGPointMake(0, 1);
        _gradientLayer.endPoint = CGPointMake(1, 1);
        _gradientLayer.cornerRadius = kFit(45)/2;
        //设置颜色数组
        _gradientLayer.colors = @[(__bridge id)kColorRGB(251, 88, 68, 1).CGColor,
                                  (__bridge id)kColorRGB(254, 141, 85, 1).CGColor];
        //设置颜色分割点（范围：0-1）
        _gradientLayer.locations = @[@(0.3f), @(1.0f)];
        _gradientLayer.hidden = YES;
    }
    return _gradientLayer;
}


- (void)handleContinueBtn:(UIButton *)sender {
    
    
    if ([_delegate respondsToSelector:@selector(handleExitOrg)]) {
        [_delegate handleExitOrg];
    }
    
}
@end
