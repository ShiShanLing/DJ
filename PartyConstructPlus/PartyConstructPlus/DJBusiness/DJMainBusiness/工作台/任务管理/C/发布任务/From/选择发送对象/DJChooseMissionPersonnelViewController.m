//
//  DJChooseMissionPersonnelViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/6.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJChooseMissionPersonnelViewController.h"
#import "DJmitationWeChatSearchBoxVIew.h"
#import "DJTaskORgChooseTableViewCell.h"
#import "DJOrgMemberListView.h"
#import "DJOrgShowHeadView.h"
#import "DJTaskReleasePeopleNumShowView.h"
#import "DJOrgSearchView.h"
@interface DJChooseMissionPersonnelViewController ()<UITableViewDelegate, UITableViewDataSource, DJmitationWeChatSearchBoxVIewDelegate, DJTaskORgChooseTableViewCellDelegate, DJOrgMemberListViewDelegate, DJOrgShowHeadViewDelegate, DJOrgSearchViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *
 */
@property (nonatomic, strong)DJmitationWeChatSearchBoxVIew *searchView;
//当前展示的组织
@property (nonatomic, strong)NSMutableArray *currentShowOrgDataArray;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * orgAllDataArray;
/**
 *存储当前展示的主 组织 以及上级组织
 */
@property (nonatomic, strong)NSMutableArray *currentZOrgAndsuperOrgArray;
/**
 *组织用户展示数组
 */
@property (nonatomic, strong)DJOrgMemberListView * orgMemberListView;

/**
 *
 */
@property (nonatomic, strong)UIView * backgroundView;
/**
 *人数展示view
 */
@property (nonatomic, strong)DJTaskReleasePeopleNumShowView * peopleNumShowView;
/**
 *搜索结果展示界面
 */
@property (nonatomic, strong)DJOrgSearchView * orgSearchView;
/**
 *搜索到的用户数组
 */
@property (nonatomic, strong)NSMutableArray * searchUserArray;
/**
 *搜索到的组织数组
 */
@property (nonatomic, strong)NSMutableArray * searchOrgArray;

@end

@implementation DJChooseMissionPersonnelViewController {
    //记录当前视图展示的组织层级 进来默认展示的是二级组织
    NSInteger orgLevel;
    NSArray *currentMainOrgArray;
    NSArray *currentLowerOrgArray;
    LowerOrgModel *lowerOrgModel;//一级组织model
    LowerOrgModel *currentChooseMemberTheOrg;
    NSInteger searchType;
}
- (NSMutableArray *)searchUserArray {
    if (!_searchUserArray) {
        _searchUserArray = [NSMutableArray array];
    }
    return _searchUserArray;
}

- (NSMutableArray *)searchOrgArray {
    if (!_searchOrgArray) {
        _searchOrgArray = [NSMutableArray array];
    }
    return  _searchOrgArray;
}
- (DJOrgMemberListView *)orgMemberListView {
    if (!_orgMemberListView) {
        _orgMemberListView = [[DJOrgMemberListView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kFit(360)+kTabbarSafeBottomMargin)];
        _orgMemberListView.delegate = self;
    }
    return _orgMemberListView;
}

- (NSMutableArray *)currentZOrgAndsuperOrgArray {
    if (!_currentZOrgAndsuperOrgArray) {
        _currentZOrgAndsuperOrgArray  = [NSMutableArray array];
    }
    return _currentZOrgAndsuperOrgArray;
}

- (NSMutableArray *)currentShowOrgDataArray {
    if (!_currentShowOrgDataArray) {
        _currentShowOrgDataArray = [NSMutableArray array];
    }
    return _currentShowOrgDataArray;
}

