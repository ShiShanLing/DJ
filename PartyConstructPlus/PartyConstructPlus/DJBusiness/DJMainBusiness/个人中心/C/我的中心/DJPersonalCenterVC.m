//
//  DJPersonalCenterVC.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJPersonalCenterVC.h"
#import "DJUserHeadView.h"
#import "UserData.h"
#import "DJUserDataShowTVCell.h"
#import "DJManageOrgViewController.h"
#import "DJJoinOrgViewController.h"
//组织选择
#import "DJOrgChooseView.h"
#import "DJNoOrgTableViewCell.h"
#import "DJCustomPopupWindow.h"
@interface DJPersonalCenterVC ()<UITableViewDelegate, UITableViewDataSource, DJUserHeadViewDelegate, DJOrgChooseViewDelegate>


@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong) CZPhotoPickerController *pickPhotoController;
/**
 *半透明黑色背景view
 */
@property (nonatomic, strong)UIView *backgroundColorView;
/**
 *组织选择view
 */
@property (nonatomic, strong)DJOrgChooseView *orgChooseView;
/**
 *切换组织按钮
 */
@property (nonatomic, strong)UIButton *rightMsgBtn;
/**
 *头像选着方式弹窗
 */
@property (nonatomic, strong)DJCustomPopupWindow * customPopupWindow;
@end

@implementation DJPersonalCenterVC {
    
    BOOL isRefresh;
    
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray  = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    isRefresh = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    self.dataEmptyView.alpha  = 1.0;
    __weak DJPersonalCenterVC *  selfWeak = self;
    if (isRefresh) {
        [self refreshUserInfo:^(BOOL results) {
            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@", results?@"YES":@"NO");
            [selfWeak IsHaveDefaultOrg];
            
        }];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}


- (void)getUserInfo {
    [self.dataArray removeAllObjects];
    NSArray *orgDataArray =  [self queryModel:@"OrgInfoModel"];
    
    for (OrgInfoModel *model in orgDataArray) {
//        NSLog(@"DJPersonalCenterVC%@ model.orgId%@", model, model.orgId);
    }
    NSString *orgName=@"";
    NSString *jobsName= @"";
    NSString *phoneStr=@"";
    if (orgDataArray.count == 0) {
        //        需要在base里面刷新接口
        orgName = @"";
        jobsName = @"";
        phoneStr = [DJUserTool getUserPhone];
    }else {
        
        for (int i = 0; i <orgDataArray.count; i ++) {
            OrgInfoModel *orgInfoModel = orgDataArray[i];
            
            if ([orgInfoModel.orgId isEqualToString:[DJUserTool getUserOrgAndCustom]]) {
                orgName = orgInfoModel.orgName;
                jobsName = orgInfoModel.stationName;
            }
        }
        phoneStr = [DJUserTool getUserPhone];
    }
//    NSLog(@"orgDataArray%@", orgDataArray);
    if (orgDataArray.count == 0) {
        NSArray *userArray= @[@{@"title":@"手机",@"data":phoneStr }, @{}];
        self.dataArray = [NSMutableArray arrayWithArray:userArray];
    }else {
        NSMutableDictionary *orgDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *jonsDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *phoneDic = [NSMutableDictionary dictionary];
        [orgDic setValue:@"组织" forKey:@"title"];
        [orgDic setValue:orgName forKey:@"data"];
        [jonsDic setValue:@"岗位" forKey:@"title"];
        [jonsDic setValue:jobsName forKey:@"data"];
        [phoneDic setValue:@"手机" forKey:@"title"];
        [phoneDic setValue:phoneStr forKey:@"data"];
        
        [self.dataArray addObject:orgDic];
        [self.dataArray addObject:jonsDic];
        [self.dataArray addObject:phoneDic];
    }
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    isRefresh = YES;
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人中心";
    [self createTableView];
    [self getUserInfo];
    
    UIButton *ReturnBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [ReturnBtn setImage:[UIImage imageNamed:@"DJWhiteReturn"] forState:(UIControlStateNormal)];
    [ReturnBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:ReturnBtn];
    ReturnBtn.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 20+(kiPhoneX?24:0)).heightIs(43).widthIs(kFit(43));
    
    self.rightMsgBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_rightMsgBtn setTitle:@"切换组织" forState:(UIControlStateNormal)];
    [_rightMsgBtn addTarget:self action:@selector(handleRightBtn) forControlEvents:(UIControlEventTouchUpInside)];
    _rightMsgBtn.font = MFont(kFit(15));
    [self.view addSubview:_rightMsgBtn];
    _rightMsgBtn.sd_layout.rightSpaceToView(self.view, 0).topSpaceToView(self.view, 20+(kiPhoneX?24:0)).heightIs(43).widthIs(kFit(70));
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"个人中心";
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.view addSubview:titleLabel];
    titleLabel.sd_layout.widthIs(200).heightIs(17).topSpaceToView(self.view, 32+(kiPhoneX?24:0)).centerXEqualToView(self.view);\
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_InLoad"];
    self.dataEmptyView.promptLabel.text = @"页面正在努力加载中, \n请耐心等待…";
    self.dataEmptyView.alpha = 0;
    [self.view addSubview:self.dataEmptyView];
