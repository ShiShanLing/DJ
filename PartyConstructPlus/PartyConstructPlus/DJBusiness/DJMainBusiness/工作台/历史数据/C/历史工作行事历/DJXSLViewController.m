//
//  DJXSLViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJXSLViewController.h"
#import "DJWorkingCalendarTableViewCell.h"
#import "DJNoticeTextModel.h"
#import "SegmentMenuView.h"
#import "DownChildMenuView.h"
#import "DJGtasksView.h"
#import "DJAgendaWorkingViewController.h"
#import "DJWCDetailsViewController.h"
#import "DJDAOrgChooseView.h"
@interface DJXSLViewController ()<UITableViewDelegate, UITableViewDataSource, SegmentMenuViewDelegate, DownChildMenuViewDelegate,DJGtasksViewDelegate, DJDAOrgChooseViewDelegate>


@property (nonatomic, strong)UITableView *tableView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * taskModelArray;

/**
 *
 */
@property (nonatomic, strong)SegmentMenuView  *menuView;
/**
 *
 */
@property (nonatomic, strong)DownChildMenuView *downMenuView;
/**
 *
 */
@property (nonatomic, strong)DJGtasksView *gtasksView;
/**
 *
 */
@property (nonatomic, strong)DJDAOrgChooseView * orgChooseView;
@end

@implementation DJXSLViewController

{
    
    NSString * wcType;//
    NSString *isEnable;//y启用 n禁用
    NSInteger menuType;//0 全部 周月季 半 年 年 菜单 1启用禁用菜单
    NSInteger pagedex;//第几页
    NSInteger pageNum;//该数据一共多少条
    NSInteger defaultOrgIndex;//默认展示的组织下标
}

#pragma mark 创建头部视图
- (SegmentMenuView *)menuView
{
    if (!_menuView) {
        NSArray *dataArray = @[@"全部", @"启用"];
        _menuView = [[SegmentMenuView alloc] initWithFrame:CGRectMake(0, kFit(45), kScreenWidth, kFit(45)) buttonData:dataArray  withType:@"全部"];
        _menuView.dividerLabel.hidden = NO;
        _menuView.delegate = self;
    }
    return _menuView;
}

//下拉框控件
- (DownChildMenuView *)downMenuView{
    if (!_downMenuView) {
        _downMenuView = [[DownChildMenuView alloc] initWithFrame:CGRectMake(0, kFit(90), kScreenWidth, kScreenHeight-kFit(90))];
        
        _downMenuView.Delegate = self;
    }
    return _downMenuView;
}

- (NSMutableArray *)taskModelArray {
    if (!_taskModelArray) {
        _taskModelArray = [NSMutableArray array];
    }
    return  _taskModelArray;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self  showHud:@"" title:@""];
    [self getUserWorkingCalendar:pagedex];
    [self getAgendaWorkingCalendar];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    wcType = @"";
    isEnable = @"y";
    pagedex=1;
    self.navigationItem.title = @"历史工作行事历";
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak DJXSLViewController *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    
    OrgInfoModel *orgModel = self.orgListArray[0];
    
    self.orgChooseView = [[DJDAOrgChooseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(45))];
    self.orgChooseView.delegate= self;
    self.orgChooseView.title = orgModel.orgName;
    [self.view addSubview:_orgChooseView];
    [self.view addSubview:self.menuView];
    [self createTableView];
    
    self.gtasksView = [[DJGtasksView alloc] init];
    _gtasksView.delegate = self;
    [self.view addSubview:_gtasksView];
    _gtasksView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(75).bottomSpaceToView(self.view, kTabbarSafeBottomMargin + 2);
    
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
    __weak DJXSLViewController *selfWeak = self;
    __block    SMKPickerView *smkPickerView = [SMKPickerView SMKPickerWithArray:totalTimeArray withHeadTitle:@"" defaultIndex:defaultOrgIndex withCall:^(SMKPickerView *pcikerView, NSString *choiceString) {
        _orgChooseView.title = [NSString stringWithFormat:@"%@", choiceString];
        for (int i = 0; i < _orgListArray.count; i ++) {
            OrgInfoModel *model = _orgListArray[i];
            if ([model.orgName isEqualToString:choiceString]) {
                defaultOrgIndex = i;
            }
        }
        [selfWeak  showHud:@"" title:@""];
        [selfWeak getUserWorkingCalendar:pagedex];
        [selfWeak getAgendaWorkingCalendar];
        [smkPickerView dismissPicker];
    }];
    [smkPickerView show];
    
}
//获取待办行事历
- (void)getAgendaWorkingCalendar {

    OrgInfoModel *model = self.orgListArray[defaultOrgIndex];
    NSMutableDictionary *URL_Dic= [NSMutableDictionary dictionary];
    [URL_Dic setObject:model.orgId forKey:@"orgId"];
    [URL_Dic setObject:@"1" forKey:@"page"];
    [URL_Dic setObject:@"1000" forKey:@"rows"];
    [URL_Dic setObject:model.stationId forKey:@"stationId"];
    NSLog(@"URL_Dic%@", URL_Dic);
    [self  getJSONDataWithUrl:kURL_agendaWorkingCalendar parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([codeStr isEqualToString:@"0"]) {
            NSDictionary *dataDic =responseObject[@"response"];
            NSString *totalNum = [NSString stringWithFormat:@"待办行事历(%@)", dataDic[@"totalNum"]];
            [_gtasksView.showBtn setTitle:totalNum forState:(UIControlStateNormal)];
        }else {
            
            [self ShowWarningHudMid:responseObject[@"msg"] ];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
        
    }];
}


