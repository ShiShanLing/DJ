//
//  DJAgendaWCTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJAgendaWCTableViewCell.h"


@interface DJAgendaWCTableViewCell ()

/**
 *工作行事历name
 */
@property (nonatomic, strong)UILabel * CalendarsName;
/**
 *副标题
 */
@property (nonatomic, strong)UILabel *subTitleLabel;

/**
 *时间
 */
@property (nonatomic, strong)UILabel *timeLabel;



@end

@implementation DJAgendaWCTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.CalendarsName = [[UILabel alloc] init];
        _CalendarsName.text = @"";
        _CalendarsName.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(16)];
        
        _CalendarsName.textColor =kColorRGB(51, 51, 51, 1);
        [self.contentView addSubview:_CalendarsName];
        _CalendarsName.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.contentView, kFit(93)).heightIs(kFit(16));
        
        self.subTitleLabel = [UILabel new];
        _subTitleLabel.text = @"编写并提交周报（内容）";
        _subTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
        
        _subTitleLabel.textColor = kColorRGB(136, 136, 136, 1);
        [self.contentView addSubview:_subTitleLabel];
        _subTitleLabel.sd_layout.leftEqualToView(_CalendarsName).topSpaceToView(_CalendarsName, kFit(10)).rightEqualToView(_CalendarsName).heightIs(kFit(14));
        
        self.timeLabel = [UILabel new];
        _timeLabel.text = @"2018.04.02—2018.04.08";
        _timeLabel.font = MFont(kFit(14));
        _timeLabel.textColor = kColorRGB(136, 136, 136, 1);
        [self.contentView addSubview:_timeLabel];
        _timeLabel.sd_layout.leftEqualToView(_CalendarsName).topSpaceToView(_subTitleLabel, kFit(15)).heightIs(kFit(14)).widthIs(kFit(180));
        
        self.timeoutLabel = [UILabel new];
        _timeoutLabel.textColor = kColorRGB(253, 115, 77, 1);
        _timeoutLabel.text = @"已超时";
        _timeoutLabel.textAlignment = 1;
        _timeoutLabel.font = MFont(kFit(10));
        _timeoutLabel.layer.borderWidth = 1;
        _timeoutLabel.layer.borderColor = kColorRGB(253, 115, 77, 1).CGColor;
        [self.contentView addSubview:_timeoutLabel];
        _timeoutLabel.sd_layout.leftSpaceToView(_timeLabel, 3).widthIs(kFit(43)).heightIs(kFit(14)).centerYEqualToView(_timeLabel);
        
        self.stateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _stateBtn.font = MFont(kFit(14));
        [_stateBtn setTitle:@"执行" forState:(UIControlStateNormal)];
        [_stateBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
        _stateBtn.layer.cornerRadius = kFit(30)/2;
        _stateBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:_stateBtn];
        _stateBtn.layer.borderWidth = 1;
         _stateBtn.layer.borderColor = [kColorRGB(96, 96, 96, 1) CGColor];
        _stateBtn.sd_layout.rightSpaceToView(self.contentView, 15).widthIs(kFit(55)).heightIs(kFit(30)).centerYEqualToView(self.contentView);
        [_stateBtn addTarget:self action:@selector(handleWaitExecutionBtn) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.waitReplaceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_waitReplaceBtn setImage:[UIImage imageNamed:@"DJReplaceWCBtn"] forState:(UIControlStateNormal)];
        [_waitReplaceBtn addTarget:self action:@selector(handleWaitExecutionBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_waitReplaceBtn];
        _waitReplaceBtn.sd_layout.rightSpaceToView(self.contentView, 0).heightIs(kFit(60)).widthIs(kFit(85)).bottomSpaceToView(self.contentView, kFit(11.5));
        UILabel *titelLabel  = [UILabel new];
        titelLabel.textColor = [UIColor whiteColor];
        titelLabel.textAlignment = 1;
        titelLabel.text = @"补办";
        titelLabel.font = MFont(kFit(13));
        [_waitReplaceBtn addSubview:titelLabel];
        titelLabel.sd_layout.leftSpaceToView(_waitReplaceBtn, 0).topSpaceToView(_waitReplaceBtn, 0).rightSpaceToView(_waitReplaceBtn, 0).bottomSpaceToView(_waitReplaceBtn, kFit(10));
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

-(void)setModel:(AgendaWorkingCalendarListModel *)model {
    
    _CalendarsName.text = model.taskName;
    _subTitleLabel.text = model.taskContent;
    _timeLabel.text = [NSString stringWithFormat:@"%@—%@", model.beginTime, model.endTime];
    if (![model.status isEqualToString:@"undo"]) {
        _stateBtn.hidden = YES;
        _waitReplaceBtn.hidden = NO;
        _timeoutLabel.hidden = NO;
    }else {
        _stateBtn.hidden = NO;
        _waitReplaceBtn.hidden = YES;
        _timeoutLabel.hidden = YES;
    }
    _model = model;
}

- (void)handleWaitExecutionBtn {
    
    if ([_delegate respondsToSelector:@selector(completeCalendar:)]) {
        [_delegate completeCalendar:self.indexPath];
    }
}

@end
