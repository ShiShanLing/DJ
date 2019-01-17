//
//  DJTaskContentEditorTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/17.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskContentEditorTableViewCell.h"
#define MAXSTRINGLENGTH 300

@interface DJTaskContentEditorTableViewCell ()<UITextViewDelegate>

@end

@implementation DJTaskContentEditorTableViewCell{
    
    UILabel * taskContentPrompLabel;
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.taskContentTV = [[UITextView alloc] init];
        _taskContentTV.text = @"";
        _taskContentTV.delegate = self;
        _taskContentTV.font = MFont(kFit(16));
        _taskContentTV.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_taskContentTV];
        _taskContentTV.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 25).bottomSpaceToView(self.contentView, 10);
        taskContentPrompLabel = [UILabel new];
        
        taskContentPrompLabel.text = @"请在次输入任务内容";
        taskContentPrompLabel.enabled = NO;//lable必须设置为不可用
        taskContentPrompLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:taskContentPrompLabel];
        taskContentPrompLabel.sd_layout.leftSpaceToView(self.contentView, 20).topSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 25).heightIs(25.5);
        
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kColorRGB(225, 225, 225, 1);
        
        _dividerLabel.alpha = 0.7;
        [self.contentView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(15)).bottomSpaceToView(self.contentView, 0.5).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        

    }
    return self;
}

-(void)textViewDidChange:(UITextView *)textView {
    
    BOOL flag=[NSString isContainsTwoEmoji:textView.text];
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
        taskContentPrompLabel.text = self.promptCopywriting;
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
        [_taskContentTV resignFirstResponder];
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

- (void)setPromptCopywriting:(NSString *)promptCopywriting {
    _promptCopywriting = promptCopywriting;
    taskContentPrompLabel.text = promptCopywriting;
}
@end
