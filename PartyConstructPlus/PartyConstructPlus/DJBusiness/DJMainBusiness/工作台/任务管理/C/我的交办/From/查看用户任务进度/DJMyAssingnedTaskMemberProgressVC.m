//
//  DJMyAssingnedTaskMemberProgressVC.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMyAssingnedTaskMemberProgressVC.h"
#import "DJMyTaskProgressTableViewCell.h"
#import "DJTaskApprovalTableViewCell.h"
#import "ChangeColourView.h"
#import "DJTaskEvaluationTableViewCell.h"
#import "UserData.h"

@interface DJMyAssingnedTaskMemberProgressVC ()<UITableViewDelegate, UITableViewDataSource, ChangeColourViewDelegate, DJTaskApprovalTableViewCellDelegate, DJTaskEvaluationTableViewCellDelegate>

@property (nonatomic, strong)UITableView *tableView;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * taskStepArray;

@end

@implementation DJMyAssingnedTaskMemberProgressVC {
    ChangeColourView *footerView;
    DJTaskApprovalTableViewCell *approvalCell;
    BOOL isAgreeApply;//是否同意申请
    NSString *approvalStr;
    CGFloat  evaluationCellHeight;
    NSInteger scoreNum;
}
- (NSMutableArray *)taskStepArray {
    if (!_taskStepArray) {
        _taskStepArray = [NSMutableArray array];
    }
    return _taskStepArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    isAgreeApply = NO;
    approvalStr =@"";
    evaluationCellHeight = kFit(176);
    [self.navigationController setNavigationBarHidden:YES];
    [self requestTaskStep];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    scoreNum = 0;
    // Do any additional setup after loading the view.
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"任务进度";
    self.defaultNavigationBarView.rightBtn.hidden= YES;
    
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    [self createTableView];
    
}
- (void)handleReturnBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//请求
- (void)requestTaskStep {
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.taskDetailsModel.taskId forKey:@"id"];
    NSLog(@"URL_Dic%@", URL_Dic);
    [self showHud:@"" title:@""];
    [self  getJSONDataWithUrl:kURL_queryTaskStep parameters:URL_Dic success:^(id responseObject) {
        [self  hudDissmiss];
        
        NSLog(@"kURL_queryTaskStep%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self parsingTaskStep:responseObject];
        }else {
            [self  ShowWarningHudMid:responseObject[@"msg"]];
        }
        NSLog(@"requestTaskStep%@", responseObject);
    } failure:^(NSError *error) {
        [self  hudDissmiss];
        NSLog(@"error%@", error);
    }];
}

