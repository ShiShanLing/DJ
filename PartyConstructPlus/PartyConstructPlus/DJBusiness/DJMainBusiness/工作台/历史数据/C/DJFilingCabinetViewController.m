//
//  DJFilingCabinetViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/21.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJFilingCabinetViewController.h"

#import "MsgView.h"
#import "ConfigurableIconVIew.h"
#import "DJdjDutyFunctionTVCell.h"
#import "DJFilingCabinetOrgChooseView.h"

#import "DJDAWDJBViewController.h"
#import "DJWDRWViewController.h"
#import "DJXSLViewController.h"
@interface DJFilingCabinetViewController ()<UITableViewDelegate, UITableViewDataSource>

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
@property (nonatomic, strong)NSMutableArray * orgArray;
@end

@implementation DJFilingCabinetViewController
- (NSMutableArray *)meunArray {
    if (!_meunArray) {
        _meunArray = [NSMutableArray array];
    }
    return _meunArray;
}

- (NSMutableArray *)orgArray {
    if (!_orgArray) {
        _orgArray = [NSMutableArray array];
    }
    return _orgArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = [UIColor whiteColor];
    NSArray *tempArray = @[@{@"icon":@"DJ_wdrwda", @"title":@"历史任务"},@{@"icon":@"DJ_wdjbda", @"title":@"历史交办任务"},@{@"icon":@"DJ_xslda", @"title":@"历史工作行事历"}];
    self.meunArray = [NSMutableArray arrayWithArray:tempArray];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    self.defaultNavigationBarView.titleLabel.text = @"历史数据";
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    self.defaultNavigationBarView.rightBtn.hidden= YES;
    
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.defaultNavigationBarView];

    [self requestHasLeftTheOrganization];
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

- (void)requestHasLeftTheOrganization {
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:@"n" forKey:@"status"];
    [self showHud:@"" title:@""];
    [self getJSONDataWithUrl:kURL_queryAllOrg parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"历史的组织%@", responseObject);
        if ([code isEqualToString:@"0"]) {
            [self parsingHasLeftTheOrganization:responseObject];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self hudDissmiss];
        NSLog(@"error%@", error);
    }];
    
}
//解析数据
- (void)parsingHasLeftTheOrganization:(NSDictionary *)dic {
    NSArray *orgArray = dic[@"response"];
        
    if (![orgArray isKindOfClass:[NSArray class]]) {
        self.dataEmptyView.hidden = NO;
        return;
    }
    
    if (orgArray.count == 0) {
        self.dataEmptyView.hidden = NO;
        return;
    }
    
    self.dataEmptyView.hidden = YES;
    _tableView.hidden = NO;
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSDictionary *dataDic in orgArray) {
        OrgInfoModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"OrgInfoModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in dataDic) {
            [model setValue:dataDic[key] forKey:key];
        }
        [modelArray addObject:model];
    }
    self.orgArray = [NSMutableArray arrayWithArray:modelArray];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJdjDutyFunctionTVCell class] forCellReuseIdentifier:@"DJdjDutyFunctionTVCell"];
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight)];
    self.dataEmptyView.promptLabel.text = @"您可在此查看历史组织数据\n当前暂无档案数据";
    self.dataEmptyView.hidden = YES;
    self.dataEmptyView.dividerLabel.hidden = YES;
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_task_empty_white"];
    [self.view addSubview:self.dataEmptyView];
    
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
    [cell ChangeLayout];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            DJWDRWViewController *VC = [[DJWDRWViewController alloc] init];
            VC.orgListArray = self.orgArray;
            [self pushToNextViewController:VC];
        }
            break;
        case 1:{
            DJDAWDJBViewController *VC = [[DJDAWDJBViewController alloc] init];
            VC.orgListArray = self.orgArray;
            [self pushToNextViewController:VC];
        }
            break;
        case 2:{
            DJXSLViewController *VC = [[DJXSLViewController alloc] init];
            VC.orgListArray = self.orgArray;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
