//
//  DJLogInViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/26.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJLogInViewController.h"
#import "DJRegisteredViewController.h"
#import "DJForgotPasswordVC.h"
#import "JPUSHService.h"
@interface DJLogInViewController ()<UITextFieldDelegate>

/**
 *退出该界面
 */
@property (nonatomic, strong)UIButton * exitBtn;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic)UIImageView *logoView;

@property (strong,nonatomic)UITextField *phoneField;
@property (strong,nonatomic)UITextField *codeField;


@property (strong,nonatomic)UIButton *loginButton;
@property (strong,nonatomic)UIButton *forgetButton;
@property (strong,nonatomic)UIButton *registerButton;

/**
 *
 */
@property (nonatomic, strong)CAGradientLayer  *gradientLayer;
@end

@implementation DJLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title =@"登录";
    [self createUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self isBeingPresented];
    [self isBeingDismissed];
    [self isMovingToParentViewController];
    [self isMovingFromParentViewController];
    
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)createUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    
    [_scrollView addGestureRecognizer:singleFingerOne];
    
    self.exitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_exitBtn setImage:[UIImage imageNamed:@"Shut_logInView"] forState:(UIControlStateNormal)];
    [_exitBtn addTarget:self action:@selector(handleExitBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [_scrollView addSubview:_exitBtn];
    _exitBtn.sd_layout.leftSpaceToView(_scrollView, 0).topSpaceToView(_scrollView, kFit(18.5)+(kiPhoneX?24:0)).widthIs(kFit(70)).heightIs(kFit(70));
    
    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - kFit(115))/2, kFit(90)+(kiPhoneX?24:0), kFit(115), kFit(115))];
    _logoView.image = [UIImage imageNamed:@"LogInLogo"];
    [_scrollView addSubview:_logoView];
    
    UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(_logoView.frame)+52,15,15)];
    phoneImageView.image = [UIImage imageNamed:@"iphoneIcon"];
    [_scrollView addSubview:phoneImageView];
    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneImageView.frame)+10,CGRectGetMaxY(_logoView.frame)+40,kScreenWidth -60,40)];
    _phoneField.placeholder = @"手机号";
    _phoneField.font = MFont(15);
    _phoneField.tag = 0;
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
//    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.borderStyle = UITextBorderStyleNone;
    _phoneField.delegate = self;
    [_scrollView addSubview:_phoneField];
    if (![DJUserTool userIsLogin]) {//如果登录过,那么就填写默认的手机号
        _phoneField.text = [DJUserTool getUserPhone];
    }
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_phoneField.frame), kScreenWidth-40, kCellDividerHeight)];
    line1.backgroundColor = kCellColorDivider;
    [_scrollView addSubview:line1];
    
    
    UIImageView *codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(line1.frame)+22,15,15)];
    codeImageView.image = [UIImage imageNamed:@"passwordIcon"];
    [_scrollView addSubview:codeImageView];
    
    
    UIButton *hiddenOrShowBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [hiddenOrShowBtn setImage:[UIImage imageNamed:@"DJ_hiddenPW"] forState:(UIControlStateNormal)];
    
    [hiddenOrShowBtn setImage:[UIImage imageNamed:@"DJ_showPW"] forState:(UIControlStateSelected)];
    [hiddenOrShowBtn addTarget:self action:@selector(handleHiddenOrShowBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [hiddenOrShowBtn setAdjustsImageWhenHighlighted:NO];
    [_scrollView addSubview:hiddenOrShowBtn];
    hiddenOrShowBtn.sd_layout.rightSpaceToView(_scrollView, kFit(15)).topSpaceToView(line1, 10).heightIs(40).widthIs(kFit(50));
    
    
    
    _codeField = [SmkBaseFuncation createTextFieldFrame:CGRectMake(CGRectGetMaxX(codeImageView.frame)+10,CGRectGetMaxY(line1.frame)+10,kScreenWidth - 60-kFit(50),40) Placeholder:@"密码" leftView:nil rightView:nil BgImageName:nil font:15.0];
    _codeField.tag = 1;
    _codeField.secureTextEntry = YES;
    _codeField.delegate = self;
    _codeField.keyboardType = UIKeyboardTypeASCIICapable;
    [_codeField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [_scrollView addSubview:_codeField];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_codeField.frame)+1, kScreenWidth-40, kCellDividerHeight)];
    line2.backgroundColor = kCellColorDivider;
    [_scrollView addSubview:line2];
    

    self.loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _loginButton.frame =CGRectMake(25, CGRectGetMaxY(line2.frame)+30, kScreenWidth-50, kFit(45.5));
    _loginButton.layer.cornerRadius = kFit(45.5)/2;
    _loginButton.userInteractionEnabled = NO;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.backgroundColor = kColorRGB(215, 215, 215, 1);
    [_loginButton addTarget:self action:@selector(handleLoginButton) forControlEvents:(UIControlEventTouchUpInside)];
    [_scrollView addSubview:_loginButton];
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = _loginButton.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [_loginButton.layer addSublayer:self.gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 1);
    self.gradientLayer.endPoint = CGPointMake(1, 1);
    self.gradientLayer.cornerRadius = kFit(45.5)/2;
    
    //设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)kColorRGB(251, 88, 68, 1).CGColor,
                                  (__bridge id)kColorRGB(254, 141, 85, 1).CGColor];
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.3f), @(1.0f)];
    _gradientLayer.hidden = YES;
    
    _forgetButton = [SmkBaseFuncation createButtonFrame:CGRectMake(0, CGRectGetMaxY(_loginButton.frame)+10, 104, 20) Title:@"忘记密码?" BgImageName:nil ImageName:nil Method:@selector(forgetClick) target:self];
    
    [_forgetButton setTitleColor:kColorRGB(89, 135, 198, 1) forState:UIControlStateNormal];
    _forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:_forgetButton];
    
    _registerButton = [SmkBaseFuncation createButtonFrame:CGRectMake(kScreenWidth-104, CGRectGetMaxY(_loginButton.frame)+10, 104, 20) Title:@"注册账号" BgImageName:nil ImageName:nil Method:@selector(registerClick) target:self];
    [_registerButton setTitleColor:kColorRGB(89, 135, 198, 1) forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:_registerButton];
    
    
    UILabel *tipLabel2 = [[UILabel alloc]init];
    tipLabel2.frame = CGRectMake(10,kScreenHeight-kTabbarSafeBottomMargin-30, kScreenWidth-20, 30);
    tipLabel2.text = @"杭州市委组织部";
    tipLabel2.font = MFont(12);
    tipLabel2.textColor = [SmkBaseFuncation getColor:@"#adadad"];
    tipLabel2.textAlignment = NSTextAlignmentCenter;
    tipLabel2.numberOfLines = 0;
