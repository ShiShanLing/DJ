//
//  DJTaskNoticeViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskNoticeViewController.h"
#import "DJTaskNoticeTableViewCell.h"
#import "DJNoticeTextModel.h"
#import "TaskPushMsgModel+CoreDataProperties.h"
#import "DJMyTaskDetailsViewController.h"
#import "DJMyTaskViewController.h"

@interface DJTaskNoticeViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong)UITableView *tableView;

/**
 *
 */
@property (nonatomic, strong)NSMutableArray * taskModelArray;
/**
 *
 */
@property (nonatomic, strong)UIBarButtonItem *releaseButtonItem;
@end

@implementation DJTaskNoticeViewController {
    
    NSInteger  pageIndex;//第多少页
    NSInteger totalNum;//数组总数量
}

- (NSMutableArray *)taskModelArray {
    if (!_taskModelArray) {
        _taskModelArray = [NSMutableArray array];
    }
    return  _taskModelArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self RequestTaskNotificationList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageIndex = 1;
    totalNum = 0;
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak  DJTaskNoticeViewController *serlWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [serlWeak.navigationController popViewControllerAnimated:YES];
    };
    
    UIButton *releaseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    releaseButton.frame = CGRectMake(10, 0, kFit(50), 50);
    
    [releaseButton setTitle:@"清空" forState:normal];
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:kFit(16)];
    [releaseButton setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
    UIEdgeInsets titleE  =  releaseButton.titleEdgeInsets;
    titleE.left -=10;
    releaseButton.titleEdgeInsets = titleE;
    [releaseButton addTarget:self action:@selector(handleQingEmptyMsg) forControlEvents:UIControlEventTouchUpInside];
    self.releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = self.releaseButtonItem;

    [self createTableView];
}

- (void)handleQingEmptyMsg {
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"清空列表" message:@"确认清空通知列表吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"我错了");
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.taskModelArray removeAllObjects];
        [self removeTaskMsgList];
    }];
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    [alertV addAction:cancle];
    [alertV addAction:confirm];
    // 4.控制器 展示弹框控件，完成时不做操作
    [self presentViewController:alertV animated:YES completion:^{
        nil;
    }];
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
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJTaskNoticeTableViewCell class] forCellReuseIdentifier:@"DJTaskNoticeTableViewCell"];
    [self.view addSubview:_tableView];
    
    [self AdditionalControls];
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dataEmptyView.promptLabel.text = @"暂无任务通知";
    self.dataEmptyView.dividerLabel.alpha =0;
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_rwtz_empty"];
    self.dataEmptyView.backgroundColor = kColorRGB(246, 246, 246, 1);
    self.dataEmptyView.alpha=0;
    [self.view addSubview:self.dataEmptyView];
    self.dataEmptyView.promptLabel.sd_layout.leftSpaceToView(self.dataEmptyView.emptyImageView, 0).rightSpaceToView(self.dataEmptyView.emptyImageView, 0).topSpaceToView(self.dataEmptyView.emptyImageView, kFit(145)).autoHeightRatio(0);
}
- (void)AdditionalControls {
    __weak  typeof(self) weakSelf = self;
    if (!_tableView.mj_header) {
        weakSelf.tableView.mj_header = [DJMJRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataWithMJType:@"header"];
        }];
    }
    if (!_tableView.mj_footer) {
        weakSelf.tableView.mj_footer = [DJMJRefreshGitFooter footerWithRefreshingBlock:^{
            [weakSelf loadDataWithMJType:@"footer"];
        }];
    }
    
    self.tableView.mj_footer.hidden = YES;
    
}

