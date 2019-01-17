//
//  DJRegOptimizeInfoVC.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJRegOptimizeInfoVC.h"
#import "RegisteredDataModel+CoreDataProperties.h"
@interface DJRegOptimizeInfoVC ()<UITextFieldDelegate>

/**
 用户信息的提示
 */
@property (nonatomic, strong)UILabel *userInfoLabel;
/**
 *手机号
 */
@property (nonatomic, strong)UITextField  *phoneTF;
/**
 *验证码
 */
@property (nonatomic, strong)UITextField  *codeTF;
/**
 *密码
 */
@property (nonatomic, strong)UITextField  *passwordTF;
/**
 *获取验证码
 */
@property (nonatomic, strong)UIButton * obtainCodeBtn;
/**
 *下一步
 */
@property (nonatomic, strong)UIButton *nextStepBtn;

/**
 继续按钮
 */
@property (nonatomic, strong)UIButton *ContinueBtn;

@property (nonatomic, strong)CAGradientLayer  *gradientLayer;

@property (nonatomic, strong)JKCountDownButton *countdownBtn;
@end

@implementation DJRegOptimizeInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    self.navigationItem.title =@"注册";
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerEvent)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    
    [self.view addGestureRecognizer:singleFingerOne];

    [self setUI];
}
//self.view轻拍手势 隐藏键盘
- (void)handleSingleFingerEvent {
    [self hiddenKeyboard];
}

