//
//  DJMainViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/24.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMainViewController.h"

#import "DJCirculationImageView.h"
#import "ConfigurableIconTVCell.h"
#import "DJFCTableViewCell.h"
#import "DJLearningTableViewCell.h"
#import "SDCycleScrollView.h"
#import "DJMyNoticeViewController.h"

#import "ShufflingFigureModel+CoreDataProperties.h"//轮播图model
//组织选择
#import "DJOrgChooseView.h"
#import "DJAllModuleShowViewController.h"
#import "DJVersionUpdateView.h"
#import "DJNotificationBarView.h"
#import <IQKeyboardManager.h> //头文件

#import "DJNearOrgViewController.h"
#import "DJWebViewController.h"
#import "DJTwolearnToDoOneVC.h"

#import "DJThreeWillOneLessonViewController.h"
#import "DJThematicPartyDayViewController.h"

#define headView_height  200

@interface DJMainViewController ()<UITableViewDelegate, UITableViewDataSource,DJCirculationImageViewDelegate,DJLearningTableViewCellDelegate,DJFCTableViewCellDelegate,ConfigurableIconTVCellDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate, DJOrgChooseViewDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, copy)NSArray *VCArray;
/**
 *
 */
@property (nonatomic, strong)UITableView * tableView;


@property (nonatomic, strong)DJCirculationImageView *DJLBTView;
/**
 *轮播图展示图片的URL数组
 */

@property (copy, nonatomic) NSMutableArray *imageUrlArray;
/**
 *模拟导航条
 */
@property (nonatomic, strong)UIView *TabBarView ;
/**
 *自定义模块展示
 */
@property (nonatomic, strong)NSMutableArray * moduleArray;
/**
 *轮播图data数组
 */
@property (nonatomic, strong)NSMutableArray * ShufflingFigureArray;

/**
 *半透明黑色背景view
 */
@property (nonatomic, strong)UIView *backgroundColorView;

/**
 *组织选择view
 */
@property (nonatomic, strong)DJOrgChooseView *orgChooseView;

/**
 *默认展示的模块数组  按照用户之前选择的顺序排列
 */
@property (nonatomic, strong)NSMutableArray * defaultModuleArray;

/**
 *轮播图对象
 */
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@end

@implementation DJMainViewController
#pragma  mark ******************* 轮播图  *******************
- (NSMutableArray *)defaultModuleArray {
    if (!_defaultModuleArray) {
        _defaultModuleArray = [NSMutableArray array];
    }
    return _defaultModuleArray;
}
- (NSMutableArray *)moduleArray {
    if (!_moduleArray) {
        _moduleArray = [NSMutableArray array];
    }
    return _moduleArray;
}

- (NSMutableArray *)ShufflingFigureArray {
    if (!_ShufflingFigureArray) {
        _ShufflingFigureArray = [NSMutableArray array];
    }
    return _ShufflingFigureArray;
}

- (DJCirculationImageView *)DJLBTView {
    if (!_DJLBTView) {
        UIImage *image = [UIImage imageNamed:@""];//banner
        _DJLBTView = [[DJCirculationImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kFit(headView_height)+(kiPhoneX?24:0)) andImageURLsArray:@[@""] andPlaceImage:image];//
        _DJLBTView.titleViewStatus = SZTitleViewBottomOnlyPageControl;
        _DJLBTView.delegate = self;
        _DJLBTView.pauseTime = 5;
    }
    return _DJLBTView;
}

