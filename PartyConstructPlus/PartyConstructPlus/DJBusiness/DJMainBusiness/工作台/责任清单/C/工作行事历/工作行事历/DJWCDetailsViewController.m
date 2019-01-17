//
//  DJWCDetailsViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJWCDetailsViewController.h"
#import "DJWCDetailsHeadTVCell.h"//行事历详情的head
#import "DJNoticeTextModel.h"
#import "DJWCDetailsReplaceTaskTVCell.h"//执行
#import "DJWCDetailsFinishTableViewCell.h"

#import "DJAWPerformViewController.h"
@interface DJWCDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, DJWCDetailsFinishTableViewCellDelegate, DJWCDetailsReplaceTaskTVCellDelegate>


@property (nonatomic, strong)UITableView *tableView;
/**
 *
 */
@property (nonatomic, strong)DJNoticeTextModel * headModel;
/**
 *
 */
@property (nonatomic, strong) NSMutableArray *taskModelArray;
@property (nonatomic, strong) NSMutableArray *testDataArray;
@end

@implementation DJWCDetailsViewController {
    NSInteger  pageNum;//一共多少条数据
    
    NSInteger  pagedex;//多少页
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self  showHud:@"" title:@""];
    [self  getUserWorkingCalendar:pagedex];
    
}

- (NSMutableArray *)taskModelArray {
    if (!_taskModelArray) {
        _taskModelArray = [NSMutableArray array];
    }
    return _taskModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pagedex = 1;
    // Do any additional setup after loading the view.
    self.navigationItem.title =@"行事历详情";
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak DJWCDetailsViewController *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    [self createTableView];
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dataEmptyView.hidden = YES;
    self.dataEmptyView.dividerLabel.hidden = YES;
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_gzxsl_empty"];
    self.dataEmptyView.promptLabel.text = @"暂无相关行事历任务";
    [self.view addSubview:self.dataEmptyView];
    
    self.dataEmptyView.promptLabel.sd_layout.leftSpaceToView(self.dataEmptyView.emptyImageView, 0).rightSpaceToView(self.dataEmptyView.emptyImageView, 0).topSpaceToView(self.dataEmptyView.emptyImageView, kFit(205)).autoHeightRatio(0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getUserWorkingCalendar:(NSInteger)num {
    [self.taskModelArray removeAllObjects];

    NSMutableDictionary *URL_Dic= [NSMutableDictionary dictionary];
    [URL_Dic setObject:self.orgModel.orgId forKey:@"orgId"];
    [URL_Dic setObject:@"1" forKey:@"page"];
    [URL_Dic setObject:[NSString stringWithFormat:@"%ld", num*20] forKey:@"rows"];
    [URL_Dic setObject:self.planId forKey:@"planId"];
    
    NSLog(@"URL_Dic%@", URL_Dic);
    [self  getJSONDataWithUrl:kURL_WorkingCalendarDetails parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        NSLog(@"responseObject%@", responseObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([codeStr isEqualToString:@"0"]) {
            
            [self parsingUserWorkingCalendar:responseObject];
        }else {
            self.dataEmptyView.hidden = NO;
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self hudDissmiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"error%@", error);
    }];
}

- (void)parsingUserWorkingCalendar:(NSDictionary *)responseObject{
    
    NSDictionary *dataDic = responseObject[@"response"];
    NSString *numStr = [NSString stringWithFormat:@"%@", dataDic[@"totalNum"]];
    pageNum = numStr.integerValue;
    NSArray *dataArray = dataDic[@"searchData"];
 
    NSArray *OrgArray =  [self queryModel:@"OrgInfoModel"];
    NSString *orgName;
    if (OrgArray.count == 0) {
        orgName =  @"组织名字获取失败";
    }else {
        OrgInfoModel *orgInfoModel = OrgArray[0];
        orgName = orgInfoModel.orgName;
    }
    
    if(![dataArray isKindOfClass:[NSArray class]]) {
        self.dataEmptyView.hidden = NO;
        
        return;
    }
    
    if (dataArray.count == 0) {
        self.dataEmptyView.hidden = NO;
        return;
    }
    
    self.dataEmptyView.hidden = YES;
    for (NSDictionary *tempDic in dataArray) {
        AgendaWorkingCalendarListModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"AgendaWorkingCalendarListModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in tempDic) {
            [model setValue:tempDic[key] forKey:key];
        }
        [model setValue:orgName forKey:@"orgName"];
        [self.taskModelArray addObject:model];
    }
    
    if (self.taskModelArray.count == pageNum) {
        self.tableView.mj_footer.alpha = 0.0;
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }else {
        self.tableView.mj_footer.alpha = 1.0;
    }
    
    NSLog(@"self.taskModelArray%@", self.taskModelArray);
    [self.tableView reloadData];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[DJWCDetailsHeadTVCell class] forCellReuseIdentifier:@"DJWCDetailsHeadTVCell"];
    [_tableView registerClass:[DJWCDetailsReplaceTaskTVCell class] forCellReuseIdentifier:@"DJWCDetailsReplaceTaskTVCell"];
    [_tableView registerClass:[DJWCDetailsFinishTableViewCell class] forCellReuseIdentifier:@"DJWCDetailsFinishTableViewCell"];
    [self.view addSubview:_tableView];
    
    self.tableView.estimatedRowHeight=150.0f;
    __weak typeof(self)  weakSelf = self;
    self.tableView.mj_header = [DJMJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithMJType:@"header"];
    }];
    
    self.tableView.mj_footer = [DJMJRefreshGitFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataWithMJType:@"footer"];
    }];
    self.tableView.mj_footer.alpha = 0.0;
}

