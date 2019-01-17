//
//  DJTaskORgChooseTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/6.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskORgChooseTableViewCell.h"

@implementation DJTaskORgChooseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.orgChooseStateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_orgChooseStateBtn setImage:[UIImage  imageNamed:@"DJLeaveOff"] forState:(UIControlStateNormal)];
        [_orgChooseStateBtn addTarget:self action:@selector(handleOrgChooseStateBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:_orgChooseStateBtn];
        _orgChooseStateBtn.sd_layout.leftSpaceToView(self.contentView, 5).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(40);
      
        self.orgNameLabel = [UILabel new];
        _orgNameLabel.text = @"";
        _orgNameLabel.numberOfLines = 2;
        [self.contentView addSubview:_orgNameLabel];
        _orgNameLabel.sd_layout.leftSpaceToView(_orgChooseStateBtn, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, kFit(120));
        
        self.arrowBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        _arrowBtn.backgroundColor = kCellColorDivider;
        [_arrowBtn setImage:[UIImage imageNamed:@"DJRegistrationRight"] forState:(UIControlStateNormal)];
        _arrowBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_arrowBtn];
        _arrowBtn.sd_layout.rightSpaceToView(self.contentView, kFit(10)).heightIs(kFit(50)).centerYEqualToView(self.contentView).widthIs(18);
        
        self.selectedNumStateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_selectedNumStateBtn setImage:[UIImage imageNamed:@"DJ_distrTask_org_chooseJobs"] forState:(UIControlStateNormal)];
//        [_selectedNumStateBtn setTitle:@"已选100人" forState:(UIControlStateNormal)];
        _selectedNumStateBtn.titleLabel.font = MFont(kFit(15));
        [_selectedNumStateBtn setTitleColor:kColorRGB(87, 122, 246, 1) forState:(UIControlStateNormal)];
        [_selectedNumStateBtn addTarget:self action:@selector(handleSelectedNumStateBtn) forControlEvents:(UIControlEventTouchUpInside)];
        _selectedNumStateBtn.titleLabel.textAlignment = 2;
        UIEdgeInsets edge  = _selectedNumStateBtn.imageEdgeInsets;
        edge.right = -kFit(30);
        NSLog(@"edge.right%f", edge.right);
        _selectedNumStateBtn.imageEdgeInsets = edge;
        [self.contentView addSubview:_selectedNumStateBtn];
        _arrowBtn.sd_layout.rightSpaceToView(self.contentView, kFit(20)).heightIs(kFit(50)).centerYEqualToView(self.contentView).widthIs(18);
        _selectedNumStateBtn.sd_layout.rightSpaceToView(_arrowBtn, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(kFit(80));
        

        UILabel *dividerLabel = [UILabel new];
        dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:dividerLabel];
        dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        
    }
    return self;
}
//选择该组织 或者 反选该组织
- (void)handleOrgChooseStateBtn {
    if ([_delegate respondsToSelector:@selector(OrgChooseStateBtn:)]) {
        [_delegate OrgChooseStateBtn:self.indexPath];
    }
}

