//
//  DJResponsibilityViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/10.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJResponsibilityViewController.h"
#import "DJReviewDutyViewController.h"
#import "MsgView.h"
#import "ConfigurableIconVIew.h"
#import "DJdjDutyFunctionTVCell.h"
#import "DJWorkingCalendarVC.h"
#import "DJResumptionExplainViewController.h"
@interface DJResponsibilityViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * meunArray;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
@end

@implementation DJResponsibilityViewController {
    
    NSInteger toDoNum;
    
}
- (NSMutableArray *)meunArray {
    if (!_meunArray) {
        _meunArray = [NSMutableArray array];
    }
    return _meunArray;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    toDoNum = 0;
    NSMutableArray  *meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
    if (meunArray.count == 0) {
        
    }else {
        [self getAgendaWorkingCalendar];
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = [UIColor whiteColor];
    NSArray *tempArray = @[@{@"icon":@"DJ_gzxsl", @"title":@"工作行事历"},@{@"icon":@"DJ_lzsms", @"title":@"履职说明书"}];
    self.meunArray = [NSMutableArray arrayWithArray:tempArray];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    self.defaultNavigationBarView.titleLabel.text = @"责任清单";
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    self.defaultNavigationBarView.rightBtn.hidden= YES;
    
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    
    [self createTableView];
}

- (void)handleReturnBtn {
    if (self.type == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJdjDutyFunctionTVCell class] forCellReuseIdentifier:@"DJdjDutyFunctionTVCell"];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meunArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJdjDutyFunctionTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJdjDutyFunctionTVCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.redView.hidden = NO;
        cell.redView.RedDotLabel.hidden = NO;
        cell.redView.titleLabel.text = [NSString stringWithFormat:@"待办(%ld) ", toDoNum];
        if (toDoNum == 0) {
            cell.redView.RedDotLabel.hidden = YES;
        }else {
            cell.redView.RedDotLabel.hidden = NO;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.meunArray[indexPath.row];
    [cell.showImageBtn setImage:[UIImage imageNamed:dataDic[@"icon"]] forState:(UIControlStateNormal)];
    cell.titleLabel.text = dataDic[@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray  *meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
    
    switch (indexPath.row) {
        case 0:{
            if (meunArray.count == 0) {
                [self refreshUserInfo:^(BOOL results) {
                    
                }];
                [self  ShowWarningHudMid:@"您不属于任何组织, 无法使用本功能哦!"];
                return;
            }else {
                DJWorkingCalendarVC *VC = [[DJWorkingCalendarVC alloc] init];
                [self pushToNextViewController:VC];
            }
        }
            break;
        case 1:{
            
            DJResumptionExplainViewController *VC = [[DJResumptionExplainViewController alloc] init];
            VC.type = 0;
            [self pushToNextViewController:VC];
        }
            break;
        case 2:{
            
        }
            break;
            
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kFit(115);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kFit(5.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(5.0))];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return footerView;
    
}
//获取待办行事历
- (void)getAgendaWorkingCalendar {
    NSMutableArray  *meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
    NSLog(@"工作行事历界面获取用户组织%@", meunArray);
    OrgInfoModel *orgModel = [NSEntityDescription insertNewObjectForEntityForName:@"OrgInfoModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    
    for (int i = 0; i <meunArray.count; i ++) {
        OrgInfoModel *orgInfoModel = meunArray[i];
        if ([orgInfoModel.defaultState isEqualToString:@"1"]) {
            orgModel = orgInfoModel;
        }
    }
    if (meunArray.count == 0) {
        return;
    }
    
    NSMutableDictionary *URL_Dic= [NSMutableDictionary dictionary];
    [URL_Dic setObject:orgModel.orgId forKey:@"orgId"];
    [URL_Dic setObject:@"1" forKey:@"page"];
    [URL_Dic setObject:@"20" forKey:@"rows"];
    [URL_Dic setObject:orgModel.stationId forKey:@"stationId"];
    NSLog(@"URL_Dic%@", URL_Dic);
    [self  getJSONDataWithUrl:kURL_agendaWorkingCalendar parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([codeStr isEqualToString:@"0"]) {
            NSDictionary *dataDic =responseObject[@"response"];
            NSString *totalNum = dataDic[@"totalNum"];
            toDoNum = totalNum.integerValue;
            [self.tableView reloadData];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"] ];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
        
    }];
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
