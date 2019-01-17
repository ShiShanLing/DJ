//
//  DJTranscriptViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/20.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTranscriptViewController.h"
#import "DJIntegralShowTableViewCell.h"
#import "DJUserTranscriptShowHeadView.h"
#import "NSDate+GFCalendar.h"
#import "DJMonthTranscriptTableViewCell.h"

@interface DJTranscriptViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong)UITableView *tableView;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray *modelArray;
/**
 *成绩列表
 */
@property (nonatomic, strong)NSMutableArray * transcriptArray;
/**
 *总成绩
 */
@property (nonatomic, strong)NSMutableDictionary * totalTranDic;
/**
 *
 */
@property (nonatomic, strong)DJUserTranscriptShowHeadView *transcriptShowHeadView;
@end

@implementation DJTranscriptViewController
{
    NSInteger pageIndex;//多少页
    NSInteger pageNum;//一共多少数据
    NSInteger transcriptState;//成绩单类型 0本月成绩单 1 历史月份成绩单  2 年度成绩单(展示每个月成绩)
    
    NSString *queryTime;
}
- (NSMutableDictionary *)totalTranDic {
    if (!_totalTranDic) {
        _totalTranDic = [NSMutableDictionary dictionary];
    }
    return _totalTranDic;
}

