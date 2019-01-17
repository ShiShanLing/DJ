//
//  DJNoticePromptTVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJNoticePromptTVCell.h"

@interface DJNoticePromptTVCell ( )




@end

@implementation DJNoticePromptTVCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_iconBtn setImage:[UIImage imageNamed:@"DJTaskNotice"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:_iconBtn];
        _iconBtn.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).widthIs(kFit(65)).heightIs(kFit(65));
        [_iconBtn updateLayout];
        self.titleLabel = [UILabel new];
        _titleLabel.text = @"任务通知";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = MFont(kFit(16));
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(_iconBtn, 0).topSpaceToView(self.contentView, kFit(15)).heightIs(kFit(16)).widthIs(kFit(120));
        
        self.subtitleLabel = [UILabel new];
        _subtitleLabel.text = @"您收到了一条新的待办任务";
        _subtitleLabel.textColor = kColorRGB(136, 136, 136, 1);
        _subtitleLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_subtitleLabel];
        _subtitleLabel.sd_layout.leftSpaceToView(_iconBtn, 0).topSpaceToView(_titleLabel, kFit(10)).heightIs(kFit(14)).rightSpaceToView(self.contentView, kFit(15));
        
        
        self.timetLabel = [UILabel new];
        _timetLabel.text = @"刚刚";
        _timetLabel.textColor = kColorRGB(136, 136, 136, 1);
        _timetLabel.font = MFont(kFit(13));
        _timetLabel.textAlignment =2;
        [self.contentView addSubview:_timetLabel];
        _timetLabel.sd_layout.rightSpaceToView(self.contentView, kFit(15)).heightIs(_iconBtn.height).topEqualToView(_iconBtn).leftSpaceToView(_iconBtn, kFit(15));
        
        self.redPointLabel = [UILabel new];
        _redPointLabel.backgroundColor  = [UIColor redColor];
        _redPointLabel.layer.cornerRadius = kFit(4);
        _redPointLabel.layer.masksToBounds = YES;
        [_iconBtn addSubview:_redPointLabel];
        _redPointLabel.sd_layout.rightSpaceToView(_iconBtn, kFit(14.5)).topSpaceToView(_iconBtn, kFit(13.5)).widthIs(kFit(8)).heightIs(kFit(8));
        
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
