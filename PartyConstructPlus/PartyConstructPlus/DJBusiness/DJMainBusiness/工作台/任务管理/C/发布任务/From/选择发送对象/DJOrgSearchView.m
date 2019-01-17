//
//  DJOrgSearchView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJOrgSearchView.h"
#import "DJTaskSendObjectTypeChooseView.h"
#import "DJBaseViewController.h"
#import "DJTaskORgChooseTableViewCell.h"
#import "DJOrgMemberListView.h"
#import "DJTaskUserChooseTableViewCell.h"
@interface DJOrgSearchView ()<UITableViewDelegate, UITableViewDataSource, DJTaskSendObjectTypeChooseViewDelegate, DJTaskORgChooseTableViewCellDelegate, DJOrgMemberListViewDelegate, UIGestureRecognizerDelegate>


@property (nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)DJCoreDataManager *djCoreDataManager;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * orgUserArray;
/**
 *
 */
@property (nonatomic, strong)UIView * backgroundView;
/**
 *
 */
@property (nonatomic, strong)DJOrgMemberListView * orgMemberListView;

/**
 *搜索的历史记录
 */
@property (nonatomic, strong)NSMutableArray * searchHistoricalRecordArray;
/**
 *
 */
@property (nonatomic, strong)DJTaskSendObjectTypeChooseView *searchTypeChooseView ;
/**
 *空白界面
 */
@property (nonatomic, strong)DJDataEmptyView * dataEmptyView;
@end

@implementation DJOrgSearchView {
    BOOL SelectAll;
    LowerOrgModel *currentChooseMemberTheOrg;
    MBProgressHUD *newhud;
}

- (NSMutableArray *)searchHistoricalRecordArray {
    if (!_searchHistoricalRecordArray) {
        _searchHistoricalRecordArray = [NSMutableArray array];
    }
    return _searchHistoricalRecordArray;
}

- (NSMutableArray *)orgUserArray {
    if (!_orgUserArray) {
        _orgUserArray  =[NSMutableArray array];
    }
    return _orgUserArray;
}

- (DJOrgMemberListView *)orgMemberListView {
    if (!_orgMemberListView) {
        _orgMemberListView = [[DJOrgMemberListView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kFit(360)+kTabbarSafeBottomMargin)];
        _orgMemberListView.delegate = self;
    }
    return _orgMemberListView;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.djCoreDataManager =  [DJCoreDataManager shareInstance];
        self.searchType = 0;
        
        [self createTableView];
    }
    return self;
}

- (void)createTableView {
    //搞38
    self.searchTypeChooseView = [[DJTaskSendObjectTypeChooseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
    _searchTypeChooseView.delegate = self;
    _searchTypeChooseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_searchTypeChooseView];
    UITapGestureRecognizer *typeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleTypeViewTap)];
    typeViewTap.numberOfTouchesRequired = 1; //手指数
    typeViewTap.numberOfTapsRequired = 1; //tap次数
    [_searchTypeChooseView addGestureRecognizer:typeViewTap];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 38, kScreenWidth, self.height) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[DJTaskUserChooseTableViewCell class] forCellReuseIdentifier:@"DJTaskUserChooseTableViewCell"];
    [_tableView registerClass:[DJTaskORgChooseTableViewCell class] forCellReuseIdentifier:@"DJTaskORgChooseTableViewCell"];
    
    [self addSubview:_tableView];
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, 38, self.width, self.height)];
    self.dataEmptyView.dividerLabel.hidden = YES;
    self.dataEmptyView.hidden = YES;
    self.dataEmptyView.userInteractionEnabled = NO;
    self.dataEmptyView.promptLabel.text = @"没有其他结果,试试其他关键字吧!";
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_search_empty"];
    [self addSubview:self.dataEmptyView];
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleViewClick)];
    tapG.numberOfTouchesRequired = 1; //手指数
    tapG.numberOfTapsRequired = 1; //tap次数
    tapG.delegate = self;
    [_tableView addGestureRecognizer:tapG];

    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleViewClick)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [_tableView addGestureRecognizer:recognizer];
    

}