- (void)handleSelectedNumStateBtn {
    if ([_delegate respondsToSelector:@selector(peopleChooseStateBtn:)]) {
        [_delegate peopleChooseStateBtn:self.indexPath];
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(LowerOrgModel *)model {
    NSLog(@"LowerOrgModel%@", model);
    if ([model.isSelectAll isEqualToString:@"1"]) {
        [_orgChooseStateBtn setImage:[UIImage  imageNamed:@"DJLeaveOn"] forState:(UIControlStateNormal)];
    }else {
        [_orgChooseStateBtn setImage:[UIImage  imageNamed:@"DJLeaveOff"] forState:(UIControlStateNormal)];
    }
    if (_indexPath.row == 0) {
        UIEdgeInsets edge  = _selectedNumStateBtn.imageEdgeInsets;
        edge.right = 0;
        NSLog(@"model.chooseNum%@", model.chooseNum);
        if (model.chooseNum.intValue  == 0 ||model.chooseNum == nil ||model.chooseNum == NULL) {
            [_selectedNumStateBtn setImage:[UIImage imageNamed:@"DJ_distrTask_org_chooseJobs"] forState:(UIControlStateNormal)];
            [_selectedNumStateBtn setTitle:@"" forState:(UIControlStateNormal)];
        }else {
            [_selectedNumStateBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
            [_selectedNumStateBtn setTitle:[NSString stringWithFormat:@"已选%@人", model.chooseNum] forState:(UIControlStateNormal)];
        }
        _selectedNumStateBtn.imageEdgeInsets = edge;
          _selectedNumStateBtn.sd_layout.rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(kFit(80));
        [_selectedNumStateBtn updateLayout];
        _arrowBtn.backgroundColor = kCellColorDivider;
        [_arrowBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        _arrowBtn.sd_layout.rightSpaceToView(_selectedNumStateBtn, 1).heightIs(20).centerYEqualToView(self.contentView).widthIs(kCellDividerHeight);
        _orgNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(16)];
    }else {
        UIEdgeInsets edge  = _selectedNumStateBtn.imageEdgeInsets;
        edge.right = -kFit(30);
        NSLog(@"edge.right%f", edge.right);
        _selectedNumStateBtn.imageEdgeInsets = edge;
        _arrowBtn.sd_layout.rightSpaceToView(self.contentView, kFit(10)).heightIs(kFit(50)).centerYEqualToView(self.contentView).widthIs(18);
        _selectedNumStateBtn.sd_layout.rightSpaceToView(_arrowBtn, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(kFit(80));
        _arrowBtn.backgroundColor = [UIColor whiteColor];
        [_arrowBtn setImage:[UIImage imageNamed:@"DJRegistrationRight"] forState:(UIControlStateNormal)];
          _orgNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(15)];
        if (model.chooseNum.intValue  == 0 ||model.chooseNum == nil ||model.chooseNum == NULL) {
            [_selectedNumStateBtn setImage:[UIImage imageNamed:@"DJ_distrTask_org_chooseJobs"] forState:(UIControlStateNormal)];
            [_selectedNumStateBtn setTitle:@"" forState:(UIControlStateNormal)];
        }else {
            [_selectedNumStateBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
            [_selectedNumStateBtn setTitle:[NSString stringWithFormat:@"已选%@人", model.chooseNum] forState:(UIControlStateNormal)];
        }
    }
    _orgNameLabel.text = model.name;
    
}

-(void)setSearchOrgModel:(LowerOrgModel *)searchOrgModel {
    _searchOrgModel = searchOrgModel;
    if ([searchOrgModel.isSelectAll isEqualToString:@"1"]) {
        [_orgChooseStateBtn setImage:[UIImage  imageNamed:@"DJLeaveOn"] forState:(UIControlStateNormal)];
    }else {
        [_orgChooseStateBtn setImage:[UIImage  imageNamed:@"DJLeaveOff"] forState:(UIControlStateNormal)];
    }
    UIEdgeInsets edge  = _selectedNumStateBtn.imageEdgeInsets;
    edge.right = 0;
    NSLog(@"model.chooseNum%@", searchOrgModel.chooseNum);
    if (searchOrgModel.chooseNum.intValue  == 0 ||searchOrgModel.chooseNum == nil ||searchOrgModel.chooseNum == NULL) {
        [_selectedNumStateBtn setImage:[UIImage imageNamed:@"DJ_distrTask_org_chooseJobs"] forState:(UIControlStateNormal)];
        [_selectedNumStateBtn setTitle:@"" forState:(UIControlStateNormal)];
    }else {
        [_selectedNumStateBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        [_selectedNumStateBtn setTitle:[NSString stringWithFormat:@"已选%@人", searchOrgModel.chooseNum] forState:(UIControlStateNormal)];
    }
    _selectedNumStateBtn.imageEdgeInsets = edge;
    _selectedNumStateBtn.sd_layout.rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(kFit(80));
    [_selectedNumStateBtn updateLayout];
    _arrowBtn.backgroundColor = kCellColorDivider;
    [_arrowBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
    _arrowBtn.sd_layout.rightSpaceToView(_selectedNumStateBtn, 1).heightIs(20).centerYEqualToView(self.contentView).widthIs(kCellDividerHeight);
    _orgNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(16)];
    _orgNameLabel.text = searchOrgModel.name;
}

@end
