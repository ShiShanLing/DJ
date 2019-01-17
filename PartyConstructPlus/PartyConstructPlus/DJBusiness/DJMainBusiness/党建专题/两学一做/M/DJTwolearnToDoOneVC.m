//
//  DJTwolearnToDoOneVC.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/22.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTwolearnToDoOneVC.h"
#import "DJdjDutyFunctionTVCell.h"
#import "DJMyReadingViewController.h"
#import "DJTaskTwoLearnOneDoViewController.h"
@interface DJTwolearnToDoOneVC ()<UITableViewDelegate, UITableViewDataSource>

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
@end

@implementation DJTwolearnToDoOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    NSArray *tempArray = @[@{@"icon":@"DJ_xxdzdg", @"title":@"我的阅读"},@{@"icon":@"DJ_zhgdy", @"title":@"我的任务"}];
    self.meunArray = [NSMutableArray arrayWithArray:tempArray];
    
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"两学一做";
    self.defaultNavigationBarView.rightBtn.hidden= YES;
    
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    [self createTableView];
}
- (void)handleReturnBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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




- (void)createTableView {
    
    self.tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStylePlain)];
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
        case 0: {
            DJMyReadingViewController *VC= [[DJMyReadingViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 1: {
            
            NSMutableArray  *meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
            
            if (meunArray.count == 0) {
                [self  ShowWarningHudMid:@"您不属于任何组织, 无法使用本功能哦!"];
                return;
            }else {
                if ([self  getDefaultOrg] == nil ) {
                    return;
                }
            }
            
            DJTaskTwoLearnOneDoViewController *VC = [[DJTaskTwoLearnOneDoViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
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
