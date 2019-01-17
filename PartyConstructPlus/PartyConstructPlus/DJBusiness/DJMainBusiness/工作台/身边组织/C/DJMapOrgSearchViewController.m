//
//  DJMapOrgSearchViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/20.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMapOrgSearchViewController.h"
#import "DJMapOrgSearchView.h"
#import <Foundation/Foundation.h>
#import "MapNearOrgModel+CoreDataProperties.h"
#import "DJMapOrgSearchShowTVCell.h"
#import "DJSearchDetailsViewController.h"
@interface DJMapOrgSearchViewController ()<DJMapOrgSearchViewDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
/**
 *
 */
@property (nonatomic, strong)DJMapOrgSearchView *searchView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * seacrhOrgArray;

@end

@implementation DJMapOrgSearchViewController {
    
    NSString *searchKeyStr;//搜索的关键字
    BOOL    isClickSearchHistory;
}
- (NSMutableArray *)seacrhOrgArray {
    if (!_seacrhOrgArray) {
        _seacrhOrgArray = [NSMutableArray array];
    }
    return _seacrhOrgArray;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isClickSearchHistory = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchView = [[DJMapOrgSearchView alloc] initWithFrame:CGRectMake(0, 24+kXNavigationBarExtraHeight, kScreenWidth, 40)];
    _searchView.delegate = self;
    [self.view addSubview:_searchView];
    [self takeSearchHistory];
//    x
    [self createTableView];
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight)];
    self.dataEmptyView.promptLabel.text = @"没有搜索到相关组织哦";
    self.dataEmptyView.dividerLabel.alpha =0;
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_sbzz_search_empty"];
    self.dataEmptyView.emptyImageView.contentMode = UIViewContentModeTop;
    self.dataEmptyView.alpha=0;
    [self.view addSubview:self.dataEmptyView];
    
    self.dataEmptyView.emptyImageView.sd_layout.widthIs((235)).heightIs(kFit(120)).centerXEqualToView(self.dataEmptyView).topSpaceToView(self.dataEmptyView, kFit(138));
    [self.dataEmptyView addSubview:self.dataEmptyView.promptLabel];
    self.dataEmptyView.promptLabel.sd_layout.leftSpaceToView(self.dataEmptyView, 0).rightSpaceToView(self.dataEmptyView, 0).topSpaceToView(self.dataEmptyView.emptyImageView, kFit(20)).autoHeightRatio(0);
}
/**
 结束搜索操作
 */
-(void)endSearch {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 搜索进行网络请求
 */
- (void)searchNetworkRequest {
    [self userDataManipulation:self.searchView.searchTF.text];
    if (self.seacrhOrgArray.count == 0) {
        [self searchAction:_searchView.searchTF.text];
    }else {
        if (self.seacrhOrgArray.count == 0) {
            return;
        }
        DJSearchDetailsViewController *VC = [[DJSearchDetailsViewController alloc] init];
        VC.orgListArray = self.seacrhOrgArray;
        VC.searchTitleStr = self.searchView.searchTF.text;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)RealTimeSearch:(NSString *)str {
    searchKeyStr = str;
    if (str.length == 0) {
        [self.seacrhOrgArray removeAllObjects];
        [self.tableView reloadData];
    }else {
        [self searchAction:str];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchAction:(NSString *)text
{
    [self.seacrhOrgArray removeAllObjects];
    [self.tableView reloadData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *contactStr = [defaults objectForKey:@"Contacts"];
    if(![contactStr isEqualToString:text]) {
        // 这货是为了取消执行延迟函数
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(callFooWithArray:) object:[NSArray arrayWithObjects:@(1), contactStr, nil]];
    }
    NSString *searchText = text;
    if (searchText.length == 0) {

    } else {
        searchText = [searchText lowercaseString];
        // 延迟函数   （这样子写是为了解决传两个值得尴尬）
        [self performSelector:@selector(callFooWithArray:) withObject:[NSArray arrayWithObjects:@(1), text, nil] afterDelay:0.3];
        [defaults setObject:text forKey:@"Contacts"];
    }
}

- (void) callFooWithArray: (NSArray *) inputArray {
    [self searchOrgName:_searchView.searchTF.text];
}

- (void)searchOrgName:(NSString *)orgName {
    [self showHud:@"" title:@""];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:orgName forKey:@"name"];
    [self getJSONDataWithUrl:kURL_mapSearchOrg parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"搜索结果%@responseObject", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self parsingSearchResults:responseObject];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
    [self hudDissmiss];
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
}

- (void)parsingSearchResults:(NSDictionary *)dataDic {
    [self.seacrhOrgArray removeAllObjects];
    if (![dataDic objectForKey:@"response"]) {
        return;
    }
    NSArray *dataArray = dataDic[@"response"];
    if (![dataArray isKindOfClass:[NSArray class]]) {
        [self emptyInterfaceLayout:1];
        return;
    }
    if (dataArray.count == 0) {
        [self emptyInterfaceLayout:1];
        return;
    }
    [self emptyInterfaceLayout:0];
    for (NSDictionary *modelDic in dataArray) {
        MapNearOrgModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"MapNearOrgModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in modelDic) {
            [model setValue:modelDic[key] forKey:key];
        }
        [self.seacrhOrgArray addObject:model];
    }
    if (isClickSearchHistory) {
        DJSearchDetailsViewController *VC = [[DJSearchDetailsViewController alloc] init];
        VC.orgListArray = self.seacrhOrgArray;
        VC.searchTitleStr = self.searchView.searchTF.text;
        [self.navigationController pushViewController:VC animated:YES];
    }else {
        [self.tableView reloadData];
    }
    
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJMapOrgSearchShowTVCell class] forCellReuseIdentifier:@"DJMapOrgSearchShowTVCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.seacrhOrgArray.count == 0) {
        
        return 0;
    }else {
        return self.seacrhOrgArray.count +1;
    }
}

