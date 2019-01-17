//
//  DJBaseNavigationController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/10.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseNavigationController.h"
#import "DJLogInViewController.h"
#import "DJCirculationImageView.h"
#import "LFPermissionMgr.h"
#import "DJResponsibilityViewController.h"
#import "DJTaskMainViewController.h"
#import "DJTranscriptViewController.h"
#import "DJFilingCabinetViewController.h"
#import "DJNetworkStatusSingleton.h"
#import "DJPerformanceViewController.h"
#import "DJMyTaskDetailsViewController.h"
#import "DJSystemNoticeViewController.h"
#import "DJMyTaskViewController.h"
#import "DJNearOrgViewController.h"
#import "DJSJFXViewController.h"
@interface DJBaseNavigationController ()<DJCirculationImageViewDelegate>{
    BOOL isRequestFinish;
    MBProgressHUD *newhud;
    MBProgressHUD *warning;
}
@property (nonatomic, strong) DJCirculationImageView *DJLBTView;


@end

@implementation DJBaseNavigationController {
    
    BOOL isOngoingRefresh;
    
}

- (UIBarButtonItem *)returnButtonItem {
    if (!_returnButtonItem) {
        UIButton *ReturnButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        ReturnButton.frame = CGRectMake(0, 0, 60, 40);
        [ReturnButton setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
        [ReturnButton addTarget:self action:@selector(handleReturnButton) forControlEvents:UIControlEventTouchUpInside];
        UIEdgeInsets imageED =  ReturnButton.imageEdgeInsets;
        imageED.left =-60+18;
        ReturnButton.imageEdgeInsets = imageED;
        _returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ReturnButton];
    }
    return _returnButtonItem;
}

- (void)handleReturnButton {
    
    self.returnClickBlock(nil);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isOngoingRefresh = NO;
    self.djCoreDataManager =  [DJCoreDataManager shareInstance];
    self.view.backgroundColor = [UIColor whiteColor];
    [[LFPermissionMgr sharedInstance] accessCamera:^(BOOL granted) {
        if (granted) {
            NSLog(@"camera access granted");
        } else {
            NSLog(@"camera access not granted");
        }
    }];

    [[LFPermissionMgr sharedInstance] accessPhoto:^(BOOL granted) {
        if (granted) {
            NSLog(@"photo access granted");
        } else {
            NSLog(@"photo access not granted");
        }
    }];
    
    [[LFPermissionMgr sharedInstance] accessLocation:LocationAuthorizedWhenInUse handler:^(BOOL granted, CLLocation *location) {
        if (granted) {
            NSLog(@"photo access granted");
        } else {
            NSLog(@"photo access not granted");
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentPushMessage:)name:@"presentPushMsg" object:nil];
    // Do any additional setup after loading the view.
}

//当接收到新的推送消息
- (void)presentPushMessage:(NSNotification *)Notification {

    NSDictionary *pushDic = Notification.object;
    NSString *msgType = [NSString stringWithFormat:@"%@", pushDic[@"msgType"]];
    NSLog(@"pushDic%@", pushDic);
    NSLog(@"msgType%@", msgType);
    
    if ([msgType isEqualToString:@"(null)"]) {
        return;
    }else {
        if ([msgType isEqualToString:@"task"]) {
            
            NSArray *keyArray = [pushDic allKeys];
            
            if ([keyArray containsObject:@"taskList"] && ![[CommonUtil getCurrentVC] isKindOfClass:[DJMyTaskViewController class]]) {
                DJMyTaskViewController *VC = [[DJMyTaskViewController alloc] init];
                VC.tagState = @"sidebar";
                [self presentToNextViewController:VC];
                
            }else {
                OrgInfoModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"OrgInfoModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
                model.orgId =  pushDic[@"orgId"];
                model.stationId = pushDic[@"stationId"];
                NSString *taskId = [NSString stringWithFormat:@"%@", pushDic[@"taskId"]];
                DJMyTaskDetailsViewController *VC = [[DJMyTaskDetailsViewController alloc] init];
                VC.taskId = taskId;
                VC.animationType = @"present";
                VC.orgModel =  model;
                NSLog(@"VC.orgModel%@", VC.orgModel);
                
                [self presentToNextViewController:VC];
            }
            
            
        }else if ([msgType isEqualToString:@"system"]) {
            
            if (![[CommonUtil getCurrentVC] isKindOfClass:[DJSystemNoticeViewController class]] ) {
                DJSystemNoticeViewController *VC = [[DJSystemNoticeViewController alloc] init];
                VC.animationType = @"present";
                [self presentToNextViewController:VC];
                
            }else {
                
            }
        }
    }
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushPushMsg" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getJSONDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(DJSuccessResponseBlock)success failure:(DJFailResponseBlock)failure {
    if ([DJNetworkStatusSingleton sharedNetworkStatusSingleton].isNerWork) {
        
    }else {
        [self ShowWarningHudMid:@"当前网络不稳定或未接入互联网, 请检查您的网络设置!"];
        
        NSError *error;
        failure(error);
        return;
    }
    [DJNetworking getJSONDataWithUrl:urlString parameters:parameters success:^(id responseObject) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        [self hudDissmiss];
        
        //这里是直接返回dic还是判断请求状态再返回.待思考
        if([dic count] == 0) {
            return ;
        }
        NSString *returnCode = [NSString stringWithFormat:@"%@", [dic objectForKey:@"code"]];
        if ([returnCode isEqualToString:@"-6"]) {
            NSLog(@"下线通知%@", dic);
            [self DeleteHistorySearchData];
            [DJUserTool logOffLogin];
            UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"您的账号已在另外一台设备上登录了杭州党建责任。如非本人操作，则密码可能已泄露，建议您尽快进行密码重置。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [DJUserTool logOffLogin];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [DJUserTool logOffLogin];
                DJLogInViewController *userLoginView = [[DJLogInViewController alloc] init];
                userLoginView.iskick = @"";
                UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:userLoginView];
                [self presentViewController:navigationController animated:YES completion:^{
                    
                }];
            }];
            // 3.将“取消”和“确定”按钮加入到弹框控制器中
            [alertV addAction:cancle];
            [alertV addAction:confirm];
            // 4.控制器 展示弹框控件，完成时不做操作
            [self presentViewController:alertV animated:YES completion:^{
                nil;
            }];
            
        } else {
            success(responseObject);
        }
    }failure:^(NSError *error) {
        [self hudDissmiss];
        failure(error);
        NSInteger errCode = error.code;
        NSString *err = [NSString stringWithFormat:@"网络调用失败[%ld]",(long)errCode];
        kNSLog(@" [self showMessageHud:err];%@",err );
        [self ShowWarningHudMid:@"当前网络不稳定或未接入互联网, 请检查您的网络设置!"];
        
    }];
}


