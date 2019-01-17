//
//  DJSJFXViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/9/12.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSJFXViewController.h"
#import "DJSJFXHeadView.h"
#import "DJSJFXRankingTableViewCell.h"
#import "DJSJFXQZTTableViewCell.h"
#import "DJSJFXZXTTableViewCell.h"
#import "DJSJFXZXTTwoTableViewCell.h"
#import "DJSJFXTypeChooseView.h"
#import "DJSJFXOrgChooseView.h"
#import "DJSJFXZTDRCYLTableViewCell.h"
@interface DJSJFXViewController ()<UITableViewDelegate, UITableViewDataSource, DJSJFXTypeChooseViewDelegate, DJSJFXOrgChooseViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * headNameArray;
/**
 *个人本月实时排名数据
 */
@property (nonatomic, strong)NSMutableArray * userThisMonthRankingArray;
/**
 *存储 本月任务完成个数  TaskCompletionSituation This Month
 */
@property (nonatomic, strong)NSMutableArray * taskCompletionSituationThisMonthArray;
/**
 *存储 年度任务完成个数  TaskCompletionSituation Annual
 */
@property (nonatomic, strong)NSMutableArray * taskCompletionSituationAnnualArray;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *
 */
@property (nonatomic, strong)DJSJFXTypeChooseView *TypeChooseView;
/**
 *
 */
@property (nonatomic, strong)DJSJFXOrgChooseView *downMenuView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * orgArray;



@end

@implementation DJSJFXViewController {
    //界面展示的数据类型
    NSInteger dataType;
    LowerOrgModel *currentModel;
    NSString *selectedTime;//选择时间
}

- (NSMutableArray *)orgArray {
    if (!_orgArray) {
        _orgArray = [NSMutableArray array];
    }
    return _orgArray;
}

- (NSMutableArray *)userThisMonthRankingArray {
    if (!_userThisMonthRankingArray) {
        _userThisMonthRankingArray = [NSMutableArray array];
    }
    return _userThisMonthRankingArray;
}

#pragma mark 创建头部视图


//下拉框控件
- (DJSJFXOrgChooseView *)downMenuView{
    if (!_downMenuView) {
        _downMenuView = [[DJSJFXOrgChooseView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+40, kScreenWidth, kScreenHeight-40-kStatusBarAndNavigationBarHeight)];
        _downMenuView.Delegate = self;
    }
    return _downMenuView;
}

- (NSMutableArray *)taskCompletionSituationThisMonthArray {
    if (!_taskCompletionSituationThisMonthArray) {
        _taskCompletionSituationThisMonthArray = [NSMutableArray array];
    }
    return _taskCompletionSituationThisMonthArray;
}

