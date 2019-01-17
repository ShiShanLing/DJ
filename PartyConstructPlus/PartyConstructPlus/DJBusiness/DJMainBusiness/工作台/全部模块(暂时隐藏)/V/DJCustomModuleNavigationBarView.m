//
//  DJCustomModuleNavigationBarView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/31.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJCustomModuleNavigationBarView.h"

@implementation DJCustomModuleNavigationBarView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        
        self.leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftBtn setTitleColor:kColorRGB(30, 139, 223, 1) forState:(UIControlStateNormal)];
        UIEdgeInsets imageE = _leftBtn.imageEdgeInsets;
        imageE.left -= 20;
        _leftBtn.imageEdgeInsets = imageE;
        _leftBtn.titleLabel.font = MFont(16);
        [self addSubview:_leftBtn];
        _leftBtn.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, 10).heightIs(25).widthIs(60);
        
        self.rightBtn =  [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightBtn setTitleColor:kColorRGB(30, 139, 223, 1) forState:(UIControlStateNormal)];
        [_rightBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
        _rightBtn.titleLabel.font = MFont(16);
        [self addSubview:_rightBtn];
        _rightBtn.sd_layout.rightSpaceToView(self, 0).bottomSpaceToView(self, 10).widthIs(60).heightIs(25);
        
        
        self.titleLabel = [UILabel new];
        _titleLabel.text = @"全部";
        _titleLabel.textAlignment =1;
        _titleLabel.textColor = kColorRGB(0, 0, 0, 1);
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [self addSubview:_titleLabel];
        _titleLabel.sd_layout.bottomSpaceToView(self, 14).widthIs(120).heightIs(18).centerXEqualToView(self);
        
        
        self.SegmentationLineLabel =[UILabel new];
        _SegmentationLineLabel.backgroundColor = kColorRGB(225, 225, 225, 1);
        _SegmentationLineLabel.alpha = 0.7;
        [self addSubview:_SegmentationLineLabel];
        _SegmentationLineLabel.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(1);
        
    }
    return self;
}


- (void)setTitle:(NSString *)title {
    
    
}

@end