- (NSMutableArray *)orgAllDataArray {
    if (!_orgAllDataArray) {
        _orgAllDataArray = [NSMutableArray array];
    }
    return _orgAllDataArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    NSArray *datarray =  [self queryModel:@"OrgInfoModel"];
    
    lowerOrgModel  =[NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    lowerOrgModel.orgId = [self getDefaultOrg].orgId;
    lowerOrgModel.name = [self getDefaultOrg].orgName;
    lowerOrgModel.orgLevel = @"1";
    lowerOrgModel.chooseNum = @"0";
    [self.currentZOrgAndsuperOrgArray removeAllObjects];
    if (_orgAllDataArray.count != 0) {
        
        for (int i = 0; i < _orgAllDataArray.count; i ++) {
            LowerOrgModel *tempModel =_orgAllDataArray[i];
            if ([tempModel.orgId isEqualToString:lowerOrgModel.orgId]) {
                [self.currentZOrgAndsuperOrgArray addObject:tempModel];
                [self.currentShowOrgDataArray addObject:tempModel];
                NSLog(@"lowerOrgModel%@", tempModel);
                break;
            }
        }
        
        if (self.self.currentShowOrgDataArray.count == 0) {
            [self.currentShowOrgDataArray addObject:lowerOrgModel];
            [self.currentZOrgAndsuperOrgArray addObject:lowerOrgModel];
            [self.orgAllDataArray addObject:lowerOrgModel];

        }
    }else {
        [self.currentShowOrgDataArray addObject:lowerOrgModel];
        [self.currentZOrgAndsuperOrgArray addObject:lowerOrgModel];
        [self.orgAllDataArray addObject:lowerOrgModel];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    searchType = 0;
    orgLevel = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    ////数组 存储二级组织 存储一顿 对象  组织的ID对应的组织的详情信息 包括组织内的人员和组织内的下级组织 以及级别
    
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"选择发送对象";
    self.defaultNavigationBarView.rightBtn.hidden= YES;
    
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    self.defaultNavigationBarView.SegmentationLineLabel.hidden = YES;
    [self.view addSubview:self.defaultNavigationBarView];
    
    self.searchView = [[DJmitationWeChatSearchBoxVIew alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, 40)];
    _searchView.delegate = self;
    _searchView.searchType = 0;
    _searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchView];
    [self getOrgData];
    [self createTableView];
    
    self.peopleNumShowView= [[DJTaskReleasePeopleNumShowView alloc] init];
    [self.peopleNumShowView.determineBtn addTarget:self action:@selector(handleDetermineBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_peopleNumShowView];
    _peopleNumShowView.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(kFit(60)+kTabbarSafeBottomMargin);
    [self updateChooseUserNum];
}

- (void)handleDetermineBtn {
    NSMutableArray *totalArray = [NSMutableArray array];
    for (int i = 0; i <self.orgAllDataArray.count; i++) {
        LowerOrgModel *model = self.orgAllDataArray[i];
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
            model.isSelectAll = @"10";
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
            [totalArray addObject:NModel];
            NSLog(@"NModel%pmodel%p", NModel, model);
        }
    }
    NSLog(@"totalArray%@  self.orgAllDataArray%@", totalArray, self.orgAllDataArray);
    
    self.taskReceiveUser(totalArray);
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)handleReturnBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取主组织下级组织
- (void)getOrgData {
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"orgId"] = [DJUserTool  getUserOrgAndCustom];
    [self  getJSONDataWithUrl:kURL_LowerOrg parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self parsingOrgData:responseObject];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
//获取下级组织
- (void)queryLowerOrganizations:(LowerOrgModel *)model {
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"orgId"] = model.orgId;
    [self showHud:@"正在获取组织信息" title:nil];
    [self  getJSONDataWithUrl:kURL_LowerOrg parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"获取下级组织%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSArray *orgArray  =responseObject[@"response"];
            
            orgLevel = model.orgLevel.integerValue;
            [self.currentShowOrgDataArray removeAllObjects];
            [self.currentShowOrgDataArray addObject:model];
            [self.currentZOrgAndsuperOrgArray addObject:model];//然后把点击的这个组织存进数据的下标0
            [self parsingOrgData:responseObject];
            
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        [self hudDissmiss];
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
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
        [self ShowWarningHudMid:@"该组织无成员"];
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
    //刷新当前界面数据数组
    for (int i= 0; i< self.currentShowOrgDataArray.count; i ++) {
        LowerOrgModel *model = self.currentShowOrgDataArray[i];
        if ([model.orgId isEqualToString:currentChooseMemberTheOrg.orgId]) {
            self.currentShowOrgDataArray[i] = currentChooseMemberTheOrg;
        }
    }
    [self updateChooseUserNum];
}

//获取组织成员
- (void)getOrgUser:(NSString *)orgId  type:(NSInteger)type{//type  0 单选 1直接全选
    
    [self showHud:@"正在获取组织用户" title:nil];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:orgId forKey:@"orgId"];
    NSLog(@"URL_Dic%@", URL_Dic);
    [self getJSONDataWithUrl:kURL_orgUser parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"正在获取组织用户%@", responseObject);
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
        [self hudDissmiss];
        NSLog(@"获取组织成员%@", responseObject);
    } failure:^(NSError *error) {
        [self hudDissmiss];
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
    
    
    
    NSArray *memberArray = (NSArray *)currentChooseMemberTheOrg.orgUser;
    
    if (memberArray.count != 0) {
        for (int i = 0; i < memberArray.count; i ++) {//遍历旧数组
            LowerOrgUserModel *oldModel =memberArray[i];
            if ([oldModel.state isEqualToString:@"1"]) {//如果旧数组里面的状态值是1
                for (int j  = 0; j < tempArray.count; j++) {//那么就遍历新数组并把改人员状态改为1
                    LowerOrgUserModel *  newModel = tempArray[j];
                    if ([oldModel.userId isEqualToString:newModel.userId] && [oldModel.orgId isEqualToString:newModel.orgId]) {
                        NSLog(@"oldModel.name%@  newModel.name%@",oldModel.userId,  newModel.userId);
                        newModel.state = @"1";
                        tempArray[j] = newModel;
                    }
                }
            }
        }
    }
    NSLog(@"tempArray%@", tempArray);
    [self chooseMemberReceive:tempArray];
    
    
}

