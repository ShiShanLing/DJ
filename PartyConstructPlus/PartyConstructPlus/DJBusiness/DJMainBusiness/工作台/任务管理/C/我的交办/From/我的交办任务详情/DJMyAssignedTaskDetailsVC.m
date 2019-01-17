//
//  DJMyAssignedTaskDetailsVC.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/12.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMyAssignedTaskDetailsVC.h"

#import "DJMyAssignedTaskReadMemberViewController.h"

#import "DJMyTaskInfoTableViewCell.h"

#import "DJMyTaskViewCommentsTableViewCell.h"
#import "TaskCommentsModel+CoreDataProperties.h"
#import "DJTaskPerFormViewController.h"
@interface DJMyAssignedTaskDetailsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

/**
 *
 */
@property (nonatomic, strong)NSMutableArray * taskCommentsArray;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;

@end

@implementation DJMyAssignedTaskDetailsVC{
    NSInteger pageIndex;//多少页
    NSInteger pageNum;//一共多少数据
}

- (NSMutableArray *)taskCommentsArray {
    if (!_taskCommentsArray) {
        _taskCommentsArray = [NSMutableArray array];
    }
    return _taskCommentsArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self showHud:@"" title:@""];
    [self requestMyTaskDetails];
    [self requestTaskComments:pageIndex];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    pageIndex = 1;
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"我的交办";
    self.defaultNavigationBarView.rightBtn.hidden= YES;
    
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    [self createTableView];
}

- (void)AdditionalControls {
    
    
}

