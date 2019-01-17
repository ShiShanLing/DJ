//
//  DJWCDetailsHeadTVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJWCDetailsHeadTVCell.h"


@interface DJWCDetailsHeadTVCell ()
/**
 *
 */
@property (nonatomic, strong)UILabel *  titleLabel;

/**
 *
 */
@property (nonatomic, strong)UILabel * taskTypeLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * WCIntroductionLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel *tagLabelThree;
@end

@implementation DJWCDetailsHeadTVCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [UILabel new];
        _titleLabel.text = @"";
//        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:kFit(16)];
//        _titleLabel.font =   [UIFont boldSystemFontOfSize:20];
        _titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold"  size:kFit(16)];
        _titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.contentView, kFit(25)).autoHeightRatio(0);
        
        UILabel *tagLabelOne = [UILabel new];
        tagLabelOne.text = @"●";
        tagLabelOne.textAlignment = 1;
        
        tagLabelOne.font = MFont(kFit(6));
        tagLabelOne.textColor = kColorRGB(96, 96, 96, 1);
        [self.contentView addSubview:tagLabelOne];
        tagLabelOne.sd_layout.leftSpaceToView(self.contentView, kFit(15.5)).topSpaceToView(_titleLabel, kFit(15)).widthIs(kFit(14)).heightIs(kFit(14 + 5.6));
        self.orgNameLabel = [UILabel new];
        _orgNameLabel.text = @"";
        _orgNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
        _orgNameLabel.numberOfLines = 0;
        _orgNameLabel.textColor =  kColorRGB(51, 51, 51, 1);
        [self.contentView addSubview:_orgNameLabel];
        _orgNameLabel.sd_layout.leftSpaceToView(tagLabelOne, 0).topSpaceToView(_titleLabel, kFit(15)).rightSpaceToView(self.contentView, kFit(25)).autoHeightRatio(0);
        
        UILabel *tagLabelTwo = [UILabel new];
        tagLabelTwo.text = @"●";
        tagLabelTwo.textAlignment = 1;
        tagLabelTwo.font = MFont(kFit(6));
        tagLabelTwo.textColor = kColorRGB(96, 96, 96, 1);
        [self.contentView addSubview:tagLabelTwo];
        tagLabelTwo.sd_layout.leftSpaceToView(self.contentView, kFit(15.5)).topSpaceToView(_orgNameLabel, kFit(15)).widthIs(kFit(14)).heightIs(kFit(14+ 5.6));
        self.taskTypeLabel = [[UILabel alloc] init];
        _taskTypeLabel.text = @"周任务";
        _taskTypeLabel.numberOfLines = 0;
        _taskTypeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
        _taskTypeLabel.textColor =  kColorRGB(51, 51, 51, 1);
        [self.contentView addSubview:_taskTypeLabel];
        _taskTypeLabel.sd_layout.leftSpaceToView(tagLabelTwo, 0).topSpaceToView(_orgNameLabel, kFit(15)).rightSpaceToView(self.contentView, kFit(25)).autoHeightRatio(0);
        
        self.tagLabelThree = [UILabel new];
        _tagLabelThree.text = @"●";
        _tagLabelThree.textAlignment = 1;
        _tagLabelThree.font = MFont(kFit(6));
        _tagLabelThree.textColor = kColorRGB(96, 96, 96, 1);
        [self.contentView addSubview:_tagLabelThree];
        _tagLabelThree.sd_layout.leftSpaceToView(self.contentView, kFit(15.5)).topSpaceToView(_taskTypeLabel, kFit(15)).widthIs(kFit(14)).heightIs(kFit(14+ 5.6));
        
        self.WCIntroductionLabel = [UILabel new];
        _WCIntroductionLabel.textColor = kColorRGB(51, 51, 51, 1);
        _WCIntroductionLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
        _WCIntroductionLabel.numberOfLines = 0;
        _WCIntroductionLabel.text = @"";
        [self.contentView addSubview:_WCIntroductionLabel];
        _WCIntroductionLabel.sd_layout.leftSpaceToView(_tagLabelThree, 0).topSpaceToView(_taskTypeLabel, kFit(15)).rightSpaceToView(self.contentView, kFit(25)).autoHeightRatio(0);
        
        
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

- (void)setModel:(AgendaWorkingCalendarListModel *)model {
    self.titleLabel.text = model.taskName;
    self.WCIntroductionLabel.text = model.taskContent;
    self.orgNameLabel.text = model.orgName;
    //周：week，月：month，季度：quarter，半halfyear，year
    if ([model.type isEqualToString:@"week"]) {
        self.taskTypeLabel.text =  @"周任务";
    }else if ([model.type isEqualToString:@"month"]) {
        self.taskTypeLabel.text =  @"月任务";
    }else if ([model.type isEqualToString:@"quarter"]) {
        self.taskTypeLabel.text =  @"季度任务";
    }else if ([model.type isEqualToString:@"halfyear"]) {
        self.taskTypeLabel.text =  @"半年任务";
    }else if ([model.type isEqualToString:@"year"]) {
        self.taskTypeLabel.text =  @"年任务";
    }
    if (_WCIntroductionLabel.text.length == 0) {
        [self setupAutoHeightWithBottomView:_taskTypeLabel bottomMargin:kFit(15)];
        _tagLabelThree.hidden = YES;
    }else {
        [self setupAutoHeightWithBottomView:_WCIntroductionLabel bottomMargin:kFit(15)];
        _tagLabelThree.hidden = NO;
    }
    
}

@end
