//
//  DJMapUserShowView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/9/3.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMapUserShowView.h"

@implementation DJMapUserShowView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        80 +tab height
        
        self.userHeadImageView = [UIImageView new];
        [self addSubview:_userHeadImageView];
        _userHeadImageView.sd_layout.leftSpaceToView(self, kFit(10)).topSpaceToView(self, kFit(10)).widthIs(kFit(60)).heightIs(kFit(60));
        [_userHeadImageView updateLayout];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.userHeadImageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.userHeadImageView.bounds.size];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = self.userHeadImageView.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        self.userHeadImageView.layer.mask = maskLayer;
        
        self.userNameLabel = [UILabel new];
        _userNameLabel.textColor = kColorRGB(51, 51, 51, 1);
        _userNameLabel.font = MFont(kFit(14));
        [self addSubview:_userNameLabel];
        _userNameLabel.sd_layout.leftSpaceToView(_userHeadImageView, kFit(10)).topSpaceToView(self, kFit(15)).rightSpaceToView(self, kFit(15)).heightIs(kFit(15));
        
        self.userAddressLabel = [UILabel new];
        _userAddressLabel.textColor = kColorRGB(136, 136, 136, 1);
        _userAddressLabel.font = MFont(kFit(12));
        [self addSubview:_userAddressLabel];
        _userAddressLabel.sd_layout.leftSpaceToView(_userHeadImageView, kFit(10)).topSpaceToView(_userNameLabel, kFit(10)).rightSpaceToView(self, kFit(15)).heightIs(kFit(13));
        
        
    }
    return self;
}
 
@end