- (void)handleReturnBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[DJMyTaskViewCommentsTableViewCell class] forCellReuseIdentifier:@"DJMyTaskViewCommentsTableViewCell"];
    [_tableView registerClass:[DJMyTaskInfoTableViewCell class] forCellReuseIdentifier:@"DJMyTaskInfoTableViewCell"];
    [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    [self.view addSubview:_tableView];//
    
    __weak typeof(self)  weakSelf = self;
    self.tableView.mj_header = [DJMJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithMJType:@"header"];
    }];
    self.tableView.mj_footer = [DJMJRefreshGitFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataWithMJType:@"footer"];
    }];
    self.tableView.mj_footer.hidden = YES;
}
//刷新 或者加载判断
-(void)loadDataWithMJType:(NSString*)type {
    if ([type isEqualToString:@"header"]) {
        pageIndex = 1;
        [self requestTaskComments:pageIndex];
    }else{
        if (self.taskCommentsArray.count < pageNum) {
            pageIndex++;
            [self requestTaskComments:pageIndex];
        }else{
            
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

-(void)requestMyTaskDetails {
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.taskId forKey:@"id"];
    NSLog(@"URL_Dic%@", URL_Dic);
    [self  getJSONDataWithUrl:kURL_myAssignedTaskDetails parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self parsingTaskDetails:responseObject];
        }else {
            [self  ShowWarningHudMid:responseObject[@"msg"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
        [self hudDissmiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

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
    [self.tableView reloadData];
    
}

//请求任务评论列表
- (void)requestTaskComments:(NSInteger )num {
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.taskId forKey:@"taskId"];
    
    [URL_Dic setValue:[NSString stringWithFormat:@"%ld", pageIndex *kEachPageRowNum] forKey:@"rows"];
    [URL_Dic setValue:@"1" forKey:@"page"];
    NSLog(@"requestTaskComments%@", URL_Dic);
    
    [self  getJSONDataWithUrl:kURL_taskCommentsList parameters:URL_Dic success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"requestTaskComments%@", responseObject);
        if ([code isEqualToString:@"0"]) {
            [self parsingTaskCommentsList:responseObject];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
    NSLog(@"self.taskCommentsArray%@", self.taskCommentsArray);
    if (self.taskCommentsArray.count < pageNum) {
            self.tableView.mj_footer.alpha = 1.0;
        
    }else{
        self.tableView.mj_footer.alpha = 0.0;
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }
    [self.tableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.taskDetailsModel == nil || self.taskDetailsModel == NULL) {
        return 0;
    }else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section ==  0) {
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        DJMyTaskViewCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJMyTaskViewCommentsTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.dividerLabel.hidden = YES;
        }else {
            cell.dividerLabel.hidden = NO;
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
    }else {
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
        return kFit(56);
    }else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 0.01;
    }else {
        return kFit(50);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.01;
    if (section != 0) {
        height = kFit(56);
    }else {
        height = 0.01;
    }
    UIView *headView =[UIView new];
    headView.frame  = CGRectMake(0, 0, kScreenWidth, height);
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, height)];
    
    titelLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:kFit(16)];
    titelLabel.textColor = kColorRGB(136, 136, 136, 1);
    [headView addSubview:titelLabel];
    
    UIButton *commentsBtn  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    commentsBtn.frame = CGRectMake(kScreenWidth - 110, 0, 110, height);
    [commentsBtn setTitle:@"我要评论" forState:(UIControlStateNormal)];
    [commentsBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
    commentsBtn.titleLabel.font = MFont(kFit(14));
    [commentsBtn setImage:[UIImage imageNamed:@"DJ_myTask_taskComments"] forState:(UIControlStateNormal)];
    [commentsBtn addTarget:self action:@selector(handleIComments) forControlEvents:(UIControlEventTouchUpInside)];
    [headView addSubview:commentsBtn];
    if (section == 1) {
        titelLabel.text = [NSString stringWithFormat:@"评论(%ld)", self.taskCommentsArray.count];
        commentsBtn.hidden = NO;
    }else {
        titelLabel.text = @"";
        commentsBtn.hidden = YES;
        return nil;
    }
    return headView;
}
//我要评论
//我要评论
- (void)handleIComments {
    DJTaskPerFormViewController *VC = [[DJTaskPerFormViewController alloc] init];
    VC.oldStatus = self.taskDetailsModel.status;
    NSLog(@"self.taskDetailsModel%@", self.taskDetailsModel);
    VC.taskId = self.taskDetailsModel.taskId;
    VC.mainTaskId = self.taskDetailsModel.taskId;
    VC.orgModel = self.orgModel;
    VC.taskOperationType =  DJTaskOperationTypeComments;
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat height = 0.01;
    if (section == 1) {
        height =  0.01;
    }else {
        height  = kFit(50);
    }
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    footerView.backgroundColor = kColorRGB(246, 246, 246, 1);
    if (section == 1) {
        return footerView;
    }else {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height-kFit(5))];
        bottomView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:bottomView];
        UILabel *  dividerHLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kCellDividerHeight)];
        dividerHLabel.backgroundColor = kCellColorDivider;
        [bottomView addSubview:dividerHLabel];
        NSLog(@"self.taskDetailsModel.readNum%@ self.taskDetailsModel.totalNum%@", self.taskDetailsModel.readNum, self.taskDetailsModel.totalNum);
        if (self.taskDetailsModel.readNum.integerValue == self.taskDetailsModel.totalNum.integerValue) {//如果全部已读
     
            UIButton *readBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [readBtn setTitle:@"全部已读" forState:(UIControlStateNormal)];
            [readBtn setTitleColor:kColorRGB(136, 136, 136, 1) forState:(UIControlStateNormal)];
            [readBtn addTarget:self action:@selector(handleReadBtn) forControlEvents:(UIControlEventTouchUpInside)];
            readBtn.frame  = CGRectMake(0, kCellDividerHeight, kScreenWidth, kFit(45));
            [bottomView addSubview:readBtn];
        }else {
            
            UIButton *readBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [readBtn setTitle:[NSString stringWithFormat:@"%ld人已读", self.taskDetailsModel.readNum.integerValue]  forState:(UIControlStateNormal)];
            [readBtn setTitleColor:kColorRGB(136, 136, 136, 1) forState:(UIControlStateNormal)];
            [readBtn addTarget:self action:@selector(handleReadBtn) forControlEvents:(UIControlEventTouchUpInside)];
            readBtn.frame  = CGRectMake(0, kCellDividerHeight, kScreenWidth/2, kFit(45));
            [bottomView addSubview:readBtn];
            
            UILabel *  dividerVLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, kFit(15), kCellDividerHeight,kFit(15))];
            dividerVLabel.backgroundColor = kCellColorDivider;
            [bottomView addSubview:dividerVLabel];
            
            UIButton *unreadBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
            NSInteger  unreadNum = self.taskDetailsModel.totalNum.integerValue - self.taskDetailsModel.readNum.integerValue;
            [unreadBtn setTitle:[NSString stringWithFormat:@"%ld人未读", unreadNum] forState:(UIControlStateNormal)];
            [unreadBtn setTitleColor:kColorRGB(253, 115, 77, 1) forState:(UIControlStateNormal)];
            unreadBtn.frame  = CGRectMake(kScreenWidth/2+kCellDividerHeight, kCellDividerHeight, kScreenWidth/2, kFit(45));
            [unreadBtn addTarget:self action:@selector(handleUnreadBtn) forControlEvents:(UIControlEventTouchUpInside)];
            [bottomView addSubview:unreadBtn];
        }
        return footerView;
    }
}

- (void)handleReadBtn {
    if (self.taskDetailsModel.readNum.integerValue == 0) {
        return;
    }
    DJMyAssignedTaskReadMemberViewController *VC = [[DJMyAssignedTaskReadMemberViewController alloc] init];
    VC.isRead = @"y";
    VC.taskId = self.taskDetailsModel.taskId;
    [self pushToNextViewController:VC];
}

- (void)handleUnreadBtn {
    DJMyAssignedTaskReadMemberViewController *VC = [[DJMyAssignedTaskReadMemberViewController alloc] init];
    VC.isRead = @"n";
    VC.taskId = self.taskDetailsModel.taskId;
    [self pushToNextViewController:VC];
    
}

- (void)TaskAskLeaveBtn{
    
}

-(void)dealloc {
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}
@end