- (NSMutableArray *)transcriptArray {
    if (!_transcriptArray) {
        _transcriptArray = [NSMutableArray array];
    }
    return _transcriptArray;
}
- (NSMutableArray *)modelArray {
    if (_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSInteger year =[[NSDate date] dateYear];
    NSInteger  month = [[NSDate date] dateMonth];
    NSString *timeStr =@"2018-06";
    if (month <10) {
        timeStr = [NSString stringWithFormat:@"%ld-0%ld",year, month];
    }else {
        timeStr = [NSString stringWithFormat:@"%ld-%ld",year, month];
    }
    queryTime = timeStr;
    [self showHud:@"" title:@""];
    [self queryThatMonthTotalIntegral:timeStr];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageIndex = 1;
    transcriptState = 0;
    queryTime = @"";
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"成绩单";
    
    NSInteger year =[[NSDate date] dateYear];
    NSInteger  month = [[NSDate date] dateMonth];
    NSString *timeStr =@"本月";
    if (month <10) {
        timeStr = [NSString stringWithFormat:@"%ld-0%ld",year, month];
    }else {
        timeStr = [NSString stringWithFormat:@"%ld-%ld",year, month];
    }
    queryTime =timeStr;
    [self.defaultNavigationBarView.rightBtn setTitle:@"        本月" forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
    self.defaultNavigationBarView.rightBtn.sd_layout.rightSpaceToView(self.defaultNavigationBarView, 0).bottomSpaceToView(self.defaultNavigationBarView, 10).widthIs(90).heightIs(25);
    [self.defaultNavigationBarView.rightBtn addTarget:self action:@selector(handleTimeChoose) forControlEvents:(UIControlEventTouchUpInside)];
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    
    self.transcriptShowHeadView = [[DJUserTranscriptShowHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kFit(160))];
    [self.view addSubview:_transcriptShowHeadView];
    [self createTableView];
}

- (void)handleReturnBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleTimeChoose {
    
    NSString *timeStr = queryTime;
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
    
    NSMutableArray *timeArray = [NSMutableArray array];
    NSInteger years = [[NSDate date] dateYear];
    for (int i = 2017; i  < years+1; i++) {
        [timeArray addObject:[NSString stringWithFormat:@"%d",i]];
    }

    NSArray *totalTimeArray = @[timeArray, @[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"全年"]];
    
    NSString *hourIndex=@"";
    NSString *minuteIndex=@"";
    
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
    
    __weak DJTranscriptViewController *selfWeak = self;
   __block SMKPickerView *smkPickerView = [SMKPickerView SMKPickerMoreComponent:totalTimeArray withHeadTitle:@"" defaultIndex:@[hourIndex, minuteIndex] withCall:^(NSString *choiceString) {
        //界面需要的time字符串
        NSString *viewTimeStr;
        NSString *choiceAfterHourStr;
        NSString *choiceAfterMinuteStr;
        NSArray *timeArray = [choiceString componentsSeparatedByString:@","];
        choiceAfterHourStr = timeArray[0];
        choiceAfterMinuteStr = timeArray[1];
        viewTimeStr = [NSString  stringWithFormat:@"%@-%@", choiceAfterHourStr, choiceAfterMinuteStr];
        NSLog(@"viewStartTime%@", viewTimeStr);
       {
           NSString *chooseTime = @"";
           if ([choiceAfterMinuteStr isEqualToString:@"全年"]) {
               [selfWeak.defaultNavigationBarView.rightBtn setTitle:[NSString stringWithFormat:@"     %@", choiceAfterHourStr] forState:(UIControlStateNormal)];
               self->queryTime = choiceAfterHourStr;
               self->transcriptState = 2;
               [selfWeak showHud:@"" title:@""];
               [selfWeak getYearsTotalScore:choiceAfterHourStr];
           }else {
               chooseTime = [NSString stringWithFormat:@"%@%@", choiceAfterHourStr, choiceAfterMinuteStr];
               NSString * currentTime = @"";
               NSInteger year =[[NSDate date] dateYear];
               NSInteger  month = [[NSDate date] dateMonth];
               if (month <10) {
                   currentTime = [NSString stringWithFormat:@"%ld0%ld",year, month];
               }else {
                   currentTime = [NSString stringWithFormat:@"%ld%ld",year, month];
               }
                if (chooseTime.integerValue != currentTime.integerValue) {
                    self->transcriptState = 1;

                    [selfWeak.defaultNavigationBarView.rightBtn setTitle:viewTimeStr forState:(UIControlStateNormal)];
                }else {
                    [selfWeak.defaultNavigationBarView.rightBtn setTitle:@"        本月" forState:(UIControlStateNormal)];
                    self->transcriptState = 0;
                }
               self->queryTime = viewTimeStr;
               [selfWeak showHud:@"" title:@""];
               [selfWeak queryThatMonthTotalIntegral:viewTimeStr];
           }
       }
       
        [smkPickerView dismissPicker];
    }];
    [smkPickerView show];
    
}

- (void)Updatetypelist:(NSString *)time {
    
    
}

- (void)AdditionalControls {
    __weak typeof(self) weakSelf = self;
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
//刷新 或者加载判断
-(void)loadDataWithMJType:(NSString*)type {
    
    if ([type isEqualToString:@"header"]) {
        pageIndex = 1;
        if (transcriptState != 2) {
            [self getMonthTranscript:queryTime];
        }else {
            [self getYearsTranscript:queryTime];
        }
        
    }else{
        if (self.transcriptArray.count < pageNum) {
            pageIndex++;
            if (transcriptState != 2) {
                NSLog(@"加载更多数据%ld", pageIndex);
                    [self getMonthTranscript:queryTime];
            }else {
                [self getYearsTranscript:queryTime];
            }
        }else{
            
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kFit(160)+kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kFit(160)-kStatusBarAndNavigationBarHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = kColorRGB(246, 246, 246, 1);
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJIntegralShowTableViewCell class] forCellReuseIdentifier:@"DJIntegralShowTableViewCell"];
    [_tableView registerClass:[DJMonthTranscriptTableViewCell class] forCellReuseIdentifier:@"DJMonthTranscriptTableViewCell"];
    [self.view addSubview:_tableView];
    [self AdditionalControls];
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, kFit(160)+kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kFit(160)-kStatusBarAndNavigationBarHeight) ];
    self.dataEmptyView.promptLabel.text = @"该月无成绩单";
    self.dataEmptyView.dividerLabel.hidden = YES;
    self.dataEmptyView.emptyImageView.image= [UIImage imageNamed:@"DJ_cjd_empty"];
    self.dataEmptyView.hidden = YES;
    [self.view addSubview:self.dataEmptyView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.transcriptArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (transcriptState != 2) {
        DJIntegralShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJIntegralShowTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = self.transcriptArray[indexPath.row];
            cell.contentLabel.text = dic[@"typeInfo"];
            NSString *timeStr = dic[@"createTime"];
            if (timeStr.length >= 12) {
                timeStr = [timeStr substringToIndex:11];
            }else {
                
            }
            cell.timeLabel.text = timeStr;
            NSString *integralStr = [NSString stringWithFormat:@"%@", dic[@"score"]];
            int  integral = integralStr.intValue;
            if (integral >= 0) {
                cell.integralLabel.text = [NSString stringWithFormat:@"+%d", integral];
            }else {
                cell.integralLabel.text = [NSString stringWithFormat:@"%d", integral];
            }
        return cell;
    }else {
        DJMonthTranscriptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJMonthTranscriptTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = self.transcriptArray[indexPath.row];
        NSString *titleStr = [NSString stringWithFormat:@"%@", dic[@"score"]];
        cell.contentLabel.text = titleStr;
        NSString *  tempMonth = [NSString stringWithFormat:@"%@", dic[@"month"]];
        
        NSArray *timeArray = [tempMonth componentsSeparatedByString:@"-"];
        NSString *monthArabr = @"";
        
        if (timeArray.count == 2) {
            monthArabr = timeArray[1];
        }
        
        
        NSString *monthStr= @"";
            switch ([monthArabr integerValue]) {
                case 1:
                    monthStr = @"一月";
                    break;
                case 2:
                    monthStr = @"二月";
                    break;
                case 3:
                    monthStr = @"三月";
                    break;
                case 4:
                    monthStr = @"四月";
                    break;
                case 5:
                    monthStr = @"五月";
                    break;
                case 6:
                    monthStr = @"六月";
                    break;
                case 7:
                    monthStr = @"七月";
                    break;
                case 8:
                    monthStr = @"八月";
                    break;
                case 9:
                    monthStr = @"九月";
                    break;
                case 10:
                    monthStr = @"十月";
                    break;
                case 11:
                    monthStr = @"十一月";
                    break;
                case 12:
                    monthStr = @"十二月";
                    break;
                default:
                    break;
            }
        
            cell.timeLabel.text= monthStr;
            cell.integralLabel.text= [self accordingScoreRating:[NSString stringWithFormat:@"%@", dic[@"score"]]];
            return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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

//获取某个月的总分
- (void)queryThatMonthTotalIntegral:(NSString *)timeStr {
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:timeStr forKey:@"month"];
    [URL_Dic setValue:[self getDefaultOrg].orgId forKey:@"orgId"];
    NSLog(@"URL_Dic%@", URL_Dic);
    __weak typeof(self) weakSelf = self;
    [self getJSONDataWithUrl:kURL_currentMonthTotalScore parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *responseDic = responseObject[@"response"];
            if (![responseDic isKindOfClass:[NSDictionary class]]) {
                [weakSelf hudDissmiss];
            }else {
                weakSelf.transcriptShowHeadView.state = transcriptState;
                weakSelf.transcriptShowHeadView.dataDic = responseObject[@"response"];
                weakSelf.totalTranDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"response"]];
                
                [weakSelf getMonthTranscript:queryTime];
            }
        }else {
            [weakSelf hudDissmiss];
        }
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
    
    
}
//获取某个月的成绩单列表
- (void)getMonthTranscript:(NSString *)timeStr {

    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:timeStr forKey:@"month"];
    [URL_Dic setValue:@"1" forKey:@"page"];
    [URL_Dic setValue:[NSString stringWithFormat:@"%ld", pageIndex * kEachPageRowNum] forKey:@"rows"];
    [URL_Dic setValue:[self getDefaultOrg].orgId forKey:@"orgId"];
    NSLog(@"URL_Dic%@", URL_Dic);
    __weak typeof(self) weakSelf = self;
    [self getJSONDataWithUrl:kURL_anyMonthTranscript parameters:URL_Dic success:^(id responseObject) {
        [weakSelf hudDissmiss];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"responseObject%@", responseObject);
        if ([code isEqualToString:@"0"]) {
            if (weakSelf.transcriptArray.count != 0) {
                [weakSelf.transcriptArray removeAllObjects];
            }
            NSDictionary *responseDic = responseObject[@"response"];
            NSArray *searchArray = responseDic[@"searchData"];
            if (![searchArray isKindOfClass:[NSArray class]]) {
                weakSelf.dataEmptyView.hidden = NO;
                weakSelf.dataEmptyView.promptLabel.text = @"该月无成绩单";
                
                [weakSelf refreshHeadDataDic:weakSelf.totalTranDic];
                [weakSelf.tableView reloadData];
                
                return ;
            }
            if (searchArray.count == 0) {
                weakSelf.dataEmptyView.hidden = NO;
                weakSelf.dataEmptyView.promptLabel.text = @"该月无成绩单";
              
                [weakSelf refreshHeadDataDic:self.totalTranDic];
                [weakSelf.tableView reloadData];
                
                return;
            }
            weakSelf.transcriptShowHeadView.rankingLabel.alpha = 1.0;
            if (transcriptState != 0) {
                weakSelf.transcriptShowHeadView.resultsImageView.alpha = 1.0;
            }else {
                weakSelf.transcriptShowHeadView.resultsImageView.alpha = 0.0;
            }
            NSString *totalNum = responseDic[@"totalNum"];
            pageNum = totalNum.integerValue;
            
            weakSelf.dataEmptyView.hidden = YES;
            weakSelf.transcriptArray = [NSMutableArray arrayWithArray:searchArray];
            [weakSelf refreshHeadDataDic:self.totalTranDic];
            if (weakSelf.transcriptArray.count < pageNum) {
            
                    self.tableView.mj_footer.alpha = 1.0;
                
            }else{
                weakSelf.tableView.mj_footer.alpha = 0.0;
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [weakSelf.tableView reloadData];
        }else {
            
        }
    } failure:^(NSError *error) {
        [weakSelf hudDissmiss];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
//获取某年的所有月份的成绩

- (void)getYearsTranscript:(NSString *)time {

    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:time forKey:@"year"];
    [URL_Dic setValue:@"1" forKey:@"page"];
    [URL_Dic setValue:@"100"forKey:@"rows"];
    [URL_Dic setValue:[self getDefaultOrg].orgId forKey:@"orgId"];
    __weak typeof(self) weakSelf = self;
    [self getJSONDataWithUrl:kURL_queryYearsEachMonthTotalScore parameters:URL_Dic success:^(id responseObject) {
        [weakSelf hudDissmiss];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
//        NSLog(@"responseObject%@", responseObject);
        if ([code isEqualToString:@"0"]) {
            if (weakSelf.transcriptArray.count != 0) {
                [weakSelf.transcriptArray removeAllObjects];
            }
            NSDictionary *responseDic = responseObject[@"response"];
            NSArray *searchArray = responseDic[@"searchData"];
            if (![searchArray isKindOfClass:[NSArray class]]) {
                weakSelf.dataEmptyView.hidden = NO;
                weakSelf.dataEmptyView.promptLabel.text = @"该年无成绩单";
                
                [weakSelf refreshHeadDataDic:self.totalTranDic];
                [weakSelf.tableView reloadData];
                return ;
            }
            if (searchArray.count == 0) {
                weakSelf.dataEmptyView.hidden = NO;
                weakSelf.dataEmptyView.promptLabel.text = @"该年无成绩单";
               
                [weakSelf refreshHeadDataDic:weakSelf.totalTranDic];
                [weakSelf.tableView reloadData];
                return;
            }
            
            weakSelf.transcriptShowHeadView.rankingLabel.alpha = 1.0;
            weakSelf.transcriptShowHeadView.resultsImageView.alpha = 1.0;
            NSString *totalNum = responseDic[@"totalNum"];
            pageNum = totalNum.integerValue;
            weakSelf.dataEmptyView.hidden = YES;
            weakSelf.transcriptArray = [NSMutableArray arrayWithArray:searchArray];
            [weakSelf refreshHeadDataDic:weakSelf.totalTranDic];
            if (weakSelf.transcriptArray.count < pageNum) {
                    self.tableView.mj_footer.alpha = 1.0;
                
            }else{
                weakSelf.tableView.mj_footer.alpha = 0.0;
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            weakSelf.transcriptShowHeadView.resultsState.text =  [weakSelf calculateYearResults];
            [weakSelf.tableView reloadData];
        }else {
            
        }
    } failure:^(NSError *error) {
        [weakSelf hudDissmiss];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}
//查询某年的总成绩
- (void)getYearsTotalScore:(NSString *)timeStr {
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:timeStr forKey:@"year"];
    [URL_Dic setValue:[self getDefaultOrg].orgId forKey:@"orgId"];
    NSLog(@"URL_Dic%@", URL_Dic);
    __weak typeof(self) weakSelf = self;
    [self getJSONDataWithUrl:kURL_currentMonthTotalScore parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *responseDic = responseObject[@"response"];
            if (![responseDic isKindOfClass:[NSDictionary class]]) {
                
            }else {
                weakSelf.transcriptShowHeadView.state = transcriptState;
                weakSelf.transcriptShowHeadView.dataDic = responseObject[@"response"];
                weakSelf.totalTranDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"response"]];
                [weakSelf getYearsTranscript:queryTime];
                
            }
        }else {
            [weakSelf hudDissmiss];
        }
    } failure:^(NSError *error) {
        [weakSelf hudDissmiss];
    }];
    
    
}


