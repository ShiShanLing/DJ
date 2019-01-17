//
//  DJDAWDJBViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJDAWDJBViewController.h"
#import "DJMyAssignedTaskShowTVCell.h"
#import "DJMyAssignedTaskDetailsVC.h"
#import "DJDAOrgChooseView.h"
@interface DJDAWDJBViewController ()<UITableViewDelegate, UITableViewDataSource, DJDAOrgChooseViewDelegate>


@property (nonatomic, strong)UITableView *tableView;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;

/**
 *
 */
@property (nonatomic, strong)UIButton *screeningBtn;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * AssignegTaskModelArray;
/**
 *
 */
@property (nonatomic, strong)DJDAOrgChooseView * orgChooseView;
@end

@implementation DJDAWDJBViewController {
    NSInteger pageIndex;//多少页
    NSInteger pageNum;//一共多少数据
    NSString *taskState;//任务类型
    NSString *taskTime;//任务时间
    
    NSInteger defaultOrgIndex;//默认展示的组织下标
    NSString  *month;//需要查看的月份
    NSString  *showTaskTime;
}

- (NSMutableArray *)AssignegTaskModelArray {
    if (!_AssignegTaskModelArray) {
        _AssignegTaskModelArray = [NSMutableArray array];
    }
    return _AssignegTaskModelArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self  showHud:@"" title:@""];
    [self requestMyAssignegTaskList:1];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    showTaskTime = @"";
    month = @"";
    pageIndex = 1;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    self.defaultNavigationBarView.rightBtn.hidden = YES;
    _defaultNavigationBarView.titleLabel.text = @"历史交办任务";
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    [self createTableView];
}

- (void)handleReturnBtn  {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_tableView registerClass:[DJMyAssignedTaskShowTVCell class] forCellReuseIdentifier:@"DJMyAssignedTaskShowTVCell"];
    [self.view addSubview:_tableView];
    
    self.screeningBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_screeningBtn setImage:[UIImage imageNamed:@"DJ_lzsms_rq"] forState:(UIControlStateNormal)];
    _screeningBtn.backgroundColor = kColorRGB(246, 246, 246, 1);
    [_screeningBtn addTarget:self action:@selector(handleChooseTime) forControlEvents:(UIControlEventTouchUpInside)];
    _screeningBtn.hidden = YES;
    _screeningBtn.frame = CGRectMake(kScreenWidth-kFit(46), kStatusBarAndNavigationBarHeight+kFit(45), kFit(46), kFit(35));
    [self.view addSubview:_screeningBtn];
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+kFit(35)+kFit(45), kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-kFit(35)-kFit(45))];
    self.dataEmptyView.hidden = YES;
    self.dataEmptyView.dividerLabel.hidden = YES;
    self.dataEmptyView.promptLabel.text = @"您暂无相关交办";
    self.dataEmptyView.backgroundColor = kColorRGB(246, 246, 246, 1);
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_assigned_task_empty"];
    [self.view addSubview:self.dataEmptyView];
    
    __weak typeof(self)  weakSelf = self;
    self.tableView.mj_header = [DJMJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithMJType:@"header"];
    }];
    
    self.tableView.mj_footer = [DJMJRefreshGitFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataWithMJType:@"footer"];
    }];
}

