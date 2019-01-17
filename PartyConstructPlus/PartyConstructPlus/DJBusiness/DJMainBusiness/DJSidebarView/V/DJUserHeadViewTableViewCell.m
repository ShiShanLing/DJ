//
//  DJUserHeadViewTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJUserHeadViewTableViewCell.h"

#define self_width kFit(260)

@implementation DJUserHeadViewTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIImageView  *bottomImage = [[UIImageView alloc] init];
        bottomImage.image = [UIImage imageNamed:@"DJUserHeadView"];
        [self.contentView addSubview:bottomImage];
        bottomImage.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).widthIs(self_width).bottomSpaceToView(self.contentView, 0);
        
        self.headImage =[[UIImageView alloc ] init];
        _headImage.image = [UIImage imageNamed:@"DJUserDefaultHead"];
        [bottomImage addSubview:_headImage];
        _headImage.sd_layout.topSpaceToView(bottomImage, kFit(54.5)).centerXEqualToView(bottomImage).widthIs(kFit(65)).heightIs(kFit(65));
        
        self.nameLabel = [UILabel new];
        _nameLabel.text = @"登录/注册";
        _nameLabel.textAlignment = 1;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font =MFont(kFit(17));
        [bottomImage addSubview:_nameLabel];
        _nameLabel.sd_layout.leftSpaceToView(bottomImage, 0).topSpaceToView(_headImage, kFit(13.5)).rightSpaceToView(bottomImage, 0).heightIs(kFit(17));
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