- (void)handleReturnButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUI {
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak  DJRegOptimizeInfoVC *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    
    
    
    self.userInfoLabel = [[UILabel alloc] init];
    _userInfoLabel.numberOfLines = 0;
    _userInfoLabel.backgroundColor = [UIColor clearColor];
    _userInfoLabel.font = [UIFont systemFontOfSize:15];
    NSString *nameStr =self.dataModel.userName;
    NSString *organizationName = self.dataModel.oName;
    NSString *positionName = self.dataModel.jobsName;
    
    
    
    NSString *textStr = [NSString stringWithFormat:@"您好，%@！\n您注册的组织为%@，岗位属性为%@。 确认无误后请完成注册；若信息有误，请返回重新编辑。", nameStr, organizationName, positionName];
     NSMutableAttributedString *MStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    //组织名字的特殊处理
    [MStr addAttribute:NSForegroundColorAttributeName value:kColorRGB(253, 115, 77, 1) range:NSMakeRange(3+nameStr.length +9,organizationName.length)]; //设置字体颜色
    
    [MStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(3+nameStr.length +9,organizationName.length)];
    //岗位名字的特殊处理
    [MStr addAttribute:NSForegroundColorAttributeName value:kColorRGB(253, 115, 77, 1) range:NSMakeRange(3+nameStr.length +9+organizationName.length+6,positionName.length)]; //设置字体颜色
    
    [MStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(3+nameStr.length +9+organizationName.length+6,positionName.length)];
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [MStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [textStr length])];
    
    _userInfoLabel.attributedText = MStr;
    [self.view addSubview:_userInfoLabel];
    CGSize size = [textStr sizeWithFont:_userInfoLabel.font constrainedToSize:self.view.bounds.size lineBreakMode:_userInfoLabel.lineBreakMode];

    _userInfoLabel.sd_layout.leftSpaceToView(self.view, kFit(15)).topSpaceToView(self.view, kFit(15)).rightSpaceToView(self.view, kFit(15)).heightIs(size.height + 17 *2);
    [_userInfoLabel updateLayout];

    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(_userInfoLabel, kFit(15)).rightSpaceToView(self.view, 0).heightIs(kFit(150+1));

    self.phoneTF = [[UITextField alloc] init];
    _phoneTF.borderStyle = UITextBorderStyleNone;
    _phoneTF.delegate = self;
    _phoneTF.placeholder = @"手机号（作为登录账户使用）";
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.returnKeyType = UIReturnKeyNext;
    [bottomView addSubview:_phoneTF];
    _phoneTF.sd_layout.leftSpaceToView(bottomView, kFit(15)).topSpaceToView(bottomView, 0).rightSpaceToView(bottomView, kFit(15)).heightIs(kFit(50));
    
    
    UILabel *dividerLabelOne = [[UILabel alloc] init];
    dividerLabelOne.backgroundColor  =kCellColorDivider;
    [bottomView addSubview:dividerLabelOne];
    dividerLabelOne.sd_layout.leftSpaceToView(bottomView, kFit(14.5)).topSpaceToView(_phoneTF, 0).heightIs(kCellDividerHeight).rightSpaceToView(bottomView, 0);
    
    self.codeTF = [[UITextField alloc] init];
    _codeTF.borderStyle = UITextBorderStyleNone;
    _codeTF.placeholder = @"验证码";
    _codeTF.delegate = self;
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.returnKeyType = UIReturnKeyNext;
    [bottomView addSubview:_codeTF];
    _codeTF.sd_layout.leftSpaceToView(bottomView, kFit(15)).topSpaceToView(dividerLabelOne, 0).rightSpaceToView(bottomView, kFit(15)).heightIs(kFit(50));
    
    //创建验证码按钮添加到手机号的空间上
    self.countdownBtn = [JKCountDownButton new];
    [_countdownBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _countdownBtn.titleLabel.font = MFont(kFit(16));
    [_countdownBtn setTitleColor:kColorRGB(89, 135, 198, 1) forState:UIControlStateNormal];
    [_countdownBtn addTarget:self action:@selector(handleObtainCode:) forControlEvents:(UIControlEventTouchUpInside)];
    [_obtainCodeBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
    _countdownBtn.userInteractionEnabled = NO;
    [_countdownBtn setTitleColor:[SmkBaseFuncation getColor:@"#cccccc"] forState:UIControlStateNormal];
    
    [bottomView addSubview:self.countdownBtn];
    self.countdownBtn.sd_layout.rightSpaceToView(bottomView, 1).topSpaceToView(dividerLabelOne, kFit(0)).heightIs(kFit(50)).widthIs(kFit(106.5));
    
    UILabel *verticalBar = [[UILabel alloc] init];
    verticalBar.backgroundColor = kColorRGB(237, 237, 237, 1);
    [bottomView addSubview:verticalBar];
    verticalBar.sd_layout.rightSpaceToView(_countdownBtn, 0).widthIs(0.5).heightIs(kFit(16.5)).topSpaceToView(dividerLabelOne, kFit(16.5));
    
    UILabel *dividerLabelTwo = [[UILabel alloc] init];
    dividerLabelTwo.backgroundColor  =kCellColorDivider;
    [bottomView addSubview:dividerLabelTwo];
    dividerLabelTwo.sd_layout.leftSpaceToView(bottomView, kFit(15)).topSpaceToView(_codeTF, 0).heightIs(kCellDividerHeight).rightSpaceToView(bottomView, 0);
    
    
    
    UIButton *hiddenOrShowBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [hiddenOrShowBtn setImage:[UIImage imageNamed:@"DJ_showPW"] forState:(UIControlStateNormal)];
    
    [hiddenOrShowBtn setImage:[UIImage imageNamed:@"DJ_hiddenPW"] forState:(UIControlStateSelected)];
    [hiddenOrShowBtn addTarget:self action:@selector(handleHiddenOrShowBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [hiddenOrShowBtn setAdjustsImageWhenHighlighted:NO];
    [bottomView addSubview:hiddenOrShowBtn];
    hiddenOrShowBtn.sd_layout.rightSpaceToView(bottomView, kFit(15)).topSpaceToView(dividerLabelTwo, 0).heightIs(kFit(50)).widthIs(kFit(50));

    
    self.passwordTF = [[UITextField alloc] init];
    _passwordTF.borderStyle = UITextBorderStyleNone;
    _passwordTF.placeholder = @"密码（8位以上）";
    _passwordTF.secureTextEntry = YES;
    _passwordTF.delegate = self;
    _passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTF.returnKeyType = UIReturnKeyDone;
    [bottomView addSubview:_passwordTF];
    _passwordTF.sd_layout.leftSpaceToView(bottomView, kFit(15)).topSpaceToView(dividerLabelTwo, 0).rightSpaceToView(hiddenOrShowBtn, kFit(15)).heightIs(kFit(50));
    self.passwordTF.secureTextEntry = !self.passwordTF.secureTextEntry;
    //继续按钮
    self.ContinueBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_ContinueBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _ContinueBtn.backgroundColor = kColorRGB(215, 215, 215, 1);
    [_ContinueBtn setTitle:@"继续" forState:(UIControlStateNormal)];
    _ContinueBtn.font = MFont(kFit(16));
    [_ContinueBtn addTarget:self action:@selector(handleContinueBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    _ContinueBtn.layer.cornerRadius = kFit(45)/2;
    _ContinueBtn.layer.masksToBounds = YES;
    [self.view addSubview:_ContinueBtn];
    _ContinueBtn.sd_layout.leftSpaceToView(self.view, kFit(15)).rightSpaceToView(self.view, kFit(15)).topSpaceToView(bottomView, kFit(20)).heightIs(kFit(45));
    [self.ContinueBtn updateLayout];
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = _ContinueBtn.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [_ContinueBtn.layer addSublayer:self.gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 1);
    self.gradientLayer.endPoint = CGPointMake(1, 1);
    self.gradientLayer.cornerRadius = kFit(45)/2;
    //设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)kColorRGB(251, 88, 68, 1).CGColor,
                                  (__bridge id)kColorRGB(254, 141, 85, 1).CGColor];
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.3f), @(1.0f)];
    
    _gradientLayer.hidden = YES;
    _ContinueBtn.userInteractionEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue) name:UITextFieldTextDidChangeNotification object:_phoneTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue) name:UITextFieldTextDidChangeNotification object:_codeTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue) name:UITextFieldTextDidChangeNotification object:_passwordTF];
}