- (void)parsingTaskStep:(NSDictionary *)dataDic {
    [self.taskStepArray removeAllObjects];
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *dataArray = dataDic[@"response"];
    if (![dataArray isKindOfClass:[NSArray class]]) {
        return;
    }
    if (dataArray.count == 0) {
        if ([_taskDetailsModel.status isEqualToString:@"time_out"]) {//如果该状态为申诉待审核
            TaskStepModel *undoModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            undoModel.status= @"time_out_no";
            undoModel.createTime = _taskDetailsModel.endDate;
            undoModel.content = @"";
            [self.taskStepArray insertObject:undoModel atIndex:0];
            [self submitTaskTimeout];
        }else {
            TaskStepModel *tempModel2  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            tempModel2.status= @"undo_no";
            tempModel2.createTime = self.taskDetailsModel.startDate;
            tempModel2.content = @"待完成";
            [self.taskStepArray addObject:tempModel2];
        }
        
            TaskStepModel *tempModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            tempModel.status= @"default_no";
            tempModel.createTime = self.taskDetailsModel.createTime;
            UserData *userModel  =[DJUserTool getUserInfo];
            tempModel.content =userModel.name;
            [self.taskStepArray addObject:tempModel];
        
    }else {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *modelDic in dataArray) {
            TaskStepModel *model  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            for (NSString *key in modelDic) {
                [model setValue:modelDic[key] forKey:key];
            }
            [tempArray addObject:model];
        }
        self.taskStepArray = [NSMutableArray arrayWithArray:tempArray];
        TaskStepModel *defaultModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        defaultModel.status= @"default_no";
        defaultModel.createTime = self.taskDetailsModel.createTime;
        UserData *userModel  =[DJUserTool getUserInfo];
        defaultModel.content =userModel.name;
        [self.taskStepArray addObject:defaultModel];
        
        TaskStepModel *tempModel = self.taskStepArray[0];
        if ([tempModel.status isEqualToString:@"appeal_no"]) {
            TaskStepModel *waiting_fill_doModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            waiting_fill_doModel.status= @"waiting_fill_do_no";
            waiting_fill_doModel.createTime = @"";
            waiting_fill_doModel.content = @"";
            [self.taskStepArray insertObject:waiting_fill_doModel atIndex:0];
        }
        if ([tempModel.status isEqualToString:@"leave_no"]) {
            TaskStepModel *undoModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            undoModel.status= @"secondUndo_no";
            undoModel.createTime = @"";
            undoModel.content = @"";
            [self.taskStepArray insertObject:undoModel atIndex:0];
        }
        if ([tempModel.status isEqualToString:@"leaveing"]) {//如果该状态为请假待审核
            TaskStepModel *undoModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            undoModel.status= @"leaveing_show";
            undoModel.createTime = @"";
            undoModel.content = @"";
            [self.taskStepArray insertObject:undoModel atIndex:0];
        }
        if ([tempModel.status isEqualToString:@"appealing"]) {//如果该状态为申诉待审核
            TaskStepModel *undoModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
            undoModel.status= @"appealing_show";
            undoModel.createTime = @"";
            undoModel.content = @"";
            [self.taskStepArray insertObject:undoModel atIndex:0];
        }

        
        if ([tempModel.status isEqualToString:@"appeal_yes"] || [tempModel.status isEqualToString:@"appealing"] || [tempModel.status isEqualToString:@"appeal_no"] || [tempModel.status isEqualToString:@"timeout_complete"]|| [tempModel.status isEqualToString:@"eva"]) {
            for (int i = 0; i < self.taskStepArray.count; i ++) {//遍历数组把数据里面的超时变为历史超时
                TaskStepModel *model = self.taskStepArray[i];
                if ([model.status isEqualToString:@"time_out"]) {
                    model.status = @"time_out_no";
                    self.taskStepArray[i] = model;
                }
            }
        }
        if ([_taskDetailsModel.status isEqualToString:@"time_out"]) {//如果该状态为超时状态
            TaskStepModel *lowModel = self.taskStepArray[0];//取出下标为 0 的状态
            NSLog(@"lowModel%@ self.taskStepArray%@", lowModel, self.taskStepArray);
            if ([lowModel.status isEqualToString:@"waiting_fill_do_no"]) {
                
            }else if ([lowModel.status isEqualToString:@"time_out"]) {
                //如果这个状态为超时  或者 waiting_fill_do(申诉未通过的待补办) 不做处理
                lowModel.status = @"time_out_no";
                self.taskStepArray[0]  = lowModel;
            }else {
                //否者 任务状态为 超时  而且 任务步骤的最后一步不是 超时,,而且不是 申诉未通过待补办   那么就手动往数据里面添加一条 用来显示
                //同时请求添加一天 超时数据
                TaskStepModel *undoModel  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskStepModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
                undoModel.status= @"time_out_no";
                undoModel.createTime = _taskDetailsModel.endDate;
                undoModel.content = @"";
                [self.taskStepArray insertObject:undoModel atIndex:0];
                [self submitTaskTimeout];
            }
        }
        
    }
    NSLog(@"self.taskStepArray%@", self.taskStepArray);
    [self.tableView reloadData];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = kColorRGB(246, 246, 246, 1);
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces  = NO;
    [_tableView registerClass:[DJMyTaskProgressTableViewCell class] forCellReuseIdentifier:@"DJMyTaskProgressTableViewCell"];
    [_tableView registerClass:[DJTaskApprovalTableViewCell class] forCellReuseIdentifier:@"DJTaskApprovalTableViewCell"];
    [_tableView registerClass:[DJTaskEvaluationTableViewCell class] forCellReuseIdentifier:@"DJTaskEvaluationTableViewCell"];
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([_taskDetailsModel.status isEqualToString:@"leaveing"]||[_taskDetailsModel.status isEqualToString:@"appealing"]||[_taskDetailsModel.status isEqualToString:@"complete"]||[_taskDetailsModel.status isEqualToString:@"timeout_complete"]) {
        if (self.taskStepArray.count == 0) {
            return 0;
        }else {
            TaskStepModel *lowModel = self.taskStepArray[0];
            if ([lowModel.status isEqualToString:@"eva"]) {
                return 1;
            }else {
                return 2;
            }
        }
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.taskStepArray.count;
    }else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DJMyTaskProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJMyTaskProgressTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TaskStepModel *model = self.taskStepArray[indexPath.row];
        [cell configControls:indexPath modelArray:self.taskStepArray];
        cell.sendUserName = [DJUserTool getUserName];
        cell.model = model;
        
        return cell;
    }else {
        if ([_taskDetailsModel.status isEqualToString:@"complete"]||[_taskDetailsModel.status isEqualToString:@"timeout_complete"]) {
            DJTaskEvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskEvaluationTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }else {
            DJTaskApprovalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskApprovalTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            if ([self.taskDetailsModel.status isEqualToString:@"leaveing"]) {
                    cell.titleLabel.text = @"同意请假申请";
               
            }else  if([self.taskDetailsModel.status isEqualToString:@"appealing"]){
                
                    cell.titleLabel.text = @"同意申诉申请";
            }
            approvalCell = cell;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [approvalCell.contentTV resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TaskStepModel *model = self.taskStepArray[indexPath.row];
        NSLog(@"此时这个cell的高度%f", [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DJMyTaskProgressTableViewCell class] contentViewWidth:kScreenWidth]);
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DJMyTaskProgressTableViewCell class] contentViewWidth:kScreenWidth];
    }else {
        if ([_taskDetailsModel.status isEqualToString:@"complete"]||[_taskDetailsModel.status isEqualToString:@"timeout_complete"]) {
            
            return  evaluationCellHeight;
            
        }else {
            return kFit(145);
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return kFit(5);
    }else {
        return 0.01;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return kFit(85);
    }else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.01;
    if (section == 1) {
        height = kFit(5);
    }else {
        height = 0.01;
    }
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    headView.backgroundColor = kColorRGB(246, 246, 246, 1);
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat height = 0.01;
    if (section == 1) {
        height = kFit(85);
    }else {
        height = 0.01;
    }
    if (section == 0) {
        UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
        return footerView;
    }else {
        footerView  = [[ChangeColourView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(85))];
        footerView.delegate = self;
        footerView.backgroundColor = kColorRGB(246, 246, 246, 1);

        if ([_taskDetailsModel.status isEqualToString:@"complete"]||[_taskDetailsModel.status isEqualToString:@"timeout_complete"]) {
            if (scoreNum!=0) {
                footerView.ContinueBtn.userInteractionEnabled = YES;
                footerView.gradientLayer.hidden = NO;
            }else {
                footerView.ContinueBtn.userInteractionEnabled = NO;
                footerView.gradientLayer.hidden = YES;
            }
            [footerView.ContinueBtn setTitle:@"提交评价" forState:(UIControlStateNormal)];
        }else {
            footerView.ContinueBtn.userInteractionEnabled = YES;
            footerView.gradientLayer.hidden = NO;
            [footerView.ContinueBtn setTitle:@"提交" forState:(UIControlStateNormal)];
        }
        return footerView;
    }
}

