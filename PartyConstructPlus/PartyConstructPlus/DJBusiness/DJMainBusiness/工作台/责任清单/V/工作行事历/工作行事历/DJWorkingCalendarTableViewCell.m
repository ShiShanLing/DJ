//
//  DJWorkingCalendarTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJWorkingCalendarTableViewCell.h"

@implementation DJWorkingCalendarTableViewCell

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

        self.typeImage = [[UIImageView alloc] init];
        _typeImage.image = [UIImage imageNamed:@"DJWorkCalendarWeeks"];
        [self.contentView addSubview:_typeImage];
        _typeImage.sd_layout.leftSpaceToView(self.contentView, kFit(16.5)).widthIs(kFit(14)).heightIs(kFit(14)).topSpaceToView(self.contentView, kFit(16.5));
        
        self.CalendarsName = [[UILabel alloc] init];
        _CalendarsName.text = @"";
        _CalendarsName.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(16)];
        _CalendarsName.numberOfLines  = 0;
        _CalendarsName.textColor =kColorRGB(51, 51, 51, 1);
        [self.contentView addSubview:_CalendarsName];
        _CalendarsName.sd_layout.leftSpaceToView(_typeImage, kFit(5)).topSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.contentView, kFit(40)).autoHeightRatio(0);
        
        self.subTitleLabel = [UILabel new];
        _subTitleLabel.text = @"编写并提交周报（内容）";
        _subTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
        
        _subTitleLabel.textColor = kColorRGB(136, 136, 136, 1);
        [self.contentView addSubview:_subTitleLabel];
        _subTitleLabel.sd_layout.leftEqualToView(_CalendarsName).topSpaceToView(_CalendarsName, kFit(10)).rightEqualToView(_CalendarsName).heightIs(kFit(16));
        
        self.InstructionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_InstructionBtn setImage:[UIImage imageNamed:@"DJRegistrationRight"] forState:(UIControlStateNormal)];
        _InstructionBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_InstructionBtn];
        _InstructionBtn.sd_layout.rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(kFit(40));
        UILabel *dividerLabel = [UILabel new];
        dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:dividerLabel];
        dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        
    }
    return self;
}

- (void)setModel:(WorkingCalendarListModel *)model {
    
    
    if ([model.type isEqualToString:@"week"]) {
        _typeImage.image = [UIImage imageNamed:@"DJWorkCalendarWeeks"];
    }else if ([model.type isEqualToString:@"month"]) {
        _typeImage.image = [UIImage imageNamed:@"DJWorkCalendarMonth"];
    }else if ([model.type isEqualToString:@"quarter"]) {
        _typeImage.image = [UIImage imageNamed:@"DJWorkCalendarSeason"];
    }else if ([model.type isEqualToString:@"halfyear"]) {
        _typeImage.image = [UIImage imageNamed:@"DJWorkCalendarHalfYear"];
    }else if ([model.type isEqualToString:@"DJWorkCalendarYears"]) {
        _typeImage.image = [UIImage imageNamed:@"DJWorkCalendarWeeks"];
    }else   if ([model.type isEqualToString:@"year"]) {
        _typeImage.image = [UIImage imageNamed:@"DJWorkCalendarYears"];
    }else  {
        
    }
    
    _CalendarsName.text = model.wcName;
    _subTitleLabel.text = model.content;
    [self setupAutoHeightWithBottomView:_subTitleLabel bottomMargin:kFit(15)];
}
@end
