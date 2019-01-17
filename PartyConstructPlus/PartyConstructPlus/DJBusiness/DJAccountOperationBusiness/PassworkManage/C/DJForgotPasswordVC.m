//
//  DJForgotPasswordVC.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJForgotPasswordVC.h"

@interface DJForgotPasswordVC ()<UITextFieldDelegate>

/*
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
 继续按钮
 */
@property (nonatomic, strong)UIButton *ContinueBtn;

@property (nonatomic, strong)CAGradientLayer  *gradientLayer;
/**
 *获取验证码
 */
@property (nonatomic, strong)UIButton * obtainCodeBtn;

@property (nonatomic, strong)JKCountDownButton *countdownBtn;
@end

@implementation DJForgotPasswordVC

//返回上一界面
- (void)handleReturnButton {
    [self.navigationController popViewControllerAnimated:YES];
}

//self.view轻拍手势 隐藏键盘
- (void)handleSingleFingerEvent {
    [self hiddenKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    self.navigationItem.title = @"重置密码";
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerEvent)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    
    [self.view addGestureRecognizer:singleFingerOne];
    
    //
    UIButton *ReturnButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    ReturnButton.frame = CGRectMake(0, 0, 60, 40);
    [ReturnButton setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    [ReturnButton addTarget:self action:@selector(handleReturnButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ReturnButton];
    UIEdgeInsets imageED =  ReturnButton.imageEdgeInsets;
    imageED.left =-60+18;
    ReturnButton.imageEdgeInsets = imageED;
    self.navigationItem.leftBarButtonItem = returnButtonItem;
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(kFit(150+1));
    
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
    _countdownBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_countdownBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_countdownBtn setTitleColor:kColorRGB(89, 135, 198, 1) forState:UIControlStateNormal];
    [_countdownBtn addTarget:self action:@selector(handleObtainCode:) forControlEvents:(UIControlEventTouchUpInside)];
    [_obtainCodeBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [bottomView addSubview:self.countdownBtn];
    self.countdownBtn.sd_layout.rightSpaceToView(bottomView, 1).topSpaceToView(dividerLabelOne, kFit(0)).heightIs(kFit(50)).widthIs(kFit(106.5));
    
    
  
    
    UILabel *verticalBar = [[UILabel alloc] init];
    verticalBar.backgroundColor = kCellColorDivider;
    [bottomView addSubview:verticalBar];
    verticalBar.sd_layout.rightSpaceToView(_countdownBtn, 0).widthIs(kCellDividerHeight).heightIs(kFit(16.5)).topSpaceToView(dividerLabelOne, kFit(16.5));
    
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
    _passwordTF.delegate = self;
    _passwordTF.secureTextEntry = YES;
    _passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTF.returnKeyType = UIReturnKeyDone;
    [bottomView addSubview:_passwordTF];
    _passwordTF.sd_layout.leftSpaceToView(bottomView, kFit(15)).topSpaceToView(dividerLabelTwo, 0).rightSpaceToView(hiddenOrShowBtn, kFit(15)).heightIs(kFit(50));
    self.passwordTF.secureTextEntry = !self.passwordTF.secureTextEntry;
    //继续按钮
    self.ContinueBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_ContinueBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _ContinueBtn.backgroundColor = kColorRGB(215, 215, 215, 1);
    [_ContinueBtn setTitle:@"重置" forState:(UIControlStateNormal)];
    
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

//获取验证码
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
    [self showHud:@"发送验证码中" title:nil];
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
        return @"重新获取";
    }];
    [self getVerificationCode];
    
}

- (void)getVerificationCode{
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:_phoneTF.text forKey:@"tel"];
    [self getJSONDataWithUrl:kURL_UserCodeForgotPassword parameters:URL_Dic success:^(id responseObject) {
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
    [self hiddenKeyboard];
    if (![DJZhengZe isMobileNumber:self.phoneTF.text]) {
        [self ShowWarningHudMid:@"请输入正确的手机号码"];
        return;
    }
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:_phoneTF.text forKey:@"tel"];
    [URL_Dic setValue:_passwordTF.text forKey:@"password"];
    [URL_Dic setValue:_codeTF.text forKey:@"code"];
    [self getJSONDataWithUrl: kURL_UserForgotPWChangePW parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *codeStr  = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        
        if ([codeStr isEqualToString:@"0"]) {
            [self ShowWarningHudMid:@"密码重置成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self  ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
    
    
}

//检测键盘text的变动
- (void)textFieldDidChangeValue {
    if (_phoneTF.text.length == 11 && [DJZhengZe isMobileNumber:self.phoneTF.text] && _codeTF.text.length != 0 && _passwordTF.text.length >=8) {
            [_obtainCodeBtn setTitleColor:kColorRGB(89, 135, 198, 1) forState:(UIControlStateNormal)];
        self.gradientLayer.hidden = NO;
        _ContinueBtn.userInteractionEnabled = YES;
    }else {
            [_obtainCodeBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        self.gradientLayer.hidden = YES;
        _ContinueBtn.userInteractionEnabled = NO;
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

#pragma mark -限定字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"<%@> textField.text%@", string, textField.text);
    if (textField == _codeTF) {
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    if (textField == _phoneTF) {
        if (string.length == 0){
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
//隐藏键盘
- (void)hiddenKeyboard {
    [self.phoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

-(void)dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
