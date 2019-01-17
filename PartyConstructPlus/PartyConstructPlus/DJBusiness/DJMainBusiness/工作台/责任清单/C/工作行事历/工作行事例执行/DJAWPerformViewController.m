//
//  DJAWPerformViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/22.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJAWPerformViewController.h"
#import "DJTaskContentEditorTableViewCell.h"
#import "DJTaskDistrImageChooseTVCell.h"
#import "DJPhotosChooseViewController.h"
#import "DJTaskDistChooseImageTableViewCell.h"
#import "DJImageUploadModel.h"
@interface DJAWPerformViewController ()<UITableViewDelegate, UITableViewDataSource, DJTaskContentEditorTableViewCellCellDelegate, DJTaskDistChooseImageTableViewCellDelegate>
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
 *用户展示的已被选中的缩略图
 */
@property (nonatomic, strong)NSMutableArray * showThumbnailImageArray;
/**
 已经选择的图片上传状态
 */
@property (nonatomic, strong)NSMutableArray *taskImageStateArray;
/**
 *已经上传的图片URL
 */
@property (nonatomic, strong)NSMutableArray * taskImageURLArray;
/**
 *
 */
@property (nonatomic, strong)DJTaskContentEditorTableViewCell * taskPerformContentCell;

@end

@implementation DJAWPerformViewController{
    NSString *taskContentStr;//任务内容
    DJTaskDistChooseImageTableViewCell * imageShowCell;
}

- (NSMutableArray *)showThumbnailImageArray {
    if (!_showThumbnailImageArray) {
        _showThumbnailImageArray = [NSMutableArray array];
    }
    return _showThumbnailImageArray;
}

- (NSMutableArray *)taskImageArray {
    if (!_taskImageArray) {
        _taskImageArray = [NSMutableArray array];
    }
    return _taskImageArray;
}

- (NSMutableArray *)taskImageURLArray {
    if (!_taskImageURLArray) {
        _taskImageURLArray = [NSMutableArray array];
    }
    return _taskImageURLArray;
}

- (NSMutableArray *)taskImageStateArray {
    if (!_taskImageStateArray) {
        _taskImageStateArray = [NSMutableArray array];
    }
    return _taskImageStateArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTakingPictures:) name:@"TakingPictures" object:nil];
    
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    
    if (![self.model.status isEqualToString:@"timeout"]) {
        _defaultNavigationBarView.titleLabel.text = @"行事历执行";
    }else {
        _defaultNavigationBarView.titleLabel.text = @"行事历补办";
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
    
    [_taskPerformContentCell.taskContentTV resignFirstResponder];
   if (![self.model.status isEqualToString:@"timeout"]) {

       [self taskPerform:@"completed"];
   }else {
       [self taskPerform:@"timecompleted"];
   }
}

