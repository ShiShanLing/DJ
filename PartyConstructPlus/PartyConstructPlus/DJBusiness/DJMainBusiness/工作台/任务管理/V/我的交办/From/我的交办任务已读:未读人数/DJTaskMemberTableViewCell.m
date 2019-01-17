//
//  DJTaskMemberTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskMemberTableViewCell.h"

@implementation DJTaskMemberTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
   
        self.memberHeadPortraitImageView = [UIImageView new];
        _memberHeadPortraitImageView.image = [UIImage imageNamed:@"DJUserDefaultHead"];
        [self.contentView addSubview:_memberHeadPortraitImageView];
        _memberHeadPortraitImageView.sd_layout.leftSpaceToView(self.contentView, kFit(25)).widthIs(kFit(40)).heightIs(kFit(40)).centerYEqualToView(self.contentView);
        [_memberHeadPortraitImageView updateLayout];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_memberHeadPortraitImageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:_memberHeadPortraitImageView.bounds.size];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = _memberHeadPortraitImageView.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        _memberHeadPortraitImageView.layer.mask = maskLayer;
        
        self.membeNamerLabel = [UILabel new];
        _membeNamerLabel.text = @"";
        _membeNamerLabel.textColor = [UIColor blackColor];
        _membeNamerLabel.font = MFont(kFit(kFit(16)));
        [self.contentView addSubview:_membeNamerLabel];
//        _membeNamerLabel.sd_layout.leftSpaceToView(_memberHeadPortraitImageView, kFit(20)).widthIs(120).heightIs(kFit(16)).topSpaceToView(self.contentView, kFit(20));
        
        self.memberStateLable = [UILabel new];
        _memberStateLable.textColor = kColorRGB(253, 115, 77, 1);
        _memberStateLable.text = @"";
        _memberStateLable.hidden = YES;
        _memberStateLable.font = MFont(kFit(13));
        [self.contentView addSubview:_memberStateLable];
//        _memberStateLable.sd_layout.leftSpaceToView(_memberHeadPortraitImageView, kFit(20)).topSpaceToView(_membeNamerLabel, kFit(8)).widthIs(120).heightIs(kFit(16));
        
        
        self.rightArrowBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightArrowBtn setImage:[UIImage imageNamed:@"DJRegistrationRight"] forState:(UIControlStateNormal)];
        _rightArrowBtn.userInteractionEnabled = NO;
        _rightArrowBtn.hidden = NO;
        [self.contentView addSubview:_rightArrowBtn];
        _rightArrowBtn.sd_layout.rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(kFit(56));
       
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(_memberHeadPortraitImageView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)isRead:(NSString *)state {
    
    if ([state isEqualToString:@"n"]) {
        _rightArrowBtn.hidden = YES;
        _memberStateLable.hidden = YES;
        _membeNamerLabel.sd_layout.leftSpaceToView(_memberHeadPortraitImageView, kFit(20)).widthIs(120).heightIs(kFit(16)).centerYEqualToView(self.contentView);
    }else {
        _rightArrowBtn.hidden = NO;
        _memberStateLable.hidden = NO;
        _membeNamerLabel.sd_layout.leftSpaceToView(_memberHeadPortraitImageView, kFit(20)).widthIs(120).heightIs(kFit(16)).topSpaceToView(self.contentView, kFit(20));
        _memberStateLable.sd_layout.leftSpaceToView(_memberHeadPortraitImageView, kFit(20)).topSpaceToView(_membeNamerLabel, kFit(8)).widthIs(120).heightIs(kFit(16));
    }
    
}

- (void)setMemberModel:(IReceivedTaskModel *)memberModel {
    NSLog(@"memberModel%@", memberModel);
    _memberModel = memberModel;
    _membeNamerLabel.text = memberModel.userName;
    if ([memberModel.status isEqualToString:@"undo"]) {//待完成
        _memberStateLable.textColor = kColorRGB(253, 115, 77, 1);
        _memberStateLable.text = @"待完成";
    }else  if ([memberModel.status isEqualToString:@"complete"]) {//已完成
        _memberStateLable.textColor = kColorRGB(136, 136, 136, 1);
        _memberStateLable.text = @"已完成";
    }else  if ([memberModel.status isEqualToString:@"timeout_complete"]) {//已完成
        _memberStateLable.textColor = kColorRGB(136, 136, 136, 1);
        _memberStateLable.text = @"已补办";
    }else  if ([memberModel.status isEqualToString:@"time_out"]) {//已超期
        _memberStateLable.text = @"任务超期待补办";
        _memberStateLable.textColor = kColorRGB(253, 115, 77, 1);
    }else  if ([memberModel.status isEqualToString:@"leaveing"]) {//请假待审批
        _memberStateLable.text = @"请假待审批";
        _memberStateLable.textColor = kColorRGB(253, 115, 77, 1);
    }else  if ([memberModel.status isEqualToString:@"leave_yes"]) {//请假通过
        _memberStateLable.textColor = kColorRGB(136, 136, 136, 1);
        _memberStateLable.text =@"请假已通过";
    }else  if ([memberModel.status isEqualToString:@"appealing"]) {//申诉待审批
        _memberStateLable.text =@"申诉待审批";
        _memberStateLable.textColor = kColorRGB(253, 115, 77, 1);
    }else if ([memberModel.status isEqualToString:@"appeal_yes"]) {//申诉通过
        _memberStateLable.text = @"申诉已通过";
        _memberStateLable.textColor = kColorRGB(136, 136, 136, 1);
    }else if ([memberModel.status isEqualToString:@"appeal_no"]) {//申诉通过
        _memberStateLable.text = @"申诉未通过";
        _memberStateLable.textColor = kColorRGB(253, 115, 77, 1);
    }else  if ([memberModel.status isEqualToString:@"leave_no"]) {//请假通过
        _memberStateLable.textColor = kColorRGB(253, 115, 77, 1);
        _memberStateLable.text =@"请假未通过";
    }else{
        
    }
    
    if ([memberModel.userHeadUrl isURL]) {
        [_memberHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",memberModel.userHeadUrl]] placeholderImage:[UIImage imageNamed:@"DJUserDefaultHead"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }else {
        [_memberHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",memberModel.dfsUrl,memberModel.userHeadUrl]] placeholderImage:[UIImage imageNamed:@"DJUserDefaultHead"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
    
    
}

@end
