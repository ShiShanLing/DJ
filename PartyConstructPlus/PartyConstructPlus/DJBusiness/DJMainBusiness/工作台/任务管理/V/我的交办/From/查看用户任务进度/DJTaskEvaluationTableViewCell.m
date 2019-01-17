//
//  DJTaskEvaluationTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskEvaluationTableViewCell.h"
#import "DJStarsCommentsView.h"
@interface DJTaskEvaluationTableViewCell ()<UITextViewDelegate, DJStarsCommentsViewDelegate>

@property (nonatomic, strong)DJStarsCommentsView *starsView;
/**
 *
 */
@property (nonatomic, strong)UILabel * titleLabel;
/**
 *cell分割线
 */
@property (nonatomic, strong)UILabel *dividerLabel ;
/**
 *
 */
@property (nonatomic, strong)UIImageView * promptImageView;
/**
 *
 */
@property (nonatomic, strong)UILabel * promptLabel;

@end

@implementation DJTaskEvaluationTableViewCell {
    UILabel *taskContentPrompLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [UILabel new];
        _titleLabel.text = @"任务完成得怎么样?来评价一下吧!";
        _titleLabel.textColor = kColorRGB(136, 136, 136, 1);
        _titleLabel.font= MFont(kFit(14));
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self.contentView, kFit(23)).topSpaceToView(self.contentView, kFit(20)).rightSpaceToView(self.contentView, kFit(25)).heightIs(14);
        
        self.starsView = [[DJStarsCommentsView alloc] initStarsViewWithFrame:CGRectMake(0, 0, kFit(176), kFit(20))];
        _starsView.delegate = self;
        [self.contentView addSubview:_starsView];
        _starsView.sd_layout.topSpaceToView(_titleLabel, kFit(10)).widthIs(kFit(176)).heightIs(kFit(20)).centerXEqualToView(self.contentView);
        {//当用户选择完星级之后
            self.promptImageView = [UIImageView new];
            _promptImageView.image = [UIImage imageNamed:@"DJ_task_evaluation_prompt"];
            _promptImageView.hidden = YES;
            
            [self.contentView addSubview:_promptImageView];
            _promptImageView.sd_layout.widthIs(kFit(199)).heightIs(kFit(47)).topSpaceToView(_starsView, kFit(8)).centerXEqualToView(self.contentView);
            
            self.promptLabel = [UILabel new];
            _promptLabel.text = @"";
            _promptLabel.hidden = YES;
            _promptLabel.textColor = kColorRGB(153, 153, 153, 1);
            _promptLabel.font = MFont(kFit(13));
            _promptLabel.textAlignment = 1;
            [self.contentView addSubview:_promptLabel];
            _promptLabel.sd_layout.widthIs(kFit(199)).topSpaceToView(_starsView, kFit(26)).heightIs(kFit(18.5)).centerXEqualToView(self.contentView);
            
        }
        self.dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [self.contentView addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(23)).topSpaceToView(_starsView, kFit(20)).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
        
        self.contentTV = [[UITextView alloc] init];
        _contentTV.text = @"";
        _contentTV.delegate = self;
        _contentTV.font = MFont(kFit(16));
        _contentTV.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_contentTV];
        _contentTV.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(_dividerLabel, kFit(15)).rightSpaceToView(self.contentView, 25).bottomSpaceToView(self.contentView, 10);
        
        taskContentPrompLabel = [UILabel new];
        taskContentPrompLabel.text = @"试试分享您的看法吧!";
        taskContentPrompLabel.enabled = NO;//lable必须设置为不可用
        taskContentPrompLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:taskContentPrompLabel];
        taskContentPrompLabel.sd_layout.leftSpaceToView(self.contentView, 20).topSpaceToView(_dividerLabel, kFit(20)).rightSpaceToView(self.contentView, 25).heightIs(25.5);
    }
    return self;
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
        taskContentPrompLabel.text = @"试试分享您的看法吧!";
    }else{
        taskContentPrompLabel.text = @"";
    }
    if ([_delegate respondsToSelector:@selector(EvaluationContentChange:)]) {
        [_delegate EvaluationContentChange:textView.text];
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
- (void)UserschangeCheck:(NSInteger)count {
    if (_promptImageView.hidden) {
        if ([_delegate respondsToSelector:@selector(InterfaceStyle:)]) {
            [_delegate InterfaceStyle:count];
        }
    }
    _promptImageView.hidden = NO;
    _promptLabel.hidden = NO;
    _dividerLabel.sd_layout.leftSpaceToView(self.contentView, kFit(23)).topSpaceToView(_promptImageView, kFit(20)).heightIs(kCellDividerHeight).rightSpaceToView(self.contentView, 0);
    switch (count) {
        case 0:
            
            break;
        case 1:
            self.promptLabel.text = @"要加油哦!";
            break;
        case 2:
            self.promptLabel.text = @"要加油哦!";
            break;
        case 3:
            self.promptLabel.text = @"还可以更好哦!";
            break;
        case 4:
            self.promptLabel.text = @"还可以更好哦!";
            break;
        case 5:
            self.promptLabel.text = @"完美";
            break;
        default:
            break;
    }

}

- (void)setPromptCopywriting:(NSString *)promptCopywriting {
    _promptCopywriting = promptCopywriting;
    taskContentPrompLabel.text = promptCopywriting;
}

@end