- (void)CirculationImageClickEvent:(NSInteger)index {
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak DJMainViewController *selfWeak = self;
    if ([DJUserTool userIsLogin]) {
        
        [self refreshUserInfo:^(BOOL results) {
            if (results) {
                [selfWeak OrgChoose];
            }
        }];
    }
    [self getUpdatedVersion];
}
//获取版本号
- (void)getUpdatedVersion {
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setObject:@"ios" forKey:@"sysType"];
    
    [self getJSONDataWithUrl:kURL_VersionUpdate parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        //NSLog(@"获取版本号信息%@", responseObject);
        if ([code isEqualToString:@"0"]) {
            NSDictionary *responseDic = responseObject[@"response"];
            NSString *newVersionName = responseDic[@"versionName"];
            newVersionName = [newVersionName stringByReplacingOccurrencesOfString:@"v" withString:@""];
            NSMutableArray *newVersionArray =  [NSMutableArray array];
            NSMutableArray *newTempArray = [NSMutableArray arrayWithArray:[newVersionName componentsSeparatedByString:@"."]];
            for (int i = 0; i < newTempArray.count; i ++) {
                NSString  *versionStr = newTempArray[i];
                if (versionStr.length == 0 || versionStr == nil || versionStr == NULL) {
                    
                }else {
                    [newVersionArray addObject:versionStr];
                }
            }
            
            NSString *oidVersionStr = [DJUserTool getVersion];
            oidVersionStr = [oidVersionStr stringByReplacingOccurrencesOfString:@"v" withString:@""];
            
            NSMutableArray *oldVersionArray =  [NSMutableArray array];
            
            NSMutableArray *oldTempArray = [NSMutableArray arrayWithArray:[oidVersionStr componentsSeparatedByString:@"."]];
            for (int i = 0; i < oldTempArray.count; i ++) {
                NSString  *versionStr = oldTempArray[i];
                if (versionStr.length == 0 || versionStr == nil || versionStr == NULL) {
                    
                }else {
                    [oldVersionArray addObject:versionStr];
                }
            }
            BOOL  isNewVersion = NO;
            
            for (int i= 0; i< oldVersionArray.count; i++) {
                NSString *oldStr = oldVersionArray[i];
                NSString *newStr = newVersionArray[i];
//                NSLog(@"newStr%@oldStr%@", newStr, oldStr);
                if (newStr.integerValue > oldStr.integerValue) {
                    isNewVersion = YES;
                    break;
                }else if(newStr.integerValue < oldStr.integerValue){
                    break;
                }
            }
//            NSLog(@"oldVersionArray%@oidVersionStr%@ \n newVersionArray%@", oldVersionArray,oidVersionStr,  newVersionArray);
//            NSLog(@"%@新版本", isNewVersion?@"有":@"没有");
            
            if (isNewVersion) {
                [DJUserTool setVersion:newVersionName];
                DJVersionUpdateView *versionUpdateView = [[DJVersionUpdateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                if ([responseDic[@"isForce"] isEqualToString:@"n"]) {
                    versionUpdateView.upDatatype = 0;
                }else {
                    versionUpdateView.upDatatype = 1;
                }
                __block DJVersionUpdateView *weakVU = versionUpdateView;
                versionUpdateView.versionUpData = ^(NSInteger type) {
                    
                    if (type == 0) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%9D%AD%E5%B7%9E%E5%85%9A%E5%BB%BA%E8%B4%A3%E4%BB%BB/id1239300314?mt=8"]];
                    }
                    
                    NSLog(@"[DJUserTool getVersion]%@, newVersionName%@", [DJUserTool getVersion], newVersionName);
                    [UIView animateWithDuration:0.4 animations:^{
                        weakVU.alpha = 0;
                    } completion:^(BOOL finished) {
                        [weakVU removeFromSuperview];
                    }];
                };
                [self.view addSubview:versionUpdateView];
                NSLog(@"versionUpdateView.contentLabel.height%f %f", versionUpdateView.contentLabel.frame.size.height, versionUpdateView.contentLabel.frame.size.width);
            }
        }else {
        }
    } failure:^(NSError *error) {
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_cycleScrollView) {
        [_cycleScrollView start];
    }
    [self  showHud:@"" title:@""];
    self.drawer.screenEdgePanGestureRecognize.enabled = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self getShufflingFigureData];
    [self getFunctionModule];
    [self.navigationController setNavigationBarHidden:YES];
    [self RegisteredPush];
    
    
    
}
//如果之前没有注册过通知或者失败了,,那么就继续注册
- (void)RegisteredPush {
    
    if ([[DJUserTool  getRegistID] isEmpty] || ![DJUserTool userIsLogin] || [[DJUserTool getJPushRegState]  isEqualToString:@"YES"]) {
        return;
    }
    
    NSString *RegistID = [NSString stringWithFormat:@"%@", [DJUserTool  getRegistID]];
//    NSLog(@"[DJUserTool  getRegistID]<%@> RegistID%@", [DJUserTool  getRegistID] , RegistID);
    
    if ([RegistID isEqualToString:@"(null)"]) {
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

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_cycleScrollView stop];
    [self handleHiddenBackgroundColorView];
    self.drawer.screenEdgePanGestureRecognize.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];;
    [self createTableView];
    self.TabBarView  = [[UIView alloc] init];
    self.TabBarView.backgroundColor = [UIColor whiteColor];
    self.TabBarView.alpha = 0;
    [self.view addSubview:_TabBarView];
    _TabBarView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(kStatusBarAndNavigationBarHeight);
    
    /*
     解释下下面的高度计算
     leftSidebarBtn  20(距离top的距离) + kiPhoneX?24:0(如果是iphoneX就+24 原因是 X的导航条比其他手机导航条高了24)
     */
    UIButton *leftSidebarBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [leftSidebarBtn setImage:[UIImage imageNamed:@"DJHamburger"] forState:(UIControlStateNormal)];
    [leftSidebarBtn addTarget:self action:@selector(handleLeftSidebarBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:leftSidebarBtn];
    leftSidebarBtn.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 20+(kiPhoneX?24:0)).heightIs(43).widthIs(kFit(43));
    
    UIButton *rightMsgBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [rightMsgBtn setImage:[UIImage imageNamed:@"DJ_main_msgNotification"] forState:(UIControlStateNormal)];
    
    [rightMsgBtn addTarget:self action:@selector(handleRightMsgBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:rightMsgBtn];
    rightMsgBtn.sd_layout.rightSpaceToView(self.view, 0).topSpaceToView(self.view, 20+(kiPhoneX?24:0)).heightIs(43).widthIs(kFit(43));
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"杭州党建责任";
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.view addSubview:titleLabel];
    titleLabel.sd_layout.widthIs(200).heightIs(17).topSpaceToView(self.view, 32+(kiPhoneX?24:0)).centerXEqualToView(self.view);
    //    注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChanges) name:@"Network changes" object:nil];
    
}

