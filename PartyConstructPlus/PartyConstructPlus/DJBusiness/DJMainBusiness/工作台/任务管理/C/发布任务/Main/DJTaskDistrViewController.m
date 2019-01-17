//
//  DJTaskDistrViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/17.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskDistrViewController.h"

#import "DJTaskNameEditorTableViewCell.h"
#import "DJTaskContentEditorTableViewCell.h"
#import "DJTaskDistrImageChooseTVCell.h"
#import "DJTaskDistrTypeChooseTVCell.h"
#import "DJTaskDistChooseImageTableViewCell.h"


#import "DJTaskTimeChooseViewController.h"
#import "GFCalendar.h"
#import "DJPhotosChooseViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "DJMainViewController.h"
#import "DJChooseMissionPersonnelViewController.h"
#import "DJSelectTaskTagViewController.h"

#import "DJImageUploadModel.h"

@interface DJTaskDistrViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, DJTaskNameEditorTableViewCellDelegate, DJTaskContentEditorTableViewCellCellDelegate, DJTaskDistrImageChooseTVCellDelegate, DJTaskDistChooseImageTableViewCellDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITextView *taskNameTV;

@property (nonatomic, strong)NSMutableArray *iconAndTitieArray;
/**
 存储从相册里面得到的image  展示到滑动的cell上
 */
@property (nonatomic, strong)NSMutableArray *PhotoAlbumImageArray;
/**
 已经被选中的图片数组
 */
@property (nonatomic, strong)NSMutableArray *selectedImageArray;

/**
 *放大图片后面的灰色背景
 */
@property (nonatomic, strong)UIView *backgroundView;
/**
 已经选择的原图片
 */
@property (nonatomic, strong)NSMutableArray *taskImageArray;


/**
 *选择发送对象
 */
@property (nonatomic, strong)NSMutableArray * taskReceiveObjectArray;
/**
 *选择人员总数据  用来回显
 */
@property (nonatomic, strong)NSMutableArray * echoorgUserArray;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * taskTagArray;



@end

@implementation DJTaskDistrViewController {
    
    DJTaskContentEditorTableViewCell *contentEditorCell;
    DJTaskNameEditorTableViewCell *nameEditorCell;
    DJTaskDistChooseImageTableViewCell *imageShowCell;
    UILabel * taskNamePrompLabel;
    NSString *taskNameStr;//任务名字
    CGFloat   taskNameAddHeight;
    NSString *taskContentStr;//任务内容
    CGFloat   taskContentAddHeight;
    NSInteger  defaultSelectedKeyBoard;//由于需求是随着字体增加自适应cell的高度 cell刷新界面添加高度 会使键盘消失,所以记录一下系统上次编辑的是哪个键盘 在界面刷新之后再默认选中某个键盘  0 为默认状态 都不选中 1 为选中任务名字编辑  2为选中任务内容编辑

    //图片是否加载完毕了
    BOOL LoadResults;
    
  __block  NSDate *taskStartTime;
    NSDate *taskEndTime;
    
}

- (NSMutableArray *)taskTagArray {
    if (!_taskTagArray) {
        _taskTagArray = [NSMutableArray array];
    }
    return _taskTagArray;
}

- (NSMutableArray *)echoorgUserArray {
    if (!_echoorgUserArray) {
        _echoorgUserArray = [NSMutableArray array];
    }
    return _echoorgUserArray;
}


- (NSMutableArray *)taskReceiveObjectArray {
    if (!_taskReceiveObjectArray) {
        _taskReceiveObjectArray = [NSMutableArray array];
    }
    return  _taskReceiveObjectArray;
}


- (NSMutableArray *)taskImageArray {
    if (!_taskImageArray) {
        _taskImageArray = [NSMutableArray array];
    }
    return _taskImageArray;
}




- (NSMutableArray *)PhotoAlbumImageArray {
    if (!_PhotoAlbumImageArray) {
        _PhotoAlbumImageArray = [NSMutableArray array];
    }
    return _PhotoAlbumImageArray;
}