- (void)pushViewControllerAccordingUrl:(NSString *)url {
    
    if ([url isURL]) {
        [self  ShowWarningHudMid:@"模块建设中"];
        return;
    }
    
    if ([url isEqualToString:@"app://file_cabinet"]) {//档案柜
        DJFilingCabinetViewController *VC = [[DJFilingCabinetViewController alloc] init];
        VC.type = 2;
        [self presentToNextViewController:VC];
        return;
    }

    if ([url isEqualToString:@"app://party_performance"]) {//党建绩效
        DJPerformanceViewController *VC = [[DJPerformanceViewController alloc] init];
        VC.type = 2;
        [self presentToNextViewController:VC];
        return;
    }
    
    if ([url isEqualToString:@"app://responsibility_list"]) {//党建责任
        DJResponsibilityViewController *VC = [[DJResponsibilityViewController alloc] init];
        VC.type = 2;
        [self presentToNextViewController:VC];
        return;
    }

    NSMutableArray  *meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];

    if (meunArray.count == 0) {
        [self  ShowWarningHudMid:@"您不属于任何组织, 无法使用本功能哦!"];
        return;
    }else {
        if ([self  getDefaultOrg] == nil ) {
            return;
        }
    }
    
    if ([url isEqualToString:@"app://side_organization"]) {//身边组织
        dispatch_async(dispatch_get_main_queue(), ^{
            DJNearOrgViewController *VC = [[DJNearOrgViewController alloc] init];
            [self presentToNextViewController:VC];
        });
        return;
    }
    
    if ([url isEqualToString:@"app://task_management"]) {//任务管理
        DJTaskMainViewController *VC = [[DJTaskMainViewController alloc] init];
        VC.type = 2;
        [self presentToNextViewController:VC];
        return;
    }
    
    if ([url isEqualToString:@"app://data_analysis"]) {//任务管理
        DJSJFXViewController *VC = [[DJSJFXViewController alloc] init];
        [self presentToNextViewController:VC];
        return;
    }
}

#pragma mark -跳转下一页面
-(void)pushToNextViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)presentToNextViewController:(UIViewController *)viewController {
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
    
}

