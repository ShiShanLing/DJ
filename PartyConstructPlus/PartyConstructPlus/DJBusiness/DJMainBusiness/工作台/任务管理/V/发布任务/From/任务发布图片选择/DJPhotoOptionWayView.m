//
//  DJPhotoOptionWayView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJPhotoOptionWayView.h"

@interface DJPhotoOptionWayView ()

@property (nonatomic, strong)UIButton *photoAlbumBtn;


@end

@implementation DJPhotoOptionWayView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        
        self.photoAlbumBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_photoAlbumBtn setTitle:@"相册" forState:(UIControlStateNormal)];
        _photoAlbumBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        [_photoAlbumBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
        [self addSubview:_photoAlbumBtn];
        _photoAlbumBtn.sd_layout.leftSpaceToView(self, kFit(36)).widthIs(kFit(150)).topSpaceToView(self, 12).heightIs(22);
        
        self.cameraBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_cameraBtn setTitle:@"相机" forState:(UIControlStateNormal)];
        _cameraBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        [_cameraBtn setTitleColor:kColorRGB(136, 136, 136, 1) forState:(UIControlStateNormal)];
        [self addSubview:_cameraBtn];
        _cameraBtn.sd_layout.leftSpaceToView(_photoAlbumBtn, 0).widthIs(kFit(150)).topSpaceToView(self, 12).heightIs(20);
        //初始化CAGradientlayer对象，使它的大小为UIView的大小
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];

        //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
        [self.layer addSublayer:gradientLayer];
        gradientLayer.frame = CGRectMake(kFit(96),34, 32, 5);
        //设置渐变区域的起始和终止位置（范围为0-1）
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        
        //设置颜色数组
        gradientLayer.colors = @[(__bridge id)kColorRGB(251, 88, 68, 1).CGColor,(__bridge id)kColorRGB(254, 141, 85, 1).CGColor];
        //设置颜色分割点（范围：0-1）
        gradientLayer.locations = @[@(0.3f), @(1.0f)];
      
        
        
    }
    return self;
}




@end
