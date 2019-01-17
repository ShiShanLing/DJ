//
//  DJTaskPerFormViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/12.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskPerFormViewController.h"
#import "DJTaskContentEditorTableViewCell.h"
#import "DJTaskDistrImageChooseTVCell.h"
#import "DJPhotosChooseViewController.h"
#import "ChangeColourView.h"

#import <IQKeyboardManager.h>

#import "DJTaskDistChooseImageTableViewCell.h"

#import "DJImageUploadModel.h"

@interface DJTaskPerFormViewController ()<UITableViewDelegate, UITableViewDataSource, DJTaskContentEditorTableViewCellCellDelegate, DJTaskDistrImageChooseTVCellDelegate, ChangeColourViewDelegate, DJTaskDistChooseImageTableViewCellDelegate>


@property (nonatomic, strong)UITableView *tableView;

/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 已经选择的图片
 */
@property (nonatomic, strong)NSMutableArray *taskImageArray;


/**
 *
 */
@property (nonatomic, strong)DJTaskContentEditorTableViewCell * taskPerformContentCell;

/**
 提交评论的按钮
 */
@property (nonatomic, strong)ChangeColourView *confirmBtn;
@end

@implementation DJTaskPerFormViewController {
    NSString *taskContentStr;//任务内容
    CGFloat   taskContentAddHeight;
    BOOL isSubmitComment;//是否提交评论
    DJTaskDistChooseImageTableViewCell *imageShowCell;
}

