//
//  DJModifyPasswordViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/21.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJModifyPasswordViewController.h"

@interface DJModifyPasswordViewController ()<UITextFieldDelegate>

/**
 *验证码
 */
@property (nonatomic, strong)UITextField  *oldPasswordTF;
/**
 *密码
 */
@property (nonatomic, strong)UITextField  *passwordNewTF;
/**
 继续按钮
 */
@property (nonatomic, strong)UIButton *ContinueBtn;

@property (nonatomic, strong)CAGradientLayer  *gradientLayer;

@end

@implementation DJModifyPasswordViewController
//返回上一界面
- (void)handleReturnButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hiddenKeyboard];
}
//self.view轻拍手势 隐藏键盘
- (void)handleSingleFingerEvent {
    [self hiddenKeyboard];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    self.navigationItem.title = @"修改密码";
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
    bottomView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(kFit(100+1));

    
    self.oldPasswordTF = [[UITextField alloc] init];
    _oldPasswordTF.borderStyle = UITextBorderStyleNone;
    _oldPasswordTF.placeholder = @"原密码";
    _oldPasswordTF.delegate = self;
    _oldPasswordTF.keyboardType = UIKeyboardTypeASCIICapable;
    _oldPasswordTF.returnKeyType = UIReturnKeyNext;
    [bottomView addSubview:_oldPasswordTF];
    _oldPasswordTF.sd_layout.leftSpaceToView(bottomView, kFit(15)).topSpaceToView(bottomView, 0).rightSpaceToView(bottomView, kFit(15)).heightIs(kFit(50));
    
    UILabel *dividerLabelTwo = [[UILabel alloc] init];
    dividerLabelTwo.backgroundColor  =kCellColorDivider;
    [bottomView addSubview:dividerLabelTwo];
    dividerLabelTwo.sd_layout.leftSpaceToView(bottomView, kFit(15)).topSpaceToView(_oldPasswordTF, 0).heightIs(kCellDividerHeight).rightSpaceToView(bottomView, 0);
    
    
    
    UIButton *hiddenOrShowBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [hiddenOrShowBtn setImage:[UIImage imageNamed:@"DJ_showPW"] forState:(UIControlStateNormal)];
    [hiddenOrShowBtn setImage:[UIImage imageNamed:@"DJ_hiddenPW"] forState:(UIControlStateSelected)];
    [hiddenOrShowBtn addTarget:self action:@selector(handleHiddenOrShowBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [hiddenOrShowBtn setAdjustsImageWhenHighlighted:NO];
    [bottomView addSubview:hiddenOrShowBtn];
    hiddenOrShowBtn.sd_layout.rightSpaceToView(bottomView, kFit(15)).topSpaceToView(dividerLabelTwo, 0).heightIs(kFit(50)).widthIs(kFit(50));
//    _passwordNewTF.keyboardType = UIKeyboardTypeASCIICapable;
    
    self.passwordNewTF = [[UITextField alloc] init];
    _passwordNewTF.borderStyle = UITextBorderStyleNone;
    _passwordNewTF.placeholder = @"新密码（8位以上）";
    _passwordNewTF.delegate = self;
    _passwordNewTF.secureTextEntry = YES;
    _passwordNewTF.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordNewTF.returnKeyType = UIReturnKeyDone;
    [bottomView addSubview:_passwordNewTF];
    _passwordNewTF.sd_layout.leftSpaceToView(bottomView, kFit(15)).topSpaceToView(dividerLabelTwo, 0).rightSpaceToView(hiddenOrShowBtn, kFit(15)).heightIs(kFit(50));
    _passwordNewTF.secureTextEntry = !_passwordNewTF.secureTextEntry;
    //继续按钮
    self.ContinueBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_ContinueBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _ContinueBtn.backgroundColor = kColorRGB(215, 215, 215, 1);
    [_ContinueBtn setTitle:@"修改" forState:(UIControlStateNormal)];
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue) name:UITextFieldTextDidChangeNotification object:_oldPasswordTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue) name:UITextFieldTextDidChangeNotification object:_passwordNewTF];
}

- (void)handleHiddenOrShowBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordNewTF.secureTextEntry = !self.passwordNewTF.secureTextEntry;
    NSString* text = self.passwordNewTF.text;
    self.passwordNewTF.text = @" ";
    self.passwordNewTF.text = text;
}

//继续按钮 点击提交资料
- (void)handleContinueBtn:(UIButton *)sender {
    
    [self hiddenKeyboard];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:_oldPasswordTF.text forKey:@"oldPassword"];
    [URL_Dic setValue:_passwordNewTF.text forKey:@"password"];
    
    [self getJSONDataWithUrl: kURL_UserChangePassword parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *codeStr  = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([codeStr isEqualToString:@"0"]) {
            [self ShowWarningHudMid:@"密码修改成功"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}

//检测键盘text的变动
- (void)textFieldDidChangeValue {
    if (_passwordNewTF.text.length >= 8) {
            self.gradientLayer.hidden = NO;
            _ContinueBtn.userInteractionEnabled = YES;
    }else {
        self.gradientLayer.hidden = YES;
        _ContinueBtn.userInteractionEnabled = NO;
    }
}

#pragma mark  UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField == _oldPasswordTF) {
        [_passwordNewTF becomeFirstResponder];
    }
    if (textField == _passwordNewTF) {//键盘消失并提交
        [textField resignFirstResponder];
    }
    return YES;
}

//隐藏键盘
- (void)hiddenKeyboard {
    [self.oldPasswordTF resignFirstResponder];
    [self.passwordNewTF resignFirstResponder];
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