- (NSMutableArray *)taskCompletionSituationAnnualArray {
    if (!_taskCompletionSituationAnnualArray) {
        _taskCompletionSituationAnnualArray = [NSMutableArray array];
    }
    return _taskCompletionSituationAnnualArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.orgArray removeAllObjects];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [self getOrgData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger years = [[NSDate date] dateYear];
    selectedTime = [NSString stringWithFormat:@"%ld", (long)years];
    // Do any additional setup after loading the view, typically from a nib.
    dataType = 1;
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
//    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.leftBtn setTitle:@"返回" forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"数据分析";
    [self.defaultNavigationBarView.rightBtn setTitle:@"2018" forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn addTarget:self action:@selector(handleChooseTime) forControlEvents:(UIControlEventTouchUpInside)];
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    [self createTableView];
    currentModel  =[NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    currentModel.orgId = [self getDefaultOrg].orgId;
    currentModel.name = [self getDefaultOrg].orgName;
    [self requestUserThisMonthRanking];
    [self requestUserThisMonthTaskState:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleReturnBtn {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)requestUserThisMonthTaskState:(NSInteger)index {
    [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    switch (index) {
        case 1:
            self.headNameArray = [NSMutableArray arrayWithArray:@[
                                                                  @{@"title":@"一 .  个人本月实时数据排名", @"subtitle":@""},
                                                                  @{@"title":@"二 .  个人本月实时任务完成情况统计", @"subtitle":@"单位 ( 个 )"},
                                                                  @{@"title":@"三 .  个人年度行事历任务统计", @"subtitle":@"单位 ( 个 )"},
                                                                  @{@"title":@"四 .  个人年度交办任务统计", @"subtitle":@"单位 ( 个 )"},
                                                                  @{@"title":@"五 .  个人每月任务平均完成时间统计", @"subtitle":@"单位 ( 天 )"},
                                                                  @{@"title":@"六 .  个人每月积分统计", @"subtitle":@""}]];
            break;
        case 2:
            self.headNameArray = [NSMutableArray arrayWithArray:@[
                                                                  @{@"title":@"一 .  组织本月实时任务完成情况统计", @"subtitle":@"单位 ( 个 )"},
                                                                  @{@"title":@"二 .  主题党日月参与率", @"subtitle":@"单位 ( % )"},
                                                                  @{@"title":@"三 .  组织年度行事历任务统计", @"subtitle":@"单位 ( 个 )"},
                                                                  @{@"title":@"四 .  组织年度交办任务统计", @"subtitle":@"单位 ( 个 )"},
                                                                  @{@"title":@"五 .  组织每月任务平均完成时间统计", @"subtitle":@"单位 ( 天 )"},
                                                                  @{@"title":@"六 .  组织人员每月平均积分统计", @"subtitle":@""}]];
            break;
        default:
            break;
    }
    dataType = index;
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    if (index == 1) {
        [URL_Dic setValue:[self getDefaultOrg].orgId forKey:@"orgId"];
    }else {
        [URL_Dic setValue:currentModel.orgId forKey:@"orgId"];
    }
    
    [self getJSONDataWithUrl:index==1? kURL_myThisMonthTaskCompleteNumber:kURL_orgThisMonthTaskCompleteNumber parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObjectOne%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *dataDic =  responseObject[@"response"];
            [self.taskCompletionSituationThisMonthArray removeAllObjects];
            [self.taskCompletionSituationThisMonthArray addObject:dataDic];
            if (index == 1) {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationNone)];
            }else {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationNone)];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    [URL_Dic setValue:selectedTime forKey:@"year"];
    
    [self getJSONDataWithUrl:index==1? kURL_myAnnualTaskData:kURL_orgAnnualTaskData parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"responseObjectTwo%@", responseObject);
        if ([code isEqualToString:@"0"]) {
            NSArray *dataArray =  responseObject[@"response"];
            
            [self.taskCompletionSituationAnnualArray removeAllObjects];
            self.taskCompletionSituationAnnualArray = [NSMutableArray arrayWithArray:dataArray];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
    }];
    
   
    
    
}
//查询用户本月排名
- (void)requestUserThisMonthRanking  {
    [self.userThisMonthRankingArray removeAllObjects];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:[self getDefaultOrg].orgId forKey:@"orgId"];
    [self getJSONDataWithUrl:kURL_myThisMonthRanking parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"responseObjectThree%@", responseObject);
        if ([code isEqualToString:@"0"]) {
            NSDictionary *response = responseObject[@"response"];
            [self.userThisMonthRankingArray addObject:response];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationAutomatic)];
        }
    } failure:^(NSError *error) {
    }];
    
}

//获取主组织下级组织
- (void)getOrgData {
    [self showHud:@"正在获取组织信息" title:@""];
    [self.orgArray removeAllObjects];
    
    LowerOrgModel *model  =[NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    model.orgId = [self getDefaultOrg].orgId;
    model.name = [self getDefaultOrg].orgName;
    [self.orgArray addObject:model];
    
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"orgId"] = [self getDefaultOrg].orgId;
    [self  getJSONDataWithUrl:kURL_LowerOrg parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self parsingOrgData:responseObject];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        [self hudDissmiss];
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
}
//解析组织数据
- (void)parsingOrgData:(NSDictionary *)dataDic  {
    
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *orgArray  =dataDic[@"response"];
    if (![orgArray isKindOfClass:[NSArray class]]) {
        return;
    }
    for (NSDictionary *orgDic in orgArray) {
        if (![orgDic isKindOfClass:[NSDictionary class]]) {
            break;
        }
        LowerOrgModel *model  =[NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in orgDic) {
            [model setValue:orgDic[key] forKey:key];
        }
        [self.orgArray addObject:model];
    }
    
    for (int i = 0 ; i < self.orgArray.count; i ++) {
        LowerOrgModel *model = self.orgArray[i];
        if ([model.orgId isEqualToString:currentModel.orgId]) {
            model.isSelectAll = @"1";
        }
    }
    
    self.downMenuView.dataArr = self.orgArray;
    self.downMenuView.isConceal = YES;
    [self.view addSubview:self.downMenuView];
}