- (NSMutableArray *)taskImageArray {
    if (!_taskImageArray) {
        _taskImageArray = [NSMutableArray array];
    }
    return _taskImageArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[IQKeyboardManager sharedManager] setEnable:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTakingPictures:) name:@"TakingPictures" object:nil];
    isSubmitComment = NO;
    taskContentStr = @"";
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];

    switch (self.taskOperationType) {
        case DJTaskOperationTypePerform:
            _defaultNavigationBarView.titleLabel.text = @"任务执行";
            break;
        case DJTaskOperationTypeAskLeave:
            _defaultNavigationBarView.titleLabel.text = @"任务请假";
            break;
        case  DJTaskOperationTypeFillDo:
            _defaultNavigationBarView.titleLabel.text = @"任务补办";
            break;
        case DJTaskOperationTypeComplaint:
            _defaultNavigationBarView.titleLabel.text = @"任务申诉";
            break;
        case DJTaskOperationTypeComments:
            _defaultNavigationBarView.titleLabel.text = @"任务评论";
            self.defaultNavigationBarView.rightBtn.hidden = YES;
            break;
            
        default:
            break;
    }
    [self.defaultNavigationBarView.rightBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(174, 174, 174, 1) forState:(UIControlStateNormal)];
    self.defaultNavigationBarView.rightBtn.userInteractionEnabled = NO;
    [self.defaultNavigationBarView.rightBtn  addTarget:self action:@selector(handleCompleteBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    [self createTableView];
    
    
}
//提交执行操作
- (void)handleCompleteBtn {
    
    [self showHud:@"" title:@""];
      [_taskPerformContentCell.taskContentTV resignFirstResponder];
    switch (self.taskOperationType) {
        case DJTaskOperationTypePerform:
            [self requestMyTaskDetails];
            break;
        case DJTaskOperationTypeAskLeave:
            [self requestMyTaskDetails];
            break;
        case DJTaskOperationTypeFillDo:{
            [self submitTaskFillDo];
        }
            break;
        case DJTaskOperationTypeComplaint:
            [self submitTaskComplaint];
            break;
        case DJTaskOperationTypeComments:
            
            break;
            
        default:
            break;
    }
}
//返回上一界面
- (void)handleReturnBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = kColorRGB(246, 246, 246, 1);
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [_tableView registerClass:[DJTaskContentEditorTableViewCell class] forCellReuseIdentifier:@"DJTaskContentEditorTableViewCell"];
        [_tableView registerClass:[DJTaskDistChooseImageTableViewCell class] forCellReuseIdentifier:@"DJTaskDistChooseImageTableViewCell"];
    [self.view addSubview:_tableView];
    

}
- (void)handleHideKeyboard {
      [_taskPerformContentCell.taskContentTV resignFirstResponder];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
 
    if (self.taskOperationType == DJTaskOperationTypePerform || self.taskOperationType == DJTaskOperationTypeFillDo) {
        return 2;
    }else {
        return 1;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0 &&indexPath.section == 0){
        DJTaskContentEditorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskContentEditorTableViewCell" forIndexPath:indexPath];
        switch (self.taskOperationType) {
            case DJTaskOperationTypePerform:
                if (taskContentStr.length == 0) {
                    cell.promptCopywriting = @"请在此输入执行内容";
                }else {
                    
                }
                
                break;
            case DJTaskOperationTypeAskLeave:
                if (taskContentStr.length == 0) {
                    cell.promptCopywriting = @"请在此输入请假内容";
                }else {
                    
                }
                
                break;
            case  DJTaskOperationTypeFillDo:
                if (taskContentStr.length == 0) {
                    cell.promptCopywriting = @"请在此输入补办内容";
                }else {
                    
                }
                
                break;
            case DJTaskOperationTypeComplaint:
                if (taskContentStr.length == 0) {
                    cell.promptCopywriting = @"请在此输入申诉内容";
                }else {
                    
                }
                
                break;
            case DJTaskOperationTypeComments:
                if (taskContentStr.length == 0) {
                    cell.promptCopywriting = @"请在此输入评论内容";
                }else {
                    
                }
                
                break;
                
            default:
                break;
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _taskPerformContentCell = cell;
        return cell;
    }else if(indexPath.row == 1&&indexPath.section == 0){
        DJTaskDistChooseImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskDistChooseImageTableViewCell" forIndexPath:indexPath];
        [cell viewRenderingShowImageArray:self.taskImageArray];
        cell.delegate = self;
        imageShowCell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:isSubmitComment?@"DJ_taskPerformAndComments_yes":@"DJ_taskPerformAndComments_no"];
        cell.textLabel.text = @"同时发布到评论";
        cell.textLabel.textColor = kColorRGB(173, 173, 173, 1);
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0 &&indexPath.section == 0){ }else if(indexPath.row == 1&&indexPath.section == 0){ }else{
        isSubmitComment = !isSubmitComment;
        [self.tableView reloadData];
    }
    
    [_taskPerformContentCell.taskContentTV resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 &&indexPath.section == 0) {
        return 110;
    }else if(indexPath.row == 1&&indexPath.section == 0){
        return  175;
    }else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    
    if (section == 0) {
        if (self.taskOperationType == DJTaskOperationTypePerform || self.taskOperationType == DJTaskOperationTypeFillDo) {
            return kFit(5);
        }else if(self.taskOperationType == DJTaskOperationTypeComments){
            return  kFit(85);
        }else {
            return 0.01 ;
        }
    }else {
        return  0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat  height = 0.0;
    if (self.taskOperationType == DJTaskOperationTypePerform || self.taskOperationType == DJTaskOperationTypeFillDo) {
        height = kFit(5);
    }else if(self.taskOperationType == DJTaskOperationTypeComments){
        height =  kFit(85);
    }else {
        height = 0.01 ;
    }
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    footerView.backgroundColor = kColorRGB(246, 246, 246, 1);
    
    if(self.taskOperationType == DJTaskOperationTypeComments){
        self.confirmBtn = [[ChangeColourView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(85))];
        [_confirmBtn.ContinueBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_confirmBtn.ContinueBtn setTitle:@"提交" forState:(UIControlStateNormal)];
        _confirmBtn.delegate = self;
        [footerView addSubview:_confirmBtn];
    }else {
        
    }
    return footerView;
    
}
#pragma mark  评论
- (void)handleExitOrg {
    
    [_taskPerformContentCell.taskContentTV resignFirstResponder];
    NSString* taskImg = @"";
    for (int i  =0; i <self.taskImageArray.count; i++) {
        DJImageUploadModel *model = self.taskImageArray[i];
        if ([model.imageState isEqualToString:@"1"]) {
            if (i == 0) {
                taskImg = model.ImageUrl;
            }else {
                taskImg = [NSString stringWithFormat:@"%@,%@", taskImg, model.ImageUrl];
            }
        }
    }
    
    NSMutableDictionary * URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:taskContentStr forKey:@"evaContent"];
    [URL_Dic setValue:taskImg forKey:@"evaImg"];
    [URL_Dic setValue:self.orgModel.orgId forKey:@"orgId"];
    [URL_Dic setValue:self.orgModel.stationId forKey:@"stationId"];
    [URL_Dic setValue:self.taskId forKey:@"taskId"];

    [self showHud:@"" title:@""];
    [self getJSONDataWithUrl:kURL_taskComments parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        NSLog(@"responseObject%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
}

#pragma mark  DJTaskContentEditorTableViewCellDelegate
- (void)taskContentChange:(NSString *)nameStr {
    taskContentStr = nameStr;
    [self isCanSubmit];
}



#pragma mark  DJTaskDistrImageChooseTVCellDelegate
#pragma  DJTaskDistrImageChooseTVCellDelegate

/**
 取消选中某张图片
 @param index
 */
- (void)cancelSelectedImage:(NSInteger )index {
    [_taskImageArray removeObjectAtIndex:index];
  
    [imageShowCell viewRenderingShowImageArray:self.taskImageArray];
    [self isCanSubmit];
}
/**
 放大某张图片
 @param indexPath NSIndexPath
 */
- (void)amplificationImage:(NSInteger )index {
    
}

//跳转照片选择界面
- (void)ClickUploadImage:(NSInteger )index {
    __weak  DJTaskPerFormViewController  *selfWeak = self;
    DJPhotosChooseViewController *VC = [[DJPhotosChooseViewController alloc] init];
    VC.existingImageNum = self.taskImageArray.count;
    VC.imageUpload = ^(NSArray *imageArray,NSArray *thumbnailImageArray) {
        for (int i = 0; i < imageArray.count; i ++) {
            UIImage *image = imageArray[i];
            DJImageUploadModel *model = [[DJImageUploadModel alloc] init];
            model.image = image;
            model.imageState = @"0";
            model.ImageUrl = @"";
            [selfWeak.taskImageArray addObject:model];
        }
//        [selfWeak.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(174, 174, 174, 1) forState:(UIControlStateNormal)];
//        selfWeak.defaultNavigationBarView.rightBtn.userInteractionEnabled = NO;
        [imageShowCell viewRenderingShowImageArray:self.taskImageArray];
        dispatch_group_t group =  dispatch_group_create();
        
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSInteger  index =  self.taskImageArray.count - imageArray.count;
            for (int i = 0; i < self.taskImageArray.count-index; i ++) {
                DJImageUploadModel *model = self.taskImageArray[i+index];
                [selfWeak ImageUpload:model.image results:^(NSString *imageUrl) {
                    model.ImageUrl= imageUrl;
                    if (![imageUrl isEmpty]) {
                        model.imageState = @"1";
                    }else {
                        model.imageState = @"2";
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 通知主线程刷新 神马的
                        [imageShowCell refreshImageUpLoadProgressArray:self.taskImageArray index:i+index];
                        [selfWeak isCanSubmit];
                        
                    });
                }];
            }
        });
        
    };
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
    [self presentViewController:NAVC animated:YES completion:nil];
    
}
- (void)getTakingPictures:(NSNotification *)notification {
    NSDictionary *dataDic = notification.userInfo;
    NSArray *imageArray = dataDic[@"image"];
    for (int i = 0; i < imageArray.count; i ++) {
        UIImage *image = imageArray[i];
        DJImageUploadModel *model = [[DJImageUploadModel alloc] init];
        model.image = image;
        model.imageState = @"0";
        model.ImageUrl = @"";
        [self.taskImageArray addObject:model];
    }
//    [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(174, 174, 174, 1) forState:(UIControlStateNormal)];
//    self.defaultNavigationBarView.rightBtn.userInteractionEnabled = NO;
    [imageShowCell viewRenderingShowImageArray:self.taskImageArray];
    dispatch_group_t group =  dispatch_group_create();
    __weak  DJTaskPerFormViewController  *selfWeak = self;
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger  index =  self.taskImageArray.count - imageArray.count;
        for (int i = 0; i < self.taskImageArray.count-index ; i ++) {
            DJImageUploadModel *model = self.taskImageArray[i+index];
            [selfWeak ImageUpload:model.image  results:^(NSString *imageUrl) {
                model.ImageUrl= imageUrl;
                 if (![imageUrl isEmpty]) {
                    model.imageState = @"1";
                }else {
                    model.imageState = @"2";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 通知主线程刷新 神马的
                    [imageShowCell refreshImageUpLoadProgressArray:self.taskImageArray index:i+index];
                    [selfWeak isCanSubmit];
                });
            }];
        }
    });
    NSLog(@"---接收到通知---");
}
/**
 如果图片上传失败 就重新上传图片
 @param index 需要重新上传的图片下标
 */
