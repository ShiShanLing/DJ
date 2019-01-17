//
//  DJAgendaWorkingViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJAgendaWorkingViewController.h"
#import "DJAgendaWCTableViewCell.h"
#import "DJAWPerformViewController.h"
@interface DJAgendaWorkingViewController ()<UITableViewDelegate, UITableViewDataSource, DJAgendaWCTableViewCellDelegte>


@property (nonatomic, strong)UITableView *tableView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * taskModelArray;
@end

@implementation DJAgendaWorkingViewController {
    NSInteger pageIndex;//多少页
    NSInteger pageNum;//一共多少数据
}

- (NSMutableArray *)taskModelArray {
    if (!_taskModelArray) {
        _taskModelArray = [NSMutableArray array];
    }
    return  _taskModelArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    [self showHud:@"正在加载数据" title:@""];
    [self getAgendaWorkingCalendar:pageIndex];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex= 1;
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"待办行事历";
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak DJAgendaWorkingViewController *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    [self createTableView];
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dataEmptyView.hidden = YES;
    if ([self.DidYouComeFromStr isEqualToString:@"FilingCabinet"]) {
        self.dataEmptyView.promptLabel.text = @"您暂无归档的工作行事历";
        self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_empty_file"];
    }else {
        self.dataEmptyView.promptLabel.text = @"所有行事历任务已完成";
        self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_gzxsl_empty"];
    }
    [self.view addSubview:self.dataEmptyView];
    self.dataEmptyView.promptLabel.sd_layout.leftSpaceToView(self.dataEmptyView.emptyImageView, 0).rightSpaceToView(self.dataEmptyView.emptyImageView, 0).topSpaceToView(self.dataEmptyView.emptyImageView, kFit(205)).autoHeightRatio(0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取待办行事历data
- (void)getAgendaWorkingCalendar:(NSInteger)num {
    [self.taskModelArray removeAllObjects];
    
    NSMutableDictionary *URL_Dic= [NSMutableDictionary dictionary];
    [URL_Dic setObject:self.orgModel.orgId forKey:@"orgId"];
    [URL_Dic setObject:@"1" forKey:@"page"];
    [URL_Dic setObject:[NSString stringWithFormat:@"%ld", num*20] forKey:@"rows"];
    [URL_Dic setObject:self.orgModel.stationId forKey:@"stationId"];
    NSLog(@"URL_Dic%@", URL_Dic);
    
    [self  getJSONDataWithUrl:kURL_agendaWorkingCalendar parameters:URL_Dic success:^(id responseObject) {
        [self  hudDissmiss];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        NSLog(@"responseObject%@", responseObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([codeStr isEqualToString:@"0"]) {
            [self parsingAgendaWorkingCalendar:responseObject];
            
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }

    } failure:^(NSError *error) {
        [self  hudDissmiss];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        NSLog(@"error%@", error);
    }];
}
//解析数据
- (void)parsingAgendaWorkingCalendar:(NSDictionary *)responseObject {
    [self.taskModelArray removeAllObjects];
    NSDictionary *dataDIc = responseObject[@"response"];
    NSString *numStr = dataDIc[@"totalNum"];
    pageNum = numStr.integerValue;
    NSArray * dataArray = dataDIc[@"searchData"];
    
    if (![dataArray isKindOfClass:[NSArray class]]) {
        self.dataEmptyView.hidden = NO;
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    
    if (dataArray.count == 0) {
       self.dataEmptyView.hidden = NO;
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    self.tableView.mj_footer.hidden = NO;
    self.dataEmptyView.hidden = YES;
    for (NSDictionary *tempDic in dataArray) {
        AgendaWorkingCalendarListModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"AgendaWorkingCalendarListModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in tempDic) {
            [model setValue:tempDic[key] forKey:key];
        }
        [self.taskModelArray addObject:model];
    }
    if (self.taskModelArray.count >=pageNum) {
        self.tableView.mj_footer.alpha = 0.0;
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }else {
        self.tableView.mj_footer.alpha = 1.0;
    }
    [self.tableView reloadData];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJAgendaWCTableViewCell class] forCellReuseIdentifier:@"DJAgendaWCTableViewCell"];
    [self.view addSubview:_tableView];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight=150.0f;
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
        [self getAgendaWorkingCalendar:pageIndex];
    }else{
        if (self.taskModelArray.count < pageNum) {
            pageIndex++;
            [self getAgendaWorkingCalendar:pageIndex];
        }else{

            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskModelArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJAgendaWCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJAgendaWCTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AgendaWorkingCalendarListModel *model = self.taskModelArray[indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AgendaWorkingCalendarListModel *model = self.taskModelArray[indexPath.row];
    [self SubmitWorkingCalenda:model];
}

- (void)SubmitWorkingCalenda:(AgendaWorkingCalendarListModel *)model{
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
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


#pragma mark DJAgendaWCTableViewCellDelegte
- (void)completeCalendar:(NSIndexPath *)indexPath {
    
    DJAWPerformViewController *VC = [[DJAWPerformViewController alloc] init];
    AgendaWorkingCalendarListModel *model  = self.taskModelArray[indexPath.row];
    VC.model = model;
    VC.orgModel = self.orgModel;
    [self.navigationController pushViewController:VC animated:YES];
    
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
