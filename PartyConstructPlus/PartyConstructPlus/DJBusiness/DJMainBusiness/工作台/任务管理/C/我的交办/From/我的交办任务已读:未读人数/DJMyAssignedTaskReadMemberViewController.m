//
//  DJMyAssignedTaskReadMemberViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMyAssignedTaskReadMemberViewController.h"
#import "DJTaskTypeChooseView.h"
#import "DJTaskMemberTableViewCell.h"
#import "DJMyAssingnedTaskMemberProgressVC.h"
@interface DJMyAssignedTaskReadMemberViewController ()<DJTaskTypeChooseViewDelegate,UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong)UITableView *tableView;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *
 */
@property (nonatomic, strong)DJTaskTypeChooseView * taskTypeChooseView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * memberArray;
@end

@implementation DJMyAssignedTaskReadMemberViewController {
    NSString *taskState;
    NSInteger pageIndex;//多少页
    NSInteger pageNum;//一共多少数据
}

- (NSMutableArray *)memberArray {
    if (!_memberArray) {
        _memberArray = [NSMutableArray array];
    }
    return _memberArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self showHud:@"" title:@""];
    [self requestMemberList:pageIndex taskState:taskState];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    taskState = @"";
    pageIndex = 1;
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    
    if ([self.isRead isEqualToString:@"y"]) {
        _defaultNavigationBarView.titleLabel.text = @"已读列表";
        [self.defaultNavigationBarView.rightBtn setTitle:@"类型" forState:(UIControlStateNormal)];
        [self.defaultNavigationBarView.rightBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self.defaultNavigationBarView.rightBtn  addTarget:self action:@selector(handleTypeSelection) forControlEvents:(UIControlEventTouchUpInside)];
    }else {
        _defaultNavigationBarView.titleLabel.text = @"未读列表";
        self.defaultNavigationBarView.rightBtn.hidden = YES;
    }
   
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    [self createTableView];
    if ([self.isRead isEqualToString:@"y"]) {
        self.taskTypeChooseView = [[DJTaskTypeChooseView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight)];
        _taskTypeChooseView.alpha = 0.0;
        _taskTypeChooseView.delegate = self;
        [self.view addSubview:_taskTypeChooseView];
    }else {
        [self.taskTypeChooseView removeFromSuperview];
    }
}

- (void)handleReturnBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleTypeSelection {

    CGFloat  alpha =  _taskTypeChooseView.alpha;
    if (alpha == 0.0) {
        alpha = 1.0;
    }else {
        alpha = 0.0;
    }
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.taskTypeChooseView.alpha = alpha;
    }];
}

- (void)parsingMember:(NSDictionary *)dataDic {
    [self.memberArray removeAllObjects];
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *responseDic = dataDic[@"response"];
    if (![responseDic isKindOfClass:[NSDictionary class]]) {
        [self.tableView reloadData];
        return;
    }
    NSString *totalNum = responseDic[@"totalNum"];
    pageNum = totalNum.integerValue;
    NSArray *dataArray = responseDic[@"searchData"];
    if (![dataArray isKindOfClass:[NSArray class]]) {
        self.tableView.mj_footer.hidden = YES;
        [self.tableView reloadData];
        return;
    }
    self.tableView.mj_footer.hidden = NO;
   
    for (int i = 0; i < dataArray.count; i ++) {
        NSDictionary *tempDic = dataArray[i];
        IReceivedTaskModel *model = [NSEntityDescription  insertNewObjectForEntityForName:@"IReceivedTaskModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in tempDic) {
            [model setValue:tempDic[key] forKey:key];
        }
        [self.memberArray addObject:model];
    }
    
    NSLog(@"pageNum%d", pageNum);
    if (self.memberArray.count < pageNum) {
    
            self.tableView.mj_footer.alpha = 1.0;
        
    }else{
        self.tableView.mj_footer.alpha = 0.0;
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJTaskMemberTableViewCell class] forCellReuseIdentifier:@"DJTaskMemberTableViewCell"];
    [self.view addSubview:_tableView];
    __weak typeof(self)  weakSelf = self;
    self.tableView.mj_header = [DJMJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithMJType:@"header"];
    }];
    self.tableView.mj_footer = [DJMJRefreshGitFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataWithMJType:@"footer"];
    }];
    self.tableView.mj_footer.alpha = 0.0;
}
//刷新 或者加载判断
-(void)loadDataWithMJType:(NSString*)type {
    if ([type isEqualToString:@"header"]) {
        pageIndex = 1;
        [self requestMemberList:pageIndex taskState:taskState];
    }else{
        if (self.memberArray.count < pageNum) {
            pageIndex++;
            [self requestMemberList:pageIndex taskState:taskState];
        }else{
            
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.memberArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJTaskMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskMemberTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell isRead:self.isRead];
    cell.memberModel = self.memberArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.isRead isEqualToString:@"y"]) {
        DJMyAssingnedTaskMemberProgressVC *VC = [[DJMyAssingnedTaskMemberProgressVC alloc] init];
        VC.taskDetailsModel = self.memberArray[indexPath.row];
        [self pushToNextViewController:VC];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return footerView;
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
    
    [self requestMemberList:pageIndex taskState:taskState];
    [UIView animateWithDuration:0.3 animations:^{
        _taskTypeChooseView.alpha = 0.0;
    }];
}


- (void)requestMemberList:(NSInteger)num taskState:(NSString *)taskState {
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.taskId forKey:@"id"];
    [URL_Dic setValue:self.isRead forKey:@"isRead"];
    [URL_Dic setValue:taskState forKey:@"status"];
    [URL_Dic setValue:@"10000" forKey:@"rows"];
    [URL_Dic setValue:@"1" forKey:@"page"];
    [self getJSONDataWithUrl:kURL_myAssignedTaskMemberState parameters:URL_Dic success:^(id responseObject) {
//        NSLog(@"responseObject%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        [self hudDissmiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([code isEqualToString:@"0"]) {
            [self parsingMember:responseObject];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hudDissmiss];
    }];
}

- (void)setTaskId:(NSString *)taskId {
    _taskId = taskId;
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