- (void)taskPerform:(NSString *)taskState {
    
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
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:taskImg forKey:@"doImg"];
    [URL_Dic setValue:taskContentStr forKey:@"doMsg"];
    [URL_Dic setValue:self.model.wcId forKey:@"id"];
    [URL_Dic setValue:self.orgModel.orgId forKey:@"orgId"];
    [URL_Dic setValue:self.orgModel.stationId forKey:@"stationId"];
    [URL_Dic setValue:taskState forKey:@"status"];
    
    
    [self getJSONDataWithUrl:kURL_finishWorkingCalendar parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

//返回上一界面
- (void)handleReturnBtn {
    [self.navigationController popViewControllerAnimated:YES];
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
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = kColorRGB(246, 246, 246, 1);
    _tableView.bounces = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [_tableView registerClass:[DJTaskContentEditorTableViewCell class] forCellReuseIdentifier:@"DJTaskContentEditorTableViewCell"];
    [_tableView registerClass:[DJTaskDistChooseImageTableViewCell class] forCellReuseIdentifier:@"DJTaskDistChooseImageTableViewCell"];
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleHideKeyboard)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    
//    [self.tableView addGestureRecognizer:singleFingerOne];
    
    
}
- (void)handleHideKeyboard {
    [_taskPerformContentCell.taskContentTV resignFirstResponder];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return 2;
  }

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0 ){
        DJTaskContentEditorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskContentEditorTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _taskPerformContentCell = cell;
        
        UILabel *_dividerLabel = [UILabel new];
        _dividerLabel.backgroundColor = kCellColorDivider;
        [cell addSubview:_dividerLabel];
        _dividerLabel.sd_layout.leftSpaceToView(cell, kFit(15)).bottomSpaceToView(cell, 0).heightIs(kCellDividerHeight).rightSpaceToView(cell, 0);
        
        return cell;
    }else{
        DJTaskDistChooseImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskDistChooseImageTableViewCell" forIndexPath:indexPath];
        [cell viewRenderingShowImageArray:self.taskImageArray];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        imageShowCell = cell;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row) {
//        <#statements#>
//    }
    [_taskPerformContentCell.taskContentTV resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 110;
    }else {
        return  175;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return  kFit(0);
    }else {
        return  0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    footerView.backgroundColor = kColorRGB(246, 246, 246, 1);
    return footerView;
    
}

#pragma mark  DJTaskContentEditorTableViewCellDelegate
- (void)taskContentChange:(NSString *)nameStr {
    taskContentStr = nameStr;
    [self isCanSubmit];
}

#pragma mark  DJTaskDistrImageChooseTVCellDelegate


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
    [_taskPerformContentCell.taskContentTV resignFirstResponder];
    __weak  typeof(self)  selfWeak = self;
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
                        [weakself isCanSubmit];
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
                    [weakself isCanSubmit];
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
    // ™ºª•ø
    tempModel.imageState = @"0";
    [imageShowCell refreshImageUpLoadProgressArray:self.taskImageArray index:index];
    
    dispatch_group_t group =  dispatch_group_create();
    __weak __typeof(self) weakself= self;
    //    270 - 27  243
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


- (void)setModel:(AgendaWorkingCalendarListModel *)model {
    _model = model;
}

- (void)isCanSubmit {
    
    if (taskContentStr.length != 0) {
        [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(30, 139, 223, 1) forState:(UIControlStateNormal)];
        self.defaultNavigationBarView.rightBtn.userInteractionEnabled = YES;
    }else {
        BOOL  isUploadedEnd = NO;//是否有上传完毕的图片
        NSInteger  areUploadingNum = 0;//有没有正在上传的
        for (int i = 0; i < self.taskImageArray.count; i ++) {
            DJImageUploadModel *model = self.taskImageArray[i];
            if ([model.imageState isEqualToString:@"1"]) {
                isUploadedEnd = YES;
                break;
            }else if([model.imageState isEqualToString:@"0"]){
                areUploadingNum ++;
                break;
            }
        }
        if (isUploadedEnd) {
            [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(30, 139, 223, 1) forState:(UIControlStateNormal)];
            self.defaultNavigationBarView.rightBtn.userInteractionEnabled = YES;
        }else {
            [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(174, 174, 174, 1) forState:(UIControlStateNormal)];
            self.defaultNavigationBarView.rightBtn.userInteractionEnabled = NO;
        }
    }
    
//    if (taskContentStr.length != 0 || self.taskImageURLArray.count != 0) {
//        BOOL  isUploadedEnd = NO;//是否有上传完毕的图片
//        NSInteger  areUploadingNum = 0;//有没有正在上传的
//        for (int i = 0; i < self.taskImageArray.count; i ++) {
//            DJImageUploadModel *model = self.taskImageArray[i];
//            if ([model.imageState isEqualToString:@"1"]) {
//                isUploadedEnd = YES;
//                break;
//            }else if([model.imageState isEqualToString:@"0"]){
//                areUploadingNum ++;
//                break;
//            }
//        }
//        if (isUploadedEnd) {
//            [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(30, 139, 223, 1) forState:(UIControlStateNormal)];
//            self.defaultNavigationBarView.rightBtn.userInteractionEnabled = YES;
//        }else {
//            [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(174, 174, 174, 1) forState:(UIControlStateNormal)];
//            self.defaultNavigationBarView.rightBtn.userInteractionEnabled = NO;
//        }
//    }else {
//        [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(174, 174, 174, 1) forState:(UIControlStateNormal)];
//        self.defaultNavigationBarView.rightBtn.userInteractionEnabled = NO;
//    }

    
    
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