- (NSMutableArray *)selectedImageArray {
    if (!_selectedImageArray) {
        _selectedImageArray = [NSMutableArray array];
    }
    return _selectedImageArray;
}

- (NSMutableArray *)iconAndTitieArray {
    if (!_iconAndTitieArray) {
        NSArray *tempArray  = @[@{@"icon":@"DJ_rwfb_object", @"title":@"请选择发送对象", @"state":@"0"}, @{@"icon":@"DJ_rwfb_time", @"title":@"请选择任务时间", @"state":@"0"}, @{@"icon":@"DJ_rwfb_Label", @"title":@"请选择任务标签", @"state":@"0"}];
        _iconAndTitieArray  = [NSMutableArray arrayWithArray:tempArray];
    }
    return _iconAndTitieArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    defaultSelectedKeyBoard = 0;
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    taskNameAddHeight= 0;
    taskStartTime = nil;
    taskEndTime = nil;
    taskNameStr = @"";
    taskContentStr = @"";
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"发布任务";
    [self.defaultNavigationBarView.rightBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(173, 173, 173, 1) forState:(UIControlStateNormal)];
    self.defaultNavigationBarView.rightBtn.userInteractionEnabled = NO;
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.defaultNavigationBarView.rightBtn addTarget:self action:@selector(handleSubmitTask) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTakingPictures:) name:@"TakingPictures" object:nil];
    [self createTableView];
    

    
}