//解析组织数据
- (void)parsingOrgData:(NSDictionary *)dataDic  {
    
    for (int i = 0; i < self.currentShowOrgDataArray.count; i ++) {
        LowerOrgModel *model  =self.currentShowOrgDataArray[i];
        NSLog(@"parsingOrgData%@", model);
    }
    
    if (![dataDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *orgArray  =dataDic[@"response"];
    if (![orgArray isKindOfClass:[NSArray class]]) {
        return;
    }
    for (NSDictionary *orgDic in orgArray) {
        if (![orgDic isKindOfClass:[NSDictionary class]]) {
            break;
        }
        
        LowerOrgModel *model  =[NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in orgDic) {
            
            [model setValue:orgDic[key] forKey:key];
            
        }
        BOOL isExistence;
        isExistence = NO;
        
        for (int i = 0 ; i < self.orgAllDataArray.count; i ++) {
            LowerOrgModel *tempModel = self.orgAllDataArray[i];
            if ([tempModel.orgId isEqualToString:model.orgId]) {//如果大数组里面有这个组织就把该组织添加进当前组织数组里面
                isExistence = YES;
                [self.currentShowOrgDataArray addObject:tempModel];//吧获取的当前下级组织存进数组
            }
        }
        if (isExistence) {//如果是YES 那么说明大数组里面有数据 而且当前组织数组已经添加该组织
            
        }else {//否则就说明大数组里面没有改组织  吧该组织添加进大数组 并添加进当前数组;
            model.chooseNum = @"0";
            [self.orgAllDataArray addObject:model];
            model.chooseNum = @"0";
            [self.currentShowOrgDataArray addObject:model];//吧获取的当前下级组织存进数组
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+40, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight - 40-50-kTabbarSafeBottomMargin) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces  = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJTaskORgChooseTableViewCell class] forCellReuseIdentifier:@"DJTaskORgChooseTableViewCell"];
    [self.view addSubview:_tableView];
    
    self.orgSearchView = [[DJOrgSearchView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+40, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight - 40-50-kTabbarSafeBottomMargin)];
    _orgSearchView.alpha = 0.0;
    
    _orgSearchView.delegate = self;
    [self.view addSubview:_orgSearchView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentShowOrgDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJTaskORgChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskORgChooseTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LowerOrgModel *model =  self.currentShowOrgDataArray[indexPath.row];
    cell.indexPath= indexPath;
    cell.model = model;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    LowerOrgModel *model =  self.currentShowOrgDataArray[indexPath.row];
    LowerOrgModel *tempModel = model;
    [self queryLowerOrganizations:tempModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.currentZOrgAndsuperOrgArray.count>1) {
        NSString *Str= @"";
        for (int i = 0; i < self.currentZOrgAndsuperOrgArray.count; i++) {
            LowerOrgModel *model = self.currentZOrgAndsuperOrgArray[i];
            Str = [NSString stringWithFormat:@"%@  %@",Str, model.name];
        }
        CGSize _textLabelSize  = [Str boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
        return _textLabelSize.height + 25;
    }else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.currentZOrgAndsuperOrgArray.count>1) {
        NSString *Str= @"";
        NSMutableArray *orgNameArray = [NSMutableArray array];
        for (int i = 0; i < self.currentZOrgAndsuperOrgArray.count; i++) {
            
            LowerOrgModel *model = self.currentZOrgAndsuperOrgArray[i];
            Str = [NSString stringWithFormat:@"%@%@",Str, model.name];
            [orgNameArray addObject:model.name];
        }
        CGSize _textLabelSize  = [Str boundingRectWithSize:CGSizeMake(kScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
        DJOrgShowHeadView  *headView  = [[DJOrgShowHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _textLabelSize.height)];
        headView.delegate = self;
        
        [headView  protocolIsSelect:orgNameArray];
        
        headView.backgroundColor = kColorRGB(246, 246, 246, 1);
        return headView;
    }else {
        UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
        return headView;
    }
}

#pragma mark  DJOrgShowHeadViewDelegate
- (void)OrgNameClick:(NSInteger)index {
    NSLog(@"你点击的%ld级组织", index);
    LowerOrgModel *model = self.currentZOrgAndsuperOrgArray[index-1];//这是要返回的组织
    for (int i = self.currentZOrgAndsuperOrgArray.count-1; i >=index-1; i --) {
        [self.currentZOrgAndsuperOrgArray removeObjectAtIndex:i];
    }
    NSLog(@"self.currentZOrgAndsuperOrgArray%@", self.currentZOrgAndsuperOrgArray);
    [self queryLowerOrganizations:model];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return footerView;
    
}
#define mark  DJTaskORgChooseTableViewCellDelegate
/**
 全选组织 或者反选
 */
- (void)OrgChooseStateBtn:(NSIndexPath *)indexPath {
    
    LowerOrgModel *model = self.currentShowOrgDataArray[indexPath.row];
    BOOL isExistence;//是否存在组织旧数据
    isExistence = NO;
    for (int i  =0; i < self.orgAllDataArray.count; i ++) {
        LowerOrgModel *tempModel  =self.orgAllDataArray[i];
        if ([model.orgId isEqualToString:tempModel.orgId]) {
            currentChooseMemberTheOrg = tempModel;
            isExistence = YES;
        }
    }
    if (!isExistence) {
        currentChooseMemberTheOrg = model;
    }
    
    if ([currentChooseMemberTheOrg.isSelectAll isEqualToString:@"1"]) {
        NSMutableArray  *tempArray =[NSMutableArray arrayWithArray:(NSArray *)currentChooseMemberTheOrg.orgUser];
        for (int j  = 0; j < tempArray.count; j++) {//那么就遍历新数组并把改人员状态改为1
            LowerOrgUserModel *  newModel = tempArray[j];
            newModel.state = @"0";
            tempArray[j] = newModel;
        }
        currentChooseMemberTheOrg.isSelectAll = @"0";
        currentChooseMemberTheOrg.chooseNum = @"0";
        currentChooseMemberTheOrg.orgUser = tempArray;
        [self updateChooseUserNum];
        
    }else {
        [self getOrgUser:model.orgId type:1];
    }
}
/**
 选择人员
 */
- (void)peopleChooseStateBtn:(NSIndexPath *)indexPath {//选择人员的时候需要先对比所有的组织数组里面有没有改组织如果有就使用旧数据
    LowerOrgModel *model = self.currentShowOrgDataArray[indexPath.row];
    BOOL isExistence;//是否存在组织旧数据
    isExistence = NO;
    for (int i  =0; i < self.orgAllDataArray.count; i ++) {
        LowerOrgModel *tempModel  =self.orgAllDataArray[i];
        if ([model.orgId isEqualToString:tempModel.orgId]) {
            currentChooseMemberTheOrg = tempModel;
            isExistence = YES;
        }
    }
    if (!isExistence) {
        currentChooseMemberTheOrg = model;
    }
    [self getOrgUser:model.orgId type:0];
    
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
    self.orgMemberListView.dataArray = memberArray;
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
- (void)handlechooseMemberViewHidden {
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakself.backgroundView removeFromSuperview];
        weakself.orgMemberListView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kFit(360)+kTabbarSafeBottomMargin);
    } completion:^(BOOL finished) {
        [weakself.orgMemberListView removeFromSuperview];
        currentChooseMemberTheOrg = nil;
    }];
    
}
#pragma maek DJOrgMemberListViewDelegate
- (void)orgMembersEdit:(NSArray *)memberArray {
    //    这里 需要先 吧获取的用户信息存入 当前操作的model里面 然后拿着这个model去所有的model数组里面找到该model然后赋值
    
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
    //刷新当前界面数据数组
    for (int i= 0; i< self.currentShowOrgDataArray.count; i ++) {
        LowerOrgModel *model = self.currentShowOrgDataArray[i];
        if ([model.orgId isEqualToString:currentChooseMemberTheOrg.orgId]) {
            model = currentChooseMemberTheOrg;
            NSLog(@"model.orgId------%@", model.isSelectAll);
            self.currentShowOrgDataArray[i] = model;
        }
    }
    
    [self updateChooseUserNum];
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


//刷新当前选择的用户数量
- (void)updateChooseUserNum {
    
    for (int i = 0; i < self.orgAllDataArray.count; i ++) {
        LowerOrgModel *orgModel = self.orgAllDataArray[i];
        NSArray *memberArray = (NSArray *)orgModel.orgUser;
        NSInteger chooseNum = 0;
        for (int i = 0; i  < memberArray.count; i ++) {
            LowerOrgUserModel *model = memberArray[i];
            if ([model.state isEqualToString:@"1"]) {
                chooseNum ++;
            }
        }
        orgModel.chooseNum = [NSString stringWithFormat:@"%ld", chooseNum];
        self.orgAllDataArray[i] = orgModel;
    }
    
    
    NSInteger totalNum = 0;
    for (int i = 0; i < self.orgAllDataArray.count; i ++) {//刷新大数组
        LowerOrgModel *model = self.orgAllDataArray[i];
        totalNum += model.chooseNum.integerValue;
        
        if ([model.orgId isEqualToString:currentChooseMemberTheOrg.orgId]) {
            self.orgAllDataArray[i] = currentChooseMemberTheOrg;
        }
    }
    
    if (totalNum == 0) {
        self.peopleNumShowView.numShowLabel.text = @"未选择";
        self.peopleNumShowView.numShowLabel.textColor = kColorRGB(173, 173, 173, 1);
        self.peopleNumShowView.gradientLayer.hidden  = YES;
        self.peopleNumShowView.determineBtn.userInteractionEnabled = NO;
        
    }else {
        self.peopleNumShowView.numShowLabel.text = [NSString stringWithFormat:@"已选择:  %ld人", totalNum];
        self.peopleNumShowView.numShowLabel.textColor = kColorRGB(251, 88, 68, 1);
        self.peopleNumShowView.gradientLayer.hidden  = NO;
        self.peopleNumShowView.determineBtn.userInteractionEnabled = YES;
    }
    [self.tableView reloadData];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)setEchoOrgUserArray:(NSArray *)echoOrgUserArray {
    _echoOrgUserArray = echoOrgUserArray;
    _orgAllDataArray = [NSMutableArray arrayWithArray:echoOrgUserArray];
    NSLog(@"echoOrgUserArray%@", echoOrgUserArray);
    [_tableView reloadData];
}

#pragma mark DJOrgSearchViewDelegate
- (void)viewResponse {
    [self.searchView.searchTF resignFirstResponder];
    
}

- (void)SearchType:(NSInteger)type {
    searchType = type;
    
    if (_searchView.searchType != type) {
        _searchView.searchType = type;
        self.searchView.searchTF.text = @"";
        if (self.searchView.searchTF.text.length != 0) {
            [self searchUserOrOrgData:self.searchView.searchTF.text];
        }
    }else {
        
    }
}

//当组织人员发生变化的时候,
- (void)orgInfoChange:(LowerOrgModel *)orgModel {
    //    先判断 总数组里面有没有该组织
    BOOL isExistence = NO;
    for (int i = 0;  i< self.orgAllDataArray.count; i ++) {
        LowerOrgModel *tempModel = self.orgAllDataArray[i];
        if ([tempModel.orgId isEqualToString:orgModel.orgId]) {
            isExistence = YES;
            tempModel.orgUser = orgModel.orgUser;
            self.orgAllDataArray[i] = tempModel;
        }
    }
    if (!isExistence) {
        [self.orgAllDataArray addObject:orgModel];
    }
    
    self.orgSearchView.allOrgDataArray = self.orgAllDataArray;
    
    [self updateChooseUserNum];
}
//当人员信息发生变化的时候
- (void)userInfoChange:(LowerOrgUserModel *)userModel orgAlUser:(NSArray *)orgAlUserArray {
    
    BOOL isExistenceUser = NO;
    for (int i = 0;  i< self.orgAllDataArray.count; i ++) {//判断如果大数组中如果有该组织就把组织人员信息记录进去
        LowerOrgModel *tempModel = self.orgAllDataArray[i];
        NSMutableArray *userArray = [NSMutableArray arrayWithArray:(NSArray *)tempModel.orgUser];
        for (int  j = 0; j  < userArray.count; j++) {
            LowerOrgUserModel *tempUserModel = userArray[j];
            if ([userModel.userId  isEqualToString:tempUserModel.userId] && [userModel.orgId  isEqualToString:tempUserModel.orgId]) {
                isExistenceUser = YES;
                //                tempUserModel.state = userModel.state;
                userArray[j] = userModel;
                tempModel.orgUser = userArray;
                self.orgAllDataArray[i] = tempModel;
            }
        }
        
        for (int j = 0; j < self.orgAllDataArray.count; j ++) {//判断如果该该组织的人员没有全选就把全选状态取消
            LowerOrgModel *tempModel = self.orgAllDataArray[i];
            NSMutableArray *userArray = [NSMutableArray arrayWithArray:(NSArray *)tempModel.orgUser];
            NSInteger chooseNum = 0;//已经选择的人数
            if ([tempModel.orgId isEqualToString:userModel.orgId]) {
                for (int  j = 0; j  < userArray.count; j++) {
                    LowerOrgUserModel *tempUserModel = userArray[j];
                    if (![tempUserModel.state isEqualToString:@"1"]) {
                        
                    }else {
                        chooseNum ++;
                    }
                }
                if (chooseNum == orgAlUserArray.count) {
                    tempModel.isSelectAll = @"1";
                }else {
                    tempModel.isSelectAll = @"0";
                    
                }
            }
            self.orgAllDataArray[i] = tempModel;
        }
    }
    if (!isExistenceUser) {//如果大数组中没有该人员 那么就添加一个组织
        LowerOrgModel *newModel = [NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        newModel.orgId = userModel.orgId;
        newModel.name = userModel.orgName;
        newModel.orgUser = @[userModel];
        [self.orgAllDataArray addObject:newModel];
    }
    
    self.orgSearchView.allOrgDataArray = self.orgAllDataArray;
    [self updateChooseUserNum];
}
//点击历史搜索记录的关键字进行搜索
- (void)QuickSearch:(NSString *)searchStr {
    [self searchUserOrOrgData:searchStr];
}
#pragma mark DJmitationWeChatSearchBoxVIewDelegate
/**
 开始搜索
 */
- (void)BeginYourSearch {
    CGRect frame1 = self.defaultNavigationBarView.frame;
    CGRect frame2 = self.searchView.frame;
    CGRect frame3 = self.tableView.frame;
    frame1.origin.y = -kStatusBarAndNavigationBarHeight;
    frame2.origin.y = 24+kXNavigationBarExtraHeight;
    frame3.origin.y = 64+kXNavigationBarExtraHeight;
    frame3.size.height = kScreenHeight-64-kXNavigationBarExtraHeight;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.defaultNavigationBarView.frame =frame1;
        weakself.searchView.frame = frame2;
        weakself.tableView.frame=frame3;
        weakself.orgSearchView.alpha = 1.0;
        weakself.orgSearchView.frame = frame3;
    } completion:^(BOOL finished) {
        weakself.orgSearchView.allOrgDataArray = self.orgAllDataArray;
    }];
}

/**
 结束搜索
 */
-(void)endSearch {
    [self.tableView reloadData];
    self.orgSearchView.searchType = 0;
    self.searchView.searchType = 0;
    self.orgSearchView.searchStr = @"";
    self.searchView.searchTF.text = @"";
    self.orgSearchView.searchDataArray = @[];
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.defaultNavigationBarView.frame =CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight);
        weakself.searchView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, 40);
        weakself.tableView.frame=CGRectMake(0, kStatusBarAndNavigationBarHeight+40, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight - 40);
        weakself.orgSearchView.alpha = 0.0;
        weakself.orgSearchView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight+40, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight - 40);
    } completion:^(BOOL finished) {
        
    }];
}

