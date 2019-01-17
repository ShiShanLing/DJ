//
//  DJRegisteredViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJRegisteredViewController.h"
#import "DJRegOptimizeInfoVC.h"

#import "RegisteredDataModel+CoreDataProperties.h"

@interface DJRegisteredViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

/**
 用户名字
 */
@property(nonatomic, strong)UITextField *nameTF;

/**
 组织邀请码
 */
@property(nonatomic, strong)UITextField *InviteCodeTF;

/**
 组织名字
 */
@property(nonatomic, strong)UITextField *organizationNameTF;
/**
 *选择岗位
 */
@property (nonatomic, strong)UIButton *choosePost;
/**
 *由于btn的文字居左不太好做 所以在上面添加一个label 来显示文字
 */
@property (nonatomic, strong)UILabel *maskLabel;

/**
 继续按钮
 */
@property (nonatomic, strong)UIButton *ContinueBtn;


@property (nonatomic, strong)CAGradientLayer  *gradientLayer;
/**
 *
 */
@property (nonatomic, strong)RegisteredDataModel *dataModel;

/**
 *
 */
@property (nonatomic, strong)NSMutableArray * jobsListArray;

@end

@implementation DJRegisteredViewController {
    NSString *organizationName;
    NSString *organizationID;
    NSString *jobsID;
    
}

- (NSMutableArray *)jobsListArray {
    if (!_jobsListArray) {
        _jobsListArray = [NSMutableArray array];
    }
    return _jobsListArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}



- (void)handleReturnButton {
     if (_nameTF.text.length != 0 || _InviteCodeTF.text.length != 0 ||  _organizationNameTF.text.length != 0 || ![self.maskLabel.text isEqualToString:@"选择岗位属性"]) {
        
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"您确认退出注册吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"我错了");
        }];
        [cancle setValue:kColorRGB(100, 100, 100, 1) forKey:@"_titleTextColor"];

        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"对不起");
        }];
        [confirm setValue:kColorRGB(89, 135, 198, 1) forKey:@"_titleTextColor"];
        
        // 3.将“取消”和“确定”按钮加入到弹框控制器中
        [alertV addAction:cancle];
        [alertV addAction:confirm];
        // 4.控制器 展示弹框控件，完成时不做操作
        [self presentViewController:alertV animated:YES completion:^{
            nil;
        }];
    }else {
            [self.navigationController popViewControllerAnimated:YES];
    }
}