- (void)handleExitOrg {
        footerView.ContinueBtn.userInteractionEnabled = NO;
        NSMutableDictionary * URL_Dic = [NSMutableDictionary dictionary];
        [URL_Dic setValue:self.taskDetailsModel.taskId forKey:@"id"];
        [URL_Dic setValue:approvalStr forKey:@"content"];
        [URL_Dic setValue:@"" forKey:@"img"];
    NSString *newState = @"";
    if ([_taskDetailsModel.status isEqualToString:@"leaveing"]) {
        if (isAgreeApply) {
            newState = @"leave_yes";
            [URL_Dic setValue:@"leave_yes" forKey:@"status"];
        }else {
            newState = @"leave_no";
            [URL_Dic setValue:@"leave_no" forKey:@"status"];
        }
        [URL_Dic setValue:@"" forKey:@"evaRank"];
        
    }else if([_taskDetailsModel.status isEqualToString:@"appealing"]){
        if (isAgreeApply) {
            newState = @"appeal_yes";
            [URL_Dic setValue:@"appeal_yes" forKey:@"status"];
        }else {
            newState = @"appeal_no";
            [URL_Dic setValue:@"appeal_no" forKey:@"status"];
        }
        [URL_Dic setValue:@"" forKey:@"evaRank"];
    }else if([_taskDetailsModel.status isEqualToString:@"complete"] || [_taskDetailsModel.status isEqualToString:@"timeout_complete"]){
            [URL_Dic setValue:@"eva" forKey:@"status"];
        newState = @"eva";
        if (scoreNum == 0) {
            [self ShowWarningHudMid:@"请先选择评价星级"];
            return;
        }
        
        [URL_Dic setValue:[NSString stringWithFormat:@"%ld", scoreNum] forKey:@"evaRank"];
    }
        [URL_Dic setValue:self.taskDetailsModel.status forKey:@"oldStatus"];
    
        [self getJSONDataWithUrl:kURL_performMyReceivedTask parameters:URL_Dic success:^(id responseObject) {
            footerView.ContinueBtn.userInteractionEnabled = YES;
            NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
            if ([code isEqualToString:@"0"]) {
                self.taskDetailsModel.status = newState;
                [self requestTaskStep];
            }
            [self ShowWarningHudMid:responseObject[@"msg"]];
            NSLog(@"responseObject%@", responseObject);
        } failure:^(NSError *error) {
            
        }];
}

