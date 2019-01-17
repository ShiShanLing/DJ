//
//  DJResumptionExplainViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJResumptionExplainViewController.h"
#import "DJResumptionExplainListTableViewCell.h"
#import "DJRESearchView.h"
#import "SMKSFPopoverView.h"//下拉菜单
#import "SMKSFPopoverAction.h"
#import "DJmitationWeChatSearchBoxVIew.h"
#import "DJWebPDFViewController.h"
#import "DJResumptionExplainView.h"
#import "NSDate+GFCalendar.h"
@interface DJResumptionExplainViewController ()<UITableViewDelegate, UITableViewDataSource, DJmitationWeChatSearchBoxVIewDelegate, DJResumptionExplainViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *履历搜索view
 */
@property (nonatomic, strong)DJmitationWeChatSearchBoxVIew *searchView;
/**
 *
 */
@property (nonatomic, strong)UIButton *screeningBtn;
/**
 *
 */
@property (nonatomic, strong)UIBarButtonItem *leftButtonItem;
/**
 *界面展示的数组
 */
@property (nonatomic, strong)NSMutableArray * dataArray;
/**
 *搜索到的数据数组
 */
@property (nonatomic, strong)NSMutableArray * searchArray;
/**
 *搜索结果展示界面
 */
@property (nonatomic, strong)DJResumptionExplainView * searchResultsView;
@end

@implementation DJResumptionExplainViewController {
    NSInteger pagedex;//第几页
    NSInteger pageNum;//该数据一共多少条
    NSString *selectedTime;//选择时间
    NSString *SearchKeyword;//搜索的关键字
    NSInteger orgScreeningType;//筛选类型 我的  或者 组织
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}

- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self QueryList];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    orgScreeningType = 0;
    selectedTime =@"";
    self.view.backgroundColor = [UIColor whiteColor];
    pagedex = 1;
    // Do any additional setup after loading the view.
    SearchKeyword = @"";
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    switch (self.type) {
        case 0:
            _defaultNavigationBarView.titleLabel.text = @"履职说明书";
            break;
        case 1:
            _defaultNavigationBarView.titleLabel.text = @"述职评议";
            break;
            
        default:
            break;
    }
    [self.defaultNavigationBarView.rightBtn setTitle:@"我的" forState:UIControlStateNormal];
    self.defaultNavigationBarView.rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn addTarget:self action:@selector(handleRigthAccount) forControlEvents:UIControlEventTouchUpInside];
    
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    self.defaultNavigationBarView.SegmentationLineLabel.hidden = YES;
    [self.view addSubview:self.defaultNavigationBarView];
        [self createTableView];
}