//点击self,view 隐藏键盘
- (void)handleSelfViewClick {
    [self hiddenKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataModel = [NSEntityDescription insertNewObjectForEntityForName:@"RegisteredDataModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    self.dataModel.jobsID = @"1";
    self.dataModel.jobsName = @"书记";
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    self.navigationItem.title = @"注册";
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSelfViewClick)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    [self.view addGestureRecognizer:singleFingerOne];
    [self setUI];
}

- (void)setUI {
    //
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    
    __weak  DJRegisteredViewController *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    
    UIView *bottomView= [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(kFit(200)+7.5);
    
    
    self.nameTF = [[UITextField alloc] init];
    _nameTF.placeholder = @"姓名";
    _nameTF.borderStyle = UITextBorderStyleNone;
    _nameTF.returnKeyType=UIReturnKeyNext;
    _nameTF.delegate = self;
    _nameTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_nameTF];
    _nameTF.sd_layout.leftSpaceToView(self.view, kFit(15)).topSpaceToView(self.view, 0).rightSpaceToView(self.view, kFit(15)).heightIs(kFit(50));
    
    UILabel *dividerLabelOne = [[UILabel alloc] init];
    dividerLabelOne.backgroundColor  =kCellColorDivider;
    [self.view addSubview:dividerLabelOne];
    dividerLabelOne.sd_layout.leftSpaceToView(self.view, kFit(14.5)).topSpaceToView(_nameTF, 1).heightIs(kCellDividerHeight).rightSpaceToView(self.view, 0);
    
    self.InviteCodeTF = [[UITextField alloc] init];
    _InviteCodeTF.placeholder = @"组织邀请码";
    _InviteCodeTF.backgroundColor = [UIColor whiteColor];
    _InviteCodeTF.borderStyle = UITextBorderStyleNone;
    _InviteCodeTF.returnKeyType=UIReturnKeyNext;
    _InviteCodeTF.keyboardType = UIKeyboardTypeASCIICapable;
    _InviteCodeTF.delegate = self;
    [self.view addSubview:_InviteCodeTF];
    _InviteCodeTF.sd_layout.leftSpaceToView(self.view, kFit(15)).topSpaceToView(dividerLabelOne, 1).rightSpaceToView(self.view, kFit(15)).heightIs(kFit(50));
    
    UILabel *dividerLabelTwo= [[UILabel alloc] init];
    dividerLabelTwo.backgroundColor  =kCellColorDivider;
    [self.view addSubview:dividerLabelTwo];
    dividerLabelTwo.sd_layout.leftSpaceToView(self.view, kFit(14.5)).topSpaceToView(_InviteCodeTF, 1).heightIs(kCellDividerHeight).rightSpaceToView(self.view, 0);
    
    
    self.organizationNameTF = [[UITextField alloc] init];
    _organizationNameTF.backgroundColor = [UIColor whiteColor];
    _organizationNameTF.placeholder = @"组织名称依据邀请码自动匹配";
    _organizationNameTF.enabled = NO;
    _organizationNameTF.borderStyle = UITextBorderStyleNone;
    
    _organizationNameTF.delegate = self;
    [self.view addSubview:_organizationNameTF];
    _organizationNameTF.sd_layout.leftSpaceToView(self.view, kFit(15)).topSpaceToView(dividerLabelTwo, 1).rightSpaceToView(self.view, kFit(15)).heightIs(kFit(50));
    
    UILabel *dividerLabelThree = [[UILabel alloc] init];
    dividerLabelThree.backgroundColor  =kCellColorDivider;
    [self.view addSubview:dividerLabelThree];
    dividerLabelThree.sd_layout.leftSpaceToView(self.view, kFit(14.5)).topSpaceToView(_organizationNameTF, 1).heightIs(kCellDividerHeight).rightSpaceToView(self.view, 0);
    
    self.choosePost = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _choosePost.backgroundColor = [UIColor whiteColor];
    _choosePost.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_choosePost setTitleColor:kColorRGB(173, 173, 173, 1) forState:(UIControlStateNormal)];
    [_choosePost addTarget:self action:@selector(handleChoosePost) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [self.view addSubview:_choosePost];
    _choosePost.sd_layout.leftSpaceToView(self.view, kFit(15)).topSpaceToView(dividerLabelThree, 1).rightSpaceToView(self.view, kFit(15)).heightIs(kFit(50));
    
    self.maskLabel = [[UILabel alloc] init];
    _maskLabel.text = @"选择岗位属性";
    _maskLabel.textColor =kColorRGB(197, 197, 202, 1);
    _maskLabel.backgroundColor  =[UIColor clearColor];
    
    [_choosePost addSubview:_maskLabel];
    _maskLabel.sd_layout.leftSpaceToView(_choosePost, 0).topSpaceToView(_choosePost, 0).rightSpaceToView(_choosePost, 0).bottomSpaceToView(_choosePost, 0);
    
    UIImageView *rightImage = [[UIImageView alloc] init];
    rightImage.image = [UIImage imageNamed:@"DJRegistrationRight"];
    [self.view addSubview:rightImage];
    rightImage.sd_layout.rightSpaceToView(self.view, kFit(11)).topSpaceToView(dividerLabelThree, kFit(16.5)).widthIs(kFit(15)).heightIs(kFit(15));
    
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
    _ContinueBtn.sd_layout.leftSpaceToView(self.view, kFit(15)).rightSpaceToView(self.view, kFit(15)).topSpaceToView(_choosePost, kFit(20)).heightIs(kFit(45));
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
    self.gradientLayer.hidden = YES;
    _ContinueBtn.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_nameTF];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_InviteCodeTF];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_organizationNameTF];
    
}

//监听键盘text变化
- (void)textFieldDidChangeValue:(NSNotification *)notification {

    if (notification.object  == _InviteCodeTF) {
        [self AccordingInvitationCodeObtainOrganizationInfo];
    }
    if (notification.object == _nameTF) {
    BOOL flag=[NSString isContainsTwoEmoji:_nameTF.text];//再次过滤
        if (flag){
            _nameTF.text = [_nameTF.text substringToIndex:_nameTF.text.length -2];
        }
        self.dataModel.userName = _nameTF.text;
    }
    if (_nameTF.text.length != 0 && _InviteCodeTF.text.length != 0 &&  _organizationNameTF.text.length != 0&&![self.maskLabel.text isEqualToString:@"选择岗位属性"]) {
        self.gradientLayer.hidden = NO;
        _ContinueBtn.userInteractionEnabled = YES;
    }else {
        self.gradientLayer.hidden = YES;
        _ContinueBtn.userInteractionEnabled = NO;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameTF) {
        [_InviteCodeTF becomeFirstResponder];
    }
    if (textField == _InviteCodeTF) {
        [textField resignFirstResponder];
        
    }
    
    return YES;
}


