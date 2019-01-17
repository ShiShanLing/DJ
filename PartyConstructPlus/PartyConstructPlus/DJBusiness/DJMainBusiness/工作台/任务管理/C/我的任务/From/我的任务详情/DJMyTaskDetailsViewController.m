//
//  DJMyTaskDetailsViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMyTaskDetailsViewController.h"
#import "DJMyTaskInfoTableViewCell.h"
#import "DJMyTaskProgressTableViewCell.h"
#import "DJMyTaskViewCommentsTableViewCell.h"
#import "DJTaskPerFormViewController.h"
#import "TaskCommentsModel+CoreDataProperties.h"
#import "DJTaskDetalisHeadView.h"
@interface DJMyTaskDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, DJMyTaskProgressTableViewCellDelegate, DJTaskDetalisHeadViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

/**
 *
 */
@property (nonatomic, strong)NSMutableArray * taskCommentsArray;
/**
 *任务进度数组
 */
@property (nonatomic, strong)NSMutableArray * taskStepArray;

/**
 *多少页
 */
@property (nonatomic, assign)NSInteger pageIndex;//
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
@end

@implementation DJMyTaskDetailsViewController {
    
    NSInteger pageNum;//一共多少数据
//    NSInteger refreshWay;//记录刷新的方式 0 刚进来刷新总界面 1下拉刷新   因为使用 本界面使用三个接口如果都使用 reloadData 会使界面有些闪烁
    
}

- (NSMutableArray *)taskCommentsArray {
    if (!_taskCommentsArray) {
        
        _taskCommentsArray = [NSMutableArray array];
    }
    return _taskCommentsArray;
}

- (NSMutableArray *)taskStepArray {
    if (!_taskStepArray) {
        _taskStepArray = [NSMutableArray array];
    }
    return _taskStepArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    
    
    
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"任务详情";
    self.defaultNavigationBarView.rightBtn.hidden= YES;
    
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    

    [self createTableView];
}

- (void)handleReturnBtn {
    
    if ([self.animationType isEqualToString:@"present"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
   [self refreshData];
}

- (void)refreshData {
    [self showHud:@"" title:@""];
    [self requestMyTaskDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    _tableView.hidden = YES;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJMyTaskViewCommentsTableViewCell class] forCellReuseIdentifier:@"DJMyTaskViewCommentsTableViewCell"];
    [_tableView registerClass:[DJMyTaskProgressTableViewCell class] forCellReuseIdentifier:@"DJMyTaskProgressTableViewCell"];
    [_tableView registerClass:[DJMyTaskInfoTableViewCell class] forCellReuseIdentifier:@"DJMyTaskInfoTableViewCell"];
    [_tableView registerClass:[DJTaskDetalisHeadView class] forHeaderFooterViewReuseIdentifier:@"DJTaskDetalisHeadView"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];//
    __weak typeof(self)  weakSelf = self;
    self.tableView.mj_header = [DJMJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithMJType:@"header"];
    }];