- (void)handleNetworkChanges {
    NSLog(@"网络发生变化-刷新界面");
    [self getShufflingFigureData];
    [self getFunctionModule];
}
//进入消息中心
- (void)handleRightMsgBtn {
    
    if (![DJUserTool userIsLogin]) {
        [self userLogIn];
    }else {
        DJMyNoticeViewController *VC  =[[DJMyNoticeViewController alloc] init];
        [self presentToNextViewController:VC];
    }
}
//请求轮播图数据
- (void)getShufflingFigureData {
    NSLog(@"kURL_ScrollFigure%@", kURL_ScrollFigure);
    
    [self getJSONDataWithUrl:kURL_ScrollFigure parameters:nil success:^(id responseObject) {
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"请求轮播图数据responseObject%@", responseObject[@"response"]);
        if ([codeStr isEqualToString:@"0"]) {
            [self parsingShufflingFigureData:responseObject];
        }else {
            [self  ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"error%@", error);
    }];
}

//解析轮播图数据
- (void)parsingShufflingFigureData:(NSDictionary *)dic {
    [self.ShufflingFigureArray removeAllObjects];
    NSArray *dataArray = dic[@"response"];
    if (![dataArray isKindOfClass:[NSArray class]]) {
        return;
    }
    
    for (NSDictionary *dataDic in dataArray) {
        @autoreleasepool {
            ShufflingFigureModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"ShufflingFigureModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            for (NSString *key in dataDic) {
                [model setValue:dataDic[key] forKey:key];
            }
            [self.ShufflingFigureArray addObject:model];
        }
    }
    [self.tableView   reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationAutomatic)];
}

