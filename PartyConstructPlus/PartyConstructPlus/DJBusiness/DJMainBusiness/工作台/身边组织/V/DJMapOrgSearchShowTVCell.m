//
//  DJMapOrgSearchShowTVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMapOrgSearchShowTVCell.h"
#import "MapNearOrgModel+CoreDataProperties.h"
@implementation DJMapOrgSearchShowTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.OrgNameLabel = [UILabel new];
        _OrgNameLabel.text = @"";
        _OrgNameLabel.textColor = kColorRGB(51, 51, 51, 1);
        _OrgNameLabel.font =MFont(kFit(16));
        [self.contentView addSubview:_OrgNameLabel];
        _OrgNameLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.contentView, kFit(15)).heightIs(kFit(18));
        self.orgAddressLabel = [UILabel new];
        _orgAddressLabel .textColor = kColorRGB(136, 136, 136, 1);
        _orgAddressLabel.text = @"";
        _orgAddressLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_orgAddressLabel];
        _orgAddressLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(_OrgNameLabel, kFit(10)).rightSpaceToView(self.contentView, kFit(15)).heightIs(kFit(16));
    }
    return self;
}



- (void)setModel:(MapNearOrgModel *)model {
    
    
    
}
@end
