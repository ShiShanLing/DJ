//
//  DJMonthTranscriptTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/26.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMonthTranscriptTableViewCell.h"

@implementation DJMonthTranscriptTableViewCell

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
        
        
        self.integralLabel = [UILabel new];
        _integralLabel.textColor = kColorRGB(51, 51, 51, 1);
        _integralLabel.font = MFont(kFit(15));
        _integralLabel.text  = @"+2";
        _integralLabel.textAlignment = 1;
        [self.contentView addSubview:_integralLabel];
        _integralLabel.sd_layout.rightSpaceToView(self.contentView, 0).widthIs(kFit(58.5)).heightIs(kFit(21)).centerYEqualToView(self.contentView);
        
        UILabel *contenHeadLabel = [UILabel new];
        contenHeadLabel.textColor = kColorRGB(136, 136, 136, 1);
        contenHeadLabel.font = MFont(kFit(14));
        contenHeadLabel.text = @"积分:";
        [self.contentView addSubview:contenHeadLabel];
        contenHeadLabel.sd_layout.leftSpaceToView(self.contentView, kFit(20)).topSpaceToView(self.contentView, kFit(15)).widthIs(kFit(40));
        
        self.contentLabel = [UILabel new];
        _contentLabel.textColor = kColorRGB(51, 51, 51, 1);
        _contentLabel.font = MFont(kFit(15));
        _contentLabel.text = @"";
        [self.contentView addSubview:_contentLabel];
        _contentLabel.sd_layout.leftSpaceToView(contenHeadLabel, kFit(10)).topSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.integralLabel, kFit(15)).heightIs(kFit(15));
        
        UILabel *timeHeadLabel = [UILabel new];
        timeHeadLabel.textColor = kColorRGB(136, 136, 136, 1);
        timeHeadLabel.font = MFont(kFit(14));
        timeHeadLabel.text = @"月份:";
        [self.contentView addSubview:timeHeadLabel];
        timeHeadLabel.sd_layout.leftSpaceToView(self.contentView, kFit(20)).topSpaceToView(contenHeadLabel, kFit(10)).widthIs(kFit(40)).heightIs(kFit(15));
        self.timeLabel = [UILabel new];
        _timeLabel.text = @"2018-06-21";
        _timeLabel.textColor = kColorRGB(102, 102, 102, 1);
        _timeLabel.font = MFont(kFit(15));
        [self.contentView addSubview:_timeLabel];
        _timeLabel.sd_layout.leftSpaceToView(timeHeadLabel, kFit(10)).topSpaceToView(contenHeadLabel, kFit(10)).rightSpaceToView(self.integralLabel, kFit(15)).heightIs(kFit(15));
        
        
    }
    return self;
}
@end