- (void)handleReturnBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)handleRigthAccount {
    __weak DJResumptionExplainViewController *selfWeak = self;
  __block  SMKSFPopoverView *PopoverView = [SMKSFPopoverView popoverView];
    
    PopoverView.style = PopoverViewStyleDarkTranslucent;
    SMKSFPopoverAction *myRankingAction  =  [SMKSFPopoverAction actionWithImage:[UIImage imageNamed:@"DJ_llsms_my"] title:@"我的" handler:^(SMKSFPopoverAction *action) {
        [PopoverView hiddenPopover];
        [selfWeak.defaultNavigationBarView.rightBtn setTitle: @"我的" forState:(UIControlStateNormal)];
        self->orgScreeningType = 0;
        self->pagedex = 1;
        [selfWeak QueryList];
    }];
    
    SMKSFPopoverAction *orgRankingAction  =  [SMKSFPopoverAction actionWithImage:[UIImage imageNamed:@"DJ_llsms_org"] title:@"组织" handler:^(SMKSFPopoverAction *action) {
        NSMutableArray  *meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
        if (meunArray.count == 0) {
            [self refreshUserInfo:^(BOOL results) {
                
            }];
            [self  ShowWarningHudMid:@"您不属于任何组织, 无法使用本功能哦!"];
            return;
        }else {
            [PopoverView hiddenPopover];
            [selfWeak.defaultNavigationBarView.rightBtn setTitle: @"组织" forState:(UIControlStateNormal)];
            self->pagedex = 1;
            self->orgScreeningType = 1;
            [selfWeak QueryList];
        }
    }];

      [PopoverView showToView:self.defaultNavigationBarView.rightBtn withActions:@[myRankingAction,orgRankingAction]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createTableView {

    self.searchView = [[DJmitationWeChatSearchBoxVIew alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, 40)];
    _searchView.delegate = self;
    switch (self.type) {
        case 0:
            _searchView.searchType = 2;
            _searchView.searchTF.placeholder = @"输入履职说明书名称以搜索";
            break;
        case 1:
            _searchView.searchType = 3;
            _searchView.searchTF.placeholder = @"输入述职评议名称以搜索";
            break;
            
        default:
            break;
    }
    _searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40+kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-40) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorRGB(246, 246, 246, 1);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[DJResumptionExplainListTableViewCell class] forCellReuseIdentifier:@"DJResumptionExplainListTableViewCell"];
    [self.view addSubview:_tableView];
    
    __weak DJResumptionExplainViewController *selfWeak = self;
    
    self.tableView.mj_header = [DJMJRefreshGifHeader headerWithRefreshingBlock:^{
        [selfWeak loadDataWithMJType:@"header"];
    }];
    
    
    self.tableView.mj_footer = [DJMJRefreshGitFooter footerWithRefreshingBlock:^{
        [selfWeak loadDataWithMJType:@"footer"];
    }];
    
    self.screeningBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_screeningBtn setImage:[UIImage imageNamed:@"DJ_lzsms_rq"] forState:(UIControlStateNormal)];
    _screeningBtn.backgroundColor = kColorRGB(246, 246, 246, 1);
    [_screeningBtn addTarget:self action:@selector(handleChooseTime) forControlEvents:(UIControlEventTouchUpInside)];
    _screeningBtn.frame = CGRectMake(kScreenWidth-kFit(46), 40+kStatusBarAndNavigationBarHeight, kFit(46), kFit(35));
  [self.view addSubview:_screeningBtn];
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dataEmptyView.dividerLabel.hidden = YES;
    self.dataEmptyView.hidden = YES;
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_emptyData_clear"];
    self.dataEmptyView.backgroundColor = kColorRGB(246, 246, 246, 1);
    [self.view addSubview:self.dataEmptyView];
//    self.dataEmptyView.emptyImageView.sd_layout.widthIs((kScreenWidth - 60)).heightIs(kFit(315)).centerXEqualToView(self.dataEmptyView).topSpaceToView(self.dataEmptyView, kFit(86));
    self.searchResultsView = [[DJResumptionExplainView alloc] initWithFrame:CGRectMake(0, 40+kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-40) ];
    _searchResultsView.searchStr = @"";
    switch (self.type) {
        case 0:
            _searchResultsView.searchType  = 0;
            break;
        case 1:
            _searchResultsView.searchType  = 1;
            break;
            
        default:
            break;
    }
    _searchResultsView.alpha = 0.0;
    _searchResultsView.delegate = self;
    [self.view addSubview:_searchResultsView];
    
    
    
}