//    如果没有评论就不显示
    self.tableView.mj_footer = [DJMJRefreshGitFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataWithMJType:@"footer"];
    }];
    
}
//刷新 或者加载判断
-(void)loadDataWithMJType:(NSString*)type {
    if ([type isEqualToString:@"header"]) {
        _pageIndex = 1;
        [self requestTaskStep];
        [self requestTaskComments:_pageIndex];
    }else{
        if (self.taskCommentsArray.count < pageNum) {
            _pageIndex++;
            [self requestTaskComments:_pageIndex];
        }else{
            
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

-(void)requestMyTaskDetails {
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.taskId forKey:@"taskId"];
    [URL_Dic setValue:self.orgModel.orgId forKey:@"orgId"];
    
    NSLog(@"URL_Dic%@", URL_Dic);
    __weak typeof(self)  weakSelf = self;
    [self  getJSONDataWithUrl:kURL_myReceivedTaskDetails parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"requestMyTaskDetails%@", responseObject);
        [URL_Dic removeAllObjects];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [weakSelf parsingTaskDetails:responseObject];
            [weakSelf requestTaskStep];
        }else {
            [weakSelf hudDissmiss];
            [weakSelf  ShowWarningHudMid:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [weakSelf hudDissmiss];
        NSLog(@"error%@", error);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
//解析
- (void)parsingTaskDetails:(NSDictionary *)responseObject {
    
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *responseDic = responseObject[@"response"];
    if (![responseDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    IReceivedTaskModel *model = [NSEntityDescription  insertNewObjectForEntityForName:@"IReceivedTaskModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    for (NSString *key in responseDic) {
        [model setValue:responseDic[key] forKey:key];
    }
    self.taskDetailsModel = model;
    
    if (![self.taskDetailsModel.isRead isEqualToString:@"y"]) {
        [self tagTaskRead];
    }
}
#warning 这里的网络请求失败怎么提示
- (void)tagTaskRead {
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.taskDetailsModel.currentTaskId forKey:@"taskId"];
    [URL_Dic setValue:self.taskDetailsModel.taskId forKey:@"id"];
    [self  getJSONDataWithUrl:kURL_tagTaskRead parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
        }else {
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
        
    }];
}
//请求任务执行步骤
- (void)requestTaskStep {
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.taskDetailsModel.taskId forKey:@"id"];
    NSLog(@"URL_Dic%@ self.taskDetailsModel%@", URL_Dic, self.taskDetailsModel);
    
    __weak typeof(self)  weakSelf = self;
    [self  getJSONDataWithUrl:kURL_queryTaskStep parameters:URL_Dic success:^(id responseObject) {
        
        NSLog(@"任务执行步骤%@", responseObject);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [weakSelf parsingTaskStep:responseObject];
            [weakSelf requestTaskComments:weakSelf.pageIndex];
            
        }else {
            [weakSelf hudDissmiss];
            [weakSelf  ShowWarningHudMid:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
        [weakSelf hudDissmiss];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)parsingTaskStep:(NSDictionary *)dataDic {
    _tableView.hidden = NO;
    [self.taskStepArray removeAllObjects];
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *dataArray = dataDic[@"response"];
    if (![dataArray isKindOfClass:[NSArray class]]) {
        
        return;
    }
    if (dataArray.count == 0) {//如果数组为空说明用户还没有进行任何操作 为待完成状态
        if ([_taskDetailsModel.status isEqualToString:@"time_out"]) {//如果该状态为申诉待审核
            TaskStepModel *undoModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            undoModel.status= @"time_out";
            undoModel.createTime = _taskDetailsModel.endDate;
            undoModel.content = @"";
            [self.taskStepArray insertObject:undoModel atIndex:0];
            [self submitTaskTimeout];
        }else {
            TaskStepModel *tempModel2  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            tempModel2.status= @"undo";
            tempModel2.createTime = self.taskDetailsModel.startDate;
            tempModel2.content = @"待完成";
            [self.taskStepArray addObject:tempModel2];
        }
        TaskStepModel *tempModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        tempModel.status= @"default";
        tempModel.createTime = self.taskDetailsModel.createTime;
        tempModel.content = self.taskDetailsModel.sendUserName;
        [self.taskStepArray addObject:tempModel];
    }else {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *modelDic in dataArray) {
            TaskStepModel *model  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            for (NSString *key in modelDic) {
                [model setValue:modelDic[key] forKey:key];
            }
            [tempArray addObject:model];
        }
        self.taskStepArray = [NSMutableArray arrayWithArray:tempArray];
        
        TaskStepModel *defaultModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        defaultModel.status= @"default";
        defaultModel.createTime = self.taskDetailsModel.createTime;
        defaultModel.content = self.taskDetailsModel.sendUserName;
        [self.taskStepArray addObject:defaultModel];
        TaskStepModel *tempModel = self.taskStepArray[0];//取出下标为0的model
        if ([tempModel.status isEqualToString:@"appeal_no"]) {//如果该状态为申述未通过
            TaskStepModel *waiting_fill_doModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            waiting_fill_doModel.status= @"waiting_fill_do";
            waiting_fill_doModel.createTime = @"";
            waiting_fill_doModel.content = @"";
            [self.taskStepArray insertObject:waiting_fill_doModel atIndex:0];
     
        }
        if ([tempModel.status isEqualToString:@"leave_no"]) {//如果改状态为请假未通过
            TaskStepModel *undoModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            undoModel.status= @"secondUndo";
            undoModel.createTime = @"";
            undoModel.content = @"";
            [self.taskStepArray insertObject:undoModel atIndex:0];
        }
        if ([tempModel.status isEqualToString:@"leaveing"]) {//如果该状态为请假待审核
            TaskStepModel *undoModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            undoModel.status= @"leaveing_show";
            undoModel.createTime = @"";
            undoModel.content = @"";
            [self.taskStepArray insertObject:undoModel atIndex:0];
        }
        if ([tempModel.status isEqualToString:@"appealing"]) {//如果该状态为申述待审核
            TaskStepModel *undoModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            undoModel.status= @"appealing_show";
            undoModel.createTime = @"";
            undoModel.content = @"";
            [self.taskStepArray insertObject:undoModel atIndex:0];
  
        }
        
        if ([tempModel.status isEqualToString:@"appeal_yes"] || [tempModel.status isEqualToString:@"appealing"] || [tempModel.status isEqualToString:@"appeal_no"] || [tempModel.status isEqualToString:@"timeout_complete"]|| [tempModel.status isEqualToString:@"eva"]) {
            for (int i = 0; i < self.taskStepArray.count; i ++) {//遍历数组把数据里面的超时变为历史超时
                TaskStepModel *model = self.taskStepArray[i];
                if ([model.status isEqualToString:@"time_out"]) {
                    model.status = @"time_out_no";
                    self.taskStepArray[i] = model;
                }
            }
        }
        if ([_taskDetailsModel.status isEqualToString:@"time_out"]) {//如果该状态为超时状态
            TaskStepModel *lowModel = self.taskStepArray[0];//去除下标为 0 的状态
            
//            NSLog(@"lowModel%@ self.taskStepArray%@", lowModel, self.taskStepArray);
            if ([lowModel.status isEqualToString:@"time_out"]||[lowModel.status isEqualToString:@"waiting_fill_do"]) {
                //如果这个状态为超时  或者 waiting_fill_do(申诉未通过的待补办) 不做处理
            }else {
                //否者 任务状态为 超时  而且 任务步骤的最后一步不是 超时,,而且不是 申述未通过待补办   那么就手动往数据里面添加一条 用来显示
                //同时请求添加一天 超时数据
                TaskStepModel *undoModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
                undoModel.status= @"time_out";
                undoModel.createTime = _taskDetailsModel.endDate;
                undoModel.content = @"";
                [self.taskStepArray insertObject:undoModel atIndex:0];
                [self submitTaskTimeout];
            }
        }
    }
    
        [self.tableView reloadData];
}

//请求任务评论列表
- (void)requestTaskComments:(NSInteger )num {
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.taskDetailsModel.currentTaskId forKey:@"taskId"];
    [URL_Dic setValue:[NSString stringWithFormat:@"%ld", self.pageIndex *kEachPageRowNum] forKey:@"rows"];
    [URL_Dic setValue:@"1" forKey:@"page"];
//    NSLog(@"requestTaskComments%@", URL_Dic);
    __weak typeof(self)  weakSelf  = self;
    [self  getJSONDataWithUrl:kURL_taskCommentsList parameters:URL_Dic success:^(id responseObject) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf hudDissmiss];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"requestTaskComments%@", responseObject);
        if ([code isEqualToString:@"0"]) {
            [weakSelf parsingTaskCommentsList:responseObject];
        }else {
            [weakSelf ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf hudDissmiss];
    }];
}
//解析任务评论列表
- (void)parsingTaskCommentsList:(NSDictionary *)commentsList {
    [self.taskCommentsArray removeAllObjects];
    if (![commentsList isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *dataDic = commentsList[@"response"];
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *totalNum = dataDic[@"totalNum"];
    pageNum = totalNum.integerValue;
    NSArray *dataArray = dataDic[@"searchData"];
    if (![dataArray isKindOfClass:[NSArray class]]) {
        self.tableView.mj_footer.hidden = YES;
        [self.tableView reloadData];
        return;
    }
    
    if (dataArray.count == 0) {
        self.tableView.mj_footer.hidden = YES;
        [self.tableView reloadData];
        return;
    }
    self.tableView.mj_footer.hidden = NO;
    for (NSDictionary *modelDic in dataArray) {
        TaskCommentsModel *model  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskCommentsModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in modelDic) {
            [model setValue:modelDic[key] forKey:key];
        }
        [self.taskCommentsArray addObject:model];
    }
    
    if (self.taskCommentsArray.count >= pageNum) {
        self.tableView.mj_footer.alpha = 0.0;
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }else {
        self.tableView.mj_footer.alpha = 1.0;
    }
    
        [self.tableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.taskStepArray.count;
    }else if (section == 0){
        return 1;
    }else {
        if (self.taskCommentsArray.count == 0) {
            return 1 ;
        }else {
            return self.taskCommentsArray.count;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DJMyTaskInfoTableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"DJMyTaskInfoTableViewCell" forIndexPath:indexPath];
        cell.model = self.taskDetailsModel;
        NSLog(@"self.taskDetailsModel%@", self.taskDetailsModel);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        DJMyTaskProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJMyTaskProgressTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        TaskStepModel *model = self.taskStepArray[indexPath.row];
        [cell configControls:indexPath modelArray:self.taskStepArray];
        cell.sendUserName = self.taskDetailsModel.sendUserName;
        cell.indexPath = indexPath;
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        DJMyTaskViewCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJMyTaskViewCommentsTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.dividerLabel.alpha = 0.0;
        }else {
            cell.dividerLabel.alpha = 1.0;
        }
        if (self.taskCommentsArray.count == 0) {
            [cell noData];
        }else {
            cell.promptLabel.hidden = YES;
            cell.emptyImageView.hidden = YES;
            TaskCommentsModel *model = self.taskCommentsArray[indexPath.row];
            cell.model  = model;
            
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.tableView cellHeightForIndexPath:indexPath model:self.taskDetailsModel keyPath:@"model" cellClass:[DJMyTaskInfoTableViewCell class] contentViewWidth:kScreenWidth];
    }else if(indexPath.section == 1){
        TaskStepModel *model = self.taskStepArray[indexPath.row];
//        NSLog(@"此时这个cell的高度%f", [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DJMyTaskProgressTableViewCell class] contentViewWidth:kScreenWidth]);
        
          return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DJMyTaskProgressTableViewCell class] contentViewWidth:kScreenWidth];
    } else{
        
        if (self.taskCommentsArray.count == 0) {
            return kFit(200);
        }else {
            TaskCommentsModel *model = self.taskCommentsArray[indexPath.row];
            
            
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DJMyTaskViewCommentsTableViewCell class] contentViewWidth:kScreenWidth];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 35;
    }else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0.01;
    }else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        DJTaskDetalisHeadView *headView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DJTaskDetalisHeadView"];
        headView.frame = CGRectMake(0, 0, kScreenWidth, 35);
        headView.delegate = self;
        if (section == 1) {
            headView.titleLabel.text = @"任务进度";
            headView.commentsBtn.hidden = YES;
        }else if(section == 2){
            headView.titleLabel.text = [NSString stringWithFormat:@"评论(%ld)", pageNum];
            headView.commentsBtn.hidden = NO;
        }
        return headView;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
    }
}
//我要评论
- (void)toCommentTask {
    DJTaskPerFormViewController *VC = [[DJTaskPerFormViewController alloc] init];
    VC.orgModel = self.orgModel;
    VC.oldStatus = self.taskDetailsModel.status;
    VC.taskId = self.taskDetailsModel.currentTaskId;
    VC.mainTaskId = self.taskDetailsModel.taskId;
    VC.taskOperationType =  DJTaskOperationTypeComments;
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat height = 0.01;
    if (section == 2) {
        height =  0.01;
    }else {
        height  = 10;
    }
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    footerView.backgroundColor = kColorRGB(246, 246, 246, 1);
    return footerView;
}
#pragma mark  DJMyTaskProgressTableViewCellDelegate
- (void)TaskPerformBtn {
    DJTaskPerFormViewController *VC = [[DJTaskPerFormViewController alloc] init];
    VC.orgModel = self.orgModel;
    VC.oldStatus = self.taskDetailsModel.status;
    VC.taskId = self.taskDetailsModel.currentTaskId;
    VC.mainTaskId = self.taskDetailsModel.taskId;
    if ([self.taskDetailsModel.status isEqualToString:@"undo"]) {
        VC.taskOperationType =  DJTaskOperationTypePerform;
    }else {
        VC.taskOperationType =  DJTaskOperationTypeFillDo;
    }
   [self.navigationController pushViewController:VC animated:YES];
}