- (void)createTableView {
    self.TypeChooseView =[[DJSJFXTypeChooseView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, 40) buttonData:@[@"个人数据", @"组织数据"] withType:@"个人数据"];
    _TypeChooseView.delegate = self;
    UIButton *tempBtn = [_TypeChooseView viewWithTag:100];
    [tempBtn setImage:nil forState:(UIControlStateNormal)];
    [tempBtn setImage:nil forState:(UIControlStateSelected)];
    tempBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [self.view addSubview:_TypeChooseView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+40, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-40) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJSJFXRankingTableViewCell class] forCellReuseIdentifier:@"DJSJFXRankingTableViewCell"];
    [_tableView registerClass:[DJSJFXQZTTableViewCell class] forCellReuseIdentifier:@"DJSJFXQZTTableViewCell"];
    [_tableView registerClass:[DJSJFXHeadView class] forHeaderFooterViewReuseIdentifier:@"DJSJFXHeadView"];
    [_tableView registerClass:[DJSJFXZXTTableViewCell class] forCellReuseIdentifier:@"DJSJFXZXTTableViewCell"];
    [_tableView registerClass:[DJSJFXZXTTwoTableViewCell class] forCellReuseIdentifier:@"DJSJFXZXTTwoTableViewCell"];
    [_tableView registerClass:[DJSJFXZTDRCYLTableViewCell class] forCellReuseIdentifier:@"DJSJFXZTDRCYLTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.headNameArray = [NSMutableArray arrayWithArray:@[
                                                          @{@"title":@"一 .  个人本月实时数据排名", @"subtitle":@""},
                                                          @{@"title":@"二 .  个人本月实时任务完成情况统计", @"subtitle":@"单位 ( 个 )"},
                                                          @{@"title":@"三 .  个人年度行事历任务统计", @"subtitle":@"单位 ( 个 )"},
                                                          @{@"title":@"四 .  个人年度交办任务统计", @"subtitle":@"单位 ( 个 )"},
                                                          @{@"title":@"五 .  个人每月任务平均完成时间统计", @"subtitle":@"单位 ( 天 )"},
                                                          @{@"title":@"六 .  个人每月积分统计", @"subtitle":@""}]];

    [self.view addSubview:_tableView];
}




- (void)ChooseDataType:(NSInteger)index {
    
    if (index == 2) {//如果点击的第二个按钮
        
        if (dataType != 2) {
            [self requestUserThisMonthTaskState:index];
        }
        
        UIButton *tempBtn = [_TypeChooseView viewWithTag:101];
        if (!self.downMenuView.isConceal) {//如果在隐藏装填
            [tempBtn setImage:[UIImage imageNamed:@"DJMenuClose"] forState:(UIControlStateNormal)];
            
            [self getOrgData];
        }else {//否者点击就是为了让他消失
            [tempBtn setImage:[UIImage imageNamed:@"DJMenuExpand"] forState:(UIControlStateNormal)];
            self.downMenuView.isConceal = NO;
            [self.downMenuView removeFromSuperview];
        }
    }else {
        UIButton *tempBtn = [_TypeChooseView viewWithTag:101];
        [tempBtn setImage:[UIImage imageNamed:@"DJMenuExpand"] forState:(UIControlStateNormal)];
        self.downMenuView.isConceal = NO;
        [self.downMenuView removeFromSuperview];
        [self requestUserThisMonthRanking];
        [self requestUserThisMonthTaskState:index];
        [self.taskCompletionSituationAnnualArray removeAllObjects];
    }
}

#pragma mark DJSJFXOrgChooseViewDelegate

