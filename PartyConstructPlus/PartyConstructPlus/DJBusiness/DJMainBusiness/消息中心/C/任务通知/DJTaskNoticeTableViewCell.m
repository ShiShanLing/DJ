//
//  DJTaskNoticeTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskNoticeTableViewCell.h"

@interface DJTaskNoticeTableViewCell ()


/**
 *对应的标题
 */
@property (nonatomic, strong)UILabel * titleLabel;

/**
 对应的副标题
 */
@property (nonatomic, strong)UILabel * subtitleLabel;
/**
 *对应的提示语
 */
@property (nonatomic, strong)UILabel * timetLabel;


@end

@implementation DJTaskNoticeTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_iconBtn setImage:[UIImage imageNamed:@"DJTaskNotice"] forState:(UIControlStateNormal)];
        _iconBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_iconBtn];
        _iconBtn.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).widthIs(kFit(65)).heightIs(kFit(65));
        [_iconBtn updateLayout];
        self.titleLabel = [UILabel new];
        _titleLabel.text = @"任务通知";
        _titleLabel.text = @"";
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = MFont(kFit(15));
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(_iconBtn, 0).topSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.contentView, kFit(86)).autoHeightRatio(0);
        
        self.timetLabel = [UILabel new];
        _timetLabel.text = @"刚刚";
        _timetLabel.textColor = kColorRGB(136, 136, 136, 1);
        _timetLabel.font = MFont(kFit(13));
        _timetLabel.textAlignment =2;
        [self.contentView addSubview:_timetLabel];
        _timetLabel.sd_layout.rightSpaceToView(self.contentView, kFit(15)).heightIs(_iconBtn.height).topEqualToView(_iconBtn).leftSpaceToView(_iconBtn, kFit(15));
        
        
        UILabel *_segmentationLabel = [[UILabel alloc]init];
        _segmentationLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:_segmentationLabel];
        _segmentationLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setTextModel:(TaskPushMsgModel *)textModel {
    _titleLabel.text = textModel.content;
    NSString *updateTime  =textModel.updateTime;
    NSDate *updateDate = [CommonUtil getDateForString:updateTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *tempStr =   [CommonUtil getTimeDiff:updateDate];
    _timetLabel.text = tempStr;
    [self setupAutoHeightWithBottomView:_titleLabel bottomMargin:kFit(14)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
