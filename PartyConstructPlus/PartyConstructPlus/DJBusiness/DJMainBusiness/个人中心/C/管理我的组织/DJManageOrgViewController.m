//
//  DJManageOrgViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJManageOrgViewController.h"
#import "DJJoinOrgViewController.h"
#import "DJLeaveOrgViewController.h"
#import "DJChangeOrgViewController.h"
@interface DJManageOrgViewController ()<UITableViewDelegate, UITableViewDataSource>

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

@implementation DJManageOrgViewController


- (NSMutableArray *)meunArray {
    if (!_meunArray) {
        _meunArray = [NSMutableArray array];
    }
    return _meunArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    __weak DJManageOrgViewController * selfWeak = self;
    [self refreshUserInfo:^(BOOL results) {
        [selfWeak.tableView reloadData];
        
    }];
    [selfWeak getUserInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"管理我的组织";
    
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"管理我的组织";
    self.defaultNavigationBarView.rightBtn.hidden= YES;
    
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    
    
    [self createTableView];
}

- (void)handleReturnBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)getUserInfo {
    
    NSArray *tempArray = @[@{@"icon":@"DJJoinOrg", @"title":@"加入新组织"},@{@"icon":@"DJExitOrg", @"title":@"离开现组织"},@{@"icon":@"DJChangeOrg", @"title":@"变更组织"}];
        self.meunArray = [NSMutableArray arrayWithArray:tempArray];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak  DJManageOrgViewController *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.scrollEnabled = NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meunArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.meunArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dataDic[@"icon"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = dataDic[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            DJJoinOrgViewController *VC = [[DJJoinOrgViewController alloc] init];
            [self pushToNextViewController:VC];
        }
            break;
        case 1:{
            DJLeaveOrgViewController *VC = [[DJLeaveOrgViewController alloc] init];
            [self pushToNextViewController:VC];
        }
            break;
        case 2:{
            DJChangeOrgViewController *VC = [[DJChangeOrgViewController alloc] init];
            [self pushToNextViewController:VC];
        }
            break;
            
        default:
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFit(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kFit(45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kFit(45);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(45))];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFit(15), kFit(17), 200, kFit(17))];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"我要";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(17)];
    [headView addSubview:titleLabel];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(45))];

    UIButton *doubtBtn  = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [doubtBtn setTitle:@"这三种类型有何区别？" forState:(UIControlStateNormal)];
    [doubtBtn setTitleColor:kColorRGB(89, 135, 198, 1) forState:(UIControlStateNormal)];
    doubtBtn.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(14)];
    doubtBtn.frame = CGRectMake(0, 0, kScreenWidth, kFit(45));
    [doubtBtn addTarget:self action:@selector(handledoubtBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:doubtBtn];
    return footerView;
    
}
- (void)handledoubtBtn {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"业务说明" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //如果你的系统大于等于7.0
    UIView *subView1 = alert.view.subviews[0];
    UIView *subView2 = subView1.subviews[0];
    UIView *subView3 = subView2.subviews[0];
    UIView *subView4 = subView3.subviews[0];
    UIView *subView5 = subView4.subviews[0];
    UILabel * messageLabel = subView5.subviews[1];
    messageLabel.textAlignment=0;
    messageLabel.textColor = kColorRGB(51, 51, 51, 1);
    messageLabel.text=@"1.加入新组织满足用户同时在多个组织任职的需求，对用户加入新组织前的状态无影响\n \n2.离开现组织适用于用户从现有组织离岗且暂不加入其它任务组织的场景\n \n3.变更组织适用于用户从一个组织调职到新组织的情况";
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
  
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
