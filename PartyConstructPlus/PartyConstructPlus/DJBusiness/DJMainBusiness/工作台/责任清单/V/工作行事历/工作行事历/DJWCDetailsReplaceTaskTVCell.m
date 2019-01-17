//
//  DJWCDReplaceTaskTVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJWCDetailsReplaceTaskTVCell.h"

@implementation DJWCDetailsReplaceTaskTVCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
   
        self.stateLabel = [UILabel new];
        _stateLabel.text = @"待完成";
        _stateLabel.textColor = kColorRGB(51, 51, 51, 1);
        _stateLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_stateLabel];
        _stateLabel.sd_layout.leftSpaceToView(self.contentView, kFit(20)).topSpaceToView(self.contentView, kFit(15)).widthIs(kFit(120)).heightIs(kFit(14));
        self.timeLabel = [UILabel new];
        _timeLabel.textColor = kColorRGB(136, 136, 136, 1);
        _timeLabel.text =@"";
        _timeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
        [self.contentView addSubview:_timeLabel];
        _timeLabel.sd_layout.leftEqualToView(_stateLabel).topSpaceToView(_stateLabel, kFit(10)).rightSpaceToView(self.contentView, kFit(100)).heightIs(kFit(14));
        
        self.waitExecutionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_waitExecutionBtn setTitle:@"执行" forState:(UIControlStateNormal)];
        
        [_waitExecutionBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
        _waitExecutionBtn.font = MFont(kFit(13));
        [_waitExecutionBtn addTarget:self action:@selector(handleWaitExecutionBtn) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.contentView addSubview:_waitExecutionBtn];
        _waitExecutionBtn.sd_layout.rightSpaceToView(self.contentView, kFit(15)).widthIs(kFit(55)).heightIs(kFit(30)).centerYEqualToView(self.contentView);
        
        self.waitReplaceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_waitReplaceBtn setImage:[UIImage imageNamed:@"DJReplaceWCBtn"] forState:(UIControlStateNormal)];
        [_waitReplaceBtn addTarget:self action:@selector(handleWaitExecutionBtn) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.contentView addSubview:_waitReplaceBtn];
        _waitReplaceBtn.sd_layout.rightSpaceToView(self.contentView, 0).heightIs(kFit(60)).widthIs(kFit(85)).topSpaceToView(self.contentView, 8.5);
        UILabel *contentLabel  = [UILabel new];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.textAlignment = 1;
        contentLabel.text = @"补办";
        contentLabel.font = MFont(kFit(13));
        [_waitReplaceBtn addSubview:contentLabel];
        contentLabel.sd_layout.leftSpaceToView(_waitReplaceBtn, 0).topSpaceToView(_waitReplaceBtn, 0).rightSpaceToView(_waitReplaceBtn, 0).bottomSpaceToView(_waitReplaceBtn, kFit(10));
        
        
        UILabel *dividerLabel = [UILabel new];
        dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:dividerLabel];
        dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
    }
    return self;
}


-(void)layoutSubviews {
    _waitExecutionBtn.layer.cornerRadius = kFit(30/2);
//    _waitExecutionBtn.layer.masksToBounds = YES;
    _waitExecutionBtn.layer.borderWidth = kFit(1);
    _waitExecutionBtn.layer.borderColor = kColorRGB(96, 96, 96, 1).CGColor;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)handleWaitExecutionBtn {
    
    if ([_delegate respondsToSelector:@selector(WCPerform:)]) {
        [_delegate WCPerform:self.indexPath];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