//获取行事历数据
- (void)getUserWorkingCalendar:(NSInteger)num {

    NSMutableDictionary *URL_Dic= [NSMutableDictionary dictionary];
    OrgInfoModel *model = self.orgListArray[defaultOrgIndex];
    NSLog(@"model.orgName%@", model.orgName);
    [URL_Dic setObject:model.orgId forKey:@"orgId"];
    
    [URL_Dic setObject:@"1" forKey:@"page"];
    [URL_Dic setObject:[NSString stringWithFormat:@"%ld", num * kEachPageRowNum] forKey:@"rows"];
    [URL_Dic setObject:model.stationId forKey:@"stationId"];
    [URL_Dic setObject:isEnable forKey:@"status"];
    [URL_Dic setObject:wcType forKey:@"type"];
    NSLog(@"URL_Dic %@ num%d", URL_Dic, num);
    [self  getJSONDataWithUrl:kURL_GetWorkingCalendar parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"responseObject%@", responseObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([codeStr isEqualToString:@"0"]) {
            [self parsingUserWorkingCalendar:responseObject];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        
        
        
    } failure:^(NSError *error) {
        [self hudDissmiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"error%@", error);
    }];
}
//解析数据
- (void)parsingUserWorkingCalendar:(NSDictionary *)responseObject{
    [self.taskModelArray removeAllObjects];
    NSDictionary *dataDic = responseObject[@"response"];
    NSString *numStr = [NSString stringWithFormat:@"%@", dataDic[@"totalNum"]];
    pageNum = numStr.integerValue;
    NSArray *dataArray = dataDic[@"searchData"];
    if (dataArray.count == 0) {
        self.dataEmptyView.hidden = NO;
        if ([isEnable isEqualToString:@"y"]) {
            self.dataEmptyView.promptLabel.text = @"您暂无启用的工作行事历";
        }else {
            self.dataEmptyView.promptLabel.text = @"您暂无禁用的工作行事历";
        }
        [self.tableView reloadData];
        return;
    }
    
    self.dataEmptyView.hidden = YES;
    for (NSDictionary *tempDic in dataArray) {
        WorkingCalendarListModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"WorkingCalendarListModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
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

#pragma mark DJGtasksViewDelegate
- (void)ClickAgendaList {
    DJAgendaWorkingViewController *VC  = [[DJAgendaWorkingViewController alloc] init];
    VC.DidYouComeFromStr = @"FilingCabinet";
    VC.orgModel = self.orgListArray[defaultOrgIndex];
    
    [self pushToNextViewController:VC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//创建UITableVIew
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kFit(90), kScreenWidth, kScreenHeight-kFit(90)-kStatusBarAndNavigationBarHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabbarSafeBottomMargin+75, 0);
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[DJWorkingCalendarTableViewCell class] forCellReuseIdentifier:@"DJWorkingCalendarTableViewCell"];
    
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
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, kFit(90), kScreenWidth, kScreenHeight-kFit(90))];
    self.dataEmptyView.dividerLabel.hidden = YES;
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_gzxsl_empty"];
    self.dataEmptyView.hidden = YES;
    [self.view addSubview:self.dataEmptyView];
    self.dataEmptyView.emptyImageView.sd_layout.widthIs((kScreenWidth - 60)).heightIs(kFit(315)).centerXEqualToView(self.dataEmptyView).topSpaceToView(self.dataEmptyView, 40);
    
    self.dataEmptyView.promptLabel.sd_layout.leftSpaceToView(self.dataEmptyView.emptyImageView, 0).rightSpaceToView(self.dataEmptyView.emptyImageView, 0).topSpaceToView(self.dataEmptyView.emptyImageView, kFit(205)).autoHeightRatio(0);
}
//刷新 或者加载判断
-(void)loadDataWithMJType:(NSString*)type {
    if ([type isEqualToString:@"header"]) {
        pagedex = 1;
        [self getUserWorkingCalendar:pagedex];
    }else{
        if (self.taskModelArray.count < pageNum) {
            pagedex++;
            [self getUserWorkingCalendar:pagedex];
        }else{
            
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJWorkingCalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJWorkingCalendarTableViewCell" forIndexPath:indexPath];
    WorkingCalendarListModel *model  = self.taskModelArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkingCalendarListModel *model  = self.taskModelArray[indexPath.row];
    
    DJWCDetailsViewController *VC = [[DJWCDetailsViewController alloc] init];
    VC.planId = model.wcId;
    VC.orgModel = self.orgListArray[defaultOrgIndex];
    [self pushToNextViewController:VC];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkingCalendarListModel *model = self.taskModelArray[indexPath.row];
    CGFloat  height = [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DJWorkingCalendarTableViewCell class] contentViewWidth:kScreenWidth];
    return height < kFit(70)?kFit(70):height;
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
#pragma mark //头部三个按钮的代理方法
- (void)SegmentMenuViewSelectedWithIndex:(NSInteger)index slectBtn:(AddAttButton *)selBtn withTag:(NSInteger)tag{
    
    if (selBtn.selected) {//selected == YES 说明下拉框可以显示出来了
        self.downMenuView.isConceal = YES;
        [self.view addSubview:self.downMenuView];
    }else {
        self.downMenuView.isConceal = NO;//吧下拉菜单的状态变为不显示
        [self.downMenuView removeFromSuperview];
        //如果隐藏视图 就把下面的赋值操作截取掉
        return;
    }
    if (index == 0) {
        menuType = 0;
        self.downMenuView.dataArr = @[@"全部", @"周", @"月", @"季", @"半年", @"年"];
    }else if (index == 1){
        menuType = 1;
        self.downMenuView.dataArr = @[@"启用", @"禁用"];
    }
}

- (void) DownChildMenuViewSelectedWithIndex:(NSInteger) index {
    [self.downMenuView removeFromSuperview];
    if (menuType == 0) {
        NSString *tempStr = wcType;
        switch (index) {
            case 0:
                wcType = @"";
                break;
            case 1:
                wcType = @"week";
                break;
            case 2:
                wcType = @"month";
                break;
            case 3:
                wcType = @"quarter";
                break;
            case 4:
                wcType = @"halfyear";
                break;
            case 5:
                wcType = @"year";
                break;
                
            default:
                break;
        }
        if (![tempStr isEqualToString:wcType]) {//如果选择前和选择后不是一样的就再做请求
            [self  showHud:@"" title:@""];
            [self getUserWorkingCalendar:pagedex];
        }
    }else {
        NSString *tempStr = isEnable;
        switch (index) {
            case 0:
                isEnable = @"y";
                break;
            case 1:
                isEnable = @"n";
                break;
                
            default:
                break;
        }
        if (![tempStr isEqualToString:isEnable]) {//如果选择前和选择后不是一样的就再做请求
            [self  showHud:@"" title:@""];
            [self getUserWorkingCalendar:pagedex];
        }
    }
    
    
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
