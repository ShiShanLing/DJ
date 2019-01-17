//
//  DJWDRWViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJWDRWViewController.h"
#import "DJResumptionExplainListTableViewCell.h"
#import "DJTaskTypeChooseView.h"
#import "DJMyTaskDetailsViewController.h"
#import "NSDate+GFCalendar.h"
#import "DJMyTaskShowTableViewCell.h"
#import "DJDAOrgChooseView.h"
@interface DJWDRWViewController () <UITableViewDelegate, UITableViewDataSource, DJTaskTypeChooseViewDelegate, DJDAOrgChooseViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
/**
 *
 */
@property (nonatomic, strong)UIButton *screeningBtn;
/**
 *
 */
@property (nonatomic, strong)UIBarButtonItem *leftButtonItem;

/**
 *
 */
@property (nonatomic, strong)DJTaskTypeChooseView * taskTypeChooseView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * taskModelArray;

/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *
 */
@property (nonatomic, strong)DJDAOrgChooseView * orgChooseView;
@end

@implementation DJWDRWViewController {
    NSInteger pageIndex;//多少页
    NSInteger pageNum;//一共多少数据
    NSString *taskState;//任务类型
    NSString *taskTime;//任务时间
    NSString *showTaskTime;//
    NSInteger defaultOrgIndex;//默认展示的组织下标
}

- (NSMutableArray *)taskModelArray {
    if (!_taskModelArray) {
        _taskModelArray = [NSMutableArray array];
    }
    return  _taskModelArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self  showHud:@"" title:@""];
    [self requestMyTaskList:1 taskState:taskState time:taskTime];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    defaultOrgIndex = 0;
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    // Do any additional setup after loading the view.
    taskTime = @"";
    showTaskTime = @"";
    taskState = @"";
    pageIndex = 1;
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"历史任务";
    [self.defaultNavigationBarView.rightBtn setTitle:@"类型" forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn addTarget:self action:@selector(handleTypeSelection) forControlEvents:(UIControlEventTouchUpInside)];
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    [self createTableView];
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+kFit(35)+kFit(45), kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-kFit(35)-kFit(45))];
    self.dataEmptyView.promptLabel.text = @"您暂无相关任务哦";
    self.dataEmptyView.dividerLabel.hidden = YES;
    self.dataEmptyView.backgroundColor = kColorRGB(246, 246, 246, 1);
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_task_empty"];
    self.dataEmptyView.hidden = YES;
    [self.view addSubview:self.dataEmptyView];
    self.taskTypeChooseView = [[DJTaskTypeChooseView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight)];
    _taskTypeChooseView.alpha = 0.0;
    _taskTypeChooseView.delegate = self;
    [self.view addSubview:_taskTypeChooseView];
    
    
    
}



- (void)createTableView {
    OrgInfoModel *orgModel = self.orgListArray[0];
    
    self.orgChooseView = [[DJDAOrgChooseView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kFit(45))];
    self.orgChooseView.delegate= self;
    self.orgChooseView.title = orgModel.orgName;
    [self.view addSubview:_orgChooseView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+kFit(45), kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-kFit(45)) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorRGB(246, 246, 246, 1);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[DJMyTaskShowTableViewCell class] forCellReuseIdentifier:@"DJMyTaskShowTableViewCell"];
    [self.view addSubview:_tableView];
    
    self.screeningBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_screeningBtn setImage:[UIImage imageNamed:@"DJ_lzsms_rq"] forState:(UIControlStateNormal)];
    _screeningBtn.backgroundColor = kColorRGB(246, 246, 246, 1);
    [_screeningBtn addTarget:self action:@selector(handleChooseTime) forControlEvents:(UIControlEventTouchUpInside)];
    _screeningBtn.frame = CGRectMake(kScreenWidth-kFit(46), kStatusBarAndNavigationBarHeight+kFit(45), kFit(46), kFit(35));
    [self.view addSubview:_screeningBtn];
    
}

/**
 历史组织点击  用户切换组织
 */
