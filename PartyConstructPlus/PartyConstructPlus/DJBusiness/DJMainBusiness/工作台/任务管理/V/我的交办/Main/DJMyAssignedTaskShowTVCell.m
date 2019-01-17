//
//  DJMyAssignedTaskShowTVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/12.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMyAssignedTaskShowTVCell.h"
#import "UserData.h"

@interface DJMyAssignedTaskShowTVCell ()
@property(nonatomic, strong)CAGradientLayer *gradientLayer;
@end

@implementation DJMyAssignedTaskShowTVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        self.taskNameLabel = [UILabel new];
        _taskNameLabel.text = @"";
        _taskNameLabel.textColor = kColorRGB(51, 51, 51, 1);
        _taskNameLabel.font = MFont(kFit(16));
        [self.contentView addSubview:_taskNameLabel];
        _taskNameLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, kFit(13)).rightSpaceToView(self.contentView, kFit(28)).heightIs(kFit(18));
        
        
        self.taskTimeLabel= [UILabel new];
        _taskTimeLabel.textColor = kColorRGB(136, 136, 136, 1);
        _taskTimeLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_taskTimeLabel];
        _taskTimeLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(_taskNameLabel, kFit(10)).rightSpaceToView(self.contentView, kFit(28)).heightIs(kFit(16));
        
        
        self.backgroundLabel = [UILabel new];
        _backgroundLabel.layer.cornerRadius = 10;
        _backgroundLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_backgroundLabel];
        _backgroundLabel.sd_layout.leftSpaceToView(self.contentView, -10).topSpaceToView(_taskTimeLabel, kFit(10)).widthIs(kFit(77)+10).heightIs(20);
        //初始化CAGradientlayer对象，使它的大小为UIView的大小
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _backgroundLabel.bounds;
        //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
        [_backgroundLabel.layer addSublayer:gradientLayer];
        //设置渐变区域的起始和终止位置（范围为0-1）
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.cornerRadius =10;
        //设置颜色数组
        gradientLayer.colors = @[(__bridge id)kColorRGB(251, 88, 68, 1).CGColor,
                                      (__bridge id)kColorRGB(254, 141, 85, 1).CGColor];
        //设置颜色分割点（范围：0-1）
        gradientLayer.locations = @[@(0.3f), @(1.0f)];
        self.gradientLayer = gradientLayer;
        self.taskStateLabel = [UILabel new];
        _taskStateLabel.textColor = kColorRGB(136, 136, 136, 1);
        _taskStateLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_taskStateLabel];
        _taskStateLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(_taskTimeLabel, kFit(10)).rightSpaceToView(self.contentView, kFit(28)).heightIs(20);
        
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        
    }
    return self;
}

- (void)setModel:(IReceivedTaskModel *)model {
    _taskNameLabel.text = model.taskName;
    UserData  *userModel = [DJUserTool getUserInfo];
    _taskTimeLabel.text = [NSString stringWithFormat:@"%@于%@发起",userModel.name, model.createTime];
    if ([model.readNum isEqualToString:model.totalNum]) {
        _taskStateLabel.text = @"全部已读";
        _taskStateLabel.textColor = kColorRGB(136, 136, 136, 1);
        _backgroundLabel.hidden = YES;
    }else {
        _taskStateLabel.text = [NSString stringWithFormat:@"%@已读/%@",model.readNum, model.totalNum];
        
        _taskStateLabel.textColor = [UIColor whiteColor];
        _backgroundLabel.hidden = NO;
        _backgroundLabel.sd_layout.leftSpaceToView(self.contentView, -10).topSpaceToView(_taskTimeLabel, kFit(10)).widthIs((_taskStateLabel.text.length * kFit(13))+kFit(25)).heightIs(20);
        [_backgroundLabel updateLayout];
        self.gradientLayer.frame = _backgroundLabel.bounds;
    }
    
}

@end