- (void)OrgChooseWithIndex:(NSInteger) index {
    LowerOrgModel *orgModel = self.orgArray[index];
    currentModel = orgModel;
    [self requestUserThisMonthTaskState:2];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
    if (dataType == 2) {
        if (indexPath.section == 0) {
            DJSJFXQZTTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"DJSJFXQZTTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.taskCompletionSituationThisMonthArray.count != 0) {
                cell.dataDic = self.taskCompletionSituationThisMonthArray[0];
            }
            return cell;
        }else  if(indexPath.section == 1) {
            DJSJFXZTDRCYLTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"DJSJFXZTDRCYLTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.chartType = DJSJFXZTDRCYLTableViewCellChartTypeLine;
            
            [cell createChartviewDataType:indexPath.section dataArray:self.taskCompletionSituationAnnualArray];
            return cell;
        }else  if ( indexPath.section == 2 || indexPath.section == 3){
            DJSJFXZXTTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"DJSJFXZXTTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.chartType = DJSJFXZXTTableViewCelChartTypeLine;
            [cell createChartviewDataType:indexPath.section dataArray:self.taskCompletionSituationAnnualArray];
            return cell;
        }else {
            DJSJFXZXTTwoTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"DJSJFXZXTTwoTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.section == 5) {
                [cell ChartColor:@[@"#2ed009"] title:NO dataType:indexPath.section dataArray:self.taskCompletionSituationAnnualArray];
            }else {
                [cell ChartColor:@[@"#fc6800"] title:YES  dataType:indexPath.section dataArray:self.taskCompletionSituationAnnualArray];
            }
            return cell;
        }
        
    }else {
        if (indexPath.section == 0) {
            DJSJFXRankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJSJFXRankingTableViewCell" forIndexPath:indexPath];
            if (self.userThisMonthRankingArray.count !=0) {
                NSDictionary *tempDic = self.userThisMonthRankingArray[0];
                
                NSString *scoreNoStr = [NSString stringWithFormat:@"%@", tempDic[@"scoreNo"]];
                NSString *outCompleteNo = [NSString stringWithFormat:@"%@", tempDic[@"outCompleteNo"]];
                NSString *completeNo = [NSString stringWithFormat:@"%@",  tempDic[@"completeNo"]];
                
                cell.transcriptIntegral.text = [NSString stringWithFormat:@"排名 : %@",scoreNoStr.integerValue == 0?@"暂无排名":scoreNoStr ];
                cell.fillDoTaskNum.text =  [NSString stringWithFormat:@"排名 : %@",outCompleteNo.integerValue == 0?@"暂无排名":outCompleteNo];
                cell.completeTaskNum.text =  [NSString stringWithFormat:@"排名 : %@", completeNo.integerValue == 0?@"暂无排名":completeNo];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.section == 1){
            DJSJFXQZTTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"DJSJFXQZTTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.taskCompletionSituationThisMonthArray.count != 0) {
                cell.dataDic = self.taskCompletionSituationThisMonthArray[0];
            }
            return cell;
        }else if(indexPath.section == 2 || indexPath.section == 3){
            DJSJFXZXTTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"DJSJFXZXTTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.chartType = DJSJFXZXTTableViewCelChartTypeLine;
            [cell createChartviewDataType:indexPath.section dataArray:self.taskCompletionSituationAnnualArray];
            return cell;
        }else {
            DJSJFXZXTTwoTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"DJSJFXZXTTwoTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.section == 5) {
                [cell ChartColor:@[@"#2ed009"] title:NO dataType:indexPath.section dataArray:self.taskCompletionSituationAnnualArray];
            }else {
                [cell ChartColor:@[@"#fc6800"] title:YES  dataType:indexPath.section dataArray:self.taskCompletionSituationAnnualArray];
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (dataType == 2) {
        if (indexPath.section == 0) {
            return kScreenWidth/2;
        }else if(indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3){
            return 300;
        }else {
            return  230;
        }
    }else {
        if (indexPath.section == 0) {
            return kFit(140);
        }else if(indexPath.section == 1){
            return kScreenWidth/2;
        }else if(indexPath.section == 2 || indexPath.section == 3) {
            return 300;
        }else {
            return 230;
        }
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kFit(40);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = self.headNameArray[section];
    DJSJFXHeadView  *headView  =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DJSJFXHeadView"];
    headView.frame  =CGRectMake(0, 0, kScreenWidth, kFit(40));
    headView.titleLabel.text = dic[@"title"];
    headView.subtitleLabel.text = dic[@"subtitle"];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return footerView;
    
}


- (void)handleChooseTime{
    NSMutableArray *timeArray = [NSMutableArray array];
    NSInteger years = [[NSDate date] dateYear];
    for (int i = 2018; i  < years+1; i++) {
        [timeArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    NSInteger  index  = 0;
    
    for (int i = 0;  i< timeArray.count; i ++) {
        if (selectedTime.length == 0) {
            break;
        }
        NSString *tempStr = timeArray[i];
        if ([tempStr isEqualToString:selectedTime]) {
            index = i;
        }
    }
    
    
    __weak  typeof(self)  selfWeak = self;
    __block   SMKPickerView *smkPickerView = [SMKPickerView SMKPickerWithArray:@[timeArray] withHeadTitle:nil defaultIndex:index withCall:^(SMKPickerView *pcikerView, NSString *choiceString) {
        if (![selectedTime isEqualToString:choiceString]) {
            [selfWeak requestUserThisMonthTaskState:dataType];
        }
        self->selectedTime = choiceString;
        [pcikerView dismissPicker];
        
    }];
    [smkPickerView show];
    
}
@end
