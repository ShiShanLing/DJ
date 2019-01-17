//
//  DJPerformanceViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/24.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJPerformanceViewController.h"
#import "DJdjDutyFunctionTVCell.h"
#import "DJWorkingCalendarVC.h"
#import "MsgView.h"
#import "DJTranscriptViewController.h"
#import "DJResumptionExplainViewController.h"

@interface DJPerformanceViewController ()<UITableViewDelegate, UITableViewDataSource>

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

@implementation DJPerformanceViewController{
    
    
}

- (NSMutableArray *)meunArray {
    if (!_meunArray) {
        _meunArray = [NSMutableArray array];
    }
    return _meunArray;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = [UIColor whiteColor];
    NSArray *tempArray = @[@{@"icon":@"DJ_cjd", @"title":@"我的成绩单"},@{@"icon":@"DJ_szms", @"title":@"述职评议"}];
    self.meunArray = [NSMutableArray arrayWithArray:tempArray];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    self.defaultNavigationBarView.titleLabel.text = @"党建绩效";
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
    
        cell.redView.hidden = YES;
        cell.redView.RedDotLabel.hidden = YES;
        
    
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
                DJTranscriptViewController *VC = [[DJTranscriptViewController alloc] init];
                [self pushToNextViewController:VC];
            }
        
        }
            break;
        case 1:{
            
            DJResumptionExplainViewController *VC = [[DJResumptionExplainViewController alloc] init];
            VC.type = 1;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