//请求可配置模块---->
- (void)getFunctionModule {
    [self getJSONDataWithUrl:kURL_configIcon parameters:nil success:^(id responseObject) {
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
//                NSLog(@"请求可配置模块%@", responseObject);
        if ([codeStr isEqualToString:@"0"]) {
            [self parsingConfigModule:responseObject];
        }else {
            [self  ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
}

//解析可配置模块
- (void)parsingConfigModule:(NSDictionary *)dic {
    [self.defaultModuleArray removeAllObjects];
    [self.moduleArray removeAllObjects];
    NSArray *moduleArray =dic[@"response"];
    if(![moduleArray isKindOfClass:[NSArray class]]) {
        return;
    }
    if (moduleArray.count == 0) {
        return;
    }
    for (NSDictionary *modelDic in moduleArray) {
        @autoreleasepool {
            ConfigModuleModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"ConfigModuleModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            for (NSString *key in modelDic) {
                if ([key isEqualToString:@"picture"]) {
                    model.moduleImage =modelDic[key];
                }else {
                    [model setValue:modelDic[key] forKey:key];
                }
            }
            [self.moduleArray addObject:model];
        }
    }
    
    //下面将设置默认展示图片,或者,对比默认图标
    NSString *modukeStr =  [DJUserTool getUserCustomModule];
    if (modukeStr.length == 0 || modukeStr ==NULL|| modukeStr ==NULL) {//如果本地存储的没有这个用户的配置信息
        NSString *moduleIdSpliceStr;
        for (int i =0; i < self.moduleArray.count; i ++) {//那么就默认展示所有组织中的前四个 并设置为默认模块
            ConfigModuleModel *model =  self.moduleArray[i];
                model.isDefault = @"1";
                if (i == 0) {
                    moduleIdSpliceStr = model.moduleId;
                }else {
                    moduleIdSpliceStr = [NSString stringWithFormat:@"%@,%@",moduleIdSpliceStr, model.moduleId];
                }
            [self.defaultModuleArray addObject:model];
            self.moduleArray[i] = model;
        }
        
//        NSLog(@"moduleIdSpliceStr%@", moduleIdSpliceStr);
        [DJUserTool setUserCustomModule:moduleIdSpliceStr];
    }else {//否者就有配置  需要判断本地存储的后台有没有返回
        NSString *moduleIdSpliceStr;
        NSMutableArray  *moduleArray= [NSMutableArray arrayWithArray:[modukeStr componentsSeparatedByString:@","]];
        for (int i= 0; i< moduleArray.count; i++) {//遍历 默认的 模块id str
            NSString *singleModule = moduleArray[i];
            for (int j = 0; j  < self.moduleArray.count;  j ++) {//然后遍历获取的最新的模块
                ConfigModuleModel *model =  self.moduleArray[j];
                if ([singleModule isEqualToString:model.moduleId]) {//如果存储的模块id == self.moduelArray[N].id 那么就把这个模块设置成默认 并记录该模块id 拼接起来从新存储一次
                    model.isDefault = @"1";
                    if (moduleIdSpliceStr.length == 0) {
                        moduleIdSpliceStr = model.moduleId;
                    }else {
                        moduleIdSpliceStr = [NSString stringWithFormat:@"%@,%@",moduleIdSpliceStr, model.moduleId];
                    }
                    self.moduleArray[j]= model;
                    [self.defaultModuleArray addObject:model];
                }
            }
        }
        [DJUserTool setUserCustomModule:moduleIdSpliceStr];
    }
//    NSLog(@"self.moduleArray%@", self.moduleArray);
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationAutomatic)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"%f",self.tableView.contentOffset.y);
    if (self.tableView.contentOffset.y <= 0) {
        self.tableView.bounces = NO;
        NSLog(@"禁止下拉");
    }else if (self.tableView.contentOffset.y >= 0){
            self.tableView.bounces = YES;
            NSLog(@"允许上拉");
    }
    
    //需要滑动的距离
    CGFloat  height = headView_height - kStatusBarAndNavigationBarHeight;
    //目前滑动的距离
    CGFloat  Y =  self.tableView.contentOffset.y;
    CGFloat viewAlpha = Y/height;
    if (viewAlpha > 1) {
        viewAlpha = 1;
    }
    if (viewAlpha < 0) {
        viewAlpha = 0;
    }
    __weak __typeof(self) weakself= self;
    [UIView animateWithDuration:0.1 animations:^{
        weakself.TabBarView.alpha = viewAlpha;
    }];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -1, kScreenWidth, kScreenHeight) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabbarSafeBottomMargin, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[DJLearningTableViewCell class] forCellReuseIdentifier:@"DJLearningTableViewCell"];
    [_tableView registerClass:[ConfigurableIconTVCell class] forCellReuseIdentifier:@"ConfigurableIconTVCell"];
    [_tableView registerClass:[DJFCTableViewCell class] forCellReuseIdentifier:@"DJFCTableViewCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[DJNotificationBarView class] forHeaderFooterViewReuseIdentifier:@"DJNotificationBarView"];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        if (self.ShufflingFigureArray.count != 0) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (ShufflingFigureModel *model in self.ShufflingFigureArray) {
                NSString *imageStr  = model.picture;
                if ([imageStr isURL]) {
                    [tempArray addObject:model.picture];
                }else {
                    [tempArray addObject:[NSString stringWithFormat:@"%@%@",model.dfsUrl ,model.picture]];
                }
            }
            if (!_cycleScrollView) {
                self.cycleScrollView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth,kFit(headView_height)+(kiPhoneX?24:0)) delegate:self placeholderImage:[UIImage imageNamed:@"DJ_lbt_load"]];//[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,
                _cycleScrollView.autoScrollTimeInterval = 5.0;
                _cycleScrollView.currentPageDotColor = kColorRGB(30,139,223,1);
            }
            _cycleScrollView.imageURLStringsGroup = tempArray;
            [cell.contentView addSubview:_cycleScrollView];
        }
        return cell;
    }else if (indexPath.section==1) {
        ConfigurableIconTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfigurableIconTVCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.modelArray = self.defaultModuleArray;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 2){
        DJFCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJFCTableViewCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else {
        DJLearningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJLearningTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kFit(headView_height)+(kiPhoneX?24:0);
    }else if (indexPath.section==1) {
        int  height = 1;
        if (self.defaultModuleArray.count == 0) {
            height = 1;
        }else {
            height = (int)((self.defaultModuleArray.count)/4) +1;
        }

        return kFit(50 + height * 90);
    }else if (indexPath.section == 2){
        return kFit(140);
    } else {
        return kFit(170);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 ) {
        return 0.01;
    }else {
        return 10.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        // 45
        return 0.01;
    }else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10.0)];
        footerView.backgroundColor =kColorRGB(246, 246, 246, 1);
        return footerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
