//
//  DJMapOrgShowTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/20.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMapOrgShowTableViewCell.h"

@implementation DJMapOrgShowTableViewCell

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
   
        
        self.navigationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        _navigationBtn.backgroundColor = [UIColor yellowColor];
        [_navigationBtn setImage:[UIImage imageNamed:@"DJ_map_goOrg"] forState:(UIControlStateNormal)];
        _navigationBtn.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_navigationBtn setTitle:@"前往" forState:(UIControlStateNormal)];
        [_navigationBtn setTitleColor:kColorRGB(100, 112, 134, 1) forState:(UIControlStateNormal)];
        [_navigationBtn addTarget:self action:@selector(handleNavigationBtn) forControlEvents:(UIControlEventTouchUpInside)];
        _navigationBtn.titleLabel.font = MFont(kFit(11));
        [self.contentView addSubview:_navigationBtn];
        _navigationBtn.sd_layout.rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(kFit(60));
        
        [_navigationBtn updateLayout];

        [_navigationBtn setTitleEdgeInsets:UIEdgeInsetsMake(_navigationBtn.imageView.frame.size.height ,-_navigationBtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [_navigationBtn setImageEdgeInsets:UIEdgeInsetsMake(-_navigationBtn.imageView.frame.size.height+5, 0.0,0.0, -_navigationBtn.titleLabel.bounds.size.width)];
      
        
        self.orgName = [UILabel new];
        _orgName.font = [UIFont fontWithName:@"Helvetica-Bold"  size:kFit(17)];
        _orgName.textColor = kColorRGB(51, 51, 51, 1);
        [self.contentView addSubview:_orgName];
        _orgName.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, kFit(20)).heightIs(kFit(18)).rightSpaceToView(_navigationBtn, kFit(15));
        
        self.orgLocationLabel = [UILabel new];
        _orgLocationLabel.textColor = kColorRGB(136, 136, 136, 1);
        _orgLocationLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_orgLocationLabel];
        _orgLocationLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(_orgName, kFit(10)).heightIs(kFit(15)).rightSpaceToView(_navigationBtn, kFit(15));
        
        self.phoneLabel = [[UILabel alloc] init];
        _phoneLabel.userInteractionEnabled = YES;
        _phoneLabel.textColor = kColorRGB(0, 139, 246, 1);
        _phoneLabel.hidden = YES;
        _phoneLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_phoneLabel];
        _phoneLabel.sd_layout.leftSpaceToView(self.contentView, kFit(12)).topSpaceToView(_orgLocationLabel, kFit(10)).heightIs(kFit(15)).rightSpaceToView(self.contentView, kFit(15));
        UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handlePhoneBtn)];
        phoneTap.numberOfTouchesRequired = 1; //手指数
        phoneTap.numberOfTapsRequired = 1; //tap次数
        phoneTap.delegate = self;
        
        [_phoneLabel addGestureRecognizer:phoneTap];

//        /**RGBA
//         *cell分割线
//         */
//        UILabel *_dividerLabel = [UILabel new];
//        _dividerLabel.backgroundColor = kCellColorDivider;
//        [self.contentView addSubview:_dividerLabel];
//        _dividerLabel.sd_layout.leftSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        
        
    }
    return self;
}

#pragma mark  DJMapOrgShowTableViewCellDelegate
- (void)handleNavigationBtn {
    if ([_delegate respondsToSelector:@selector(navigationGoToOrg:)]) {
        [_delegate navigationGoToOrg:self.indexPath];
    }
}

- (void)handlePhoneBtn {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phoneStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
@end
