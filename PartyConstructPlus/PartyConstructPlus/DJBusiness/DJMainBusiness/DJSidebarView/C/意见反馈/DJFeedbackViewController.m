//
//  DJFeedbackViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/22.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJFeedbackViewController.h"
#import "ChangeColourView.h"
@interface DJFeedbackViewController ()<UITextFieldDelegate, UITextViewDelegate, ChangeColourViewDelegate>
/**
 联系方式
 */
@property (nonatomic, strong)UITextField *contactTF;
/**
 *内容
 */
@property (nonatomic, strong)UITextView * contentTV;
/**
 *
 */
@property (nonatomic, strong)ChangeColourView * confirmBtn;
@end

@implementation DJFeedbackViewController{
    
    UILabel * taskContentPrompLabel;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    DJ_App_download
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak DJFeedbackViewController *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(236))];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    self.contactTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, kFit(50))];
    _contactTF.delegate = self;
    _contactTF.keyboardType = UIKeyboardTypeASCIICapable;
    _contactTF.borderStyle = UITextBorderStyleNone;
    _contactTF.placeholder = @"请输入您的联系方式（邮箱或电话）";
    _contactTF.returnKeyType = UIReturnKeyNext;
    [bottomView addSubview:_contactTF];
    
    UILabel *_dividerLabel = [UILabel new];
    _dividerLabel.backgroundColor = kCellColorDivider;
    [bottomView addSubview:_dividerLabel];
    _dividerLabel.sd_layout.leftSpaceToView(bottomView, 15).topSpaceToView(_contactTF, 0).heightIs(kCellDividerHeight).rightSpaceToView(bottomView, 0);
    
    self.contentTV = [[UITextView alloc] init];
    _contentTV.text = @"";
    _contentTV.delegate = self;
    _contentTV.font = MFont(kFit(16));
    _contentTV.returnKeyType = UIReturnKeyDone;
    [bottomView addSubview:_contentTV];
    _contentTV.sd_layout.leftSpaceToView(bottomView, 10).topSpaceToView(_dividerLabel, 10).rightSpaceToView(bottomView, 25).bottomSpaceToView(bottomView, 10);
    taskContentPrompLabel = [UILabel new];
    taskContentPrompLabel.numberOfLines = 0;
    taskContentPrompLabel.textColor =  kColorRGB(199, 199, 205, 1);
    taskContentPrompLabel.text = @"我们一直致力于杭州党建责任APP的优化与提升，您的意见与建议对我们来说尤为宝贵，感谢您的反馈。";
    taskContentPrompLabel.userInteractionEnabled = NO;//lable必须设置为不可用
    
    taskContentPrompLabel.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:taskContentPrompLabel];
    taskContentPrompLabel.sd_layout.leftSpaceToView(bottomView, 15).topSpaceToView(_dividerLabel, 10).rightSpaceToView(bottomView, 25).heightIs(kFit(72));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue) name:UITextFieldTextDidChangeNotification object:_contactTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue) name:UITextFieldTextDidChangeNotification object:_contentTV];
    
    
    self.confirmBtn = [[ChangeColourView alloc] initWithFrame:CGRectMake(0, kFit(236), kScreenWidth, kFit(85))];
    
    [_confirmBtn.ContinueBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _confirmBtn.delegate = self;
    [_confirmBtn.ContinueBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [self.view addSubview:_confirmBtn];


}

- (void)handleExitOrg {
    
    if (![DJZhengZe isEmail:_contactTF.text] && ![DJZhengZe isMobileNumber:_contactTF.text] ) {
        
        [self ShowWarningHudMid:@"请输入正确的邮箱或手机号"];
        return;
    }
    NSInteger blankNum = 0;
    for (int i  = 0; i < _contentTV.text.length; i++) {
        NSString *str = [_contentTV.text substringWithRange:NSMakeRange(i,1)];
        if ([str isEqualToString:@" "]) {
            blankNum ++;
        }
    }
    if (blankNum == _contentTV.text.length) {
        [self ShowWarningHudMid:@"请输入您对该app的宝贵意见或建议"];
        return;
    }
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:_contactTF.text forKey:@"conInfo"];
    [URL_Dic setValue:_contentTV.text forKey:@"content"];
    
    [self getJSONDataWithUrl:kURL_Feedback parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"handleExitOrg%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@" , responseObject[@"code"]];
        
        if ([code isEqualToString:@"0"]) {
            
            [self ShowWarningHudMid:@"提交成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//检测键盘text的变动
- (void)textFieldDidChangeValue {
    
    
    
    
    if (_contentTV.text.length != 0 && _contactTF.text.length != 0) {
        _confirmBtn.ContinueBtn.userInteractionEnabled = YES;
        _confirmBtn.gradientLayer.hidden = NO;
    }else {
        _confirmBtn.ContinueBtn.userInteractionEnabled = NO;
        _confirmBtn.gradientLayer.hidden = YES;
    }
    

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
        
        if (contentLength > 300)
        {
            textView.text = [textView.text substringToIndex:300];
            [self ShowWarningHudMid:@"最多输入 300 个文字" ];
        }
        if (contentLength < 300){
            
        }else{
            
        }
    }else{
        if (textView.text.length > 300)
        {
            textView.text = [textView.text substringToIndex:300];
            [self ShowWarningHudMid:@"最多输入 300 个文字" ];
        }
        
    }
    if (textView.text.length == 0) {
        taskContentPrompLabel.text = @"我们一直致力于杭州党建责任APP的优化与提升，您的意见与建议对我们来说尤为宝贵，感谢您的反馈。";
    }else{
        taskContentPrompLabel.text = @"";
    }
    
    if (_contentTV.text.length != 0 && _contactTF.text.length != 0) {
        _confirmBtn.ContinueBtn.userInteractionEnabled = YES;
        _confirmBtn.gradientLayer.hidden = NO;
    }else {
        _confirmBtn.ContinueBtn.userInteractionEnabled = NO;
        _confirmBtn.gradientLayer.hidden = YES;
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
            if ([NSString hasEmoji:text] || [NSString stringContainsEmoji:text] ||[NSString isContainsTwoEmoji:text]){
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)textViewDidChange {
    
    
}

#pragma mark  UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isFirstResponder]) {
        NSLog(@"string%@", string);
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            return NO;
        }
        //判断键盘是不是九宫格键盘
        if ([NSString isNineKeyBoard:string] ){
            return YES;
        }else{
            if ([NSString hasEmoji:string] || [NSString stringContainsEmoji:string]){
                return NO;
            }
        }
    }

    return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _contactTF) {
        [_contentTV becomeFirstResponder];
    }
 
    return YES;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