- (void)setTaskDetailsModel:(IReceivedTaskModel *)taskDetailsModel {
    _taskDetailsModel = taskDetailsModel;
    [_tableView reloadData];
}

#pragma mark DJTaskApprovalTableViewCellDelegate
- (void)taskContentChange:(NSString *)str {
    approvalStr = str;
}
- (void)isAgreeApply:(BOOL)type {
    isAgreeApply = type;
}

- (void)EvaluationContentChange:(NSString *)str{
    
    approvalStr = str;
}

/**
 界面样式发生改变
 
 @param index  1-5 变高 0 变低 但是这个方法只要调用 基本不可能是0了
 */
- (void)InterfaceStyle:(NSInteger)index {
    evaluationCellHeight = kFit(231.5);
    scoreNum = index;
    [self.tableView reloadData];
}
//提交任务超时
- (void)submitTaskTimeout {
    
    NSMutableDictionary * URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.taskDetailsModel.currentTaskId forKey:@"id"];
    [URL_Dic setValue:@"" forKey:@"content"];
    [URL_Dic setValue:@"" forKey:@"img"];
    [URL_Dic setValue:@"time_out" forKey:@"status"];
    [URL_Dic setValue:self.taskDetailsModel.status forKey:@"oldStatus"];
    [self getJSONDataWithUrl:kURL_performMyReceivedTask parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            
        }
        [self ShowWarningHudMid:responseObject[@"msg"]];
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSError *error) {
        
    }];
}
-(void)dealloc {
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
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
