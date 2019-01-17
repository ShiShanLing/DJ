//
//  DJTaskApprovalTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskApprovalTableViewCell.h"


@interface DJTaskApprovalTableViewCell ()<UITextViewDelegate>

/**
 *
 */
@property (nonatomic, strong)UISwitch * approvalSwitch;

/**
 *cell分割线
 */
@property (nonatomic, strong)UILabel *dividerLabel ;
@end
@implementation DJTaskApprovalTableViewCell {
    
    UILabel *taskContentPrompLabel;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [UILabel new];
        _titleLabel.text =@"";
        _titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        _titleLabel.font = MFont(kFit(16));
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self.contentView, kFit(23)).topSpaceToView(self.contentView, kFit(20)).widthIs(120).heightIs(16);
        
        self.approvalSwitch = [[UISwitch alloc] init];
        
        _approvalSwitch.onTintColor =kColorRGB(252, 108, 75, 1);
        [_approvalSwitch addTarget:self action:@selector(handleApprovalSwitch:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.contentView addSubview:self.approvalSwitch];
        self.approvalSwitch.sd_layout.rightSpaceToView(self.contentView, kFit(15)).heightIs(kFit(25)).widthIs(kFit(53)).centerYEqualToView(_titleLabel);
        
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(23)).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0).topSpaceToView(_titleLabel, kFit(20));
        
        self.contentTV = [[UITextView alloc] init];
        _contentTV.text = @"";
        _contentTV.delegate = self;
        _contentTV.font = MFont(kFit(16));
        _contentTV.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_contentTV];
        _contentTV.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(_dividerLabel, kFit(15)).rightSpaceToView(self.contentView, 25).bottomSpaceToView(self.contentView, 10);
        taskContentPrompLabel = [UILabel new];
        taskContentPrompLabel.text = @"在此输入您的审批评议!";
        taskContentPrompLabel.enabled = NO;//lable必须设置为不可用
        taskContentPrompLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:taskContentPrompLabel];
        taskContentPrompLabel.sd_layout.leftSpaceToView(self.contentView, 20).topSpaceToView(_dividerLabel, kFit(20)).rightSpaceToView(self.contentView, 25).heightIs(25.5);
        
        
    }
    return self;
}

- (void)handleApprovalSwitch:(UISwitch *)sender {
    
    if ([_delegate respondsToSelector:@selector(isAgreeApply:)]) {
        [_delegate isAgreeApply:sender.isOn];
    }
     NSLog(@"%@", sender.isOn ? @"ON" : @"OFF");
    
}

- (void)setIsAgreeApply:(BOOL)isAgreeApply {
    if (isAgreeApply) {
        _approvalSwitch.on = YES;
    }else {
        _approvalSwitch.on = NO;
    }
    _isAgreeApply = isAgreeApply;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)textViewDidChange:(UITextView *)textView {
    
    BOOL flag=[NSString isContainsTwoEmoji:textView.text];//再次过滤
    if (flag){
        textView.text = [textView.text substringToIndex:textView.text.length -2];
    }
    
    if (textView.text.length > 300) {
        textView.text  = [textView.text substringToIndex:300];
        return;
    }
    if (textView.text.length == 0) {
        taskContentPrompLabel.text = @"在此输入您的审批评议";
    }else{
        taskContentPrompLabel.text = @"";
    }
    if ([_delegate respondsToSelector:@selector(taskContentChange:)]) {
        [_delegate taskContentChange:textView.text];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // 不让输入表情
    if ([textView isFirstResponder]) {
        NSLog(@"text%@", text);
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
        //判断键盘是不是九宫格键盘
        if ([NSString isNineKeyBoard:text] ){
            return YES;
        }else{
            if ([NSString hasEmoji:text] || [NSString stringContainsEmoji:text]){
                return NO;
            }
        }
        
        
        
    }
    if ([text isEqualToString:@"\n"]) {
        [_contentTV resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