- (void)SwitchHistoricalOrg {

    NSMutableArray *orgArray = [NSMutableArray array];
    for (int i = 0; i < self.orgListArray.count; i ++) {
        OrgInfoModel *model = self.orgListArray[i];
        [orgArray addObject:model.orgName];
    }
    
    NSArray *totalTimeArray = @[orgArray];
    
    __weak DJWDRWViewController *selfWeak = self;
    __block    SMKPickerView *smkPickerView = [SMKPickerView SMKPickerWithArray:totalTimeArray withHeadTitle:@"" defaultIndex:defaultOrgIndex withCall:^(SMKPickerView *pcikerView, NSString *choiceString) {
        _orgChooseView.title = choiceString;
        for (int i = 0; i < _orgListArray.count; i ++) {
            OrgInfoModel *model = _orgListArray[i];
            if ([model.orgName isEqualToString:choiceString]) {
                defaultOrgIndex = i;
            }
        }
        [selfWeak showHud:@"" title:@""];
        [selfWeak requestMyTaskList:pageIndex taskState:taskState time:taskTime];
        [smkPickerView dismissPicker];
    }];
    [smkPickerView show];
    
}
- (void)AdditionalControls {
    __weak typeof(self)  weakSelf = self;
    if (!_tableView.mj_header) {
        
        self.tableView.mj_header = [DJMJRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataWithMJType:@"header"];
        }];
    }
    if (!_tableView.mj_footer) {
        self.tableView.mj_footer = [DJMJRefreshGitFooter footerWithRefreshingBlock:^{
            [weakSelf loadDataWithMJType:@"footer"];
        }];
    }
    
    
    
}