//    [_scrollView addSubview:tipLabel2];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:_phoneField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:_codeField];
}


- (void)handleHiddenOrShowBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.codeField.secureTextEntry = !self.codeField.secureTextEntry;
    NSString* text = self.codeField.text;
    self.codeField.text = @" ";
    self.codeField.text = text;
}


- (void)textFieldDidChangeValue:(NSNotification*)notification {
    
    NSString *phoneStr = [SmkBaseFuncation replacWhiteLine:_phoneField.text];
   
    
    if (_phoneField.text.length != 0 &&_codeField.text.length != 0) {
        
        if (phoneStr.length == 11 && _codeField.text.length > 5) {
            _loginButton.userInteractionEnabled = YES;
            _gradientLayer.hidden = NO;
            
        }else{
            _gradientLayer.hidden = YES;
            _loginButton.userInteractionEnabled = NO;
        }
        
    }else {
        _loginButton.userInteractionEnabled = NO;
        _gradientLayer.hidden = YES;
    }

}

#pragma mark 登录按钮被点击
- (void)handleLoginButton {
    
    if (![DJZhengZe isMobileNumber:self.phoneField.text]) {
        [self ShowWarningHudMid:@"请输入正确的手机号码"];
        return;
    }
    [self handleSingleFingerEvent:nil];
//    __weak DJLogInViewController *selfWeak = self;
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.codeField.text forKey:@"password"];
    [URL_Dic setValue:self.phoneField.text forKey:@"tel"];
    [self showHud:@"" title:@""];
    [self getJSONDataWithUrl:kURL_UserLogIn parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        
        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *resStr = [NSString stringWithFormat:@"%@", responseDic[@"code"]];
        if ([resStr isEqualToString:@"0"]) {

            [self ShowWarningHudMid:@"登录成功"];
            NSDictionary *dataDic = responseDic[@"response"];
            [DJUserTool clearLoginInfo];
            [DJUserTool saveLoginStatusWithUserId:dataDic[@"id"] withPhone:dataDic[@"tel"] withtokenn:dataDic[@"token"] withName:dataDic[@"userName"]];
            [self handleExitBtn];
            [self RegisteredPush];
        }else {
            
            [self  ShowWarningHudMid:responseObject[@"msg"]];
        }
        [self hudDissmiss];
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
    
}

- (void)RegisteredPush {
    NSString *RegistID = [NSString stringWithFormat:@"%@", [DJUserTool  getRegistID]];
    
    if ([[DJUserTool  getRegistID] isEmpty] || [RegistID isEqualToString:@"(null)"]) {
        return;
    }

    NSMutableDictionary *tempDic  = [NSMutableDictionary dictionary];
    [tempDic setObject:[DJUserTool  getRegistID] forKey:@"registId"];
    [tempDic setObject:[DJUserTool getUserPhone] forKey:@"tel"];
    NSLog(@"tempDic%@", tempDic);
    [self  getJSONDataWithUrl:kURL_RegisteredPush parameters:tempDic success:^(id responseObject) {
        NSLog(@"RegisteredPush%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [DJUserTool setJPushRegState:@"YES"];
        }else {
            [DJUserTool setJPushRegState:@"NO"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
    
}

//退出该界面
- (void)handleExitBtn {
    if (![self.iskick isEqualToString:@"YES"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
//点击登录
- (void)requestJG {

}

- (void)closeView//因为登录界面必定是某个界面点击进来的所以 只需要返回就行了
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//忘记密码
- (void)forgetClick {
    [self handleSingleFingerEvent:nil];
    DJForgotPasswordVC *VC = [[DJForgotPasswordVC alloc] init];
    [self pushToNextViewController:VC];
}
//注册
- (void)registerClick {
    
    [self handleSingleFingerEvent:nil];
    DJRegisteredViewController *VC = [[DJRegisteredViewController alloc] init];
    [self pushToNextViewController:VC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -限定字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _phoneField) {
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

-(void)textFieldDidChange
{
    //    NSString *str = [SmkBaseFuncation replacWhiteLine:_codeField.text];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_codeField resignFirstResponder];
    return YES;
}
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender {
    
    [_phoneField resignFirstResponder];
    [_codeField resignFirstResponder];
    
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
