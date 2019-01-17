//
//  DJJoinOrgTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJJoinOrgTableViewCell.h"
#import "DJBaseViewController.h"
#import "RegisteredDataModel+CoreDataProperties.h"
@interface DJJoinOrgTableViewCell ()<UIAlertViewDelegate,UITextFieldDelegate>

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
@property (nonatomic, strong)NSMutableArray * jobsListArray;

/**
 *
 */
@property (nonatomic, strong)RegisteredDataModel *dataModel;
/**
 *
 */
@property (nonatomic, strong)DJBaseViewController * BaseVC;

/**
 *
 */
@property (nonatomic, strong)DJCoreDataManager *djCoreDataManager;

@end

@implementation DJJoinOrgTableViewCell

- (DJBaseViewController *)BaseVC {
    if (!_BaseVC) {
        _BaseVC = [[DJBaseViewController alloc] init];
    }
    return _BaseVC;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.djCoreDataManager =  [DJCoreDataManager shareInstance];
        self.dataModel = [NSEntityDescription insertNewObjectForEntityForName:@"RegisteredDataModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        // Do any additional setup after loading the view.
        self.contentView.backgroundColor = kColorRGB(246, 246, 246, 1);
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleSelfViewClick)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        [self.contentView addGestureRecognizer:singleFingerOne];
        [self setUI];
    }
    return self;
}

- (NSMutableArray *)jobsListArray {
    if (!_jobsListArray) {
        _jobsListArray = [NSMutableArray array];
    }
    return _jobsListArray;
}

//点击self,view 隐藏键盘
- (void)handleSelfViewClick {
    [self hiddenKeyboard];
}


