//
//  DJSidebarOptionsTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSidebarOptionsTableViewCell.h"

@implementation DJSidebarOptionsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        _iconBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_iconBtn];
        _iconBtn.sd_layout.leftSpaceToView(self.contentView, kFit(45)).bottomSpaceToView(self.contentView, 0).widthIs(kFit(18)).heightIs(kFit(18));
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        _titleLabel.text = @"首页";//高48  宽 38
        _titleLabel.font = MFont(kFit(16));
        [self.contentView addSubview:_titleLabel];
        _titleLabel .sd_layout.leftSpaceToView(_iconBtn, kFit(10)).bottomSpaceToView(self.contentView, kFit(1.5)).widthIs(kFit(260-63-20)).heightIs(kFit(15.5));
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setDataDic:(NSDictionary *)dataDic {
    [_iconBtn setImage:[UIImage imageNamed:dataDic[@"icon"]] forState:(UIControlStateNormal)];
    _titleLabel.text = dataDic[@"title"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
