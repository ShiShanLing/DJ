//
//  DJResumptionExplainListTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJResumptionExplainListTableViewCell.h"

@interface DJResumptionExplainListTableViewCell ()


@end

@implementation DJResumptionExplainListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [UILabel new];
        _titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        _titleLabel.text = @"";
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(16)];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.contentView, kFit(140));
        
        self.timeLabel = [UILabel new];
        _timeLabel.textColor = kColorRGB(136, 136, 136, 1);
        _timeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
        _timeLabel.textAlignment = 2;
        _timeLabel.text = @"";
        [self.contentView addSubview:_timeLabel];
        _timeLabel.sd_layout.rightSpaceToView(self.contentView, kFit(11)).heightIs(kFit(14)).widthIs(kFit(110)).centerYEqualToView(_titleLabel);
        
        self.jobsLabel = [UILabel new];
        _jobsLabel.text = @"";
        _jobsLabel.textColor = kColorRGB(136, 136, 136, 1);
        _jobsLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
        [self.contentView addSubview:_jobsLabel];
        _jobsLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(_titleLabel, kFit(10)).rightSpaceToView(self.contentView, kFit(15)).heightIs(kFit(14));
        UILabel *dividerLabel = [UILabel new];
        dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:dividerLabel];
        dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
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

@end