- (void)setUI {

    UIView *bottomView= [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    bottomView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(kFit(150)+5);
    self.InviteCodeTF = [[UITextField alloc] init];
    _InviteCodeTF.placeholder = @"组织邀请码";
    _InviteCodeTF.backgroundColor = [UIColor whiteColor];
    _InviteCodeTF.borderStyle = UITextBorderStyleNone;
    _InviteCodeTF.returnKeyType=UIReturnKeyNext;
    _InviteCodeTF.keyboardType = UIKeyboardTypeASCIICapable;
    _InviteCodeTF.delegate = self;
    [bottomView addSubview:_InviteCodeTF];
    _InviteCodeTF.sd_layout.leftSpaceToView(bottomView, kFit(15)).topSpaceToView(bottomView, 0).rightSpaceToView(bottomView, kFit(15)).heightIs(kFit(50));
    
    UILabel *dividerLabelTwo= [[UILabel alloc] init];
    dividerLabelTwo.backgroundColor  =kCellColorDivider;
    [bottomView addSubview:dividerLabelTwo];
    dividerLabelTwo.sd_layout.leftSpaceToView(bottomView, kFit(14.5)).topSpaceToView(_InviteCodeTF, 1).heightIs(kCellDividerHeight).rightSpaceToView(bottomView, 0);
    
    self.organizationNameTF = [[UITextField alloc] init];
    _organizationNameTF.backgroundColor = [UIColor whiteColor];
    _organizationNameTF.placeholder = @"组织名称依据邀请码自动匹配";
    _organizationNameTF.enabled = NO;
    _organizationNameTF.borderStyle = UITextBorderStyleNone;
    
    _organizationNameTF.delegate = self;
    [bottomView addSubview:_organizationNameTF];
    _organizationNameTF.sd_layout.leftSpaceToView(bottomView, kFit(15)).topSpaceToView(dividerLabelTwo, 1).rightSpaceToView(bottomView, kFit(15)).heightIs(kFit(50));
    
    UILabel *dividerLabelThree = [[UILabel alloc] init];
    dividerLabelThree.backgroundColor  =kCellColorDivider;
    [bottomView addSubview:dividerLabelThree];
    dividerLabelThree.sd_layout.leftSpaceToView(bottomView, kFit(14.5)).topSpaceToView(_organizationNameTF, 1).heightIs(kCellDividerHeight).rightSpaceToView(bottomView, 0);
    
    self.choosePost = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _choosePost.backgroundColor = [UIColor whiteColor];
    _choosePost.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_choosePost setTitleColor:kColorRGB(173, 173, 173, 1) forState:(UIControlStateNormal)];
    [_choosePost addTarget:self action:@selector(handleChoosePost) forControlEvents:(UIControlEventTouchUpInside)];
    
    [bottomView addSubview:_choosePost];
    _choosePost.sd_layout.leftSpaceToView(bottomView, kFit(15)).topSpaceToView(dividerLabelThree, 1).rightSpaceToView(bottomView, kFit(15)).heightIs(kFit(50));
    
    self.maskLabel = [[UILabel alloc] init];
    _maskLabel.text = @"选择岗位属性";
    _maskLabel.textColor =kColorRGB(197, 197, 202, 1);
    _maskLabel.backgroundColor  =[UIColor clearColor];
    
    [_choosePost addSubview:_maskLabel];
    _maskLabel.sd_layout.leftSpaceToView(_choosePost, 0).topSpaceToView(_choosePost, 0).rightSpaceToView(_choosePost, 0).bottomSpaceToView(_choosePost, 0);
    
    UIImageView *rightImage = [[UIImageView alloc] init];
    rightImage.image = [UIImage imageNamed:@"DJRegistrationRight"];
    [bottomView addSubview:rightImage];
    rightImage.sd_layout.rightSpaceToView(bottomView, kFit(11)).topSpaceToView(dividerLabelThree, kFit(16.5)).widthIs(kFit(15)).heightIs(kFit(15));
    
    //继续按钮
    self.ContinueBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_ContinueBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _ContinueBtn.backgroundColor = kColorRGB(215, 215, 215, 1);
    [_ContinueBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    
    _ContinueBtn.font = MFont(kFit(16));
    [_ContinueBtn addTarget:self action:@selector(handleContinueBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    _ContinueBtn.layer.cornerRadius = kFit(45)/2;
    _ContinueBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:_ContinueBtn];
    _ContinueBtn.sd_layout.leftSpaceToView(self.contentView, kFit(15)).rightSpaceToView(self.contentView, kFit(15)).topSpaceToView(bottomView, kFit(20)).heightIs(kFit(45));
    [self.ContinueBtn updateLayout];
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    
    self.gradientLayer.frame =CGRectMake(0, 0, kScreenWidth -kFit(30), _ContinueBtn.height);
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
    if ( _InviteCodeTF.text.length != 0 &&  _organizationNameTF.text.length != 0&&![self.maskLabel.text isEqualToString:@"选择岗位属性"]) {//如果所需要的资料都不是空
        if (self.isChooseDelete) {//如果需要已经选择了要删除的组织
            self.gradientLayer.hidden = NO;
            _ContinueBtn.userInteractionEnabled = YES;
        }else {
            self.gradientLayer.hidden = YES;
            _ContinueBtn.userInteractionEnabled = YES;
        }
        
    }else {
        self.gradientLayer.hidden = YES;
        _ContinueBtn.userInteractionEnabled = NO;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _InviteCodeTF) {
        [textField resignFirstResponder];
        
    }
    
    return YES;
}


- (void)AccordingInvitationCodeObtainOrganizationInfo {
    
    if  (_InviteCodeTF.text.length != 8) {
        self.dataModel.oName = @"";
        self.dataModel.oId = @"";
        self.organizationNameTF.text = @"";
        return;
    }
    [self callFooWithArray:nil];
//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *contactStr = [defaults objectForKey:@"Contacts"];
//    if(![contactStr isEqualToString:_InviteCodeTF.text])
//    {
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(callFooWithArray:) object:[NSArray arrayWithObjects:@(1), contactStr, nil]];
//    }
//    NSString *searchText = _InviteCodeTF.text;
//    if (searchText.length == 0) {
//
//    } else {
//        searchText = [searchText lowercaseString];
//        [self performSelector:@selector(callFooWithArray:) withObject:[NSArray arrayWithObjects:@(1), _InviteCodeTF.text, nil] afterDelay:0.5];
//        [defaults setObject:_InviteCodeTF.text forKey:@"Contacts"];
//    }
}

- (void) callFooWithArray: (NSArray *) inputArray {
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:_InviteCodeTF.text forKey:@"inviteCode"];
    NSLog(@"inputArray%@ URL_Dic%@", inputArray,URL_Dic);
    DJBaseViewController *VC = [[DJBaseViewController alloc] init];
    [VC showHud:@"" title:@""];
    [self.BaseVC getJSONDataWithUrl: kURL_GetOrganizationName parameters:URL_Dic success:^(id responseObject) {
        [VC hudDissmiss];
        NSLog(@"responseObject%@", responseObject);
        NSString *respStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([respStr isEqualToString:@"0"]) {
            NSDictionary *dataDic =  responseObject[@"response"];
            self.dataModel.oName = [NSString stringWithFormat:@"%@", dataDic[@"name"]];
            self.dataModel.oId = [NSString stringWithFormat:@"%@", dataDic[@"id"]];
            self.organizationNameTF.text = dataDic[@"name"];
        }else {
            self.organizationNameTF.text = @"";
            [self  ShowWarningHudMid:@"无效的组织邀请码"];
        }
        [self textFieldDidChangeValue:nil];
    } failure:^(NSError *error) {
        [VC hudDissmiss];
        NSLog(@"error%@",error);
    }];
}

