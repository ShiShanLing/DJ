//
//  TaskImageShowCVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/18.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskImageShowCVCell.h"


@interface DJTaskImageShowCVCell ()







@end

@implementation DJTaskImageShowCVCell


-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        
        self.showImageView  =  [[UIImageView alloc] init];
//        _showImageView.image = [UIImage imageNamed:@"DJ_fbrw_AddImage"];
        _showImageView.userInteractionEnabled = YES;
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        _showImageView.backgroundColor = kColorRGB(237, 237, 237, 1);
        [self.contentView addSubview:_showImageView];
        _showImageView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.contentView, kFit(15)).heightEqualToWidth();
        
        self.imageNameLabel = [UILabel new];
//        _imageNameLabel.text = @"IMG001";
        _imageNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(12)];
        _imageNameLabel.textColor = kColorRGB(51, 51, 51, 1);
        [self.contentView addSubview:_imageNameLabel];
        _imageNameLabel.sd_layout.leftEqualToView(_showImageView).topSpaceToView(_showImageView, kFit(10)).rightEqualToView(_showImageView).heightIs(kFit(12));
        
        self.imageSizeLabel = [UILabel new];
//        _imageSizeLabel.text = @"1.23M";
        _imageSizeLabel.textColor = kColorRGB(173, 173, 173, 1);
        _imageSizeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(12)];
        [self.contentView addSubview:_imageSizeLabel];
    _imageSizeLabel.sd_layout.leftEqualToView(_showImageView).rightEqualToView(_showImageView).topSpaceToView(_imageNameLabel, kFit(5)).heightIs(kFit(12));
        
        self.deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_deleteBtn setImage:[UIImage imageNamed:@"DJ_delete"] forState:(UIControlStateNormal)];
        _deleteBtn.hidden = YES;
        [_deleteBtn addTarget:self action:@selector(handleSeleteBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_deleteBtn];
        _deleteBtn.sd_layout.rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).widthIs(34).heightIs(34);
        
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSingleFingerEvent)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        
        
        [self addGestureRecognizer:singleFingerOne];

        
    }
    return self;
}


- (void)handleSingleFingerEvent {
    if ([_delegate respondsToSelector:@selector(handleClickImage:)]) {
        [_delegate handleClickImage:self.indexPath];
    }
    
}
- (void)handleSeleteBtn  {
    
    if ([_delegate respondsToSelector:@selector(deletelImage:)]) {
        [_delegate deletelImage:self.indexPath];
    }
    
}



@end