#pragma mark -去除tableview多余线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark -设置hud
- (void)showHud:(NSString *)message title:(NSString *)title{
    NSLog(@"%@newhud", newhud);
    if (newhud.alpha != 0) {
        return;
    }
    newhud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    newhud.userInteractionEnabled = YES;
    newhud.mode = MBProgressHUDModeIndeterminate;
    newhud.backgroundView.backgroundColor =[UIColor clearColor];
    newhud.backgroundView.alpha = 0.2;
    newhud.label.text = title;
    newhud.label.numberOfLines = 0;
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    newhud.label.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:kFit(18)];
    newhud.label.textColor = [UIColor whiteColor];
    newhud.detailsLabel.textColor =[UIColor whiteColor];
    newhud.detailsLabel.text = message;
    newhud.detailsLabel.textAlignment = 0;
    newhud.detailsLabel.font = MFont(kFit(16));
    newhud.bezelView.backgroundColor = [UIColor blackColor];
//    newhud.bezelView.alpha = 0.8;
    
}
//关闭
-(void)hudDissmiss {
    [newhud hideAnimated:YES];
}
//警告
-(void)ShowWarningHud:(NSString *)message {
    MBProgressHUD *warning = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    warning.mode = MBProgressHUDModeText;
    warning.label.text = message;
    warning.label.lineBreakMode = NSLineBreakByWordWrapping;
    warning.label.numberOfLines = 0;
    warning.offset = CGPointMake(0.f, (kScreenHeight/2)-kFit(190)+kTabbarSafeBottomMargin);
    warning.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    warning.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    warning.label.textColor = [UIColor whiteColor];
    warning.label.alpha = 1;
    [warning hideAnimated:YES afterDelay:1.6];
}

//警告
-(void)ShowWarningHudMid:(NSString *)message {
    if (warning.alpha != 0) {
        return;
    }
    warning = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    warning.mode = MBProgressHUDModeText;
    warning.label.text = message;
    warning.label.textColor = [UIColor whiteColor];;
    warning.label.lineBreakMode = NSLineBreakByWordWrapping;
    warning.label.numberOfLines = 0;
    
    warning.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    warning.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    warning.offset = CGPointMake(0.f, 100);
    [warning hideAnimated:YES afterDelay:1.6f];
}

