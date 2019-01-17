//
//  DJTaskDistrTypeChooseTVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/18.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskDistrTypeChooseTVCell.h"


@implementation DJTaskDistrTypeChooseTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.sd_layout.leftSpaceToView(self.contentView, kFit(9)).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(kFit(30));
        
        self.titleLabel = [UILabel new];
        _titleLabel.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(16)];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(_iconImageView, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, kFit(38));
        
        self.pointToImage = [UIImageView new];
        _pointToImage.contentMode = UIViewContentModeCenter;
        _pointToImage.image = [UIImage imageNamed:@"DJRegistrationRight"];
        [self.contentView addSubview:_pointToImage];
        _pointToImage.sd_layout.rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(kFit(38));
        
        
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kColorRGB(225, 225, 225, 1);
        
        _dividerLabel.alpha = 0.7;
        [self.contentView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0.5).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        
    }
    return self;
}

@end
