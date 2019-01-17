//
//  DJTaskTagSelectTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/25.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskTagSelectTableViewCell.h"

@interface DJTaskTagSelectTableViewCell ()
@property (nonatomic, strong)UILabel *titleLabel;
/**
 *
 */
@property (nonatomic, strong)UIButton * stateImageBtn;
@end

@implementation DJTaskTagSelectTableViewCell

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
   
        self.stateImageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_stateImageBtn setImage:[UIImage imageNamed:@"DJLeaveOff"] forState:(UIControlStateNormal)];
        _stateImageBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_stateImageBtn];
        _stateImageBtn.sd_layout.leftSpaceToView(self.contentView, kFit(15)).centerYEqualToView(self.contentView).widthIs(24).heightIs(24);
        
        self.titleLabel = [UILabel new];
        _titleLabel.text =@"";
        _titleLabel.textColor = kColorRGB(0, 0, 0, 1);
        _titleLabel.font = MFont(kFit(16));
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(_stateImageBtn, kFit(9)).rightSpaceToView(self.contentView, kFit(15)).heightIs(kFit(16)).centerYEqualToView(self.contentView);
        
        
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    
    _indexPath = indexPath;
    if (indexPath.row != 0) {
        _stateImageBtn.sd_layout.leftSpaceToView(self.contentView, kFit(43)).centerYEqualToView(self.contentView).widthIs(24).heightIs(24);
    }else {
        _stateImageBtn.sd_layout.leftSpaceToView(self.contentView, kFit(15)).centerYEqualToView(self.contentView).widthIs(24).heightIs(24);
    }
    [_stateImageBtn updateLayout];
}

-(void)setDataDic:(NSDictionary *)dataDic  {
    _dataDic = dataDic;
    _titleLabel.text =dataDic[@"title"];
    if ([dataDic[@"state"] isEqualToString:@"0"]) {
        [_stateImageBtn setImage:[UIImage imageNamed:@"DJLeaveOff"] forState:(UIControlStateNormal)];
    }else if ([dataDic[@"state"] isEqualToString:@"1"]){
        [_stateImageBtn setImage:[UIImage imageNamed:@"DJLeaveOn"] forState:(UIControlStateNormal)];
    }else {
        [_stateImageBtn setImage:[UIImage imageNamed:@"DJLeaveDisable"] forState:(UIControlStateNormal)];
    }
    
}
@end