#pragma mark - 登陆页面调用的方法
- (void)userLogIn {
    DJLogInViewController *userLoginView = [[DJLogInViewController alloc] init];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:userLoginView];
    [self presentViewController:navigationController animated:YES completion:^{
        
    }];
}
//系统提示的弹出窗
- (void)timerFireMethod:(NSTimer*)theTimer {//弹出框
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

- (void)showAlert:(NSString *) _message time:(CGFloat)time{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
#pragma mark 通知相关
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//查询实体类
- (NSArray *)queryModel:(NSString *)modelName {
    NSEntityDescription *entity = [NSEntityDescription entityForName:modelName
                                              inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    ///创建查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    ///设置查询请求的 实体
    [request setEntity:entity];
    ///获取查询的结果
    NSArray *resultArray = [self.djCoreDataManager.managedObjectContext executeFetchRequest:request
                                                                                      error:nil];
    
    return resultArray;
}
//删除之前的数据 这里可以放进 base
- (void)deleteModel :(NSString *)modelStr{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:modelStr
                                              inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    ///创建查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    ///设置查询请求的 实体
    [request setEntity:entity];
    //    //添加查询条件
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age=10"];
    //    [request setPredicate:predicate];
    ///获取查询的结果
    NSArray *resultArray = [self.djCoreDataManager.managedObjectContext executeFetchRequest:request
                                                                                      error:nil];
    
    for (OrgInfoModel *model in resultArray) {
        [self.djCoreDataManager.managedObjectContext deleteObject:model];
    }
    
    [self.djCoreDataManager save];
}
- (void)ImageUpload:(UIImage *)image results:(ImageUpload)results {
    
    NSString *imageData = [UIImage imageBase64WithDataURL:image];
    NSString *imageFormat = [UIImage typeForImageData:image];
    //    NSLog(@"imageFormat%@", imageFormat);
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setObject:imageData forKey:@"fileBase64Str"];
    
    [URL_Dic setObject:imageFormat forKey:@"fileSuffix"];
    [self  getJSONDataWithUrl:kFileUpload parameters:URL_Dic success:^(id responseObject) {
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
//        NSLog(@"这里是图片上传啊 这里是图片上传啊 这里是图片上传啊 这里是图片上传啊%@ 这里是图片上传啊 这里是图片上传啊 这里是图片上传啊 %@", responseObject, URL_Dic);
        if ([codeStr isEqualToString:@"0"]) {
            NSDictionary *dataDic =responseObject[@"response"];
            results(dataDic[@"fileUrl"]);
        }else if([codeStr isEqualToString:@"-2"]){
            results(@"");
        }else {
            results(@"");
            
        }
    } failure:^(NSError *error) {
        results(@"");
        NSLog(@"error%@", error);
    }];
    
}

- (void)setFullScreenImageShow:(NSArray *)imageArray  defaultIndex:(NSInteger)index {
    UIViewController *topVC = [self appRootViewController];
    
    UIImage *image = [UIImage imageNamed:@"123.png"];
    self.DJLBTView = [[DJCirculationImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andImageNamesArray:imageArray andPlaceImage:image];
    _DJLBTView.titleViewStatus = SZTitleViewBottomOnlyPageControl;
    
    _DJLBTView.backgroundColor =[UIColor lightGrayColor];
    _DJLBTView.delegate = self;
    _DJLBTView.pauseTime = 100;
    _DJLBTView.imageContentMode =  UIViewContentModeScaleAspectFit;
    [topVC.view addSubview:_DJLBTView];
    _DJLBTView.sd_layout.leftSpaceToView(topVC.view, 0).topSpaceToView(topVC.view, 0).rightSpaceToView(topVC.view, 0).bottomSpaceToView(topVC.view, 0);
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

- (void)CirculationImageClickEvent:(NSInteger)index {
    
    [self.DJLBTView removeFromSuperview];
    
}



//请求用户信息数据
- (void)refreshUserInfo:(proceResults)results {
    isOngoingRefresh = YES;
    [self  getJSONDataWithUrl:kURL_UserInfoDetails parameters:nil success:^(id responseObject) {
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"responseObject%@", responseObject);
        [self hudDissmiss];
        if ([codeStr isEqualToString:@"0"]) {
            [self parsingUserInfoData:responseObject];
            results(YES);
        }else if([codeStr isEqualToString:@"-2"]){
            results(NO);
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }else {
            results(NO);
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [self hudDissmiss];
        NSLog(@"error%@", error);
    }];
}
//解析用户信息数据
- (void)parsingUserInfoData:(NSDictionary  *)dic{
    NSDictionary *dataDic = dic[@"response"];
    NSString *ImageUrlStr  = [NSString stringWithFormat:@"%@", dataDic[@"headUrl"]];
    if ([ImageUrlStr isURL]) {
        
        [DJUserTool updateHeadUrl:ImageUrlStr];
    }else {
        [DJUserTool updateHeadUrl:[NSString stringWithFormat:@"%@%@",dataDic[@"dfsUrl"],  ImageUrlStr]];
    }
    
    [self deleteModel:@"OrgInfoModel"];
    NSArray *orgArray = dataDic[@"orgList"];
    if (![orgArray isKindOfClass:[NSArray class]]) {
        
        return;
    }
    
    if (orgArray.count == 0) {
        
        return;
    }
    [DJUserTool setUserPhone:dataDic[@"tel"]];
    NSString *oldOrgId = [NSString stringWithFormat:@"%@", [DJUserTool getUserOrgAndCustom]];
    NSLog(@"UserConfig%@", [NSString stringWithFormat:@"%@", UserOrgConfig]);
    
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSDictionary *dataDic in orgArray) {
        OrgInfoModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"OrgInfoModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in dataDic) {
            [model setValue:dataDic[key] forKey:key];
        }
        if (orgArray.count == 1) {
            model.defaultState = @"1";
            [DJUserTool setUserOrgAndCustom:model.orgId];
        }
        
        [modelArray addObject:model];
//        NSLog(@"modelArray%@", modelArray);
    }
    if (oldOrgId.length != 0) {
        for (int i= 0; i<modelArray.count; i++) {
            OrgInfoModel *newModel = modelArray[i];
            if ([newModel.orgId isEqualToString:oldOrgId]) {
                newModel.defaultState = @"1";
                newModel.chooseState= @"1";
                modelArray[i] = newModel;
                break;
            }
        }
    }
    NSLog(@"<><><><><><><><><><><>modelArray%@", modelArray);
    
    [self.djCoreDataManager save];
}
//删除
- (void)DeleteHistorySearchData {
    
    NSArray *sandboxpath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [sandboxpath objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"searchOrgAndUserRecord.plist"];
    //存储根数据
    NSMutableDictionary *rootDic = [[NSMutableDictionary alloc ] init];
    //字典中的详细数据
    [rootDic setObject:@[] forKey:@"user"];
    [rootDic setObject:@[] forKey:@"org"];
    //写入文件
    [rootDic writeToFile:plistPath atomically:YES];
    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"写入成功");
    
}

- (OrgInfoModel *)getDefaultOrg{
    NSMutableArray  *meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
    
    OrgInfoModel *orgModel = [NSEntityDescription insertNewObjectForEntityForName:@"OrgInfoModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    
    for (int i = 0; i <meunArray.count; i ++) {
        OrgInfoModel *orgInfoModel = meunArray[i];
        if ([orgInfoModel.defaultState isEqualToString:@"1"]) {
            orgModel = orgInfoModel;
        }
    }
    return orgModel;
    
}

//
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