/**
 搜索进行网络请求
 */
- (void)searchNetworkRequest {
    self.orgSearchView.searchStr = self.searchView.searchTF.text;
    [self searchUserOrOrgData:self.searchView.searchTF.text];
    
}


#pragma mark  搜索人员或者组织的网络请求
- (void)searchUserOrOrgData:(NSString *)searchStr{
    [self.searchUserArray removeAllObjects];
    self.searchView.searchTF.text = searchStr;
    NSMutableArray  *meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
    
    OrgInfoModel *orgModel = [NSEntityDescription insertNewObjectForEntityForName:@"OrgInfoModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    
    for (int i = 0; i <meunArray.count; i ++) {
        OrgInfoModel *orgInfoModel = meunArray[i];
        if ([orgInfoModel.defaultState isEqualToString:@"1"]) {
            orgModel = orgInfoModel;
        }
    }
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:orgModel.orgId forKey:@"orgId"];
    [URL_Dic setValue:searchStr forKey:@"text"];
    if (searchType == 0) {
        [URL_Dic setValue:@"user" forKey:@"type"];
    }else {
        [URL_Dic setValue:@"org" forKey:@"type"];
    }
    NSLog(@"URL_Dic%@", URL_Dic);
    [self showHud:@"" title:@""];
    [self  getJSONDataWithUrl:kURL_fuzzySearchUserOrOrg parameters:URL_Dic success:^(id responseObject) {
        [self hudDissmiss];
        NSLog(@"responseObject%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            if (searchType == 0) {
                [self parsingSearchUserData:responseObject];
            }else {
                [self parsingSearchOrgData:responseObject];
            }
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self hudDissmiss];
        [self ShowWarningHudMid:@"网络请求失败.请重试!"];
    }];
}