- (void)handleDeleteSearchHistoryBtn {
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"是否清空历史记录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self DeleteSearchHistory];
        [self.seacrhOrgArray removeAllObjects];
        [self.tableView reloadData];
    }];
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    [alertV addAction:cancle];
    [alertV addAction:confirm];
    // 4.控制器 展示弹框控件，完成时不做操作
    [self presentViewController:alertV animated:YES completion:^{
        nil;
    }];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [deleteBtn setImage:[UIImage imageNamed:@"DJ_delete_search"] forState:(UIControlStateNormal)];
        deleteBtn.frame = CGRectMake(kScreenWidth -48, kFit(7), kFit(48), kFit(35));
        deleteBtn.backgroundColor = [UIColor whiteColor];
        [deleteBtn addTarget:self action:@selector(handleDeleteSearchHistoryBtn) forControlEvents:(UIControlEventTouchUpInside)];
        
        if (searchKeyStr.length == 0) {
            cell.textLabel.text = @"历史搜索";
            [deleteBtn setImage:[UIImage imageNamed:@"DJ_delete_search"] forState:(UIControlStateNormal)];
        }else {
            cell.textLabel.text = @"搜索结果";
            [deleteBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
            deleteBtn.userInteractionEnabled = NO;
        }
        [cell.contentView addSubview:deleteBtn];
        return cell;
    }else {
        if (searchKeyStr.length == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = self.seacrhOrgArray[indexPath.row-1];
            return cell;
        }else {
            DJMapOrgSearchShowTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJMapOrgSearchShowTVCell" forIndexPath:indexPath];
            MapNearOrgModel *model =   self.seacrhOrgArray[indexPath.row-1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model  = model;
            {
                NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: model.name];
                [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:kFit(16)] range: NSMakeRange(0, model.name.length)];
                
                NSRange range;
                range = [model.name rangeOfString:_searchView.searchTF.text];
                
                if (range.location != NSNotFound) {
                    
                    [attributedStr01 addAttribute: NSForegroundColorAttributeName value:kColorRGB(251, 85, 64, 1) range: range];
                    cell.OrgNameLabel.attributedText = attributedStr01;
                    cell.orgAddressLabel.text = model.address;
                }else{
                    range =  [model.address rangeOfString:_searchView.searchTF.text];
                    if (range.location != NSNotFound) {
                        NSMutableAttributedString *attributedStr02 = [[NSMutableAttributedString alloc] initWithString: model.address];
                        [attributedStr02 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:kFit(14)] range: NSMakeRange(0, model.address.length)];
                        [attributedStr02 addAttribute: NSForegroundColorAttributeName value:kColorRGB(251, 85, 64, 1) range: range];
                        cell.OrgNameLabel.text = model.name;
                        cell.orgAddressLabel.attributedText = attributedStr02;
                    }else {
                        
                    }
                }
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (searchKeyStr.length == 0 && indexPath.row != 0) {
        self.searchView.searchTF.text = self.seacrhOrgArray[indexPath.row -1];
        searchKeyStr = self.seacrhOrgArray[indexPath.row -1];
        isClickSearchHistory = YES;
        [self searchOrgName:self.seacrhOrgArray[indexPath.row -1]];
        [self.seacrhOrgArray removeAllObjects];
    }else {
        MapNearOrgModel *model =   self.seacrhOrgArray[indexPath.row-1];
        [self userDataManipulation:model.name];
        DJSearchDetailsViewController *VC = [[DJSearchDetailsViewController alloc] init];
        NSMutableArray *tempArray= [NSMutableArray arrayWithArray:@[self.seacrhOrgArray[indexPath.row]]];
        VC.orgListArray = tempArray;
        VC.searchTitleStr = self.searchView.searchTF.text;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kFit(50);
    }else {
        if (searchKeyStr.length == 0) {
            return kFit(50);
        }else {
            return kFit(70);
        }
    }
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

//插入一条数据
- (void)userDataManipulation:(NSString *)insertData{
    
    NSString *key = @"mapOrg";
    
    NSArray *sandboxpath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [sandboxpath objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"searchOrgAndUserRecord.plist"];
    //存储根数据
    NSMutableDictionary *rootDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    
    
    NSMutableArray *tempArrray = [NSMutableArray arrayWithArray:rootDic[key]];
    
    [tempArrray insertObject:insertData atIndex:0];//插入一条数据
    
    
    //    tempArrray = [NSMutableArray arrayWithArray:[tempArrray valueForKeyPath:@"@distinctUnionOfObjects.self"]];
    
    //    tempArrray  =   [NSMutableArray arrayWithArray:[[tempArrray reverseObjectEnumerator] allObjects]];
    
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (int i = 0; i < tempArrray.count; i ++) {
        NSString *str = tempArrray[i];
        if (![dataArray containsObject:str] && dataArray.count <3) {
            [dataArray addObject:str];
        }
    }
    
    NSLog(@"tempArrray%@ dataArray%@rootDic%@", tempArrray, dataArray, rootDic);
    //  dataArray  =   [NSMutableArray arrayWithArray:[[dataArray reverseObjectEnumerator] allObjects]];
    
    if (rootDic == NULL) {
        rootDic = [NSMutableDictionary dictionaryWithDictionary:@{key:dataArray}];
    }else {
        [rootDic setObject:dataArray forKey:key];
    }
    
    //写入文件
    BOOL  isSucce  = [rootDic writeToFile:plistPath atomically:YES];
    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"写入%@ key%@ dataArray%@rootDic%@", isSucce?@"成功":@"失败", key, dataArray, rootDic);
    //重新获取数据 看是否有变动（虚拟机上会有变动，但是真机上不会）
    NSMutableDictionary *newDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSLog(@"new %@",newDataDic);//打印新数据
}

