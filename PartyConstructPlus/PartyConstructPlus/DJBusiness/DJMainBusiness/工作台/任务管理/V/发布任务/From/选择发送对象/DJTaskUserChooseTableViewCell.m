//
//  DJTaskUserChooseTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/1.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskUserChooseTableViewCell.h"

@implementation DJTaskUserChooseTableViewCell

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
        
        self.iconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.iconBtn.userInteractionEnabled = NO;
        [_iconBtn setImage:[UIImage  imageNamed:@"DJLeaveOff"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:self.iconBtn];
        self.iconBtn.sd_layout.leftSpaceToView(self.contentView, 5).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(40);
        
        self.titleLabel = [UILabel new];
        _titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        _titleLabel.font = MFont(kFit(16));
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(_iconBtn, kFit(10)).topSpaceToView(self.contentView, kFit(13)).rightSpaceToView(self.contentView, kFit(15)).heightIs(kFit(19));
        
        self.subTitleLabel = [UILabel new];
        _subTitleLabel.textColor = kColorRGB(136, 136, 136, 1);
        _subTitleLabel.font = MFont(kFit(13));
        [self.contentView addSubview:_subTitleLabel];
        _subTitleLabel.sd_layout.leftSpaceToView(_iconBtn, kFit(10)).topSpaceToView(_titleLabel, kFit(1)).heightIs(kFit(17)).rightSpaceToView(self.contentView, kFit(15));
        UILabel *dividerLabel = [UILabel new];
        dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:dividerLabel];
        dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
    }
    return self;
}

@end