//        DJNotificationBarView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DJNotificationBarView"];
//        footerView.frame = CGRectMake(0, 0, kScreenWidth, kFit(45));
//        footerView.contentLabel.text = @"暂无公告";
//        footerView.arrowImageView.hidden = YES;
//        return footerView;
    }else {
        return nil;
    }
}

#pragma mark DJLearningTableViewCellDelegate
- (void)ClickLearningModule:(NSInteger)index {

    
    switch (index) {
        case 0: {//党费计算
            DJWebViewController *webVC = [[DJWebViewController alloc] init];
            webVC.url = @"http://122.224.157.71:8080/public/app/dangFeiCalculator.html";
            webVC.navigationItem.title = @"党费计算";
            [self presentToNextViewController:webVC];
        }
            break;
        case 1:{//场地预约
            DJWebViewController *webVC = [[DJWebViewController alloc] init];
            webVC.url = @"http://xhxf.hzdj.gov.cn/index.php/sitebooking/index";
            webVC.navigationItem.title = @"场地预约";
            [self presentToNextViewController:webVC];
        }
            break;
        case 2:{//最美先锋
            DJWebViewController *webVC = [[DJWebViewController alloc] init];
            webVC.url = @"http://zuimeixianfeng.kuaizhan.com";
            webVC.navigationItem.title = @"最美先锋";
            [self presentToNextViewController:webVC];
        }
            break;
        case 3:{
        }
            break;
        default:
            break;
    }
    
}