- (void)parsingSearchUserData:(NSDictionary *)userData {
    
    if (![userData isKindOfClass:[NSDictionary class]]) {
        
        return;
    }
    NSArray *responseArray  = userData[@"response"];
    if (![responseArray isKindOfClass:[NSArray class] ]) {
        
        return;
    }
    
    if (responseArray.count == 0) {
        //        [self ShowWarningHudMid:@"没有查到该用户"];
        self.orgSearchView.searchDataArray = @[];
        [self.tableView reloadData];
        return;
    }
    
    for (NSDictionary *userDic in responseArray) {
        LowerOrgUserModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgUserModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in userDic) {
            [model setValue:userDic[key] forKey:key];
        }
        [self.searchUserArray addObject:model];
    }
    
    
    for (int i = 0; i < self.searchUserArray.count; i ++) {
        LowerOrgUserModel *searchModel = self.searchUserArray[i];
        for (int j = 0; j  < self.orgAllDataArray.count; j ++) {
            LowerOrgModel *oldModel = self.orgAllDataArray[j];
            NSMutableArray *userArray = [NSMutableArray arrayWithArray:(NSArray *)oldModel.orgUser];
            for (int k = 0; k  < userArray.count; k ++) {
                LowerOrgUserModel *userModel = userArray[k];
                if ([userModel.userId isEqualToString:searchModel.userId] && [userModel.orgId isEqualToString:searchModel.orgId]) {
                    searchModel.state = userModel.state;
                    self.searchUserArray[i] = searchModel;
                }
            }
        }
    }
    self.orgSearchView.searchType = 0;
    
    self.orgSearchView.searchDataArray = self.searchUserArray;
    
}