//        self.dataEmptyView.promptLabel.sd_layout.leftSpaceToView(self.dataEmptyView.emptyImageView, 0).rightSpaceToView(self.dataEmptyView.emptyImageView, 0).topSpaceToView(self.dataEmptyView.emptyImageView, kFit(205)).autoHeightRatio(0);
    
    UIButton *_exitBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_exitBtn setImage:[UIImage imageNamed:@"Shut_logInView"] forState:(UIControlStateNormal)];
    [_exitBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.dataEmptyView addSubview:_exitBtn];
    _exitBtn.sd_layout.leftSpaceToView(self.dataEmptyView, 0).topSpaceToView(self.dataEmptyView, kFit(18.5)+(kiPhoneX?24:0)).widthIs(kFit(70)).heightIs(kFit(70));
}

- (void)handleReturnBtn {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)handleRightBtn {
    [self OrgChoose];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorRGB(246, 246, 246, 1);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[DJUserDataShowTVCell class] forCellReuseIdentifier:@"DJUserDataShowTVCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[DJNoOrgTableViewCell class] forCellReuseIdentifier:@"DJNoOrgTableViewCell"];
    [self.view addSubview:_tableView];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *orgDataArray =  [self queryModel:@"OrgInfoModel"];
    if (orgDataArray.count == 0) {
        return self.dataArray.count + 1;
    }
    return self.dataArray.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *orgDataArray =  [self queryModel:@"OrgInfoModel"];
    if (self.dataArray.count == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kColorRGB(246, 246, 246, 1);
        UIButton*manageOrgBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        manageOrgBtn.backgroundColor = [UIColor whiteColor];
        if (orgDataArray.count == 0) {
            
            [manageOrgBtn setTitle:@"加入新组织" forState:(UIControlStateNormal)];
        }else {
            [manageOrgBtn setTitle:@"管理我的组织" forState:(UIControlStateNormal)];
        }
        
        [manageOrgBtn addTarget:self action:@selector(handleManageOrgBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [manageOrgBtn setTitleColor:kColorRGB(251, 85, 64, 1) forState:(UIControlStateNormal)];
        manageOrgBtn.font =MFont(kFit(16));
        [cell addSubview:manageOrgBtn];
        manageOrgBtn.sd_layout.leftSpaceToView(cell, 0).topSpaceToView(cell, kFit(10)).rightSpaceToView(cell, 0).bottomSpaceToView(cell, 0);
        return cell;
    }else {
        
        NSLog(@"orgDataArray%@", orgDataArray);
        
        if (orgDataArray.count == 0) {
            
            if (indexPath.row  == self.dataArray.count-1) {
                DJNoOrgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJNoOrgTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                return cell;
            }else {
                DJUserDataShowTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJUserDataShowTVCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.dataDic = self.dataArray[indexPath.row];
                if (indexPath.row == self.dataArray.count - 1) {
                    cell.segmentationLabel.hidden = YES;
                }else {
                    cell.segmentationLabel.hidden = NO;
                }
                return cell;
            }
        }else{
            
            DJUserDataShowTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJUserDataShowTVCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dataDic = self.dataArray[indexPath.row];
            if (indexPath.row == self.dataArray.count - 1) {
                cell.segmentationLabel.hidden = YES;
            }else {
                cell.segmentationLabel.hidden = NO;
            }
            return cell;
        }
        
    }
}
//跳转组织管理界面
- (void)handleManageOrgBtn {
    NSArray *datarray =  [self queryModel:@"OrgInfoModel"];
    if (datarray.count == 0) {
        DJJoinOrgViewController *VC = [[DJJoinOrgViewController alloc] init];
        [self.navigationController  pushViewController:VC animated:YES];
    }else {
        DJManageOrgViewController *VC= [[DJManageOrgViewController alloc] init];
        [self.navigationController  pushViewController:VC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArray.count) {
        return kFit(60);
    }else {
        NSArray *orgDataArray =  [self queryModel:@"OrgInfoModel"];
        if (orgDataArray.count == 0) {
            if (indexPath.row  == self.dataArray.count-1) {
                return kFit(132);
            }else {
                return kFit(50);
            }
        }else {
            return kFit(50);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kFit(205)+(kiPhoneX?24:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DJUserHeadView *headView  = [[DJUserHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(205)+(kiPhoneX?24:0))];
    headView.delegate = self;
    UserData  *model = [DJUserTool getUserInfo];
    headView.bottomImage.image = [UIImage imageNamed:@"DJUserCenterBackground"];
    if (model.name.length == 0 ||model.name == NULL ||model.name == nil)  {
        
    }else {
        [headView.nameBtn setTitle:[NSString stringWithFormat:@"你好, %@", model.name] forState:(UIControlStateNormal)];
    }
    headView.nameBtn.userInteractionEnabled = NO;
    
    [headView.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[DJUserTool getUserHeadImage]]] placeholderImage:[UIImage imageNamed:@"DJUserDefaultHead"]];
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handlechooseUploadpictureWay)];
    
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    
    [headView.headImage addGestureRecognizer:singleFingerOne];
    
    return headView;
}




- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return footerView;
    
}

- (void)ClickUserCenter {
    
}

//选择上传图片的方式
- (void)handlechooseUploadpictureWay {
    
    UIViewController *VC = [self appRootViewController];
    
    CGRect frame = VC.view.frame;
    frame.origin.y = 0;
    VC.view.frame = frame;
    self.backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backgroundColorView.backgroundColor = [UIColor blackColor];
    _backgroundColorView.alpha = 0.1;
    [VC.view addSubview:_backgroundColorView];
    
    self.customPopupWindow = [[DJCustomPopupWindow alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kFit(182))];
    
    
    __weak __typeof(self) weakself= self;
    _customPopupWindow.chooseBlock = ^(NSInteger index) {
        switch (index) {
            case 0: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.pickPhotoController = [weakself photoController];
                    weakself.pickPhotoController.allowsEditing = YES;
                    weakself.pickPhotoController.saveToCameraRoll = NO;
                    if ([CZPhotoPickerController canTakePhoto]) {
                        [weakself.pickPhotoController showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    }
                });
                [UIView animateWithDuration:0.3 animations:^{
                    
                } completion:^(BOOL finished) {
                    [weakself.customPopupWindow removeFromSuperview];
                    [weakself.backgroundColorView removeFromSuperview];
                }];
            }
                break;
            case 1:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.pickPhotoController = [weakself photoController];
                    weakself.pickPhotoController.allowsEditing = YES;
                    weakself.pickPhotoController.saveToCameraRoll = NO;
                    if ([CZPhotoPickerController canTakePhoto]) {
                        [weakself.pickPhotoController showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                    }
                });
                [UIView animateWithDuration:0.3 animations:^{
                    
                } completion:^(BOOL finished) {
                    [weakself.customPopupWindow removeFromSuperview];
                    [weakself.backgroundColorView removeFromSuperview];
                }];
            }
                break;
            case 2:{
                [UIView animateWithDuration:0.3 animations:^{
                    weakself.customPopupWindow.frame =  CGRectMake(0, kScreenHeight, kScreenWidth, kFit(182));
                    weakself.backgroundColorView.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakself.customPopupWindow removeFromSuperview];
                    [weakself.backgroundColorView removeFromSuperview];
                }];
            }
                break;
                
            default:
                break;
        }
    };
    [_customPopupWindow actionWithTitles:@[@"从相册选择", @"拍照", @"取消"]];
    [VC.view addSubview:_customPopupWindow];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.customPopupWindow.frame =  CGRectMake(0, kScreenHeight-kFit(182)-(kiPhoneX?34:7), kScreenWidth, kFit(182));
        self.backgroundColorView.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
    
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleHiddenImageUploadOption)];
    
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    
    [_backgroundColorView addGestureRecognizer:singleFingerOne];
    
    
}

