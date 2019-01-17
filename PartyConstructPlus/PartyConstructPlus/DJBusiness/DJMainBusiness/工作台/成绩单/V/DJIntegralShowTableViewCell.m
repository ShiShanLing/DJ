//
//  DJIntegralShowTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/21.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJIntegralShowTableViewCell.h"

@interface DJIntegralShowTableViewCell ()


@end

@implementation DJIntegralShowTableViewCell

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
        
        
        self.contentLabel = [UILabel new];
        _contentLabel.textColor = kColorRGB(51, 51, 51, 1);
        _contentLabel.font = MFont(kFit(15));
        _contentLabel.text = @"完成行事历任务";
        [self.contentView addSubview:_contentLabel];
        _contentLabel.sd_layout.leftSpaceToView(self.contentView, kFit(20)).topSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.integralLabel, kFit(15));
        
        self.timeLabel = [UILabel new];
        _timeLabel.text = @"2018-06-21";
        _timeLabel.textColor = kColorRGB(136, 136, 136, 1);
        _timeLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_timeLabel];
        _timeLabel.sd_layout.leftSpaceToView(self.contentView, kFit(20)).topSpaceToView(_contentLabel, kFit(10)).rightSpaceToView(self.integralLabel, kFit(15)).heightIs(kFit(14));
        
        
        
    }
    return self;
}
@end