- (void)parsingSearchOrgData:(NSDictionary *)orgData {
    [self.searchOrgArray removeAllObjects];
    if (![orgData isKindOfClass:[NSDictionary class]]) {
        
        return;
    }
    NSArray *responseArray  = orgData[@"response"];
    if (![responseArray isKindOfClass:[NSArray class] ]) {
        
        return;
    }
    
    if (responseArray.count == 0) {
        //        [self ShowWarningHudMid:@"没有查到该组织"];
        self.orgSearchView.searchDataArray = self.searchOrgArray;
        return;
    }
    
    for (NSDictionary *userDic in responseArray) {
        LowerOrgModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"LowerOrgModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in userDic) {
            [model setValue:userDic[key] forKey:key];
        }
        BOOL isExistence;
        isExistence = NO;
        for (int i = 0 ; i < self.orgAllDataArray.count; i ++) {
            LowerOrgModel *tempModel = self.orgAllDataArray[i];
            if ([tempModel.orgId isEqualToString:model.orgId]) {//如果大数组里面有这个组织就把该组织添加进当前组织数组里面
                isExistence = YES;
                [self.searchOrgArray addObject:tempModel];
                break;
            }
        }
        if (isExistence) {
            
        }else {
            [self.searchOrgArray addObject:model];
        }
    }
    for (int i = 0; i < self.searchOrgArray.count; i ++) {
        LowerOrgModel *searchModel = self.searchOrgArray[i];
        for (int j = 0; j  < self.orgAllDataArray.count; j ++) {
            LowerOrgModel *oldModel = self.orgAllDataArray[j];
            if ([searchModel.orgId isEqualToString:oldModel.orgId]) {
                searchModel.orgUser = oldModel.orgUser;
                self.searchOrgArray[i] = searchModel;
            }
        }
    }
    self.orgSearchView.searchType = 1;
    self.orgSearchView.searchDataArray = self.searchOrgArray;
}



@end