- (void)handleViewClick {
    if ([_delegate respondsToSelector:@selector(viewResponse)]) {
        [_delegate viewResponse];
    }
}

- (void)handleTypeViewTap {
    if ([_delegate respondsToSelector:@selector(viewResponse)]) {
        [_delegate viewResponse];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchDataArray.count == 0) {
        if (self.searchStr.length == 0) {
            NSLog(@"self.searchHistoricalRecordArray%@", self.searchHistoricalRecordArray);
                return self.searchHistoricalRecordArray.count;
            
        }else {
            return 0;
        }
    }else {
        return self.searchDataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchDataArray.count == 0  && self.searchHistoricalRecordArray.count != 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.searchHistoricalRecordArray[indexPath.row];
        cell.imageView.image = nil;
        return cell;
    }else {
        if (self.searchType == 0) {
            DJTaskUserChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskUserChooseTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            LowerOrgUserModel *model =  self.searchDataArray[indexPath.row];
            if (![model.state isEqualToString:@"1"]) {
                [cell.iconBtn setImage:[UIImage imageNamed:@"DJLeaveOff"] forState:(UIControlStateNormal)];
            }else {
                [cell.iconBtn setImage:[UIImage imageNamed:@"DJLeaveOn"] forState:(UIControlStateNormal)];
            }
            cell.titleLabel.text = model.userName;
            cell.subTitleLabel.text = model.orgName;
            return cell;
        }else {
            DJTaskORgChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskORgChooseTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            LowerOrgModel *model =  self.searchDataArray[indexPath.row];
            cell.searchOrgModel = model;
            cell.indexPath = indexPath;
            cell.arrowBtn.hidden = YES;
            cell.delegate = self;
            return cell;
        }
    }
}
/**
 全选组织 或者反选
 
 @param indexPath cell所属下标
 */
- (void)OrgChooseStateBtn:(NSIndexPath *)indexPath {
    
    LowerOrgModel *model = self.searchDataArray[indexPath.row];
    currentChooseMemberTheOrg = model;
    if ([model.isSelectAll isEqualToString:@"1"]) {
        NSMutableArray  *tempArray =[NSMutableArray arrayWithArray:(NSArray *)model.orgUser];
        for (int j  = 0; j < tempArray.count; j++) {//那么就遍历新数组并把改人员状态改为1
            LowerOrgUserModel *  newModel = tempArray[j];
            newModel.state = @"0";
            tempArray[j] = newModel;
        }
        model.isSelectAll = @"0";
        model.chooseNum = @"0";
        model.orgUser = tempArray;
        //        这里需要刷新展示人数的view
        [self.tableView reloadData];
    }else {
        //获取组织人员并全选
        [self getOrgUser:model.orgId type:1];
    }
    
}

/**
 选择人员
 
 @param indexPath cell所属下标
 */
