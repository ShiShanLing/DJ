//
//  DJTaskNameEditorTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/17.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskNameEditorTableViewCell.h"


#define MAXSTRINGLENGTH 28
@interface DJTaskNameEditorTableViewCell ()<UITextViewDelegate>



@end

@implementation DJTaskNameEditorTableViewCell {
    
    UILabel * taskNamePrompLabel;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.taskNameTV = [[UITextView alloc] init];
        _taskNameTV.text = @"";
        _taskNameTV.delegate = self;
        _taskNameTV.font = MFont(kFit(16));
        [self.contentView addSubview:_taskNameTV];
        _taskNameTV.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 25).bottomSpaceToView(self.contentView, 4);
        taskNamePrompLabel = [UILabel new];
        _taskNameTV.returnKeyType = UIReturnKeyDone;
        taskNamePrompLabel.text = @"请在此输入任务主题";
        taskNamePrompLabel.enabled = NO;//lable必须设置为不可用
        taskNamePrompLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:taskNamePrompLabel];
        taskNamePrompLabel.sd_layout.leftSpaceToView(self.contentView, 20).topSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 25).bottomSpaceToView(self.contentView, 10);
        
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kColorRGB(225, 225, 225, 1);
        
        _dividerLabel.alpha = 0.7;
        [self.contentView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0.5).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        
    
        
    }
    return self;
}



-(void)textViewDidChange:(UITextView *)textView {
    BOOL flag=[NSString isContainsTwoEmoji:textView.text];//再次过滤
    if (flag){
        textView.text = [textView.text substringToIndex:textView.text.length -2];
    }

    NSString *lang = [[[UITextInputMode activeInputModes] firstObject] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        UITextRange *range = [textView markedTextRange];
        UITextPosition *start = range.start;
        UITextPosition*end = range.end;
        NSInteger selectLength = [textView offsetFromPosition:start toPosition:end];
        NSInteger contentLength = textView.text.length - selectLength;
        
        if (contentLength > MAXSTRINGLENGTH)
        {
            textView.text = [textView.text substringToIndex:MAXSTRINGLENGTH];
            
        }
        if (contentLength < MAXSTRINGLENGTH){
          
        }else{
            
        }
    }else{
        
        if (textView.text.length > MAXSTRINGLENGTH)
        {
            textView.text = [textView.text substringToIndex:MAXSTRINGLENGTH];

        }
        
    }
        if (textView.text.length == 0) {
            taskNamePrompLabel.text = self.promptCopywriting;
        }else{
            taskNamePrompLabel.text = @"";
        }
    if ([_delegate respondsToSelector:@selector(taskNameChange:)]) {
        [_delegate taskNameChange:textView.text];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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
        [_taskNameTV resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//警告
-(void)ShowWarningHudMid:(NSString *)message {
    
    MBProgressHUD *warning = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    warning.mode = MBProgressHUDModeText;
    warning.label.text = message;
    warning.label.textColor = [UIColor whiteColor];;
    warning.label.lineBreakMode = NSLineBreakByWordWrapping;
    warning.label.numberOfLines = 0;
    warning.bezelView.backgroundColor = [UIColor blackColor];
    warning.bezelView.alpha = 0.8;
    warning.offset = CGPointMake(0.f, 100);
    [warning hideAnimated:YES afterDelay:1.0f];
}
- (void)setPromptCopywriting:(NSString *)promptCopywriting {
    _promptCopywriting = promptCopywriting;
    taskNamePrompLabel.text = promptCopywriting;
}
@end
