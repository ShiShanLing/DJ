//
//  DJLearnSpeechCollectionViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/22.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJLearnSpeechCollectionViewCell.h"


@implementation DJLearnSpeechCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.showImageView = [UIImageView new];
        _showImageView.image = [UIImage imageNamed:@"DJ_xljh"];
        [self.contentView addSubview:_showImageView];
        _showImageView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(kFit(120));
        
        self.titleLabel = [UILabel new];
        _titleLabel.text = @"此处为讲话标题标题";
        _titleLabel.textColor = kColorRGB(0, 0, 0, 1);
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold"  size:kFit(15)];
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(_showImageView, 5).rightSpaceToView(self.contentView, 0).heightIs(45);
        
    }
    return self;
}

@end