- (void)uploadAgainImage:(NSInteger)index {
    DJImageUploadModel *tempModel = self.taskImageArray[index];
    if ([tempModel.imageState isEqualToString:@"0"] || [tempModel.imageState isEqualToString:@"1"] ) {
        return;
    }
    tempModel.imageState = @"0";
    [imageShowCell refreshImageUpLoadProgressArray:self.taskImageArray index:index];
    
    dispatch_group_t group =  dispatch_group_create();
    __weak __typeof(self) weakself= self;
    
    dispatch_queue_t reloadQueue = dispatch_queue_create("com.reloadGCD.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, reloadQueue, ^{
        NSInteger tempIndex = index;
        DJImageUploadModel *model = self.taskImageArray[tempIndex];
        model.imageState = @"0";
        [weakself ImageUpload:model.image results:^(NSString *imageUrl) {
            model.ImageUrl = imageUrl;
            if (![imageUrl isEmpty]) {
                model.imageState = @"1";
            }else {
                model.imageState = @"2";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [imageShowCell refreshImageUpLoadProgressArray:self.taskImageArray index:tempIndex];
                [weakself isCanSubmit];
            });
        }];
        
    });
}

-(void)requestMyTaskDetails {
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.taskId forKey:@"taskId"];
    [URL_Dic setValue:self.orgModel.orgId forKey:@"orgId"];
    NSLog(@"taskId%@", self.taskId);
    [self  getJSONDataWithUrl:kURL_myReceivedTaskDetails parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *responseDic = responseObject[@"response"];
            if (![responseDic isKindOfClass:[NSDictionary class]]) {
                return ;
            }
            
            if ([responseDic[@"status"] isEqualToString:@"time_out"]) {
                self.oldStatus = @"time_out";
                switch (self.taskOperationType) {
                    case DJTaskOperationTypePerform: {
                        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"任务已超期" message:@"任务已超期, 点击确认, 本次执行做补办处理。" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            
                        }];
                        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [self submitTaskFillDo];
                        }];
                        // 3.将“取消”和“确定”按钮加入到弹框控制器中
                        [alertV addAction:cancle];
                        [alertV addAction:confirm];
                        // 4.控制器 展示弹框控件，完成时不做操作
                        [self presentViewController:alertV animated:YES completion:^{
                            nil;
                        }];
                    }
                        break;
                    case DJTaskOperationTypeAskLeave: {
                        
                        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"任务已超期" message:@"任务已超期,无法发起请假申请。" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            
                        }];
                        
                        // 3.将“取消”和“确定”按钮加入到弹框控制器中
                        [alertV addAction:cancle];
                        // 4.控制器 展示弹框控件，完成时不做操作
                        [self presentViewController:alertV animated:YES completion:^{
                            nil;
                        }];
                    }
                        
                        break;
                        
                    default:
                        break;
                }
                
                
            }else {
                switch (self.taskOperationType) {
                    case DJTaskOperationTypePerform:
                        [self submitTaskPerform];
                        break;
                    case DJTaskOperationTypeAskLeave:
                        [self submitTaskAskLeave];
                        break;
                        
                    default:
                        break;
                }
            }
            
        }else {
            [self  ShowWarningHudMid:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [self hudDissmiss];
        NSLog(@"error%@", error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//提交任务执行
- (void)submitTaskPerform {
    NSString* taskImg = @"";
    for (int i  =0; i <self.taskImageArray.count; i++) {
        DJImageUploadModel *model = self.taskImageArray[i];
        if ([model.imageState isEqualToString:@"1"]) {
            if (i == 0) {
                taskImg = model.ImageUrl;
            }else {
                taskImg = [NSString stringWithFormat:@"%@,%@", taskImg, model.ImageUrl];
            }
        }
    }
    NSMutableDictionary * URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.mainTaskId forKey:@"id"];
    [URL_Dic setValue:taskContentStr forKey:@"content"];
    [URL_Dic setValue:taskImg forKey:@"img"];
    [URL_Dic setValue:self.oldStatus forKey:@"oldStatus"];
    [URL_Dic setValue:@"complete" forKey:@"status"];
    
    [self getJSONDataWithUrl:kURL_performMyReceivedTask parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            if (isSubmitComment) {
                [self taskPerformAndPostComment];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        
        NSLog(@"responseObject%@", responseObject);
        
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
    
}
//提交任务请假
- (void)submitTaskAskLeave {

    NSString* taskImg = @"";
    for (int i  =0; i <self.taskImageArray.count; i++) {
        DJImageUploadModel *model = self.taskImageArray[i];
        if ([model.imageState isEqualToString:@"1"]) {
            if (i == 0) {
                taskImg = model.ImageUrl;
            }else {
                taskImg = [NSString stringWithFormat:@"%@,%@", taskImg, model.ImageUrl];
            }
        }
    }
    
    NSMutableDictionary * URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.mainTaskId forKey:@"id"];
    [URL_Dic setValue:taskContentStr forKey:@"content"];
    [URL_Dic setValue:taskImg forKey:@"img"];
    [URL_Dic setValue:self.oldStatus forKey:@"oldStatus"];
    [URL_Dic setValue:@"leaveing" forKey:@"status"];
    
    [self getJSONDataWithUrl:kURL_performMyReceivedTask parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        NSLog(@"responseObject%@", responseObject);
        [self hudDissmiss];
        if ([code isEqualToString:@"0"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
}
//提交任务补办
- (void)submitTaskFillDo {

    NSString* taskImg = @"";
    for (int i  =0; i <self.taskImageArray.count; i++) {
        DJImageUploadModel *model = self.taskImageArray[i];
        if ([model.imageState isEqualToString:@"1"]) {
            if (i == 0) {
                taskImg = model.ImageUrl;
            }else {
                taskImg = [NSString stringWithFormat:@"%@,%@", taskImg, model.ImageUrl];
            }
        }
    }
    
    NSMutableDictionary * URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.mainTaskId forKey:@"id"];
    [URL_Dic setValue:taskContentStr forKey:@"content"];
    [URL_Dic setValue:taskImg forKey:@"img"];
    [URL_Dic setValue:self.oldStatus forKey:@"oldStatus"];
    [URL_Dic setValue:@"timeout_complete" forKey:@"status"];
    [self getJSONDataWithUrl:kURL_performMyReceivedTask parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            if (isSubmitComment) {
                [self taskPerformAndPostComment];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        
        NSLog(@"submitTaskFillDoresponseObject%@", responseObject);
        
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
    
    
}
//提交任务申诉
- (void)submitTaskComplaint {

    NSString* taskImg = @"";
    for (int i  =0; i <self.taskImageArray.count; i++) {
        DJImageUploadModel *model = self.taskImageArray[i];
        if ([model.imageState isEqualToString:@"1"]) {
            if (i == 0) {
                taskImg = model.ImageUrl;
            }else {
                taskImg = [NSString stringWithFormat:@"%@,%@", taskImg, model.ImageUrl];
            }
        }
    }
    
    NSMutableDictionary * URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:self.mainTaskId forKey:@"id"];
    [URL_Dic setValue:taskContentStr forKey:@"content"];
    [URL_Dic setValue:taskImg forKey:@"img"];
    [URL_Dic setValue:self.oldStatus forKey:@"oldStatus"];
    [URL_Dic setValue:@"appealing" forKey:@"status"];
    
    
    [self getJSONDataWithUrl:kURL_performMyReceivedTask parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
    
    
}

- (void)isCanSubmit {
    if (taskContentStr.length != 0) {
        _confirmBtn.ContinueBtn.userInteractionEnabled = YES;
        _confirmBtn.gradientLayer.hidden = NO;
        [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(30, 139, 223, 1) forState:(UIControlStateNormal)];
        self.defaultNavigationBarView.rightBtn.userInteractionEnabled = YES;
    }else {
        BOOL  isUploadedEnd = NO;//是否有上传完毕的图片
        NSInteger  areUploadingNum = 0;//有没有正在上传的
        for (int i = 0; i < self.taskImageArray.count; i ++) {
            DJImageUploadModel *model = self.taskImageArray[i];
            if ([model.imageState isEqualToString:@"1"]) {
                isUploadedEnd = YES;
            }else if([model.imageState isEqualToString:@"0"]){
                areUploadingNum ++;
                break;
            }
        }
        if (isUploadedEnd) {
            _confirmBtn.ContinueBtn.userInteractionEnabled = YES;
            _confirmBtn.gradientLayer.hidden = NO;
            [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(30, 139, 223, 1) forState:(UIControlStateNormal)];
            self.defaultNavigationBarView.rightBtn.userInteractionEnabled = YES;
        }else {
            _confirmBtn.ContinueBtn.userInteractionEnabled = NO;
            _confirmBtn.gradientLayer.hidden = YES;
            [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(174, 174, 174, 1) forState:(UIControlStateNormal)];
            self.defaultNavigationBarView.rightBtn.userInteractionEnabled = NO;
        }
        
    }
    

}

- (void)taskPerformAndPostComment {
    
    [_taskPerformContentCell.taskContentTV resignFirstResponder];
    NSString* taskImg = @"";
    for (int i  =0; i <self.taskImageArray.count; i++) {
        DJImageUploadModel *model = self.taskImageArray[i];
        if ([model.imageState isEqualToString:@"1"]) {
            if (i == 0) {
                taskImg = model.ImageUrl;
            }else {
                taskImg = [NSString stringWithFormat:@"%@,%@", taskImg, model.ImageUrl];
            }
        }
    }
    
    NSMutableDictionary * URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:taskContentStr forKey:@"evaContent"];
    [URL_Dic setValue:taskImg forKey:@"evaImg"];
    [URL_Dic setValue:self.orgModel.orgId forKey:@"orgId"];
    [URL_Dic setValue:self.orgModel.stationId forKey:@"stationId"];
    [URL_Dic setValue:self.taskId forKey:@"taskId"];
    
    
    [self getJSONDataWithUrl:kURL_taskComments parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        NSLog(@"responseObject%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        [self.navigationController popViewControllerAnimated:YES];
        if ([code isEqualToString:@"0"]) {
            
        }else {
            
        }
        
//        [self ShowWarningHudMid:responseObject[@"msg"]];
    } failure:^(NSError *error) {
        [self hudDissmiss];
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