//警告
-(void)ShowWarningHudMid:(NSString *)message {
    MBProgressHUD *warning = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    warning.mode = MBProgressHUDModeText;
    warning.label.text = message;
    warning.label.textColor = [UIColor whiteColor];;
    warning.label.lineBreakMode = NSLineBreakByWordWrapping;
    warning.label.numberOfLines = 0;
    warning.bezelView.backgroundColor = [UIColor blackColor];
    warning.bezelView.alpha = 0.8;
    warning.offset = CGPointMake(0.f, -50);
    [warning hideAnimated:YES afterDelay:1.5f];
}


//获取组织职位 点击事件
- (void)handleChoosePost {
    [self hiddenKeyboard];
    DJBaseViewController *VC = [[DJBaseViewController alloc] init];
    [VC showHud:@"" title:@""];
    [self.BaseVC getJSONDataWithUrl: kURL_ObtainPostInfoList parameters:nil success:^(id responseObject) {
        [VC hudDissmiss];
     //   NSLog(@"responseObject%@", responseObject);
        NSString *respStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([respStr isEqualToString:@"0"]) {
            NSArray *dataArray =  responseObject[@"response"];
            self.jobsListArray = [NSMutableArray arrayWithArray:dataArray];
            [self createJobsPickerView];
        }else {
            [self.BaseVC ShowWarningHudMid:responseObject[@"msg"] ];
        }
    } failure:^(NSError *error) {
        [VC hudDissmiss];
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
    SMKPickerView *smkPickerView = [SMKPickerView SMKPickerWithArray:@[jobsTypeArray] withHeadTitle:nil defaultIndex:row1  withCall:^(SMKPickerView *pcikerView, NSString *choiceString) {
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

//点击继续
- (void)handleContinueBtn:(UIButton *)sender {
    [self hiddenKeyboard];
    if ([_delegate respondsToSelector:@selector(SubmitApplication:)]) {
        [_delegate SubmitApplication:self.dataModel];
    }
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)refreshControlState{
    NSLog(@"%@", self.isChooseDelete?@"YES":@"NO");
    [self  textFieldDidChangeValue:nil];
}

- (void)hiddenKeyboard {
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
@end