//查询
- (void)takeSearchHistory {
    [self.seacrhOrgArray removeAllObjects];
    NSString *key = @"mapOrg";
    //获取路径
    NSArray *obtainPath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[obtainPath objectAtIndex:0] stringByAppendingPathComponent:@"searchOrgAndUserRecord.plist"];
    NSLog(@"%@",NSHomeDirectory());
    //获取数据
    NSMutableDictionary *obtainData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:obtainData[key]];
    NSLog(@"obtainData%@", obtainData);
    if (![dataArray isKindOfClass:[NSMutableArray class]]) {
        self.seacrhOrgArray = [NSMutableArray arrayWithArray:@[]];
    }else {
        self.seacrhOrgArray = dataArray;
    }
    [self.tableView reloadData];
}
//删除
- (void)DeleteSearchHistory {
    NSString *key = @"mapOrg";
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

//0加载成功并有数据 1加载成功并没有数据 2加载失败
- (void)emptyInterfaceLayout:(NSInteger)type {
    switch (type) {
        case 0:
            self.dataEmptyView.alpha = 0;
            
            break;
        case 1:
            self.dataEmptyView.alpha = 1.0;
            
            
            break;
        case 2:
            self.dataEmptyView.alpha = 0.0;
            break;
            
        default:
            break;
    }
    
}

@end