- (void)handleHiddenImageUploadOption {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.customPopupWindow.frame =  CGRectMake(0, kScreenHeight, kScreenWidth, kFit(182));
        self.backgroundColorView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.customPopupWindow removeFromSuperview];
        [self.backgroundColorView removeFromSuperview];
    }];
    
    
}

#pragma mark - photo
- (CZPhotoPickerController *)photoController {
    __weak typeof(self) weakSelf = self;
    
    return [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        [weakSelf.pickPhotoController dismissAnimated:YES];
        weakSelf.pickPhotoController = nil;
        if (imagePickerController == nil || imageInfoDict == nil) {
            return;
        }
        isRefresh = NO;
        UIImage *image = imageInfoDict[UIImagePickerControllerEditedImage];
        if(!image)
            image = imageInfoDict[UIImagePickerControllerOriginalImage];
        image = [CommonUtil scaleImage:image minLength:1200];
        __weak DJPersonalCenterVC *selfWeak = self;
        [self ImageUpload:image results:^(NSString * imageURL) {
            NSLog(@"imageURL%@", imageURL);
            [selfWeak ReplacePicture:imageURL];
        }];
    }];
}

- (void)ReplacePicture:(NSString *)urlStr {
    
    NSMutableDictionary *URL_Dic  = [NSMutableDictionary dictionary];
    [URL_Dic setObject:urlStr forKey:@"headUrl"];
    NSLog(@"URL_Dic%@", URL_Dic);
    [self  getJSONDataWithUrl:kURL_ReplacePicture parameters:URL_Dic success:^(id responseObject) {
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        MBProgressHUD *warning = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        warning.mode = MBProgressHUDModeText;
        warning.label.text = responseObject[@"msg"];
        warning.label.lineBreakMode = NSLineBreakByWordWrapping;
        warning.label.numberOfLines = 0;
        warning.offset = CGPointMake(0.f, 100);
        warning.bezelView.backgroundColor = [UIColor blackColor];
        warning.bezelView.alpha = 0.7;
        warning.label.textColor = [UIColor whiteColor];
        warning.label.alpha = 1;
        [warning hideAnimated:YES afterDelay:1.2];
        if ([codeStr isEqualToString:@"0"]) {
            NSLog(@"ReplacePicture%@", responseObject);
            [DJUserTool updateHeadUrl:urlStr];
            [self refreshUserInfo:^(BOOL results) {
                [self IsHaveDefaultOrg];
                [self.tableView reloadData];
            }];
        }else {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
}

//创建一个存在于视图最上层的UIViewController
- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)IsHaveDefaultOrg {
    
    NSArray *datarray =  [self queryModel:@"OrgInfoModel"];
    //    NSLog(@"datarray%@", datarray);
    
    if (datarray.count>1) {
        _rightMsgBtn.hidden = NO;
    }
    
    
    self.dataEmptyView.alpha  = 0.0;
    
    if (datarray.count == 0 || datarray.count == 1) {
        _rightMsgBtn.hidden = YES;
        [self getUserInfo];
        return;
    }else {
        _rightMsgBtn.hidden = NO;
    }
    
    for (OrgInfoModel *model in datarray) {
        NSLog(@"OrgChoose<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<%@", model.defaultState);
        if ([model.defaultState isEqualToString:@"1"]) {
            
            [self getUserInfo];
            return;
        }
    }
    _rightMsgBtn.hidden = NO;
    [self OrgChoose];
}

- (void)OrgChoose {
    
    NSArray *datarray =  [self queryModel:@"OrgInfoModel"];
    
    UIViewController *VC = [self appRootViewController];
    
    CGRect frame = VC.view.frame;
    frame.origin.y = 0;
    VC.view.frame = frame;
    self.backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backgroundColorView.backgroundColor = [UIColor blackColor];
    _backgroundColorView.alpha = 0.5;
    [VC.view addSubview:_backgroundColorView];
    self.orgChooseView = [[DJOrgChooseView alloc] init];
    _orgChooseView.delegate = self;
    [VC.view addSubview:_orgChooseView];
    CGFloat height = kFit(105) + datarray.count*kFit(65);
    if (height > kScreenHeight-kStatusBarAndNavigationBarHeight-kTabbarSafeBottomMargin) {
        height = kScreenHeight-kStatusBarAndNavigationBarHeight-kTabbarSafeBottomMargin;
    }
    _orgChooseView.sd_layout.widthIs(kFit(315)).heightIs(height).centerXEqualToView(VC.view).centerYEqualToView(VC.view);
    _orgChooseView.modelArray =[NSMutableArray arrayWithArray:datarray];
    NSLog(@"_orgChooseView.modelArray%@", _orgChooseView.modelArray);
    
    
}

- (void)handleHiddenBackgroundColorView {
    [_orgChooseView removeFromSuperview];
    [_backgroundColorView removeFromSuperview];
}

#pragma mark  DJOrgChooseViewDelegate
- (void)confirmChoicesOrg:(OrgInfoModel *)model {
    [_orgChooseView removeFromSuperview];
    [_backgroundColorView removeFromSuperview];
    
    NSMutableArray *datarray =[NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
    for (int i= 0; i< datarray.count; i++) {
        OrgInfoModel *model = datarray[i];
        if ([model.chooseState isEqualToString:@"1"]) {
            model.defaultState = @"1";
            model.chooseState = @"1";
            datarray[i] = model;
            [DJUserTool setUserOrgAndCustom:model.orgId];
            
        }else {
            model.defaultState = @"0";
            model.chooseState = @"0";
            datarray[i] = model;
        }
    }
    [self.djCoreDataManager save];
    NSArray *testArray =  [self queryModel:@"OrgInfoModel"];
    NSLog(@"testArray%@", testArray);
    [self getUserInfo];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(UIView *)findView:(UIView *)aView withName:(NSString *)name{
    Class cl = [aView class];
    NSString *desc = [cl description];
    if ([name isEqualToString:desc])
        return aView;
    for (UIView *view in aView.subviews) {
        Class cll = [view class];
        NSString *stringl = [cll description];
        if ([stringl isEqualToString:name]) {
            return view;
        }
    }
    return nil;
}

-(void)addSomeElements:(UIViewController *)viewController{
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self addSomeElements:viewController];
}

@end