- (void)peopleChooseStateBtn:(NSIndexPath *)indexPath {
    
    LowerOrgModel *model = self.searchDataArray[indexPath.row];
    currentChooseMemberTheOrg = model;
    [self getOrgUser:model.orgId type:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self handleViewClick];
    if (self.searchDataArray.count == 0) {
        NSString * userName = self.searchHistoricalRecordArray[indexPath.row];
        self.searchStr = userName;
        if ([_delegate respondsToSelector:@selector(QuickSearch:)]) {
            [_delegate QuickSearch:userName];
        }
    }else {
    if (self.searchType == 0) {
            LowerOrgUserModel *model =  self.searchDataArray[indexPath.row];

            [self AccordingUserGetUserOrgAlluser:model indexPath:indexPath];
        
        
        }
    }
        [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
      if (self.searchDataArray.count == 0  && self.searchHistoricalRecordArray.count != 0) {
          return 50;
      }else {
          if (self.searchType == 0) {
              return kFit(65);
          }else {
              return 50;
          }
      }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.searchDataArray.count == 0) {
        if (self.searchStr.length == 0) {
            return 52;
        }else {
            return 0.01;
        }
    }else {
        return 52;
    }
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView  = [[UIView alloc] init];
    
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, kScreenWidth, 52);
     UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFit(15), 22, 120, 16)];
    titleLabel.textColor = kColorRGB(51, 51, 51, 1);
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [headView addSubview:titleLabel];
        if (self.searchStr.length == 0) {
            if (self.searchHistoricalRecordArray.count == 0) {
                titleLabel.text = @"";
            }else {
                titleLabel.text = @"历史搜索";
                UIButton *deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [deleteBtn setImage:[UIImage imageNamed:@"DJ_delete_search"] forState:(UIControlStateNormal)];
                deleteBtn.frame = CGRectMake(kScreenWidth -48, 17, 48, 35);
                [deleteBtn addTarget:self action:@selector(handleDeleteBtn) forControlEvents:(UIControlEventTouchUpInside)];
                [headView addSubview:deleteBtn];
                UILabel *dividerLabel = [UILabel new];
                dividerLabel.backgroundColor = kCellColorDivider;
                [headView addSubview:dividerLabel];
                dividerLabel.sd_layout.leftSpaceToView(headView, kFit(15)).bottomSpaceToView(headView, 0).heightIs(kCellDividerHeight).rightSpaceToView(headView, 0);
            }
        }else {
            titleLabel.text = @"搜索结果";
        }
        
        

   
    return headView;
}


- (void)handleDeleteBtn {
    
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"是否清空历史记录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self DeleteDataType:self.searchType];
        
        [self.searchHistoricalRecordArray removeAllObjects];
        [self.tableView reloadData];
    }];
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    [alertV addAction:cancle];
    [alertV addAction:confirm];
    // 4.控制器 展示弹框控件，完成时不做操作
    
    DJBaseViewController *VC = [[DJBaseViewController alloc] init];
    VC.view = self;
    [VC presentViewController:alertV animated:YES completion:^{
        nil;
    }];

    

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return footerView;
    
}



#pragma  mark  DJTaskSendObjectTypeChooseViewDelegate

- (void)switchSearchTypes:(NSInteger)index {
    if (self.searchDataArray.count != 0){
        [self.searchDataArray removeAllObjects];
    }
    self.searchStr = @"";
    self.searchType = index;
    _dataEmptyView.hidden = YES;
    [self.searchDataArray removeAllObjects];
    [self takeData:self.searchType];
    if ([_delegate respondsToSelector:@selector(SearchType:)]) {
        [_delegate SearchType:index];
    }
}

