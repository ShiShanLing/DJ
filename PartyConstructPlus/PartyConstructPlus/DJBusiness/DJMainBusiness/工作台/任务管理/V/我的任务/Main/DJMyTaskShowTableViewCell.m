//
//  DJMyTaskShowTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/12.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMyTaskShowTableViewCell.h"

@implementation DJMyTaskShowTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        self.taskNameLabel = [UILabel new];
        _taskNameLabel.text = @"";
        _taskNameLabel.textColor = kColorRGB(51, 51, 51, 1);
        _taskNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(16)];
        
        [self.contentView addSubview:_taskNameLabel];
        _taskNameLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(self.contentView, kFit(10)).rightSpaceToView(self.contentView, kFit(28)).heightIs(kFit(18));
        
        
        self.taskTimeLabel= [UILabel new];
        _taskTimeLabel.textColor = kColorRGB(136, 136, 136, 1);
        _taskTimeLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_taskTimeLabel];
        _taskTimeLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(_taskNameLabel, kFit(10)).rightSpaceToView(self.contentView, kFit(28)).heightIs(kFit(16));
        
        
        self.taskStateLabel = [UILabel new];
        _taskStateLabel.textColor = kColorRGB(136, 136, 136, 1);
        _taskStateLabel.font = MFont(kFit(14));
        [self.contentView addSubview:_taskStateLabel];
        _taskStateLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).topSpaceToView(_taskTimeLabel, kFit(10)).rightSpaceToView(self.contentView, kFit(28)).heightIs(kFit(16));
        
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        
    }
    return self;
}

- (void)setModel:(IReceivedTaskModel *)model {
    
    _taskNameLabel.text = [model.taskName stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    _taskTimeLabel.text = [NSString stringWithFormat:@"%@于%@发起",model.sendUserName, model.createTime];
    //undo 待完成 complete 已完成 time_out 已超期 leaveing 请假待审批 leave_yes 请假通过 appealing 申诉待审批 appeal_yes 申诉成功
    NSString *status = [model.status stringByReplacingOccurrencesOfString:@" " withString:@""];
    model.status = status;
    if ([model.status isEqualToString:@"undo"]) {//待完成
        _taskStateLabel.textColor = kColorRGB(253, 115, 77, 1);
        _taskStateLabel.text = @"待完成";
    }else  if ([model.status isEqualToString:@"complete"]) {//已完成
        _taskStateLabel.textColor = kColorRGB(136, 136, 136, 1);
        _taskStateLabel.text = @"已完成";
    }else  if ([model.status isEqualToString:@"time_out"]) {//已超期
        _taskStateLabel.text = @"超期待补办";
        _taskStateLabel.textColor = kColorRGB(253, 115, 77, 1);
    }else  if ([model.status isEqualToString:@"leaveing"]) {//请假待审批
        _taskStateLabel.text = @"请假待审批";
        _taskStateLabel.textColor = kColorRGB(253, 115, 77, 1);
    }else  if ([model.status isEqualToString:@"leave_yes"]) {//请假通过
        _taskStateLabel.textColor = kColorRGB(136, 136, 136, 1);
        _taskStateLabel.text = @"请假通过";
    }else  if ([model.status isEqualToString:@"appealing"]) {//申诉待审批
        _taskStateLabel.text = @"申诉待审批";
        _taskStateLabel.textColor = kColorRGB(253, 115, 77, 1);
    }else if ([model.status isEqualToString:@"appeal_yes"]) {//申述通过
        _taskStateLabel.text = @"申诉通过";
        _taskStateLabel.textColor = kColorRGB(136, 136, 136, 1);
    }else if ([model.status isEqualToString:@"appeal_no"]) {//申述未通过
        _taskStateLabel.text = @"申诉未通过";
        _taskStateLabel.textColor = kColorRGB(253, 115, 77, 1);
    }else  if ([model.status isEqualToString:@"leave_no"]) {//请假通过
        _taskStateLabel.textColor = kColorRGB(253, 115, 77, 1);
        _taskStateLabel.text =@"请假未通过";
    }else if ([model.status isEqualToString:@"timeout_complete"]) {//请假通过
        _taskStateLabel.textColor = kColorRGB(136, 136, 136, 1);
        _taskStateLabel.text =@"已补办";
    }else{
        
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

@end
