//
//  DJFCModuleCollectionViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJFCModuleCollectionViewCell.h"

@interface DJFCModuleCollectionViewCell ()

/**
 主标题
 */
@property (nonatomic, strong)UILabel *titleLabel;

/**
 副标题
 */
@property (nonatomic, strong)UILabel *subtitle;

/**
 *
 */
@property (nonatomic, strong)UIImageView * backgroundImage;

@end

@implementation DJFCModuleCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundImage = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_backgroundImage];
        _backgroundImage.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 2).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
        self.titleLabel = [[UILabel alloc] init];
       _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(16)];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self.contentView, kFit(25)).topSpaceToView(self.contentView, kFit(22)).rightSpaceToView(self.contentView, kFit(10)).heightIs(kFit(16));
        self.subtitle = [[UILabel alloc] init];
        _subtitle.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(13)];
        _subtitle.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_subtitle];
        _subtitle.sd_layout.leftSpaceToView(self.contentView, kFit(25)).topSpaceToView(_titleLabel, kFit(9.5)).rightSpaceToView(self.contentView, kFit(10)).heightIs(kFit(13));
    }
    return self;
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _backgroundImage.image = [UIImage imageNamed:dataDic[@"icon"]];
    _titleLabel.text  = dataDic[@"title"];
//    _subtitle.text  = dataDic[@"subtitle"];
    
}
@end