-(void)setSearchDataArray:(NSMutableArray *)searchDataArray {
    _searchDataArray = [NSMutableArray arrayWithArray:searchDataArray];
    if (_searchDataArray.count == 0 && _searchStr.length != 0) {
        _dataEmptyView.hidden = NO;
    }else {
        _dataEmptyView.hidden = YES;
        [_tableView reloadData];
    }
}
//获取某个人员所属组织下面的所有人
- (void)AccordingUserGetUserOrgAlluser:(LowerOrgUserModel *)model indexPath:(NSIndexPath *)indexPath{
    
    DJBaseViewController *VC = [[DJBaseViewController alloc] init];
    [VC showHud:@"正在获取组织用户" title:nil];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:model.orgId forKey:@"orgId"];
    NSLog(@"URL_Dic%@", URL_Dic);
    [VC getJSONDataWithUrl:kURL_orgUser parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self parsingUserOrgAllUser:responseObject userModel:model indexPath:indexPath];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        [VC hudDissmiss];
        NSLog(@"获取组织成员%@", responseObject);
    } failure:^(NSError *error) {
        [VC hudDissmiss];
    }];
    
}
//解析某个人员所属组织下面的所有人员
- (void)parsingUserOrgAllUser:(NSDictionary *)dataDic   userModel:(LowerOrgUserModel *)chooseModel indexPath:(NSIndexPath *)indexPath{
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *orgArray  =dataDic[@"response"];
    if (![orgArray isKindOfClass:[NSArray class]]) {
        return;
    }
    if (orgArray.count == 0) {
        
        return;
    }
    NSMutableArray *tempArray =[NSMutableArray array];
    for (NSDictionary *orgDic in orgArray) {
        LowerOrgUserModel *model  =[NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgUserModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in orgDic) {
            [model setValue:orgDic[key] forKey:key];
        }
        [tempArray addObject:model];
    }
    
    LowerOrgUserModel *model =  self.searchDataArray[indexPath.row];
    if (![model.state isEqualToString:@"1"]) {
        model.state = @"1";
    }else {
        model.state = @"0";
    }
    //每次选中一个人 那么就需要请求一下该人员所属组织有多少人,,用户计算该组织人员会否全选
    self.searchDataArray[indexPath.row] = model;
    
    if ([_delegate respondsToSelector:@selector(userInfoChange:orgAlUser:)]) {
        [_delegate userInfoChange:chooseModel orgAlUser:tempArray];
    }
    [self.tableView reloadData];
}

//获取组织成员
- (void)getOrgUser:(NSString *)orgId  type:(NSInteger)type{//type  0 单选 1直接全选
    DJBaseViewController *VC = [[DJBaseViewController alloc] init];
    [VC showHud:@"正在获取组织用户" title:nil];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:orgId forKey:@"orgId"];
    NSLog(@"URL_Dic%@", URL_Dic);
    [VC getJSONDataWithUrl:kURL_orgUser parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            if (type == 0) {
                [self parsingOrgUserData:responseObject orgId:orgId];
            }else {
                [self selectAllOrgUser:responseObject];
            }
            
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        [VC hudDissmiss];
        NSLog(@"获取组织成员%@", responseObject);
    } failure:^(NSError *error) {
        [VC hudDissmiss];
    }];
    
}
//解析组织人员数据
- (void)parsingOrgUserData:(NSDictionary *)dataDic orgId:(NSString *)orgId{
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *orgArray  =dataDic[@"response"];
    if (![orgArray isKindOfClass:[NSArray class]]) {
        return;
    }
    if (orgArray.count == 0) {
        
        return;
    }
    NSMutableArray *tempArray =[NSMutableArray array];
    for (NSDictionary *orgDic in orgArray) {
        LowerOrgUserModel *model  =[NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgUserModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in orgDic) {
            [model setValue:orgDic[key] forKey:key];
        }
        [tempArray addObject:model];
    }
    NSArray *memberArray = (NSArray *)currentChooseMemberTheOrg.orgUser;
    
    if (memberArray.count != 0) {
        for (int i = 0; i < memberArray.count; i ++) {//遍历旧数组
            LowerOrgUserModel *oldModel =memberArray[i];
            if ([oldModel.state isEqualToString:@"1"]) {//如果旧数组里面的状态值是1
                for (int j  = 0; j < tempArray.count; j++) {//那么就遍历新数组并把改人员状态改为1
                    LowerOrgUserModel *  newModel = tempArray[j];
                    if ([oldModel.userId isEqualToString:newModel.userId]) {
                        newModel.state = @"1";
                        tempArray[j] = newModel;
                    }
                }
            }
        }
    }
    NSLog(@"tempArray%@", tempArray);
    //展示人员选择界面
    [self chooseMemberReceive:tempArray];
    
    
}
//全选组织 获取全部取消
- (void)selectAllOrgUser:(NSDictionary *)dataDic {
    
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *orgArray  =dataDic[@"response"];
    if (![orgArray isKindOfClass:[NSArray class]]) {
        return;
    }
    if (orgArray.count == 0) {
        [self ShowWarningHudMid:@"该组织没有成员"];
        return;
    }
    
    NSMutableArray *tempArray =[NSMutableArray array];
    for (NSDictionary *orgDic in orgArray) {
        LowerOrgUserModel *model  =[NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgUserModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in orgDic) {
            [model setValue:orgDic[key] forKey:key];
        }
        [tempArray addObject:model];
    }
    if (![currentChooseMemberTheOrg.isSelectAll isEqualToString:@"1"]) {
        for (int j  = 0; j < tempArray.count; j++) {//那么就遍历新数组并把改人员状态改为1
            LowerOrgUserModel *  newModel = tempArray[j];
            newModel.state = @"1";
            tempArray[j] = newModel;
        }
        currentChooseMemberTheOrg.isSelectAll = @"1";
    }
    
    currentChooseMemberTheOrg.orgUser = tempArray;
    currentChooseMemberTheOrg.chooseNum = [NSString stringWithFormat:@"%ld", tempArray.count];
    
    if ([_delegate respondsToSelector:@selector(orgInfoChange:)]) {
        [_delegate orgInfoChange:currentChooseMemberTheOrg];
    }
   
    [self.tableView reloadData];
}
//警告
-(void)ShowWarningHudMid:(NSString *)message {
    
    MBProgressHUD *warning = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    warning.mode = MBProgressHUDModeText;
    warning.label.text = message;
    warning.label.textColor = [UIColor whiteColor];;
    warning.label.lineBreakMode = NSLineBreakByWordWrapping;
    warning.label.numberOfLines = 0;
    warning.bezelView.backgroundColor = [UIColor blackColor];
    warning.bezelView.alpha = 0.8;
    warning.offset = CGPointMake(0.f, 100);
    [warning hideAnimated:YES afterDelay:1.0f];
}

