//
//  DJSelectTaskTagViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/25.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSelectTaskTagViewController.h"
#import "DJTaskTagSelectTableViewCell.h"
@interface DJSelectTaskTagViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong)UITableView *tableView;

/**
 *
 */
@property (nonatomic, strong)NSMutableArray * tagArray;

/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
@end

@implementation DJSelectTaskTagViewController

- (NSMutableArray *)tagArray {
    if (!_tagArray) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *tempArray = @[@[@{@"title":@"主题党日",@"state":@"0"}], @[@{@"title":@"两学一做",@"state":@"0"}], @[@{@"title":@"三会一课",@"state":@"2"},@{@"title":@"支部党员大会",@"state":@"0"},@{@"title":@"支部委员会",@"state":@"0"},@{@"title":@"党小组会",@"state":@"0"},@{@"title":@"党课",@"state":@"0"}]];
    
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
//    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"选择任务标签";
    [self.defaultNavigationBarView.leftBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.leftBtn setTitleColor:kColorRGB(0, 0, 0, 1) forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(174, 174, 174, 1) forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.defaultNavigationBarView.rightBtn addTarget:self action:@selector(handleSubmit) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    if (_defaultDataArray.count == 0) {
        self.tagArray = [NSMutableArray arrayWithArray:tempArray];
    }else {
        [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(0, 0, 0, 1) forState:(UIControlStateNormal)];
        self.tagArray = [NSMutableArray arrayWithArray:self.defaultDataArray];
    }
    [self.view addSubview:self.defaultNavigationBarView];
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleReturnBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSubmit {
    

    
    self.taskTagBlock(self.tagArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJTaskTagSelectTableViewCell class] forCellReuseIdentifier:@"DJTaskTagSelectTableViewCell"];
    [self.view addSubview:_tableView];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tagArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tempArray = self.tagArray[section];
    
    return tempArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DJTaskTagSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJTaskTagSelectTableViewCell" forIndexPath:indexPath];
    NSArray *tempArray = self.tagArray[indexPath.section];
    NSDictionary *tempDic = tempArray[indexPath.row];
    cell.indexPath =indexPath;
    cell.dataDic = tempDic;
//    if (indexPath.row == 0 || indexPath.row == tempArray.count-1) {
//        cell.dividerLabel.hidden = NO;
//    }else {
//        cell.dividerLabel.hidden = YES;
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.tagArray[indexPath.section]];
    
    
    for (int i = 0; i < tempArray.count; i ++) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:tempArray[i]];
        if (![tempDic[@"state"] isEqualToString:@"2"]) {
            
            if (i == indexPath.row) {
                
                if ([tempDic[@"state"] isEqualToString:@"0"]) {
                    tempDic[@"state"]  = @"1";
                }else {
                    tempDic[@"state"]  = @"0";
                }
            }else {
                tempDic[@"state"]  = @"0";
            }
        }else {
            
        }
        tempArray[i] = tempDic;
    }
    self.tagArray[indexPath.section] = tempArray;
    NSMutableArray *selectedTagArray  = [NSMutableArray array];
    for (int i = 0;  i< self.tagArray.count; i ++) {
        NSArray *tempArray = self.tagArray[i];
        for (int j = 0; j < tempArray.count; j ++) {
            NSDictionary *tempDic = tempArray[j];
            if ([tempDic[@"state"] isEqualToString:@"1"]) {
                [selectedTagArray addObject:tempDic[@"title"]];
            }
        }
    }
    if (selectedTagArray.count != 0) {
        [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(0, 0, 0, 1) forState:(UIControlStateNormal)];
    }else {
        [self.defaultNavigationBarView.rightBtn setTitleColor:kColorRGB(174, 174, 174, 1) forState:(UIControlStateNormal)];
    }
    
    
    
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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

-(void)setDefaultDataArray:(NSMutableArray *)defaultDataArray {
    _defaultDataArray = defaultDataArray;
    
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