- (void)handleHiddenOrShowBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTF.secureTextEntry = !self.passwordTF.secureTextEntry;
    NSString* text = self.passwordTF.text;
    self.passwordTF.text = @" ";
    self.passwordTF.text = text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleObtainCode:(JKCountDownButton *)sender {
    
    NSString *str = [SmkBaseFuncation replacWhiteLine:_phoneTF.text];
    if (str.length == 0) {
        [self ShowWarningHudMid:@"请输入手机号码"];
        return;
    }
    if (![DJZhengZe isMobileNumber:str]) {
        [self ShowWarningHudMid:@"请输入正确的手机号码"];
        return;
    }
    __weak DJRegOptimizeInfoVC  *selfWeak = self;
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:60];
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"重新获取%ds",second];
        [_countdownBtn setTitleColor:[SmkBaseFuncation getColor:@"#cccccc"] forState:UIControlStateNormal];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        [_countdownBtn setTitleColor:[SmkBaseFuncation getColor:@"#0050e2"] forState:UIControlStateNormal];
        [selfWeak textFieldDidChangeValue];
        if (_phoneTF.text.length == 11 && [DJZhengZe isMobileNumber:self.phoneTF.text]) {
            _countdownBtn.userInteractionEnabled = YES;
            [_countdownBtn setTitleColor:[SmkBaseFuncation getColor:@"#0050e2"] forState:UIControlStateNormal];
        }else {
            _countdownBtn.userInteractionEnabled = NO;
            [_countdownBtn setTitleColor:[SmkBaseFuncation getColor:@"#cccccc"] forState:UIControlStateNormal];
            
        }
        return @"重新获取";
    }];
    

    [self showHud:@"发送验证码中" title:nil];
    [self getVerificationCode];
    
}