//刷新 或者加载判断
-(void)loadDataWithMJType:(NSString*)type {
    
    if ([type isEqualToString:@"header"]) {
        self.tableView.mj_footer.alpha = 0.0;
        pagedex = 1;
        [self QueryList];
    }else{
        
        NSInteger totalNum = 0;
        for (int i = 0; i < self.dataArray.count; i ++) {
            NSDictionary *taskDic = self.dataArray[i];
            NSArray * keyArray =[taskDic allKeys];
            NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
            totalNum += taskArray.count;
        }
            if (totalNum < pageNum) {
            pagedex++;
            [self QueryList];
        }else{

            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count == 0 && selectedTime.length  != 0) {
        return 1;
    }else {
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0 && selectedTime.length  != 0) {
        return 0;
    }else {
        NSDictionary *taskDic = self.dataArray[section];
        NSArray * keyArray =[taskDic allKeys];
        NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
        return taskArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJResumptionExplainListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJResumptionExplainListTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *taskDic = self.dataArray[indexPath.section];
    NSArray * keyArray =[taskDic allKeys];
    NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
    NSDictionary *dataDic = taskArray[indexPath.row];
    cell.titleLabel.text = dataDic[@"title"];
    NSString *timeStr = dataDic[@"createTime"];
    if (timeStr.length >= 12) {
        timeStr = [timeStr substringToIndex:11];
    }else {
        
    }
    cell.timeLabel.text = timeStr;
    NSString *stationName = [NSString stringWithFormat:@"%@", dataDic[@"stationName"]];
    NSString *orgName = [NSString stringWithFormat:@"%@", dataDic[@"orgName"]];
    if ([stationName isEmpty]) {
        stationName = @"";
    }
    if ( [orgName isEmpty] ) {
        orgName = @"";
    }
    cell.jobsLabel.text = [NSString stringWithFormat:@"%@  |  %@", stationName,orgName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *taskDic = self.dataArray[indexPath.section];
    NSArray * keyArray =[taskDic allKeys];
    NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
    NSDictionary *dataDic = taskArray[indexPath.row];
    DJWebPDFViewController *webPDFVC= [[DJWebPDFViewController alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"%@", dataDic[@"fileUrl"]];
    
    if ([urlStr isURL]) {
        
    }else {
        urlStr = [NSString stringWithFormat:@"%@%@", dataDic[@"dfsUrl"], dataDic[@"fileUrl"]];
    }
    webPDFVC.url = urlStr;
    webPDFVC.title = dataDic[@"title"];
    [self.navigationController pushViewController:webPDFVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFit(70);
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
    if (self.dataArray.count == 0 && selectedTime.length  != 0) {
        titleLabel.text = selectedTime;
    }else {
        NSDictionary *taskDic = self.dataArray[section];
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
    NSMutableArray *timeArray = [NSMutableArray array];
    NSInteger years = [[NSDate date] dateYear];
    for (int i = 2017; i  < years+1; i++) {
        [timeArray addObject:[NSString stringWithFormat:@"%d年",i]];
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
    
    
    __weak  DJResumptionExplainViewController *selfWeak = self;
 __block   SMKPickerView *smkPickerView = [SMKPickerView SMKPickerWithArray:@[timeArray] withHeadTitle:nil defaultIndex:index withCall:^(SMKPickerView *pcikerView, NSString *choiceString) {
     
        self->selectedTime = choiceString;
        [selfWeak QueryList];
     [pcikerView dismissPicker];
     
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

- (void)QueryList {
    NSString *URL_Str = @"";
    if (self.dataArray.count == 0) {
        self.tableView.mj_footer.hidden = YES;
    }
    [self showHud:@"正在加载数据" title:@""];
    NSMutableDictionary *URL_Dic= [NSMutableDictionary dictionary];
    [URL_Dic setObject:@"1" forKey:@"page"];
    
    [URL_Dic setObject:selectedTime forKey:@"year"];
    [URL_Dic setObject:SearchKeyword forKey:@"title"];
    
    if (self.type == 0) {
        URL_Str =  kURL_resumptionExplainList;
        [URL_Dic setObject:[NSString stringWithFormat:@"%ld", pagedex * kEachPageRowNum] forKey:@"rows"];
    }else {
        URL_Str =  kURL_reviewDutyList;
        [URL_Dic setObject:@"10000" forKey:@"rows"];
    }
    
    if (orgScreeningType == 0) {
        [URL_Dic setObject:@"" forKey:@"orgId"];
    }else {
        [URL_Dic setObject:[self getDefaultOrg].orgId forKey:@"orgId"];
    }
    NSLog(@"URL_Dic %@", URL_Dic);
    
    [self  getJSONDataWithUrl:URL_Str parameters:URL_Dic success:^(id responseObject) {
        self.tableView.mj_footer.hidden = NO;
        [self hudDissmiss];
        NSLog(@"responseObject%@", responseObject);
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([codeStr isEqualToString:@"0"]) {
            [self parsingData:responseObject];
        }else {
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

- (void)parsingData:(NSDictionary *)dataDic  {
    
    NSLog(@"SearchKeyword%@", SearchKeyword);
    
    if (SearchKeyword.length == 0) {
        [self.dataArray removeAllObjects];
    }else {
        
    }
    NSDictionary *searchDataDic =dataDic[@"response"];
    if (![searchDataDic isKindOfClass:[NSDictionary class]]) {
        [self emptyInterfaceLayout:2];
        self.searchResultsView.searchDataArray = @[];
        [self.tableView reloadData];
        return;
    }
    NSString *totalNum = searchDataDic[@"totalNum"];
    pageNum  = totalNum.integerValue;
    NSArray *searchDataArray  = searchDataDic[@"searchData"];
    if (![searchDataArray isKindOfClass:[NSArray class]] || searchDataArray.count == 0) {
        
        if (SearchKeyword.length == 0) {
            [self emptyInterfaceLayout:1];
        }
        self.searchResultsView.searchDataArray = @[];
        [self.tableView reloadData];
        return;
    }
    
    if (SearchKeyword.length == 0) {
        
        [self emptyInterfaceLayout:0];
        NSMutableDictionary *timeTaskDic = [NSMutableDictionary dictionary];
        NSString *yearsStr = @"";
        for (int i = 0;  i < searchDataArray.count; i ++) {
            NSDictionary *tempDic = searchDataArray[i];
            NSString *startTimeStr = tempDic[@"uploadTime"];
            NSDate *tempDate = [CommonUtil  getDateForString:startTimeStr format:@"yyyy-MM-dd HH:mm:ss"];
            NSString *tempStr = [CommonUtil getStringForDate:tempDate format:@"yyyy年"];
            
            if (![yearsStr isEqualToString:tempStr]) {
                if (yearsStr.length != 0) {
                    [self.dataArray  addObject:[NSMutableDictionary dictionaryWithDictionary:timeTaskDic]];
                    [timeTaskDic removeAllObjects];
                }
                NSMutableArray *tempArray = [NSMutableArray array];
                [tempArray addObject:tempDic];
                [timeTaskDic setValue:tempArray forKey:tempStr];
                yearsStr = tempStr;
            }else {
                NSMutableArray *taskArray = [NSMutableArray arrayWithArray:(NSArray *)timeTaskDic[yearsStr]];
                [taskArray addObject:tempDic];
                [timeTaskDic setValue:taskArray forKey:yearsStr];
            }
            if (i == searchDataArray.count - 1) {
                [self.dataArray  addObject:[NSMutableDictionary dictionaryWithDictionary:timeTaskDic]];
                [timeTaskDic removeAllObjects];
            }
        }
        
        NSInteger totalNum = 0;
        for (int i = 0; i < self.dataArray.count; i ++) {
            NSDictionary *taskDic = self.dataArray[i];
            NSArray * keyArray =[taskDic allKeys];
            NSArray *taskArray = [taskDic objectForKey:keyArray[0]];
            totalNum += taskArray.count;
        }
        if (totalNum < pageNum) {
            self.tableView.mj_footer.alpha = 1.0;
        }else {
            self.tableView.mj_footer.alpha = 0.0;
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        [self.tableView reloadData];
    }else {
            self.searchArray =[NSMutableArray arrayWithArray:searchDataArray];
        
        self.searchResultsView.searchDataArray = self.searchArray;
    }
}

#pragma mark DJmitationWeChatSearchBoxVIewDelegate
/**
 开始搜索
 */
- (void)BeginYourSearch {
    switch (self.type) {
        case 0:
            _searchResultsView.searchType  = 0;
            break;
        case 1:
            _searchResultsView.searchType  = 1;
            break;
            
        default:
            break;
    }
    self.tableView.mj_footer.hidden = YES;
    //这里需要重置搜索界面的数据

    self.screeningBtn.hidden = YES;
    CGRect frame1 = self.defaultNavigationBarView.frame;
    CGRect frame2 = self.searchView.frame;
    CGRect frame3 = self.tableView.frame;
    frame1.origin.y = -kStatusBarAndNavigationBarHeight;
    frame2.origin.y = 24+kXNavigationBarExtraHeight;
    frame3.origin.y = 64+kXNavigationBarExtraHeight;
    frame3.size.height = kScreenHeight-64 + kTabbarSafeBottomMargin;
    __weak __typeof(self) weakself= self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.defaultNavigationBarView.frame =frame1;
        weakself.searchView.frame = frame2;
        weakself.searchResultsView.frame = frame3;
        weakself.searchResultsView.alpha = 1.0;
        weakself.tableView.frame=frame3;

    } completion:^(BOOL finished) {
        
    }];
}

/**
 结束搜索
 */
-(void)endSearch {
    [self.tableView reloadData];
    SearchKeyword = @"";
    self.searchView.searchTF.text = @"";
    self.searchResultsView.searchStr = @"";
    self.searchResultsView.searchDataArray = @[];
    
    self.screeningBtn.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.defaultNavigationBarView.frame =CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight);
        self.searchView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, 40);
        self.tableView.frame=CGRectMake(0, 40+kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-40) ;
        self.searchResultsView.frame = CGRectMake(0, 40+kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-40) ;
        self.searchResultsView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.tableView.mj_footer.hidden = NO;
    }];
}

/**
 搜索进行网络请求
 */
- (void)searchNetworkRequest {

    SearchKeyword = self.searchView.searchTF.text;
    self.searchResultsView.searchStr = SearchKeyword;
    [self QueryList];
}

- (void)searchData:(NSString *)string {

}

#pragma mark  DJResumptionExplainViewDelegate

- (void)searchDataChoose:(NSDictionary *)dataDic {
    [self.searchView.searchTF resignFirstResponder];
   
    DJWebPDFViewController *webPDFVC= [[DJWebPDFViewController alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"%@", dataDic[@"fileUrl"]];
    if ([urlStr isURL]) {
        
    }else {
        urlStr = [NSString stringWithFormat:@"%@%@", dataDic[@"dfsUrl"], dataDic[@"fileUrl"]];
    }
    webPDFVC.url = urlStr;
    webPDFVC.title = dataDic[@"title"];
    [self.navigationController pushViewController:webPDFVC animated:YES];
}

-(void)SearchHistoryChoose:(NSString *)string {
    [self.searchView.searchTF resignFirstResponder];
    self.searchView.searchTF.text = string;
    SearchKeyword = string;
    [self QueryList];
}
- (void)viewResponse {
    [self.searchView.searchTF resignFirstResponder];
}
//0加载成功并有数据 1加载成功并没有数据 2加载失败
- (void)emptyInterfaceLayout:(NSInteger)type {
   
    switch (type) {
        case 0:
            self.dataEmptyView.hidden = YES;
            self.tableView.bounces = YES;
            self.tableView.mj_footer.hidden = NO;
            break;
        case 1:{
            self.tableView.mj_footer.hidden = YES;
            if (self.type == 0) {
                self.dataEmptyView.backgroundColor = kColorRGB(246, 246, 246, 1);
                self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_llsms_empty"];
                if (orgScreeningType == 0) {
                    self.dataEmptyView.promptLabel.text = @"您尚未上传履职说明书";
                }else {
                    self.dataEmptyView.promptLabel.text = @"您所在组织尚无人员上传履职说明书";
                }
            }else {
                self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_szpy_empty"];
                if (orgScreeningType == 0) {
                    self.dataEmptyView.promptLabel.text = @"您尚未上传述职评议";
                }else {
                    self.dataEmptyView.promptLabel.text = @"您所在组织尚无人员上传述职评议";
                }
            }
            
            if (selectedTime.length == 0) {
                self.dataEmptyView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight+40, kScreenWidth, kScreenHeight);
                self.dataEmptyView.hidden = NO;
                self.dataEmptyView.backgroundColor = [UIColor whiteColor];
                self.tableView.bounces = NO;
            }else {
                
                 self.dataEmptyView.frame =CGRectMake(0, kStatusBarAndNavigationBarHeight+40+kFit(35), kScreenWidth, kScreenHeight-40-kFit(35));
                self.dataEmptyView.hidden = NO;
                self.dataEmptyView.backgroundColor = kColorRGB(246, 246, 246, 1);
                self.tableView.bounces = NO;
            }
        }
            break;
        case 2: {
            self.tableView.mj_footer.hidden = YES;
        }
            
            break;
        default:
            break;
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