- (void)handleReturnBtn {
    [self.navigationController  popViewControllerAnimated:YES];
    
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


- (void)handleSubmitTask {
    [contentEditorCell.taskContentTV resignFirstResponder];
    [nameEditorCell.taskNameTV resignFirstResponder];

    NSString *startStr = [NSDate dateString:taskStartTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *endStr = [NSDate dateString:taskEndTime format:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDictionary *dataDic = _iconAndTitieArray[2];
    NSString *titleStr = dataDic[@"title"];
    
    NSArray *datarray =  [self queryModel:@"OrgInfoModel"];
    NSString *orgId = @"";
    NSString *stationId = @"";
    for (OrgInfoModel *model in datarray) {
        if ([model.defaultState isEqualToString:@"1"]) {
            orgId = model.orgId;
            stationId = model.stationId;
            break;
        }
    }
    NSMutableDictionary*URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:startStr forKey:@"startDate"];
    [URL_Dic setValue:endStr forKey:@"endDate"];
    [URL_Dic setValue:orgId forKey:@"orgId"];
    [URL_Dic setValue:stationId forKey:@"stationId"];
    [URL_Dic setValue:[CommonUtil taskTagsLetterWithHanzi:titleStr] forKey:@"tags"];
    [URL_Dic setValue:taskContentStr forKey:@"taskContent"];
    

    NSString* taskImg = @"";
    for (int i  =0; i <self.taskImageArray.count; i++) {
        DJImageUploadModel *model  = self.taskImageArray[i];
        if (![model.imageState isEqualToString:@"2"]) {
            if (i == 0) {
                taskImg = model.ImageUrl;
            }else {
                taskImg = [NSString stringWithFormat:@"%@,%@", taskImg, model.ImageUrl];
            }
        }
    }
    
    
    [URL_Dic setValue:taskImg forKey:@"taskImg"];
    
    [URL_Dic setValue:taskNameStr forKey:@"taskName"];

    [URL_Dic setValue:self.taskReceiveObjectArray forKey:@"users"];
    
    NSString *temoStr = URL_Dic[@"users"];
  
    NSLog(@"URL_Dic%@ temoStr%@", URL_Dic, temoStr);
    
    
    [self showHud:@"" title:@""];
    [self  getJSONDataWithUrl:kURL_TaskSend parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        NSLog(@"发布任务回调%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [self ShowWarningHudMid:@"发布成功"];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.bounces = NO;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [_tableView registerClass:[DJTaskNameEditorTableViewCell class] forCellReuseIdentifier:@"DJTaskNameEditorTableViewCell"];
    [_tableView registerClass:[DJTaskContentEditorTableViewCell class] forCellReuseIdentifier:@"DJTaskContentEditorTableViewCell"];
    [_tableView registerClass:[DJTaskDistrImageChooseTVCell class] forCellReuseIdentifier:@"DJTaskDistrImageChooseTVCell"];
    [_tableView registerClass:[DJTaskDistrTypeChooseTVCell class] forCellReuseIdentifier:@"DJTaskDistrTypeChooseTVCell"];
    [_tableView registerClass:[DJTaskDistChooseImageTableViewCell class] forCellReuseIdentifier:@"DJTaskDistChooseImageTableViewCell"];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else {
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DJTaskNameEditorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskNameEditorTableViewCell" forIndexPath:indexPath];
            if (taskNameStr.length == 0) {
                cell.promptCopywriting = @"请在此输入任务主题";
            }else {
                cell.promptCopywriting = @"";
            }
            if (defaultSelectedKeyBoard == 1) {
                [cell.taskNameTV becomeFirstResponder];
            }
            nameEditorCell = cell;
            cell.delegate = self;
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.row == 1){
            DJTaskContentEditorTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"DJTaskContentEditorTableViewCell" forIndexPath:indexPath];
            if (defaultSelectedKeyBoard == 2) {
                [cell.taskContentTV becomeFirstResponder];
            }
            if (taskContentStr.length == 0) {
                    cell.promptCopywriting = @"请在此输入任务内容";
            }else {
                cell.promptCopywriting = @"";
            }
            
            contentEditorCell = cell;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.row == 2){
            DJTaskDistChooseImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskDistChooseImageTableViewCell" forIndexPath:indexPath];
            [cell viewRenderingShowImageArray:self.taskImageArray];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            imageShowCell = cell;
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            return cell;
        }
    }else {
        DJTaskDistrTypeChooseTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskDistrTypeChooseTVCell" forIndexPath:indexPath];
        NSDictionary *dataDic =self.iconAndTitieArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImageView.image = [UIImage imageNamed:dataDic[@"icon"]];
        cell.titleLabel.text = dataDic[@"title"];
        if ([dataDic[@"state"] isEqualToString:@"0"]) {
            cell.titleLabel.textColor = kColorRGB(173, 173, 173, 1);
        }else {
            cell.titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        }
        if (indexPath.row == self.iconAndTitieArray.count - 1) {
            cell.dividerLabel.hidden = YES;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [contentEditorCell.taskContentTV resignFirstResponder];
    [nameEditorCell.taskNameTV resignFirstResponder];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                NSMutableArray *copyMArray = [NSMutableArray array];
                for (int i = 0; i <self.echoorgUserArray.count; i++) {
                    LowerOrgModel *model = self.echoorgUserArray[i];
                    if (![model.chooseNum isEqualToString:@"0"]) {//如果这个组织下面的任务已经有被选择的那么就存进数组返回给发布任务界面 用户数据上传和回显使用
                        LowerOrgModel *NModel = [NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
                        NModel.content = model.content;
                        NModel.name = model.name;
                        NModel.orgId = model.orgId;
                        NModel.name = model.name;
                        NModel.pid = model.pid;
                        NModel.orgLevel = model.orgLevel;
                        NModel.chooseNum = model.chooseNum;
                        NModel.isSelectAll = model.isSelectAll;
                        NSArray *orgUserArray = (NSArray *)model.orgUser;
                        NSMutableArray *MUserArray = [NSMutableArray array];
                        for (LowerOrgUserModel *userModel in orgUserArray) {
                            LowerOrgUserModel *NUserModel = [NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgUserModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
                            NUserModel.orgId = userModel.orgId;
                            NUserModel.stationId = userModel.stationId;
                            NUserModel.userId = userModel.userId;
                            NUserModel.userName = userModel.userName;
                            NUserModel.state = userModel.state;
                            NUserModel.orgName = userModel.orgName;
                            [MUserArray addObject:NUserModel];
                            NSLog(@"MUserArray%p  userModel%p", MUserArray, userModel);
                        }
                        NModel.orgUser  = MUserArray;
                        [copyMArray addObject:NModel];
                        NSLog(@"NModel%pmodel%p", NModel, model);
                    }
                }
                
                DJChooseMissionPersonnelViewController *VC = [[DJChooseMissionPersonnelViewController alloc] init];
                VC.echoOrgUserArray = copyMArray;
                __weak DJTaskDistrViewController *selfWeak = self;
                VC.taskReceiveUser = ^(NSArray *orgArray) {//得到的该数组是组织数组
                    selfWeak.echoorgUserArray = [NSMutableArray arrayWithArray:orgArray];
                    NSMutableArray *tempArray = [NSMutableArray array];
                    NSMutableArray *selectedUserArray = [NSMutableArray array];
                    NSString *cellShowStr = @"";
                    for (int i = 0; i < orgArray.count; i ++) {//得到单独的组织
                        LowerOrgModel *orgModel = orgArray[i];
                        NSArray *orgUserArray = (NSArray *)orgModel.orgUser;//得到组织下面的所有人员
                        for (int j = 0; j  < orgUserArray.count ; j ++) {
                            LowerOrgUserModel * orgUserModel = orgUserArray[j];
                            if ([orgUserModel.state isEqualToString:@"1"]) {
                                [selectedUserArray addObject:orgUserModel];
                                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                                [tempDic setValue:orgUserModel.orgId forKey:@"orgId"];
                                [tempDic setValue:orgUserModel.stationId forKey:@"stationId"];
                                [tempDic setValue:orgUserModel.userId forKey:@"userId"];
                                [tempArray addObject:tempDic];
                            }
                        }
                    }
                    for (int i = 0; i  < selectedUserArray.count; i ++) {
                        LowerOrgUserModel * model = selectedUserArray[i];
                        if (i == 0) {
                            cellShowStr = model.userName;
                        }else if(i == 1){
                            if (selectedUserArray.count == 2) {
                                cellShowStr = [NSString stringWithFormat:@"%@,%@", cellShowStr, model.userName];
                            }else {
                                cellShowStr = [NSString stringWithFormat:@"%@,%@等%ld人", cellShowStr, model.userName, selectedUserArray.count];
                            }
                        }
                    }
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.iconAndTitieArray[0]];
                tempDic[@"title"] = cellShowStr;
                tempDic[@"state"] = @"1";
                self.iconAndTitieArray[0] =tempDic;
                selfWeak.taskReceiveObjectArray = [NSMutableArray arrayWithArray:tempArray];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    [selfWeak.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
                [selfWeak refreshInterface];
                };
                [self pushToNextViewController:VC];
            }
                break;
            case 1:{
                dispatch_async(dispatch_get_main_queue(), ^{
                DJTaskTimeChooseViewController *VC = [[DJTaskTimeChooseViewController alloc] init];
                __weak DJTaskDistrViewController  *selfWeak = self;
                VC.startDefaultDate = taskStartTime;
                VC.endDefaultDate = taskEndTime;
                VC.returnTime = ^(NSString *startDate, NSString *endDate) {
                    NSLog(@"startDate%@ endDate%@", startDate, endDate);
                    NSDate *start_date = [NSDate stringToDate:startDate format:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *end_date = [NSDate stringToDate:endDate format:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *startStr = [NSDate dateString:start_date format:@"yyyy/MM/dd HH:mm"];
                    NSString *endStr = [NSDate dateString:end_date format:@"yyyy/MM/dd HH:mm"];
                    NSMutableDictionary  *dataDic =[NSMutableDictionary dictionaryWithDictionary:selfWeak.iconAndTitieArray[1]];
                    dataDic[@"state"] = @"1";
                    dataDic[@"title"] = [NSString stringWithFormat:@"%@至%@", startStr, endStr];
                    selfWeak.iconAndTitieArray[1] = dataDic;
                    taskStartTime = start_date;
                    taskEndTime = end_date;
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                    [selfWeak.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
                    [selfWeak refreshInterface];
                };
                [self pushToNextViewController:VC];
                });
            }
                               
                break;
            case 2:{
                __weak DJTaskDistrViewController *selfWeak = self;
                DJSelectTaskTagViewController *VC = [[DJSelectTaskTagViewController alloc] init];
                VC.defaultDataArray = self.taskTagArray;
                VC.taskTagBlock = ^(NSArray *tagArray) {
                    selfWeak.taskTagArray = [NSMutableArray arrayWithArray:tagArray];
                    NSMutableArray *selectedTagArray  = [NSMutableArray array];
                    for (int i = 0;  i< tagArray.count; i ++) {
                        NSArray *tempArray = tagArray[i];
                        for (int j = 0; j < tempArray.count; j ++) {
                            NSDictionary *tempDic = tempArray[j];
                            if ([tempDic[@"state"] isEqualToString:@"1"]) {
                                [selectedTagArray addObject:tempDic[@"title"]];
                            }
                        }
                    }
                    NSString *tagStr = @"";
                    for (int i = 0; i  < selectedTagArray.count; i ++) {
                        if (i == 0) {
                            tagStr = selectedTagArray[i];
                        }else {
                            tagStr = [NSString stringWithFormat:@"%@,%@", tagStr, selectedTagArray[i]];
                        }
                    }
                    
                    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:_iconAndTitieArray[2]];
                    dataDic[@"title"] = tagStr;
                    dataDic[@"state"] = @"1";
                    _iconAndTitieArray[2] = dataDic;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
                    [selfWeak.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
                    [selfWeak refreshInterface];
                };
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            default:
                break;
        }
        
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 50 + taskNameAddHeight;
        }else if (indexPath.row==1) {
            return 110;
        }else if(indexPath.row == 2){
            return 175;
        }else{
            return kFit(50);
        }
    }else {
        return kFit(50);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return kFit(5);
    }else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(5))];
        footerView.backgroundColor = kColorRGB(246, 246, 246, 1);
        return footerView;
    }else {
        UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
        return footerView;
    }
}

#pragma mark DJTaskNameEditorTableViewCell
- (void)taskNameChange:(NSString *)nameStr {
    defaultSelectedKeyBoard = 1;
    taskNameStr = nameStr;
    [self refreshInterface];
}
#pragma mark  DJTaskContentEditorTableViewCellCellDelegate
- (void)taskContentChange:(NSString *)nameStr {
    defaultSelectedKeyBoard = 2;
    taskContentStr = nameStr;
    [self refreshInterface];
}

#pragma  DJTaskDistrImageChooseTVCellDelegate

/**
 取消选中某张图片
 @param index
 */
- (void)cancelSelectedImage:(NSInteger )index {
    [_taskImageArray removeObjectAtIndex:index];
    [imageShowCell viewRenderingShowImageArray:self.taskImageArray];
    [self refreshInterface];
}

/**
 放大某张图片
 @param indexPath NSIndexPath
 */
- (void)amplificationImage:(NSInteger )index {
    
 }

//跳转照片选择界面
- (void)ClickUploadImage:(NSInteger )index {
    __weak  DJTaskDistrViewController  *selfWeak = self;
    DJPhotosChooseViewController *VC = [[DJPhotosChooseViewController alloc] init];
    VC.existingImageNum = self.taskImageArray.count;
    VC.imageUpload = ^(NSArray *imageArray,NSArray *thumbnailImageArray) {
        for (int i = 0; i < imageArray.count; i ++) {
            UIImage *image = imageArray[i];
            DJImageUploadModel *model = [[DJImageUploadModel alloc] init];
            model.imageState = @"0";
            model.ImageUrl = @"";
            model.image = image;
            [selfWeak.taskImageArray addObject:model];
        }
//        selfWeak.defaultNavigationBarView.rightBtn.userInteractionEnabled = NO;
//        [selfWeak.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(173, 173, 173, 1) forState:(UIControlStateNormal)];
        [imageShowCell viewRenderingShowImageArray:self.taskImageArray];
        dispatch_group_t group =  dispatch_group_create();
        
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (int i = 0; i < self.taskImageArray.count-index; i ++) {
                DJImageUploadModel *model = self.taskImageArray[i+index];
                
                [selfWeak ImageUpload:model.image results:^(NSString *imageUrl) {
                    model.ImageUrl= imageUrl;
                    NSLog(@"<%@>", imageUrl);
                    if (![imageUrl isEmpty]) {
                        model.imageState = @"1";
                    }else {
                        model.imageState = @"2";
                    }
                    __weak __typeof(self) weakself= self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [imageShowCell refreshImageUpLoadProgressArray:self.taskImageArray index:i+index];
                        [weakself refreshInterface];
                    });
                }];
            }
        });
    };
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
    [self presentViewController:NAVC animated:YES completion:nil];
}

