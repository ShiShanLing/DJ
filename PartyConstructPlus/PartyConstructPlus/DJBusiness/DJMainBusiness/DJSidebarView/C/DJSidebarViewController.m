//
//  DJSidebarViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/24.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSidebarViewController.h"
#import "InterfaceTestVC.h"
#import "DJSidebarOptionsTableViewCell.h"
#import "DJUserHeadView.h"
#import "UserData.h"
#import "DJLogOutView.h"
#import "DJPersonalCenterVC.h"
#import "DJMyTaskViewController.h"
#import "DJModifyPasswordViewController.h"
#import "DJAboutUsViewController.h"
#import "DJFeedbackViewController.h"
#import "JPUSHService.h"
#import "DJMyNoticeViewController.h"

@interface DJSidebarViewController ()<UITableViewDelegate, UITableViewDataSource,DJLogOutViewDelegate,UIAlertViewDelegate, DJUserHeadViewDelegate>


@property (nonatomic, strong)UITableView *tableView;


/**
 *
 */
@property (nonatomic, strong)NSMutableArray * logInOptionsArray;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * LogOutArray;
/**
 *
 */
@property (nonatomic, strong)DJLogOutView *logOutView;


@end

@implementation DJSidebarViewController



- (NSMutableArray *)logInOptionsArray {
    if (!_logInOptionsArray) {
        _logInOptionsArray = [NSMutableArray array];
    }
    return _logInOptionsArray;
}

- (NSMutableArray *)LogOutArray {
    if (!_LogOutArray) {
        _LogOutArray = [NSMutableArray array];
    }
    return _LogOutArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak DJSidebarViewController *selfWeak = self;
    [self refreshUserInfo:^(BOOL results) {
        [selfWeak.tableView reloadData];
    }];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self handleHiddenSudebar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
    
    self.logOutView = [[DJLogOutView alloc] init];
    _logOutView.delegate = self;
    
    [self.view addSubview:_logOutView];
    _logOutView.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, kFit(32)+kTabbarSafeBottomMargin).widthIs(kFit(260)).heightIs(kFit(48));
    [self refreshData];
}
//请求数据
- (void)refreshData {
 
  NSArray *NotLoggedInDataArray = @[@[@{@"icon":@"DJHomePage",@"title":@"首页"}],//
                                      @[@{@"icon":@"DJAboutUs",@"title":@"关于我们"},@{@"icon":@"DJFeedback",@"title":@"意见反馈"},@{@"icon":@"DJ_delete_search",@"title":@"清除缓存"},]
                                      ];
    NSArray *IsLoggedInDataArray = @[@[@{@"icon":@"DJHomePage",@"title":@"首页"},@{@"icon":@"DJMyTask",@"title":@"我的任务"},@{@"icon":@"DJMyNotice",@"title":@"我的通知"}],
                                     @[@{@"icon":@"DJPassword",@"title":@"修改密码"},@{@"icon":@"DJAboutUs",@"title":@"关于我们"},@{@"icon":@"DJFeedback",@"title":@"意见反馈"},@{@"icon":@"DJ_delete_search",@"title":@"清除缓存"},]
                                     ];
    if ([DJUserTool userIsLogin]) {
        self.LogOutArray = [NSMutableArray arrayWithArray:IsLoggedInDataArray];
        _logOutView.hidden = NO;
    }else {
        self.LogOutArray = [NSMutableArray arrayWithArray:NotLoggedInDataArray];
        _logOutView.hidden = YES;
        };
    [self.tableView reloadData];
    //1.党建发布任务
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[DJSidebarOptionsTableViewCell class] forCellReuseIdentifier:@"DJSidebarOptionsTableViewCell"];

//    _tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    _tableView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    
}