- (void)TaskAskLeaveBtn{
    
    DJTaskPerFormViewController *VC = [[DJTaskPerFormViewController alloc] init];
    VC.orgModel = self.orgModel;
    VC.oldStatus = self.taskDetailsModel.status;
    VC.taskId = self.taskDetailsModel.currentTaskId;
    VC.mainTaskId = self.taskDetailsModel.taskId;
    NSLog(@"self.taskDetailsModel.currentTaskId%@self.taskDetailsModel.taskId%@", self.taskDetailsModel.currentTaskId, self.taskDetailsModel.taskId);
    if ([self.taskDetailsModel.status isEqualToString:@"undo"]) {
        VC.taskOperationType =  DJTaskOperationTypeAskLeave;
    }else {
        VC.taskOperationType =  DJTaskOperationTypeComplaint;
    }
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)submitTaskTimeout {
    
//    NSMutableDictionary * URL_Dic = [NSMutableDictionary dictionary];
//    [URL_Dic setValue:self.taskDetailsModel.taskId forKey:@"id"];
//    [URL_Dic setValue:@"" forKey:@"content"];
//    [URL_Dic setValue:@"" forKey:@"img"];
//    [URL_Dic setValue:@"time_out" forKey:@"status"];
//    [URL_Dic setValue:self.taskDetailsModel.status forKey:@"oldStatus"];
//    [self getJSONDataWithUrl:kURL_performMyReceivedTask parameters:URL_Dic success:^(id responseObject) {
//        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
//        if ([code isEqualToString:@"0"]) {
//
//        }else {
//            [self ShowWarningHudMid:responseObject[@"msg"]];
//        }
////        NSLog(@"responseObject%@", responseObject);
//    } failure:^(NSError *error) {
//
//    }];
    
}

-(void)setTaskDetailsModel:(IReceivedTaskModel *)taskDetailsModel {
    
    _taskDetailsModel = taskDetailsModel;
    
}

- (void)setTaskId:(NSString *)taskId {
    _taskId = taskId;
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
