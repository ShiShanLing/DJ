//
//  DJThematicPartyDayViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/29.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJThematicPartyDayViewController.h"
#import "DJResumptionExplainListTableViewCell.h"
#import "DJTaskTypeChooseView.h"
#import "DJMyTaskDetailsViewController.h"
#import "NSDate+GFCalendar.h"
#import "DJMyTaskShowTableViewCell.h"
@interface DJThematicPartyDayViewController ()<UITableViewDelegate, UITableViewDataSource, DJTaskTypeChooseViewDelegate>

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
 *任务时间 传给后台的
 */
@property (nonatomic, strong)NSString *taskTime;
/**
 *任务时间展示用
 */
@property (nonatomic, strong)NSString *showTaskTime;//
/**
 *任务类型
 */
@property (nonatomic, strong)NSString *taskState;
/**
 *多少页
 */
@property (nonatomic, assign)NSInteger pageIndex;

@end

@implementation DJThematicPartyDayViewController{
    
    NSInteger pageNum;//一共多少数据
    
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
    
    
    [self requestMyTaskList:_pageIndex taskState:_taskState time:_taskTime];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    // Do any additional setup after loading the view.
    self.pageIndex = 1;
    self.taskTime = @"";
    self.taskState = @"";
    self.showTaskTime= @"";
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"主题党日";
    [self.defaultNavigationBarView.rightBtn setTitle:@"类型" forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn addTarget:self action:@selector(handleTypeSelection) forControlEvents:(UIControlEventTouchUpInside)];
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    [self createTableView];
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+kFit(35), kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-kFit(35))];
    self.dataEmptyView.promptLabel.text = @"您暂无相关任务哦";
    self.dataEmptyView.dividerLabel.alpha =0;
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_task_empty"];
    self.dataEmptyView.backgroundColor = kColorRGB(246, 246, 246, 1);
    self.dataEmptyView.alpha=0;
    [self.view addSubview:self.dataEmptyView];
    
    self.networkRequestFailedView  = [[DJLoadFailedView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight)];
    self.networkRequestFailedView.backgroundColor = [UIColor whiteColor];
    self.networkRequestFailedView.alpha = 0.0;
    __weak typeof(self) weakSelf  = self;
    self.networkRequestFailedView.reloadData = ^(NSString * temp) {
        weakSelf.networkRequestFailedView.alpha = 0.0;
        [weakSelf requestMyTaskList:_pageIndex taskState:_taskState time:_taskTime];
    };
    self.networkRequestFailedView.failureImageView.image = [UIImage imageNamed:@"DJ_network_load_failure"];
    [self.view addSubview:self.networkRequestFailedView];
    self.taskTypeChooseView = [[DJTaskTypeChooseView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight)];
    _taskTypeChooseView.alpha = 0.0;
    _taskTypeChooseView.delegate = self;
    [self.view addSubview:_taskTypeChooseView];
}