#pragma mark -设置hud
- (void)showHud:(NSString *)message title:(NSString *)title{
    newhud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    newhud.userInteractionEnabled = YES;
    newhud.mode = MBProgressHUDModeIndeterminate;
    newhud.backgroundView.backgroundColor =[UIColor blackColor];
    newhud.backgroundView.alpha = 0.2;
    //    UIImage *images=[UIImage sd_animatedGIFNamed:@"logo"];
    //    newhud.customView = [[UIImageView alloc] initWithImage:images];
    newhud.label.text = title;
    newhud.label.numberOfLines = 0;
    newhud.label.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:kFit(18)];
    newhud.label.textColor = kColorRGB(51, 51, 51, 1);
    newhud.detailsLabel.textColor =kColorRGB(51, 51, 51, 1);
    newhud.detailsLabel.text = message;
    newhud.detailsLabel.textAlignment = 0;
    newhud.detailsLabel.font = MFont(kFit(16));
    newhud.bezelView.backgroundColor = [UIColor whiteColor];
}
//关闭
-(void)hudDissmiss {
    [newhud hideAnimated:YES];
}


//创建一个存在于视图最上层的UIViewController
- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
//展示人员选择界面
- (void)chooseMemberReceive:(NSArray *)memberArray {
    [self.backgroundView removeFromSuperview];
    [self.orgMemberListView removeFromSuperview];
    UIViewController *VC = [self appRootViewController];
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.frame =VC.view.bounds;
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.6;
    [VC.view addSubview:self.backgroundView];
    self.orgMemberListView.titleLabel.text = [NSString stringWithFormat:@"%@人员", currentChooseMemberTheOrg.name];
    self.orgMemberListView.dataArray = [NSMutableArray arrayWithArray:memberArray];
    [VC.view addSubview:self.orgMemberListView];
    [UIView animateWithDuration:0.5 animations:^{
        self.orgMemberListView.frame = CGRectMake(0, kScreenHeight - kFit(360)-kTabbarSafeBottomMargin, kScreenWidth, kFit(360)+kTabbarSafeBottomMargin);
    }];
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handlechooseMemberViewHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    
    [self.backgroundView addGestureRecognizer:singleFingerOne];
    
}
//隐藏界面
- (void)handlechooseMemberViewHidden {
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakself.backgroundView removeFromSuperview];
        weakself.orgMemberListView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kFit(360)+kTabbarSafeBottomMargin);
    } completion:^(BOOL finished) {
        [weakself.orgMemberListView removeFromSuperview];
        self->currentChooseMemberTheOrg = nil;
    }];
    
}
//选择人员返回代理
- (void)orgMembersEdit:(NSArray *)memberArray {
    NSInteger chooseNum = 0;
    for (int i = 0; i  < memberArray.count; i ++) {
        LowerOrgUserModel *model = memberArray[i];
        if ([model.state isEqualToString:@"1"]) {
            chooseNum ++;
        }
    }
    if (chooseNum == memberArray.count) {
        currentChooseMemberTheOrg.isSelectAll = @"1";
    }else {
        currentChooseMemberTheOrg.isSelectAll = @"0";
    }
    currentChooseMemberTheOrg.orgUser = memberArray;
    currentChooseMemberTheOrg.chooseNum = [NSString stringWithFormat:@"%ld", chooseNum];
    
    if ([_delegate respondsToSelector:@selector(orgInfoChange:)]) {
        [_delegate orgInfoChange:currentChooseMemberTheOrg];
    }
    //如果刷新界面
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakself.backgroundView removeFromSuperview];
        weakself.orgMemberListView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kFit(360)+kTabbarSafeBottomMargin);
    } completion:^(BOOL finished) {
        [weakself.orgMemberListView removeFromSuperview];
        currentChooseMemberTheOrg = nil;
        [weakself.tableView reloadData];
    }];
    
}