- (void)logOut {
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"退出登录后,您将不再接收来自杭州党建责任的通知，确认退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
        [promptAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    
    if (buttonIndex == 1) {

        [self DeleteHistorySearchData];
        [DJUserTool logOffLogin];
        [self refreshData];
        [self.drawer close];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return self.LogOutArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tempArray = self.LogOutArray[section];
    return tempArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        DJSidebarOptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJSidebarOptionsTableViewCell" forIndexPath:indexPath];
        NSArray *tempArray = self.LogOutArray[indexPath.section];
        cell.dataDic = tempArray[indexPath.row];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 1 && indexPath.row == tempArray.count-1) {
        cell.titleLabel.text = @"清除缓存(正在计算...)";
        
        cell.userInteractionEnabled = NO;
       __block NSInteger size =0;;
        dispatch_async(dispatch_queue_create(0, 0), ^{
             size = [SDImageCache sharedImageCache].getSize;
            //设置文件大小格式
            NSString * sizeText = nil;
            if (size >= pow(10, 9)) {
                sizeText = [NSString stringWithFormat:@"%.1fGB", size / pow(10, 9)];
            }else if (size >= pow(10, 6)) {
                sizeText = [NSString stringWithFormat:@"%.1fMB", size / pow(10, 6)];
            }else if (size >= pow(10, 3)) {
                sizeText = [NSString stringWithFormat:@"%.1fKB", size / pow(10, 3)];
            }else {
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.detailTextLabel.text = sizeText;
                cell.titleLabel.text = [NSString stringWithFormat:@"清除缓存(%@)", sizeText];
                cell.userInteractionEnabled = YES;
            });
        });
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
    }
//    if (indexPath.section == 0 &&indexPath.row == 1) {
//        DJMyTaskViewController *VC =[[DJMyTaskViewController alloc] init];
//        VC.tagState = @"sidebar";
//        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
//        [self.navigationController presentViewController:NAVC animated:YES completion:nil];
//    }
    
    if (indexPath.section == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([DJUserTool userIsLogin]) {
                switch (indexPath.row) {
                    case 0:{
                      [self.drawer close];
                    }
                        break;
                    case 1: {
                        
                        NSMutableArray  *meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
                        if (meunArray.count == 0) {
                            [self  ShowWarningHudMid:@"您不属于任何组织, 无法使用本功能哦!"];
                            
                        }else if ([DJUserTool userIsLogin]) {
                              DJMyTaskViewController *VC =[[DJMyTaskViewController alloc] init];
                              VC.tagState = @"sidebar";
                              UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
                              [self.navigationController presentViewController:NAVC animated:YES completion:nil];
                          }
                    }
                        break;
                    case 2: {
                        if (![DJUserTool userIsLogin]) {
                            [self userLogIn];
                        }else {
                            DJMyNoticeViewController *VC  =[[DJMyNoticeViewController alloc] init];
                            [self presentToNextViewController:VC];
                        }
                    }
                        break;
                    case 3:
                        
                        break;
                    case 4:
                        
                        break;
                    default:
                        break;
                }
            }else {
                switch (indexPath.row) {
                    case 0:{
                        [self.drawer close];
                    }
                        break;
                    case 1: {
                      
                    }
                        break;
                    default:
                        break;
                }
            }
            
            
            
        });
    }
    
    if (indexPath.section == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if ([DJUserTool userIsLogin]) {
                switch (indexPath.row) {
                    case 0:{
                        DJModifyPasswordViewController *VC = [[DJModifyPasswordViewController alloc] init];
                        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
                        [self presentViewController:NAVC animated:YES completion:nil];
                    }
                        break;
                    case 1: {
                        DJAboutUsViewController *VC = [[DJAboutUsViewController alloc] init];
                        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
                        [self presentViewController:NAVC animated:YES completion:nil];
                    }
                        break;
                    case 2: {
                        DJFeedbackViewController *VC = [[DJFeedbackViewController alloc] init];
                        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
                        [self presentViewController:NAVC animated:YES completion:nil];
                    }
                        break;
                    case 3:{
                        DJSidebarOptionsTableViewCell *cell   = (DJSidebarOptionsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                      
                        MBProgressHUD *warning = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
                        warning.label.text = @"清除成功";
                        warning.label.lineBreakMode = NSLineBreakByWordWrapping;
                        UIImage *images=[UIImage imageNamed:@"DJ_CacheClearSuccess"];
                        warning.customView = [[UIImageView alloc] initWithImage:images];
                        warning.label.numberOfLines = 0;
                        warning.bezelView.backgroundColor = [UIColor blackColor];
                        warning.bezelView.alpha = 0.8;
                        warning.offset = CGPointMake(0.f, 100);
                        warning.mode = MBProgressHUDModeCustomView;
                        [warning hideAnimated:YES afterDelay:1.2];
                        cell.titleLabel.text =  @"清除缓存(0B)";
                        warning.label.textColor = [UIColor whiteColor];
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                             }];
                            });        
                }
                        break;
                    case 4:
                        
                        break;
                        
                        
                    default:
                        break;
                }
            }else {
                switch (indexPath.row) {
                    case 0:{
                        DJAboutUsViewController *VC = [[DJAboutUsViewController alloc] init];
                        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
                        [self presentViewController:NAVC animated:YES completion:nil];
                    }
                        break;
                    case 1: {
                        DJFeedbackViewController *VC = [[DJFeedbackViewController alloc] init];
                        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
                        [self presentViewController:NAVC animated:YES completion:nil];
                    }
                        break;
                    case 2: {
                        DJSidebarOptionsTableViewCell *cell   = (DJSidebarOptionsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                        
                        MBProgressHUD *warning = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
                        warning.label.text = @"清除成功";
                        warning.label.lineBreakMode = NSLineBreakByWordWrapping;
                        UIImage *images=[UIImage imageNamed:@"DJ_CacheClearSuccess"];
                        warning.customView = [[UIImageView alloc] initWithImage:images];
                        warning.label.numberOfLines = 0;
                        warning.bezelView.backgroundColor = [UIColor blackColor];
                        warning.bezelView.alpha = 0.8;
                        warning.offset = CGPointMake(0.f, 100);
                        warning.mode = MBProgressHUDModeCustomView;
                        [warning hideAnimated:YES afterDelay:1.2];
                        cell.titleLabel.text =  @"清除缓存(0B)";
                        warning.label.textColor = [UIColor whiteColor];
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                            }];
                        });
                        
                    }
                        break;
                    default:
                        break;
                }
            }
        
      

            });
       
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
        return kFit(48);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kFit(190);
    }else {
        return 0.01;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kFit(31);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        DJUserHeadView *headView  = [[DJUserHeadView alloc] initWithFrame:CGRectMake(0, 0, kFit(260), kFit(190))];
        headView.delegate = self;
        UserData  *model = [DJUserTool getUserInfo];
        [headView.nameBtn setTitle:model.name.length>0?[NSString stringWithFormat:@"你好, %@", model.name]:@"登录/注册" forState:(UIControlStateNormal)];
        [headView.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[DJUserTool getUserHeadImage]]] placeholderImage:[UIImage imageNamed:@"DJUserDefaultHead"]];
        UITapGestureRecognizer *headImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleHeadImageTap)];
        headImageTap.numberOfTouchesRequired = 1; //手指数
        headImageTap.numberOfTapsRequired = 1; //tap次数
        [headView.headImage addGestureRecognizer:headImageTap];
        return headView;
    }else {
        return nil;
    }
}

- (void)handleHeadImageTap {

    //如果没有登录就去登录  如果已经登录就去个人中心
    if ([DJUserTool userIsLogin]) {
        DJPersonalCenterVC *VC =[[DJPersonalCenterVC alloc] init];
        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:NAVC animated:YES completion:nil];
    }else {
        [self userLogIn];
        
    }
    
}

#pragma mark  DJUserHeadViewDelegate
- (void)ClickUserCenter {
    
    //如果没有登录就去登录  如果已经登录就去个人中心
    if ([DJUserTool userIsLogin]) {
        DJPersonalCenterVC *VC =[[DJPersonalCenterVC alloc] init];
        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:NAVC animated:YES completion:nil];

    }else {
        [self userLogIn];

    }
    
    
}


- (void)handleHiddenSudebar {
    [self.drawer close];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    return footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Configuring the view’s layout behavior
//
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(DJSidebarVC *)drawerController
{
    self.view.userInteractionEnabled = YES;
    
}

- (void)drawerControllerDidClose:(DJSidebarVC *)drawerController {
    self.view.userInteractionEnabled = NO;
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
