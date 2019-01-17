//
//  DJMyNoticeViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMyNoticeViewController.h"
#import "DJNoticePromptTVCell.h"
#import "DJTaskNoticeViewController.h"
#import "DJSystemNoticeViewController.h"
#import "TaskPushMsgModel+CoreDataProperties.h"

@interface DJMyNoticeViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong)UITableView *tableView;

/**
 *
 */
@property (nonatomic, strong)NSMutableDictionary * taskPushDic;
/**
 *
 */
@property (nonatomic, strong)NSMutableDictionary * systemPushDic;
@end

@implementation DJMyNoticeViewController


- (NSMutableDictionary *)systemPushDic {
    if (!_systemPushDic) {
        _systemPushDic = [NSMutableDictionary dictionary];
    }
    return _systemPushDic;
}

- (NSMutableDictionary *)taskPushDic {
    if (!_taskPushDic) {
        _taskPushDic = [NSMutableDictionary dictionary];
    }
    return _taskPushDic;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getLatestNew];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的通知";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak  DJMyNoticeViewController *weakSelf = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[DJNoticePromptTVCell class] forCellReuseIdentifier:@"DJNoticePromptTVCell"];
    [self.view addSubview:_tableView];

}

- (void)getLatestNew {
    [self showHud:@"" title:@""];
    [self getJSONDataWithUrl:kURL_GetNewPushContent parameters:nil success:^(id responseObject) {
        [self hudDissmiss];
        NSLog(@"responseObject%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if (![code isEqualToString:@"0"]) {
            [self ShowWarningHudMid:responseObject[@"msg"]];
            return ;
        }
        NSDictionary *msgDic = responseObject[@"response"];
        if ([msgDic isKindOfClass:[NSDictionary class]]) {
            NSDictionary *taskDic  = msgDic[@"task"];
            self.taskPushDic = [NSMutableDictionary dictionaryWithDictionary:taskDic];
            NSDictionary *systemDic  = msgDic[@"system"];
            self.systemPushDic = [NSMutableDictionary dictionaryWithDictionary:systemDic];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
    //TaskPushMsgModel
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *dataArray = @[@{@"title":@"任务通知", @"icon":@"DJTaskNotice", @"subTitle":@""}, @{@"title":@"系统通知", @"icon":@"DJSystemNotice", @"subTitle":@""},];
    DJNoticePromptTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJNoticePromptTVCell" forIndexPath:indexPath];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.redPointLabel.alpha = 0.0;
    NSDictionary *dataDic = dataArray[indexPath.row];
    cell.titleLabel.text = dataDic[@"title"];
    [cell.iconBtn setImage:[UIImage imageNamed:dataDic[@"icon"]] forState:(UIControlStateNormal)];
    if (indexPath.row == 0) {
        if ([CommonUtil isBlankDictionary:self.taskPushDic]) {
            cell.subtitleLabel.text = @"暂无通知";
            cell.timetLabel.text = @"";
        }else {
            cell.subtitleLabel.text  =  self.taskPushDic[@"content"];
            NSString *updateTime  =self.taskPushDic[@"updateTime"];
            NSDate *updateDate = [CommonUtil getDateForString:updateTime format:@"yyyy-MM-dd HH:mm:ss"];
            NSString *tempStr =   [CommonUtil getTimeDiff:updateDate];
            NSLog(@"tempStr%@ updateDate%@", tempStr, updateDate);
            cell.timetLabel.text = tempStr;
        }
    }else {
        
        
        if ( [CommonUtil isBlankDictionary:self.systemPushDic]) {
            cell.subtitleLabel.text = @"暂无通知";
            cell.timetLabel.text = @"";
        }else {
            NSString *updateTime  =self.systemPushDic[@"updateTime"];
            
            NSDate *updateDate = [CommonUtil getDateForString:updateTime format:@"yyyy-MM-dd HH:mm:ss"];
            NSString *tempStr =   [CommonUtil getTimeDiff:updateDate];
            NSLog(@"tempStr%@ updateDate%@", tempStr, updateDate);
            cell.timetLabel.text = tempStr;
            cell.subtitleLabel.text  =  self.systemPushDic[@"content"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        DJTaskNoticeViewController *VC = [[DJTaskNoticeViewController alloc] init];
        VC.navigationItem.title = @"任务通知";
        [self pushToNextViewController:VC];
    }else {
        
        DJSystemNoticeViewController *VC = [[DJSystemNoticeViewController alloc] init];
        VC.navigationItem.title = @"系统通知";
        [self  pushToNextViewController:VC];
        
//        [self showHud:@"系统正在自动为您切换至【组织名称组织名称】..." title:@"更换组织"];
//        [self hudDissmiss];
//        [self ShowWarningHudMid:@"切换成功"];
//        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFit(70);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