-(void)setAllOrgDataArray:(NSMutableArray *)allOrgDataArray {
    _allOrgDataArray = allOrgDataArray;
}

- (void)setSearchType:(NSUInteger)searchType {
    __weak DJOrgSearchView *selfWeak = self;
    _searchType = searchType;
    _searchTypeChooseView.searchType = searchType;

    [selfWeak takeData:self.searchType];
}

//查询
- (void)takeData:(NSInteger )type {
    [self.searchHistoricalRecordArray removeAllObjects];
    NSString *key = @"";
    switch (type) {
        case 0:
            key = @"user";
            break;
        case 1:
            key = @"org";
            break;
        default:
            break;
    }
    //获取路径
    NSArray *obtainPath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[obtainPath objectAtIndex:0] stringByAppendingPathComponent:@"searchOrgAndUserRecord.plist"];
    NSLog(@"%@",NSHomeDirectory());
    //获取数据
    NSMutableDictionary *obtainData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:obtainData[key]];
    NSLog(@"obtainData%@", obtainData);
    if (![dataArray isKindOfClass:[NSMutableArray class]]) {
        self.searchHistoricalRecordArray = [NSMutableArray arrayWithArray:@[]];
    }else {
        self.searchHistoricalRecordArray = dataArray;
    }
    [self.tableView reloadData];
}
//删除
- (void)DeleteDataType:(NSInteger )type {
    
    NSString *key = @"";
    switch (type) {
        case 0:
            key = @"user";
            break;
        case 1:
            key = @"org";
            break;
        default:
            break;
    }
    NSArray *sandboxpath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [sandboxpath objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"searchOrgAndUserRecord.plist"];
    //存储根数据
    NSMutableDictionary *rootDic = [[NSMutableDictionary alloc ] init];
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:rootDic[key]];
    NSLog(@"删除之前的数据%@", dataArray);
    //字典中的详细数据
    [rootDic setObject:@[] forKey:key];
    //写入文件
    [rootDic writeToFile:plistPath atomically:YES];
    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"写入成功");
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