- (void)handleReturnBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
//刷新 或者加载判断
-(void)loadDataWithMJType:(NSString*)type {
    if ([type isEqualToString:@"header"]) {
    
        pageIndex = 1;
        [self requestMyTaskList:pageIndex taskState:taskState time:taskTime];
    }else{
        
        NSInteger totalNum = 0;
        for (int i = 0; i < self.taskModelArray.count; i ++) {
            NSDictionary *taskDic = self.taskModelArray[i];
            NSArray * keyArray =[taskDic allKeys];
            NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
            totalNum += taskArray.count;
        }
        if (totalNum < pageNum) {
            pageIndex++;
            [self requestMyTaskList:pageIndex taskState:taskState time:taskTime];
        }else{
            
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

-(void)requestMyTaskList:(NSInteger)num taskState:(NSString *)taskState time:(NSString *)time{
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    
    OrgInfoModel *orgModel = self.orgListArray[defaultOrgIndex];
    [URL_Dic setValue:orgModel.orgId forKey:@"orgId"];
    [URL_Dic setValue:@"1" forKey:@"page"];
    [URL_Dic setValue:[NSString stringWithFormat:@"%ld", num*kEachPageRowNum] forKey:@"rows"];
    [URL_Dic setValue:taskState forKey:@"status"];
    [URL_Dic setValue:time forKey:@"month"];
    [URL_Dic setObject:@"" forKey:@"tag"];
    NSLog(@"URL_Dic%@", URL_Dic);
    [self  getJSONDataWithUrl:kURL_myReceivedTask parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        [self AdditionalControls];
        NSLog(@"responseObject%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self parsingTaskData:responseObject];
            
        }else {
            [self  ShowWarningHudMid:responseObject[@"msg"]];
            self.dataEmptyView.hidden = YES;
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self hudDissmiss];
        NSLog(@"error%@", error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)parsingTaskData:(NSDictionary *)dataDic {
    [self.taskModelArray removeAllObjects];
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        [self emptyInterfaceLayout:2];
        return;
    }
    NSDictionary *responseDic = dataDic[@"response"];
    if (![responseDic isKindOfClass:[NSDictionary class]]) {
        [self emptyInterfaceLayout:2];
        return;
    }
    
    NSString *totalNum = [NSString stringWithFormat:@"%@", responseDic[@"totalNum"]];
    
    if (totalNum.integerValue == 0) {
        self.dataEmptyView.hidden = NO;
        self.screeningBtn.hidden = NO;
        self.tableView.hidden  = YES;
        [self.tableView reloadData];
        return;
    }else {
        pageNum = totalNum.integerValue;
    }
    self.tableView.hidden  = NO;
    self.dataEmptyView.hidden = YES;
    NSArray *dataArray = responseDic[@"searchData"];
    if (![dataArray isKindOfClass:[NSArray class]] || dataArray.count == 0) {
        [self emptyInterfaceLayout:1];
        return;
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i ++) {
        NSDictionary *tempDic = dataArray[i];
        IReceivedTaskModel *model = [NSEntityDescription  insertNewObjectForEntityForName:@"IReceivedTaskModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in tempDic) {
            [model setValue:tempDic[key] forKey:key];
        }
        [tempArray addObject:model];
    }
    
    NSMutableDictionary *timeTaskDic = [NSMutableDictionary dictionary];
    NSString *yearsStr = @"";
    for (int i = 0;  i < tempArray.count; i ++) {
        IReceivedTaskModel *model = tempArray[i];
        NSString *startTimeStr = model.createTime;
        
        NSDate *tempDate = [CommonUtil  getDateForString:startTimeStr format:@"yyyy-MM-dd HH:mm"];
        NSString *tempStr = [CommonUtil getStringForDate:tempDate format:@"yyyy年MM月"];
        
        if (![yearsStr isEqualToString:tempStr]) {
            if (yearsStr.length != 0) {
                [self.taskModelArray  addObject:[NSMutableDictionary dictionaryWithDictionary:timeTaskDic]];
                [timeTaskDic removeAllObjects];
            }
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObject:model];
            [timeTaskDic setValue:tempArray forKey:tempStr];
            yearsStr = tempStr;
        }else {
            NSMutableArray *taskArray = [NSMutableArray arrayWithArray:(NSArray *)timeTaskDic[yearsStr]];
            [taskArray addObject:model];
            [timeTaskDic setValue:taskArray forKey:yearsStr];
        }
        if (i == tempArray.count - 1) {
            [self.taskModelArray  addObject:[NSMutableDictionary dictionaryWithDictionary:timeTaskDic]];
            [timeTaskDic removeAllObjects];
        }
    }
    
    NSInteger tempNum = 0;
    for (int i = 0; i < self.taskModelArray.count; i ++) {
        NSDictionary *taskDic = self.taskModelArray[i];
        NSArray * keyArray =[taskDic allKeys];
        NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
        tempNum += taskArray.count;
    }
    if (tempNum < pageNum) {
            self.tableView.mj_footer.alpha = 1.0;
        
    }else{
        
        self.tableView.mj_footer.alpha = 0.0;
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }
    
    
    
    [self.tableView reloadData];
}

- (void)handleTypeSelection {
    
    CGFloat  alpha =  _taskTypeChooseView.alpha;
    if (alpha == 0.0) {
        alpha = 1.0;
    }else {
        alpha = 0.0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _taskTypeChooseView.alpha = alpha;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.taskModelArray.count == 0  && taskTime.length != 0) {
        return 1;
    }else {
        return self.taskModelArray.count;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.taskModelArray.count == 0  && taskTime.length != 0) {
        return 0;
    }else {
        NSDictionary *taskDic = self.taskModelArray[section];
        NSArray * keyArray =[taskDic allKeys];
        NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
        return taskArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJMyTaskShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJMyTaskShowTableViewCell" forIndexPath:indexPath];
    NSDictionary *taskDic = self.taskModelArray[indexPath.section];
    NSArray * keyArray =[taskDic allKeys];
    NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
    IReceivedTaskModel *model = taskArray[indexPath.row];
    if (indexPath.row == taskArray.count - 1) {
        cell.dividerLabel.hidden = YES;
    }else {
        cell.dividerLabel.hidden = NO;
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DJMyTaskDetailsViewController *VC = [[DJMyTaskDetailsViewController alloc] init];
    NSDictionary *taskDic = self.taskModelArray[indexPath.section];
    NSArray * keyArray =[taskDic allKeys];
    NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
    IReceivedTaskModel *model = taskArray[indexPath.row];
    VC.taskDetailsModel = model;
    OrgInfoModel *orgModel = self.orgListArray[defaultOrgIndex];
    VC.orgModel = orgModel;
    VC.taskId = model.currentTaskId;
    [self pushToNextViewController:VC];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFit(90);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kFit(35);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(35))];
    headView.backgroundColor = kColorRGB(246, 246, 246, 1);
    UILabel *titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(kFit(15), 0, 120, kFit(35))];
    if (self.taskModelArray.count == 0  && taskTime.length != 0) {
        titleLabel.text = taskTime;
    }else {
        NSDictionary *taskDic = self.taskModelArray[section];
        NSArray * keyArray =[taskDic allKeys];
        titleLabel.text = keyArray[0];
    }
    
    titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(15)];
    titleLabel.textColor = kColorRGB(51, 51, 51, 1);
    [headView addSubview:titleLabel];
    if (section == 0) {
        //下拉展示 上啦消失 正常情况下展示的都是虚拟的
        UIButton *screeningBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [screeningBtn setImage:[UIImage imageNamed:@"DJ_lzsms_rq"] forState:(UIControlStateNormal)];
        
        [screeningBtn addTarget:self action:@selector(handleChooseTime) forControlEvents:(UIControlEventTouchUpInside)];
        screeningBtn.frame = CGRectMake(kScreenWidth-kFit(46), 0, kFit(46), kFit(35));
        [headView addSubview:screeningBtn];
    }
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    
    return footerView;
}

- (void)handleChooseTime{
    NSString *timeStr = taskTime;
    NSArray * tempArray = [timeStr componentsSeparatedByString:@"-"];
    NSString *yearsStr =@"";
    NSString *monthStr =@"";
    if (tempArray.count == 2) {
        yearsStr =   [NSString stringWithFormat:@"%@年", tempArray[0]];
        monthStr = [NSString stringWithFormat:@"%@月", tempArray[1]];
    }else {
        NSInteger year =[[NSDate date] dateYear];
        NSInteger  month = [[NSDate date] dateMonth];
        yearsStr = [NSString stringWithFormat:@"%ld年", year];
        if (month <10) {
            monthStr = [NSString stringWithFormat:@"0%ld月", month];
        }else {
            monthStr = [NSString stringWithFormat:@"%ld月", month];
        }
    }
    NSString *hourIndex = @"";
    NSString *minuteIndex = @"";
    
    NSMutableArray *yearsArray = [NSMutableArray array];
    NSInteger years = [[NSDate date] dateYear];
    for (int i = 2017; i  < years+1; i++) {
        [yearsArray addObject:[NSString stringWithFormat:@"%d年",i]];
    }
    
    
    NSArray *totalTimeArray = @[yearsArray, @[@"01月", @"02月", @"03月", @"04月", @"05月", @"06月", @"07月", @"08月", @"09月", @"10月", @"11月", @"12月"]];
    for (int i= 0; i<totalTimeArray.count; i++) {
        NSArray *tempArray= totalTimeArray[i];
        for (int j= 0; j < tempArray.count; j++) {
            NSString *tempStr = tempArray[j];
            if (i == 0) {
                if ([yearsStr isEqualToString:tempStr]) {
                    hourIndex = [NSString stringWithFormat:@"%d", j];
                }
            }
            if (i == 1) {
                if ([monthStr isEqualToString:tempStr]) {
                    minuteIndex = [NSString stringWithFormat:@"%d", j];
                }
            }
        }
    }
    __weak DJWDRWViewController *selfWeak = self;
    __block    SMKPickerView *smkPickerView = [SMKPickerView SMKPickerMoreComponent:totalTimeArray withHeadTitle:@"" defaultIndex:@[hourIndex, minuteIndex] withCall:^(NSString *choiceString) {
        NSLog(@"choiceString%@", choiceString);
        choiceString = [choiceString stringByReplacingOccurrencesOfString:@"年" withString:@""];
        choiceString = [choiceString stringByReplacingOccurrencesOfString:@"月" withString:@""];
        //界面需要的time字符串
        NSString *choiceAfterHourStr;
        NSString *choiceAfterMinuteStr;
        NSArray *timeArray = [choiceString componentsSeparatedByString:@","];
        choiceAfterHourStr = timeArray[0];
        choiceAfterMinuteStr = timeArray[1];
        taskTime =  [NSString  stringWithFormat:@"%@-%@", choiceAfterHourStr, choiceAfterMinuteStr];
        showTaskTime = [NSString  stringWithFormat:@"%@年%@月", choiceAfterHourStr, choiceAfterMinuteStr];
        [selfWeak  showHud:@"" title:@""];
        [selfWeak requestMyTaskList:pageIndex taskState:taskState time:taskTime];
        [smkPickerView dismissPicker];
    }];
    [smkPickerView show];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 1) {//隐藏
        self.screeningBtn.hidden = YES;
    }else {//显示
        self.screeningBtn.hidden = NO;
    }
    
    //    NSLog(@"scrollView%f", scrollView.contentOffset.y);
    
}

