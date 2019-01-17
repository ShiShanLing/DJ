//
//  DJOrgChooseTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJOrgChooseTableViewCell.h"


@interface DJOrgChooseTableViewCell ()

@property (nonatomic, strong)UIButton *chooseBtn;
/**
 *
 */
@property (nonatomic, strong)UILabel *orgNameLabel;

@end

@implementation DJOrgChooseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.chooseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_chooseBtn setImage:[UIImage imageNamed:@"DJLeaveOff"] forState:(UIControlStateNormal)];
        _chooseBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_chooseBtn];
        _chooseBtn.sd_layout.leftSpaceToView(self.contentView, kFit(10)).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(kFit(40));
        self.orgNameLabel = [UILabel new];
        _orgNameLabel.textColor = kColorRGB(51, 51, 51, 1);
        _orgNameLabel.numberOfLines = 2;
        _orgNameLabel.text = @"";
        _orgNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(16)];
        [self.contentView addSubview:_orgNameLabel];
        _orgNameLabel.sd_layout.leftSpaceToView(self.chooseBtn, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, kFit(33));
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(OrgInfoModel *)model {
    
    if ([model.chooseState isEqualToString:@"1"]) {
        [_chooseBtn setImage:[UIImage imageNamed:@"DJLeaveOn"] forState:(UIControlStateNormal)];
    }else {
        [_chooseBtn setImage:[UIImage imageNamed:@"DJLeaveOff"] forState:(UIControlStateNormal)];
        
    }
    _orgNameLabel.text = model.orgName;
}
@end