- (void)getTakingPictures:(NSNotification *)notification {
    
    NSLog(@"%@",notification.userInfo);
    NSDictionary *dataDic = notification.userInfo;
    
    NSArray *imageArray = dataDic[@"image"];
    
    for (int i = 0; i < imageArray.count; i ++) {
        UIImage *image = imageArray[i];
        DJImageUploadModel *model = [[DJImageUploadModel alloc] init];
        model.imageState = @"0";
        model.ImageUrl = @"";
        model.image = image;
        [self.taskImageArray addObject:model];
    }
//    self.defaultNavigationBarView.rightBtn.userInteractionEnabled = NO;
//    [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(173, 173, 173, 1) forState:(UIControlStateNormal)];
    [imageShowCell viewRenderingShowImageArray:self.taskImageArray];
    dispatch_group_t group =  dispatch_group_create();
    __weak __typeof(self) weakself= self;
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger  index =  self.taskImageArray.count - imageArray.count;
        for (int i = 0; i < self.taskImageArray.count-index; i ++) {
            DJImageUploadModel *model = self.taskImageArray[i+index];
            [weakself ImageUpload:model.image results:^(NSString *imageUrl) {
                model.ImageUrl = imageUrl;
                if (![imageUrl isEmpty]) {
                    model.imageState = @"1";
                }else {
                    model.imageState = @"2";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                [imageShowCell refreshImageUpLoadProgressArray:self.taskImageArray index:i+index];
                [weakself refreshInterface];
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
                [weakself refreshInterface];
            });
        }];
    });
}
//刷新界面
- (void)refreshInterface {
    NSString *startStr = [NSDate dateString:taskStartTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *endStr = [NSDate dateString:taskEndTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSDictionary *dataDic = _iconAndTitieArray[2];
    NSString *titleStr = dataDic[@"title"];
    if ([titleStr isEqualToString:@"请选择任务标签"]) {
        titleStr = @"";
    }
    BOOL  isUploadedEnd = NO;//是否有上传完毕的图片
    NSInteger  areUploadingNum = 0;//有没有正在上传的
    if (self.taskImageArray.count != 0) {
        for (int i = 0; i < self.taskImageArray.count; i ++) {
            DJImageUploadModel *model = self.taskImageArray[i];
            if ([model.imageState isEqualToString:@"1"]) {
                isUploadedEnd = YES;
            }else if([model.imageState isEqualToString:@"0"]){
                areUploadingNum ++;
                break;
            }
        }
    }
    
    BOOL isCanSubmit = NO;
    if ((taskNameStr.length != 0) && (taskContentStr.length != 0)&& (self.taskReceiveObjectArray.count != 0)&& (![startStr isEmpty])) {
        isCanSubmit = YES;
    }
    if (isCanSubmit) {
        self.defaultNavigationBarView.rightBtn.userInteractionEnabled = YES;
        [self.defaultNavigationBarView.rightBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }else {
        self.defaultNavigationBarView.rightBtn.userInteractionEnabled = NO;
        [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(173, 173, 173, 1) forState:(UIControlStateNormal)];
    }
    
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