#pragma mark  DJFCTableViewCellDelegate
- (void)ClickGracefulBearingModule:(NSInteger)index {
    if (![DJUserTool userIsLogin]) {
        [self userLogIn];
        return;
    }
    switch (index) {
        case 0:{
            
            if (![DJUserTool userIsLogin]) {
                [self userLogIn];
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
            
            DJThematicPartyDayViewController * VC= [[DJThematicPartyDayViewController alloc] init];
            [self  presentToNextViewController:VC];
        }
            break;
        case 1:{
            DJTwolearnToDoOneVC *VC = [[DJTwolearnToDoOneVC alloc] init];
            [self  presentToNextViewController:VC];
        }
            break;
        case 2:{
            NSMutableArray  *meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
            
            if (meunArray.count == 0) {
                [self  ShowWarningHudMid:@"您不属于任何组织, 无法使用本功能哦!"];
                return;
            }else {
                if ([self  getDefaultOrg] == nil ) {
                    return;
                }
            }
            
            DJThreeWillOneLessonViewController *VC= [[DJThreeWillOneLessonViewController alloc] init];
            [self  presentToNextViewController:VC];
        }
            break;
        default:
            break;
    }
}
#pragma ConfigurableIconTVCellDelegate
- (void)ClickFunctionModuleIndex:(NSInteger)index {
    
    if (![DJUserTool userIsLogin]) {
        [self userLogIn];
        return;
    }
    
    if (index == self.defaultModuleArray.count ) {
        DJAllModuleShowViewController *VC = [[DJAllModuleShowViewController alloc] init];
        VC.selectedArray = self.defaultModuleArray;
        VC.AllArray  = self.moduleArray;
        [self presentToNextViewController:VC];
        return;
    }
    NSLog(@"defaultModuleArray%d", self.defaultModuleArray.count);
    ConfigModuleModel  * model = self.defaultModuleArray[index];
    [self pushViewControllerAccordingUrl:model.url];
    
    NSLog(@"你点击的是,党建工作里面的是第 < %ld > 个模块", (long)index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(DJSidebarVC *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(DJSidebarVC *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Open drawer button
- (void)handleLeftSidebarBtn {
    [self.drawer open];
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

- (void)OrgChoose {
    NSArray *datarray =  [self queryModel:@"OrgInfoModel"];
    if (datarray.count == 0 || datarray.count == 1) {
        if (datarray.count == 1) {
        }
        return;
    }
    NSLog(@"用户默认组织%@ UserOrgConfig%@", [DJUserTool getUserOrgAndCustom], UserOrgConfig);
    for (OrgInfoModel *model in datarray) {
        NSLog(@"OrgChoose%@", model.defaultState);
        if ([model.defaultState isEqualToString:@"1"]) {
            return;
        }
    }
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
    _orgChooseView.modelArray = [NSMutableArray arrayWithArray:datarray];
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
            datarray[i] = model;
            [DJUserTool setUserOrgAndCustom:model.orgId];
            break;
        }
    }
    
    [self.djCoreDataManager save];
    NSArray *testArray =  [self queryModel:@"OrgInfoModel"];
    NSLog(@"testArray%@", testArray);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//界面跳转方法

- (UIViewController *)getViewController:(NSString *)viewUrl {
    
    
    
    
    
    return self;
}




@end