//刷新 或者加载判断
-(void)loadDataWithMJType:(NSString*)type {
    if ([type isEqualToString:@"header"]) {
        pageIndex = 1;
        
        [self RequestTaskNotificationList];
    }else{

        if ( self.taskModelArray.count < totalNum) {
            pageIndex++;
            [self RequestTaskNotificationList];
        }else{
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
}

-(void)RequestTaskNotificationList {
    [self showHud:@"" title:@""];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setObject:@"task" forKey:@"msgType"];
    [URL_Dic setObject:[NSString stringWithFormat:@"%ld", kEachPageRowNum * pageIndex] forKey:@"rows"];
    [URL_Dic setObject:@"1" forKey:@"page"];
    [self getJSONDataWithUrl:kURL_getPushMsgList parameters:URL_Dic success:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self hudDissmiss];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"responseObject%@", responseObject);
        
        
        
        
        if ([code isEqualToString:@"0"]) {
            [self parsingTaskNotificationList:responseObject];
        }else {
            [self  ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self hudDissmiss];
        NSLog(@"error%@", error);
    }];
}



- (void)parsingTaskNotificationList:(NSDictionary *)responseObject{
    [self.taskModelArray removeAllObjects];
    NSDictionary *listDic = responseObject[@"response"];
    NSString *totalNumStr =  listDic[@"totalNum"];
    totalNum = totalNumStr.integerValue;
    NSArray *msgListArrray = listDic[@"searchData"];
    
    if (![msgListArrray isKindOfClass:[NSArray class]]) {
        [self emptyInterfaceLayout:1];
        return;
    }
    
    if (msgListArrray.count == 0) {
        [self emptyInterfaceLayout:1];
        
        return;
    }
    
    [self emptyInterfaceLayout:0];
    for (NSDictionary *dataDic in msgListArrray) {
        NSLog(@"dataDic%@", dataDic);
        TaskPushMsgModel *msgModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskPushMsgModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in dataDic) {
            [msgModel setValue:dataDic[key] forKey:key];
        }
        [self.taskModelArray addObject:msgModel];
    }
 
    
    
    if (self.taskModelArray.count < totalNum) {
            self.tableView.mj_footer.alpha = 1.0;
        
    }else {
        self.tableView.mj_footer.alpha = 0.0;
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }
    [self.tableView reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskModelArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJTaskNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskNoticeTableViewCell" forIndexPath:indexPath];
    TaskPushMsgModel *model =  self.taskModelArray[indexPath.row];
    cell.textModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskPushMsgModel *model = self.taskModelArray[indexPath.row];
    if (model.taskId.length == 0) {
        DJMyTaskViewController *VC = [[DJMyTaskViewController alloc] init];
        [self pushToNextViewController:VC];
    }else {
        DJMyTaskDetailsViewController *VC = [[DJMyTaskDetailsViewController alloc] init];
        VC.orgModel = [self  getDefaultOrg];
        VC.animationType = @"";
        VC.taskId = model.taskId;
        [self pushToNextViewController:VC];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskPushMsgModel *model = self.taskModelArray[indexPath.row];
    CGFloat  height = [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"textModel" cellClass:[DJTaskNoticeTableViewCell class] contentViewWidth:kScreenWidth];
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


//0加载成功并有数据 1加载成功并没有数据 2加载失败
- (void)emptyInterfaceLayout:(NSInteger)type {
    switch (type) {
        case 0:
            self.dataEmptyView.alpha = 0;
            self.tableView.bounces = YES;
            self.tableView.mj_footer.hidden = NO;
            self.releaseButtonItem.customView.hidden = NO;
            break;
        case 1:
            self.tableView.mj_footer.hidden = YES;
            self.tableView.bounces = NO;
            self.releaseButtonItem.customView.hidden = YES;
            self.dataEmptyView.alpha = 1.0;
            self.dataEmptyView.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            break;
        case 2:
            
            break;
    
        default:
            break;
    }
    
}

- (void)removeTaskMsgList {
    [self showHud:@"" title:@""];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setObject:@"task" forKey:@"msgType"];
    [self getJSONDataWithUrl:kURL_emptyMsgList parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        [self  ShowWarningHudMid:responseObject[@"msg"]];
        [self emptyInterfaceLayout:1];
        [self.tableView removeFromSuperview];
    } failure:^(NSError *error) {
        [self hudDissmiss];
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