-(void)loadDataWithMJType:(NSString*)type {
    
    if ([type isEqualToString:@"header"]) {
        pagedex = 1;
        [self getUserWorkingCalendar:pagedex];
    }else{
        if (self.taskModelArray.count < pageNum) {
            pagedex++;
            [self getUserWorkingCalendar:pagedex];
        }else{
            self.tableView.mj_footer.alpha = 0.0;
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.taskModelArray.count == 0) {
        return 0;
    }else {
        return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.taskModelArray.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DJWCDetailsHeadTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJWCDetailsHeadTVCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        OrgInfoModel *orgModel = [self getDefaultOrg];
        AgendaWorkingCalendarListModel *model = self.taskModelArray[indexPath.row];
        cell.model = model;
        cell.orgNameLabel.text = self.orgModel.orgName;
        return cell;
    }else {
        AgendaWorkingCalendarListModel *model  = self.taskModelArray[indexPath.row];
        if ([model.status isEqualToString:@"completed"] || [model.status isEqualToString:@"timecompleted"] ) {
            DJWCDetailsFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJWCDetailsFinishTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = model;
            cell.delegate = self;
            return cell;
        }else {
            DJWCDetailsReplaceTaskTVCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"DJWCDetailsReplaceTaskTVCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.timeLabel.text = [NSString stringWithFormat:@"%@—%@", model.beginTime, model.endTime];
            if (![model.status isEqualToString:@"timeout"]) {
                cell.waitExecutionBtn.hidden = NO;
                cell.waitReplaceBtn.hidden = YES;
                cell.stateLabel.text = @"待完成";
            }else {
                cell.waitExecutionBtn.hidden = YES;
                cell.waitReplaceBtn.hidden = NO;
                cell.stateLabel.text = @"任务超期";
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AgendaWorkingCalendarListModel *model  = self.taskModelArray[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DJWCDetailsHeadTVCell class] contentViewWidth:kScreenWidth];
    }else {
        
        AgendaWorkingCalendarListModel *model  = self.taskModelArray[indexPath.row];
        if ([model.status isEqualToString:@"completed"] || [model.status isEqualToString:@"timecompleted"] ) {
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DJWCDetailsFinishTableViewCell class] contentViewWidth:kScreenWidth];
            
        }else {
            return kFit(65);
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return kFit(5);
    }else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(5))];
    footerView.backgroundColor = kColorRGB(246, 246, 246, 1);
    return footerView;
}
#pragma mark  DJWCDetailsFinishTableViewCellDelegate
- (void)ClickImageIndex:(NSInteger)index  cell:(DJWCDetailsFinishTableViewCell *)cell {
    
    NSLog(@"[self.tableView indexPathForCell:cell];%@", [self.tableView indexPathForCell:cell]);
    [self setFullScreenImageShow:@[@"123.png", @"123.png", @"123.png", @"123.png", @"123.png", @"123.png"] defaultIndex:2];
}
#pragma mark DJWCDetailsReplaceTaskTVCellDelegate
- (void)WCPerform:(NSIndexPath *)indexPath {
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