#pragma mark DJTaskTypeChooseViewDelegate
- (void)taskTypeSelection:(NSInteger )index {
    
    switch (index) {
        case 0:
            taskState = @"";
            break;
        case 1:
            taskState = @"undo";
            break;
        case 2:
            taskState = @"complete";
            break;
        case 3:
            taskState = @"time_out";
            break;
        case 4:
            taskState = @"appealing";
            break;
        case 5:
            taskState = @"leaveing";
            break;
        case 6:
            taskState = @"leave_yes";
            break;
        case 7:
            taskState = @"timeout_complete ";
            break;
        case 8:
            taskState = @"appeal_yes ";
            break;
        default:
            break;
    }
    [self  showHud:@"" title:@""];
    [self requestMyTaskList:pageIndex taskState:taskState time:taskTime];
    [UIView animateWithDuration:0.3 animations:^{
        _taskTypeChooseView.alpha = 0.0;
    }];
}

- (void)setOrgListArray:(NSArray *)orgListArray {
    
    _orgListArray = orgListArray;
    
}
//0加载成功并有数据 1加载成功并没有数据 2加载失败
- (void)emptyInterfaceLayout:(NSInteger)type {
    switch (type) {
        case 0:
            self.dataEmptyView.hidden = YES;
            self.tableView.bounces = YES;
            
            break;
        case 1:
            self.tableView.bounces = NO;
            self.dataEmptyView.hidden = NO;
            if (taskTime.length == 0) {
                self.dataEmptyView.frame =CGRectMake(0, kStatusBarAndNavigationBarHeight+kFit(45), kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-kFit(45));
            }else {
                self.dataEmptyView.frame =CGRectMake(0, kStatusBarAndNavigationBarHeight+kFit(35)+kFit(45), kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-kFit(35)-kFit(45));
            }
            break;
        case 2:
            
            break;
            
        default:
            break;
    }
    
}

@end