- (void)AdditionalControls {
    __weak  typeof(self) weakSelf = self;
    if (!_tableView.mj_header) {
        weakSelf.tableView.mj_header = [DJMJRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataWithMJType:@"header"];
        }];
    }
    if (!_tableView.mj_footer) {
        weakSelf.tableView.mj_footer = [DJMJRefreshGitFooter footerWithRefreshingBlock:^{
            [weakSelf loadDataWithMJType:@"footer"];
        }];
    }
    
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)handleReturnBtn {
    
    
        [self dismissViewControllerAnimated:YES completion:nil];

}
//刷新 或者加载判断
-(void)loadDataWithMJType:(NSString*)type {
    if ([type isEqualToString:@"header"]) {
        _pageIndex = 1;
        [self requestMyTaskList:_pageIndex taskState:_taskState time:_taskTime];
    }else{
        
        NSInteger totalNum = 0;
        for (int i = 0; i < self.taskModelArray.count; i ++) {
            NSDictionary *taskDic = self.taskModelArray[i];
            NSArray * keyArray =[taskDic allKeys];
            NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
            totalNum += taskArray.count;
        }
        if (totalNum < pageNum) {
            _pageIndex++;
            [self requestMyTaskList:_pageIndex taskState:_taskState time:_taskTime];
        }else{
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

-(void)requestMyTaskList:(NSInteger)num taskState:(NSString *)taskState time:(NSString *)time{
    self.screeningBtn.hidden = YES;
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    
    [URL_Dic setValue:[DJUserTool getUserOrgAndCustom] forKey:@"orgId"];
    [URL_Dic setValue:@"1" forKey:@"page"];
    [URL_Dic setValue:[NSString stringWithFormat:@"%ld", num*kEachPageRowNum] forKey:@"rows"];
    [URL_Dic setValue:taskState forKey:@"status"];
    [URL_Dic setValue:time forKey:@"month"];
    [URL_Dic setObject:@"A" forKey:@"tag"];
    [self showHud:@"" title:@""];
    NSLog(@"URL_Dic%@", URL_Dic);
    __weak  typeof(self) weakSelf = self;
    [self  getJSONDataWithUrl:kURL_myReceivedTask parameters:URL_Dic success:^(id responseObject) {
        [weakSelf hudDissmiss];
        NSLog(@"responseObject%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [weakSelf parsingTaskData:responseObject];
            
        }else {
            [weakSelf  ShowWarningHudMid:responseObject[@"msg"]];
            [weakSelf emptyInterfaceLayout:2];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf hudDissmiss];
        NSLog(@"error%@", error);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf emptyInterfaceLayout:2];
    }];
    
}

- (void)parsingTaskData:(NSDictionary *)dataDic {
    
    [self.taskModelArray removeAllObjects];
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *responseDic = dataDic[@"response"];
    if (![responseDic isKindOfClass:[NSDictionary class]]) {
        [self emptyInterfaceLayout:2];
        return;
    }
    
    NSString *totalNum = [NSString stringWithFormat:@"%@", responseDic[@"totalNum"]];
    
    self.tableView.hidden  = NO;
    self.dataEmptyView.alpha = 0;
    NSArray *dataArray = responseDic[@"searchData"];
    if (![dataArray isKindOfClass:[NSArray class]] || totalNum.integerValue == 0) {
        [self emptyInterfaceLayout:1];
        self.screeningBtn.hidden = YES;
        [self.tableView reloadData];
        return;
    }
    if (totalNum.integerValue == 0) {
        
    }else {
        pageNum = totalNum.integerValue;
    }
    self.screeningBtn.hidden = NO;
    [self emptyInterfaceLayout:0];
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



- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorRGB(246, 246, 246, 1);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[DJMyTaskShowTableViewCell class] forCellReuseIdentifier:@"DJMyTaskShowTableViewCell"];
    [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    [self.view addSubview:_tableView];
    
    self.screeningBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.screeningBtn.hidden = YES;
    [_screeningBtn setImage:[UIImage imageNamed:@"DJ_lzsms_rq"] forState:(UIControlStateNormal)];
    _screeningBtn.backgroundColor = kColorRGB(246, 246, 246, 1);
    [_screeningBtn addTarget:self action:@selector(handleChooseTime) forControlEvents:(UIControlEventTouchUpInside)];
    _screeningBtn.frame = CGRectMake(kScreenWidth-kFit(46), kStatusBarAndNavigationBarHeight, kFit(46), kFit(35));
    [self.view addSubview:_screeningBtn];
    [self AdditionalControls];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.taskModelArray.count == 0  && _taskTime.length != 0) {
        return 1;
    } else {
        return self.taskModelArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.taskModelArray.count == 0  && _taskTime.length != 0) {
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
    VC.taskId = model.currentTaskId;
    VC.orgModel = [self getDefaultOrg];
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
    UITableViewHeaderFooterView *headView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    headView.contentView.backgroundColor = kColorRGB(246, 246, 246, 1);
    headView.frame  =CGRectMake(0, 0, kScreenWidth, kFit(35));
    
    UILabel *titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(kFit(15), 0, 120, kFit(35))];
    titleLabel.backgroundColor = kColorRGB(246, 246, 246, 1);
    NSLog(@"taskTime%@", _showTaskTime);
    if (self.taskModelArray.count == 0  && _showTaskTime.length != 0) {
        titleLabel.text = _showTaskTime;
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
    NSString *timeStr = _taskTime;
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
    NSString *hourIndex= @"";
    NSString *minuteIndex= @"";
    
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
    __weak DJThematicPartyDayViewController *selfWeak = self;
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
        selfWeak.taskTime =  [NSString  stringWithFormat:@"%@-%@", choiceAfterHourStr, choiceAfterMinuteStr];
        selfWeak.showTaskTime =  [NSString  stringWithFormat:@"%@年%@月", choiceAfterHourStr, choiceAfterMinuteStr];
        [selfWeak showHud:@"" title:@""];
        [selfWeak requestMyTaskList:selfWeak.pageIndex taskState:selfWeak.taskState time:selfWeak.taskTime];
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
    
}

#pragma mark DJTaskTypeChooseViewDelegate
- (void)taskTypeSelection:(NSInteger )index {
    
    switch (index) {
        case 0:
            _taskState = @"";
            break;
        case 1:
            _taskState = @"undo";
            break;
        case 2:
            _taskState = @"complete";
            break;
        case 3:
            _taskState = @"time_out";
            break;
        case 4:
            _taskState = @"appealing";
            break;
        case 5:
            _taskState = @"leaveing";
            break;
        case 6:
            _taskState = @"leave_yes";
            break;
        case 7:
            _taskState = @"timeout_complete ";
            break;
        case 8:
            _taskState = @"appeal_yes ";
            break;
        default:
            break;
    }
    
    [self showHud:@"" title:@""];
    [self requestMyTaskList:_pageIndex taskState:_taskState time:_taskTime];
    [UIView animateWithDuration:0.3 animations:^{
        self.taskTypeChooseView.alpha = 0.0;
    }];
    //好像总在自愿或者不自愿的被世俗束缚着
}

//0加载成功并有数据 1加载成功并没有数据 2加载失败
- (void)emptyInterfaceLayout:(NSInteger)type {
    switch (type) {
        case 0:
            self.dataEmptyView.alpha = 0;
            self.tableView.bounces = YES;
            self.tableView.mj_footer.hidden = NO;
            break;
        case 1:
            self.tableView.mj_footer.hidden = YES;
            self.tableView.bounces = NO;
            self.dataEmptyView.alpha = 1.0;
            if (_taskTime.length == 0) {
                self.dataEmptyView.frame =CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight);
            }else {
                self.dataEmptyView.frame =CGRectMake(0, kStatusBarAndNavigationBarHeight+kFit(35), kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-kFit(35));
                
            }
            break;
        case 2:
            self.networkRequestFailedView.alpha = 1.0;
            self.tableView.mj_footer.hidden = YES;
            self.tableView.bounces = NO;
            self.dataEmptyView.alpha = 0.0;
            break;
            
        default:
            break;
    }
    
}

-(void)dealloc {
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
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
