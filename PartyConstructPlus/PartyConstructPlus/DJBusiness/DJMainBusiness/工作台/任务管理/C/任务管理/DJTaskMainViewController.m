//
//  DJTaskMainViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/25.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskMainViewController.h"

#import "MsgView.h"
#import "ConfigurableIconVIew.h"
#import "DJdjDutyFunctionTVCell.h"
#import "DJTaskDistrViewController.h"
#import "DJMyTaskViewController.h"

#import "DJTaskTypeChooseView.h"
#import "DJMyAssignedTaskViewController.h"
@interface DJTaskMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * meunArray;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *
 */
@property (nonatomic, strong)DJTaskTypeChooseView * taskTypeChooseView;
@end

@implementation DJTaskMainViewController

- (NSMutableArray *)meunArray {
    if (!_meunArray) {
        _meunArray = [NSMutableArray array];
    }
    return _meunArray;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor  = [UIColor whiteColor];
    NSArray *tempArray = @[@{@"icon":@"DJ_task_release", @"title":@"发布任务"},@{@"icon":@"DJ_my_task", @"title":@"我的任务"},@{@"icon":@"DJ_my_assigned_task", @"title":@"我的交办"}];
    self.meunArray = [NSMutableArray arrayWithArray:tempArray];
    
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"任务管理";
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

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.meunArray[indexPath.row];
    [cell.showImageBtn setImage:[UIImage imageNamed:dataDic[@"icon"]] forState:(UIControlStateNormal)];
    cell.titleLabel.text = dataDic[@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            DJTaskDistrViewController *VC = [[DJTaskDistrViewController alloc] init];
            [self pushToNextViewController:VC];
        }
            break;
        case 1:{
            DJMyTaskViewController *VC =[[DJMyTaskViewController alloc] init];
            VC.tagState = @"";
            [self pushToNextViewController:VC];
        }
            break;
        case 2:{
            DJMyAssignedTaskViewController *VC =[[DJMyAssignedTaskViewController alloc] init];
            [self pushToNextViewController:VC];
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

-(void)dealloc {
        self.tableView.delegate = nil;
        self.tableView.dataSource = nil;
        self.defaultNavigationBarView = nil;
}
@end
