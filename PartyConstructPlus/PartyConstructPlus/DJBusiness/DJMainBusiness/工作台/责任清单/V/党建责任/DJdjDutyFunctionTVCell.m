//
//  DJdjDutyFunctionTVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJdjDutyFunctionTVCell.h"
#import "MsgView.h"

@implementation DJdjDutyFunctionTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *shadowViewImage = [[UIImageView alloc] init];
        shadowViewImage.image = [UIImage pathPngFile:@"DJ_djzr"];
        shadowViewImage.clipsToBounds = YES;
        [self.contentView addSubview:shadowViewImage];
        shadowViewImage.sd_layout.leftSpaceToView(self.contentView, kFit(5)).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, kFit(5)).bottomSpaceToView(self.contentView, -5);
        self.showImageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_showImageBtn setImage:[UIImage imageNamed:@"DJ_gzxsl"] forState:(UIControlStateNormal)];
        _showImageBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_showImageBtn];
        _showImageBtn.sd_layout.leftSpaceToView(self.contentView, kFit(25)).widthIs(kFit(65)).heightIs(kFit(65)).topSpaceToView(self.contentView, kFit(32));
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(17)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"";
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(_showImageBtn, kFit(20)).heightIs(kFit(20)).widthIs(kFit(120)).centerYEqualToView(self.contentView);

        self.redView = [[MsgView alloc] init];
        _redView.hidden = YES;
        [self.contentView addSubview:_redView];
        _redView.sd_layout.rightSpaceToView(self.contentView, kFit(30)).heightIs(kFit(20)).centerYEqualToView(self.contentView).widthIs(kFit(100));
        
    }
    return self;
}

- (void)ChangeLayout {

    _showImageBtn.sd_layout.leftSpaceToView(self.contentView, kFit(21)).widthIs(kFit(70)).heightIs(kFit(70)).bottomSpaceToView(self.contentView, kFit(19));
    
}
@end