- (void)AccordingInvitationCodeObtainOrganizationInfo {
    
    NSString *tempStr = [_InviteCodeTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"tempStr%@", tempStr);
    if  (tempStr.length != 8) {
        self.dataModel.oName = @"";
        self.dataModel.oId = @"";
        self.organizationNameTF.text = @"";
        return;
    }
    [self callFooWithArray:nil];

}

- (void) callFooWithArray: (NSArray *) inputArray {
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        [URL_Dic setValue:_InviteCodeTF.text forKey:@"inviteCode"];
        NSLog(@"inputArray%@ URL_Dic%@", inputArray,URL_Dic);
    __weak DJRegisteredViewController *weakSelf = self;
        [self showHud:@"" title:@""];
        [self getJSONDataWithUrl: kURL_GetOrganizationName parameters:URL_Dic success:^(id responseObject) {
            [self hudDissmiss];
            NSLog(@"responseObject%@", responseObject);
            NSString *respStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
            
            if ([respStr isEqualToString:@"0"]) {
                NSDictionary *dataDic =  responseObject[@"response"];
                for (NSString *key in dataDic) {
                    [self.dataModel setValue:dataDic[key] forKey:key];
                }
                self.organizationNameTF.text = self.dataModel.oName;
                [self textFieldDidChangeValue:nil];
            }else {
                self.dataModel.oName = @"";
                self.dataModel.oId = @"";
                self.organizationNameTF.text = @"";
                [self textFieldDidChangeValue:nil];
                [self  ShowWarningHudMid:@"无效的组织邀请码"];
            }
            
            
        } failure:^(NSError *error) {
            [self hudDissmiss];
            NSLog(@"error%@",error);
        }];
}

//获取组织职位 点击事件
- (void)handleChoosePost {
    [self hiddenKeyboard];
    [self showHud:@"" title:@""];

    [self getJSONDataWithUrl: kURL_ObtainPostInfoList parameters:nil success:^(id responseObject) {
        [self hudDissmiss];
        NSLog(@"responseObject%@", responseObject);
        NSString *respStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([respStr isEqualToString:@"0"]) {
          NSArray *dataArray =  responseObject[@"response"];

            self.jobsListArray = [NSMutableArray arrayWithArray:dataArray];
            [self createJobsPickerView];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self hudDissmiss];
        NSLog(@"error%@",error);
    }];
 
}

- (void)createJobsPickerView {

    NSMutableArray *jobsTypeArray =[NSMutableArray array];
    for (NSDictionary *dic in self.jobsListArray) {
        [jobsTypeArray addObject:dic[@"name"]];
    }
    NSInteger row1 = 0;
    for (int i = 0; i <jobsTypeArray.count; i ++) {
        if ([jobsTypeArray[i] isEqualToString:_maskLabel.text]) {
            row1 = i;
        }
    }
    __weak typeof(self)weakSelf = self;
    SMKPickerView *smkPickerView = [SMKPickerView SMKPickerWithArray:@[jobsTypeArray] withHeadTitle:nil defaultIndex:row1 withCall:^(SMKPickerView *pcikerView, NSString *choiceString) {
        [pcikerView dismissPicker];
        NSLog(@"choiceString%@", choiceString);
        for (NSDictionary *dic in self.jobsListArray) {
            if ([dic[@"name"] isEqualToString:choiceString]) {
                weakSelf.dataModel.jobsName = [NSString stringWithFormat:@"%@", dic[@"name"]];
                weakSelf.dataModel.jobsID = [NSString stringWithFormat:@"%@", dic[@"id"]];
                weakSelf.maskLabel.text = weakSelf.dataModel.jobsName;
                weakSelf.maskLabel.textColor = kColorRGB(51, 51, 51, 1);
                break;
            }
        }
        [weakSelf textFieldDidChangeValue:nil];
    }];
    [smkPickerView show];
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 3;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 25.0f;
    
}
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

    return kScreenWidth;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
}
//点击继续
- (void)handleContinueBtn:(UIButton *)sender {
    [self hiddenKeyboard];
    DJRegOptimizeInfoVC *VC = [[DJRegOptimizeInfoVC alloc] init];
    NSLog(@"handleContinueBtn%@", self.dataModel);
    VC.dataModel = self.dataModel;
    [self pushToNextViewController:VC];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
       [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hiddenKeyboard {
    [_nameTF resignFirstResponder];
    [_InviteCodeTF resignFirstResponder];
    [_organizationNameTF resignFirstResponder];
    
}
#pragma mark -限定字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _InviteCodeTF) {
        if (string.length == 0)
        {
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 8) {
            return NO;
        }
    }
    return YES;
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