-(void)refreshHeadDataDic:(NSDictionary *)dataDic {
    
    
    NSString *currentTime= @"";
    NSString *yearsStr =@"";
    NSString *monthStr =@"";
    NSInteger year =[[NSDate date] dateYear];
    NSInteger  month = [[NSDate date] dateMonth];
    yearsStr = [NSString stringWithFormat:@"%ld", year];
    if (month <10) {
        monthStr = [NSString stringWithFormat:@"0%ld", month];
    }else {
        monthStr = [NSString stringWithFormat:@"%ld", month];
    }
    currentTime = [NSString stringWithFormat:@"%@%@", yearsStr, monthStr];
    
    NSString * chooseTime  = [queryTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"currentTime%@chooseTime%@", currentTime, chooseTime);
    
    NSString *imageURL = [NSString stringWithFormat:@"%@", dataDic[@"headUrl"]];
    
    if ([imageURL isURL]) {
        [self.transcriptShowHeadView.headImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"DJUserDefaultHead"]];
    }else {
        [self.transcriptShowHeadView.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dataDic[@"dfsUrl"] ,imageURL]] placeholderImage:[UIImage imageNamed:@"DJUserDefaultHead"]];
    }
    self.transcriptShowHeadView.resultsImageView.image = [UIImage imageNamed:@"DJ_results_state"];
    self.transcriptShowHeadView.resultsImageView.alpha = 1.0;
    self.transcriptShowHeadView.userNameLabel.text=dataDic[@"userName"];
    self.transcriptShowHeadView.orgNameLabel.text = [NSString stringWithFormat:@"%@ | %@", dataDic[@"stationName"], dataDic[@"orgName"]];
    
    
    
    if (self.transcriptArray.count == 0) {
        self.transcriptShowHeadView.resultsImageView.alpha = 0.0;
    }else {
        self.transcriptShowHeadView.resultsImageView.alpha = 1.0;
    }
    switch (transcriptState) {
        case 0://如果是本月成绩单
            self.transcriptShowHeadView.rankingLabel.text = [NSString stringWithFormat:@"当前积分:  %@", dataDic[@"score"]];
            self.transcriptShowHeadView.resultsState.text = [NSString stringWithFormat:@"%@", dataDic[@"score"]];
            self.transcriptShowHeadView.resultsState.alpha = 1.0;
           self.transcriptShowHeadView.resultsImageView.alpha = 0.0;
            break;
        case 1:
            self.transcriptShowHeadView.rankingLabel.text  = @"";
//            self.transcriptShowHeadView.rankingLabel.text = [NSString stringWithFormat:@"%@分，超越%@同组织用户", dataDic[@"score"],dataDic[@"score"]];
            
            if (self.transcriptArray.count == 0) {
                self.transcriptShowHeadView.resultsImageView.alpha = 0.0;
            }
            
            self.transcriptShowHeadView.resultsState.text =  [self accordingScoreRating:[NSString stringWithFormat:@"%@%%", dataDic[@"score"]]];
            self.transcriptShowHeadView.resultsState.alpha = 1.0;
                if (currentTime.integerValue > chooseTime.integerValue) {
                    //如果选择的时间小于当前时间
                    self.transcriptShowHeadView.resultsState.alpha = 1.0;
                    self.transcriptShowHeadView.rankingLabel.alpha = 1.0;
                }else if (currentTime.integerValue == chooseTime.integerValue) {
                    //如果选择的时候等于当前时间
                    self.transcriptShowHeadView.resultsState.alpha = 1.0;
                    self.transcriptShowHeadView.rankingLabel.alpha = 1.0;
                }else{
                    //否者选择的时间大于当前时间
                    self.transcriptShowHeadView.resultsState.alpha = 0.0;
                    self.transcriptShowHeadView.rankingLabel.alpha = 0.0;
                    self.transcriptShowHeadView.resultsImageView.alpha = 0.0;
                }
            break;
        case 2:
            self.transcriptShowHeadView.rankingLabel.text =@"";
//            self.transcriptShowHeadView.rankingLabel.text = [NSString stringWithFormat:@"%@分，超越%@%%同组织用户", dataDic[@"score"],dataDic[@"percent"]];
            
                if (yearsStr.integerValue > queryTime.integerValue) {
                    //如果选择的时间小于当前时间
                    self.transcriptShowHeadView.resultsState.alpha = 1.0;
                    self.transcriptShowHeadView.rankingLabel.alpha = 1.0;
                }else if (yearsStr.integerValue == queryTime.integerValue) {
                    self.dataEmptyView.hidden = NO;
                    self.dataEmptyView.promptLabel.text = @"本年度成绩单暂未完成";
                    //如果选择的时候等于当前时间
                    self.transcriptShowHeadView.resultsState.alpha = 0.0;
                    self.transcriptShowHeadView.rankingLabel.alpha = 0.0;
                    self.transcriptShowHeadView.resultsImageView.alpha = 0.0;
                }else {
                    //否者选择的时间大于当前时间
                    self.transcriptShowHeadView.resultsState.alpha = 0.0;
                    self.transcriptShowHeadView.rankingLabel.alpha = 0.0;
                    self.transcriptShowHeadView.resultsImageView.alpha = 0.0;
                }
            
            //计算总分
            break;
            
        default:
            break;
    }
    
}


- (NSString *)calculateYearResults {
    int  score = 0;
    for (int i = 0; i  < self.transcriptArray.count; i ++) {
        NSDictionary *tempDic = self.transcriptArray[i];
        NSString *scoreStr = [NSString stringWithFormat:@"%@", tempDic[@"score"]];
        if (scoreStr.intValue <75) {
            score +=1;
        }
        if ( scoreStr.intValue<93 && scoreStr.intValue >= 75) {
            score +=2;
        }
        
        if (scoreStr.intValue >= 93) {
            score +=3;
        }
    }
    if (score < 20) {
        return @"合格";
    }
    if (score >= 20 || score < 28) {
        return @"良好";
    }
    if (score >= 28) {
        return @"优秀";
    }
}


- (NSString *)accordingScoreRating:(NSString *)Score {
    
    NSInteger results = Score.integerValue;
    NSString *resultsStr= @"合格";
    if (results < 75) {
        resultsStr = @"合格";
    }
    if ( results<93 && results >= 75) {
        resultsStr =  @"良好";
    }
    if (results >= 93) {
        resultsStr =  @"优秀";
    }
    return resultsStr;
}

- (void)dealloc {
    
    
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