- (void)getVerificationCode{
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    
    [URL_Dic setValue:_phoneTF.text forKey:@"tel"];
    [self getJSONDataWithUrl:kRUL_UserCodeRegistered parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        
        if ([codeStr isEqualToString:@"0"]) {
          [self ShowWarningHudMid:@"验证码已发送, 请注意查收!"];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
            [_countdownBtn stop];
        }
        [self hudDissmiss];
    } failure:^(NSError *error) {
        
        NSLog(@"error%@",error);
        [self hudDissmiss];
    }];
    
}

//继续按钮 点击提交资料
- (void)handleContinueBtn:(UIButton *)sender {
    
    if (![DJZhengZe isMobileNumber:self.phoneTF.text]) {
        [self ShowWarningHudMid:@"请输入正确的手机号码" ];
        return;
    }
    
    if (_passwordTF.text.length < 8) {
        [self ShowWarningHudMid:@"密码最少设置八位" ];
    }
    [self hiddenKeyboard];
    
    
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setObject:self.codeTF.text forKey:@"code"];
    [URL_Dic setObject:self.dataModel.oId forKey:@"orgId"];
    [URL_Dic setObject:self.passwordTF.text forKey:@"password"];
    [URL_Dic setObject:self.dataModel.jobsID forKey:@"stationId"];
    [URL_Dic setObject:self.phoneTF.text forKey:@"tel"];
    [URL_Dic setObject:self.dataModel.userName forKey:@"userName"];
    NSLog(@"URL_Dic%@", URL_Dic);
    [self getJSONDataWithUrl: kURL_UserRegistered parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        
        if ([codeStr isEqualToString:@"0"]) {
            NSDictionary *userDataDic = responseObject[@"response"];
            [DJUserTool saveLoginStatusWithUserId:userDataDic[@"id"] withPhone:@"" withtokenn:userDataDic[@"token"] withName:userDataDic[@"realName"]];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self  ShowWarningHudMid:@"注册成功"];
        }else {
            [self  ShowWarningHudMid:responseObject[@"msg"]];
        }
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}

//检测键盘text的变动
- (void)textFieldDidChangeValue {
    

    
    
    if (_countdownBtn.enabled) {
        if (_phoneTF.text.length == 11 && [DJZhengZe isMobileNumber:self.phoneTF.text]) {
            _countdownBtn.userInteractionEnabled = YES;
            [_countdownBtn setTitleColor:[SmkBaseFuncation getColor:@"#0050e2"] forState:UIControlStateNormal];
        }else {
            _countdownBtn.userInteractionEnabled = NO;
            [_countdownBtn setTitleColor:[SmkBaseFuncation getColor:@"#cccccc"] forState:UIControlStateNormal];
            
        }
    }
   
    
    if (_phoneTF.text.length == 11 && [DJZhengZe isMobileNumber:self.phoneTF.text] && _codeTF.text.length != 0 && _passwordTF.text.length >= 8) {
        
        [_obtainCodeBtn setTitleColor:kColorRGB(89, 135, 198, 1) forState:(UIControlStateNormal)];
        _obtainCodeBtn.userInteractionEnabled = YES;

        _gradientLayer.hidden = NO;
        _ContinueBtn.userInteractionEnabled = YES;
    }else {
        [_obtainCodeBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        _obtainCodeBtn.userInteractionEnabled = NO;
        _ContinueBtn.userInteractionEnabled = NO;
        _gradientLayer.hidden = YES;
    }
    
    
    
 
}

#pragma mark  UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _phoneTF) {
        [_codeTF becomeFirstResponder];
    }
    if (textField == _codeTF) {
        [_passwordTF becomeFirstResponder];
    }
    if (textField == _passwordTF) {//键盘消失并提交
        [textField resignFirstResponder];
    }
    
    return YES;
}
//隐藏键盘
- (void)hiddenKeyboard {
    
    [self.phoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    
}
#pragma mark -限定字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _codeTF) {
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    if (textField == _phoneTF) {
        if (string.length == 0)
        {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    return YES;
}
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