#pragma mark  按照时间搜索
- (void)handleChooseTime{
    
    NSString *timeStr = month;
    NSArray * tempArray = [timeStr componentsSeparatedByString:@"-"];
    NSLog(@"tempArray%@", tempArray);
    NSString *yearsStr =@"";
    NSString *monthStr =@"";
    if (tempArray.count == 2) {
        yearsStr =   tempArray[0];
        monthStr = tempArray[1];
    }else {
        NSInteger year =[[NSDate date] dateYear];
        NSInteger  month = [[NSDate date] dateMonth];
        yearsStr = [NSString stringWithFormat:@"%ld", year];
        if (month <10) {
            monthStr = [NSString stringWithFormat:@"0%ld", month];
        }else {
            monthStr = [NSString stringWithFormat:@"%ld", month];
        }
    }
    NSString *hourIndex = @"";
    NSString *minuteIndex = @"";
    
    NSMutableArray *yearsArray = [NSMutableArray array];
    NSInteger years = [[NSDate date] dateYear];
    for (int i = 2017; i  < years+1; i++) {
        [yearsArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSArray *totalTimeArray = @[yearsArray, @[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12"]];
    
    
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
    
    __block  NSString *viewTimeStr;
    __weak DJDAWDJBViewController *selfWeak = self;
    __block   SMKPickerView *smkPickerView = [SMKPickerView SMKPickerMoreComponent:totalTimeArray withHeadTitle:@"" defaultIndex:@[hourIndex, minuteIndex] withCall:^(NSString *choiceString) {
        NSLog(@"choiceString%@", choiceString);
        //界面需要的time字符串
        NSString *choiceAfterHourStr;
        NSString *choiceAfterMinuteStr;
        NSArray *timeArray = [choiceString componentsSeparatedByString:@","];
        choiceAfterHourStr = timeArray[0];
        choiceAfterMinuteStr = timeArray[1];
        viewTimeStr = [NSString  stringWithFormat:@"%@-%@", choiceAfterHourStr, choiceAfterMinuteStr];
        showTaskTime = [NSString  stringWithFormat:@"%@年%@月", choiceAfterHourStr, choiceAfterMinuteStr];
        NSLog(@"viewStartTime%@", viewTimeStr);
        self->month = viewTimeStr;
        [selfWeak  showHud:@"" title:@""];
        [selfWeak requestMyAssignegTaskList:pageIndex];
        NSLog(@"month%@", self->month);
        [smkPickerView dismissPicker];
    }];
    [smkPickerView show];
}

#pragma mark  切换组织

- (void)SwitchHistoricalOrg {

    NSMutableArray *orgArray = [NSMutableArray array];
    for (int i = 0; i < self.orgListArray.count; i ++) {
        OrgInfoModel *model = self.orgListArray[i];
        [orgArray addObject:model.orgName];
    }
    
    NSArray *totalTimeArray = @[orgArray];
    
    __weak DJDAWDJBViewController *selfWeak = self;
    __block    SMKPickerView *smkPickerView = [SMKPickerView SMKPickerWithArray:totalTimeArray withHeadTitle:@"" defaultIndex:defaultOrgIndex withCall:^(SMKPickerView *pcikerView, NSString *choiceString) {
        _orgChooseView.title = choiceString;
        for (int i = 0; i < _orgListArray.count; i ++) {
            OrgInfoModel *model = _orgListArray[i];
            if ([model.orgName isEqualToString:choiceString]) {
                defaultOrgIndex = i;
            }
        }
        [selfWeak requestMyAssignegTaskList:pageIndex];
        [smkPickerView dismissPicker];
    }];
    [smkPickerView show];
    
}
//刷新 或者加载判断
-(void)loadDataWithMJType:(NSString*)type {
    if ([type isEqualToString:@"header"]) {
    
        pageIndex = 1;
        [self requestMyAssignegTaskList:pageIndex];
    }else{
        NSInteger totalNum = 0;
        for (int i = 0; i < self.AssignegTaskModelArray.count; i ++) {
            NSDictionary *taskDic = self.AssignegTaskModelArray[i];
            NSArray * keyArray =[taskDic allKeys];
            NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
            totalNum += taskArray.count;
        }
        if (totalNum < pageNum) {
            pageIndex++;
            [self requestMyAssignegTaskList:pageIndex];
        }else{
            
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

- (void)requestMyAssignegTaskList:(NSInteger)num {
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    OrgInfoModel *orgModel = self.orgListArray[defaultOrgIndex];
    [URL_Dic setValue:orgModel.orgId forKey:@"orgId"];
    [URL_Dic setValue:@"1" forKey:@"page"];
    [URL_Dic setValue:month forKey:@"month"];
    [URL_Dic setValue:[NSString stringWithFormat:@"%ld", num*kEachPageRowNum] forKey:@"rows"];
    [self  getJSONDataWithUrl:kURL_myAssignedTask parameters:URL_Dic success:^(id responseObject) {
        
        [self  hudDissmiss];
        
        NSLog(@"requestMyAssignegTaskList%@", responseObject);
        
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            _screeningBtn.hidden = NO;
            [self parsingAssignegTaskData:responseObject];
        }else {
            _screeningBtn.hidden = YES;
            [self  ShowWarningHudMid:responseObject[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        
        [self  hudDissmiss];
        NSLog(@"error%@", error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (void)parsingAssignegTaskData:(NSDictionary *)dataDic {
    [self.AssignegTaskModelArray removeAllObjects];
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
    pageNum = totalNum.integerValue;
    if (totalNum.integerValue == 0) {
        [self emptyInterfaceLayout:1];
        [self.tableView reloadData];
        return;
    }
    self.tableView.hidden  = NO;
    
    NSArray *dataArray = responseDic[@"searchData"];
    if (![dataArray isKindOfClass:[NSArray class]]) {
        return;
    }
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
        if (startTimeStr == nil && startTimeStr == NULL && startTimeStr.length == 0) {
            
        }else {
        
        NSDate *tempDate = [CommonUtil  getDateForString:startTimeStr format:@"yyyy-MM-dd HH:mm"];
        NSString *tempStr = [CommonUtil getStringForDate:tempDate format:@"yyyy年MM月"];
        
        if (![yearsStr isEqualToString:tempStr]) {
            if (yearsStr.length != 0) {
                [self.AssignegTaskModelArray  addObject:[NSMutableDictionary dictionaryWithDictionary:timeTaskDic]];
                [timeTaskDic removeAllObjects];
            }
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObject:model];
            NSLog(@"tempStr%@tempStr%@", tempStr, tempStr);
            if (tempStr == nil && tempStr == NULL && tempStr.length == 0) {
                
            }else {
                [timeTaskDic setValue:tempArray forKey:tempStr];
            }
            yearsStr = tempStr;
        }else {
            NSMutableArray *taskArray = [NSMutableArray arrayWithArray:(NSArray *)timeTaskDic[yearsStr]];
            [taskArray addObject:model];
            [timeTaskDic setValue:taskArray forKey:yearsStr];
        }
        if (i == tempArray.count - 1) {
            [self.AssignegTaskModelArray  addObject:[NSMutableDictionary dictionaryWithDictionary:timeTaskDic]];
            [timeTaskDic removeAllObjects];
        }
        }
    }
    
    NSInteger tempTotalNum = 0;
    for (int i = 0; i < self.AssignegTaskModelArray.count; i ++) {
        NSDictionary *taskDic = self.AssignegTaskModelArray[i];
        NSArray * keyArray =[taskDic allKeys];
        NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
        tempTotalNum += taskArray.count;
    }
    if (tempTotalNum < pageNum) {
            self.tableView.mj_footer.alpha = 1.0;
        
    }else{
        self.tableView.mj_footer.alpha = 0.0;
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }
    NSLog(@"self.AssignegTaskModelArray%@" ,self.AssignegTaskModelArray);
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (month.length != 0 || self.AssignegTaskModelArray.count == 0) {
        return 1;
    }else {
        return self.AssignegTaskModelArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (month.length != 0 || self.AssignegTaskModelArray.count == 0) {
        return 0;
    }else {
        NSDictionary *taskDic = self.AssignegTaskModelArray[section];
        NSArray * keyArray =[taskDic allKeys];
        NSLog(@"keyArray%@", keyArray);
        NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
        return taskArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJMyAssignedTaskShowTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJMyAssignedTaskShowTVCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *taskDic = self.AssignegTaskModelArray[indexPath.section];
    NSArray * keyArray =[taskDic allKeys];
    NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
    IReceivedTaskModel *model = taskArray[indexPath.row];
    if (indexPath.row == taskArray.count - 1) {
        cell.dividerLabel.hidden = YES;
    }else {
        cell.dividerLabel.hidden = NO;
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *taskDic = self.AssignegTaskModelArray[indexPath.section];
    NSArray * keyArray =[taskDic allKeys];
    NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
    IReceivedTaskModel *model = taskArray[indexPath.row];
    DJMyAssignedTaskDetailsVC *VC = [[DJMyAssignedTaskDetailsVC alloc] init];
    VC.taskDetailsModel = model;
    VC.currentTaskId = model.currentTaskId;
    VC.taskId = model.taskId;
    OrgInfoModel *orgModel = self.orgListArray[defaultOrgIndex];
    VC.orgModel = orgModel;
    NSLog(@"didSelectRowAtIndexPath%@", model);
    
    [self pushToNextViewController:VC];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFit(95);
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
    //    NSDictionary *taskDic = self.taskModelArray[section];
    //    NSArray * keyArray =[taskDic allKeys];
 
    titleLabel.text = @"2018年6月";
    titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(15)];
    titleLabel.textColor = kColorRGB(51, 51, 51, 1);
    if (showTaskTime.length != 0 || self.AssignegTaskModelArray.count == 0) {
        titleLabel.text = showTaskTime;
    }else {
        NSDictionary *taskDic = self.AssignegTaskModelArray[section];
        NSArray * keyArray =[taskDic allKeys];
        titleLabel.text = keyArray[0];
    }
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 1) {//隐藏
        self.screeningBtn.hidden = YES;
    }else {//显示
        self.screeningBtn.hidden = NO;
    }
    
    //    NSLog(@"scrollView%f", scrollView.contentOffset.y);
    
}

//0加载成功并有数据 1加载成功并没有数据 2加载失败
- (void)emptyInterfaceLayout:(NSInteger)type {
    switch (type) {
        case 0:
            self.dataEmptyView.hidden = YES;
            self.tableView.bounces = YES;
            self.tableView.mj_footer.hidden = NO;
            break;
        case 1:
//            self.networkRequestFailedView.hidden = NO;
            self.dataEmptyView.hidden = NO;
            self.tableView.mj_footer.hidden = YES;
            self.tableView.bounces = NO;
            if (month.length == 0) {

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
