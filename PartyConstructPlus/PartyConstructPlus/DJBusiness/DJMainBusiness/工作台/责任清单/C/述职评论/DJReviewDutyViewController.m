//
//  DJReviewDutyViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/21.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJReviewDutyViewController.h"
#import "DJResumptionExplainListTableViewCell.h"
#import "DJRESearchView.h"
#import "SMKSFPopoverView.h"//下拉菜单
#import "SMKSFPopoverAction.h"
@interface DJReviewDutyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

/**
 *履历搜索view
 */
@property (nonatomic, strong)DJRESearchView * RESearchView;
/**
 *
 */
@property (nonatomic, strong)UIButton *screeningBtn;
/**
 *
 */
@property (nonatomic, strong)UIBarButtonItem *leftButtonItem;

@end

@implementation DJReviewDutyViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"述职评议";
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    UIButton *myButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    myButton.frame = CGRectMake(0, 0, 50, 50);
    [myButton setTitle:@"我的" forState:UIControlStateNormal];
    myButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [myButton setTitleColor:kColorRGB(51, 51, 51, 1) forState:(UIControlStateNormal)];
    
    [myButton addTarget:self action:@selector(handleLeftAccount) forControlEvents:UIControlEventTouchUpInside];
    self.leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    self.navigationItem.rightBarButtonItem = _leftButtonItem;
    
    __weak DJReviewDutyViewController *serlWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [serlWeak.navigationController popViewControllerAnimated:YES];
    };
    
    [self createTableView];
}

- (void)handleLeftAccount {
    
    SMKSFPopoverView *PopoverView = [SMKSFPopoverView popoverView];
    
    PopoverView.style = PopoverViewStyleDarkTranslucent;
    SMKSFPopoverAction *myRankingAction  =  [SMKSFPopoverAction actionWithImage:[UIImage imageNamed:@"DJ_llsms_my"] title:@"我的" handler:^(SMKSFPopoverAction *action) {
        [(UIButton*)_leftButtonItem.customView setTitle: @"我的" forState:(UIControlStateNormal)];
    }];
    SMKSFPopoverAction *orgRankingAction  =  [SMKSFPopoverAction actionWithImage:[UIImage imageNamed:@"DJ_llsms_org"] title:@"组织" handler:^(SMKSFPopoverAction *action) {
        [(UIButton*)_leftButtonItem.customView setTitle: @"组织" forState:(UIControlStateNormal)];
    }];
    
    [PopoverView showToView:_leftButtonItem.customView withActions:@[myRankingAction,orgRankingAction]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorRGB(246, 246, 246, 1);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[DJResumptionExplainListTableViewCell class] forCellReuseIdentifier:@"DJResumptionExplainListTableViewCell"];
    [self.view addSubview:_tableView];
    UIEdgeInsets tempE = _tableView.contentInset;
    
    tempE.top = 40;
    _tableView.contentInset = tempE;
    
    DJRESearchView *SearchView = [[DJRESearchView alloc] initWithFrame:CGRectMake(0, -40, kScreenWidth, 40)];
    
    [self.tableView addSubview:SearchView];
    
    self.screeningBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_screeningBtn setImage:[UIImage imageNamed:@"DJ_lzsms_rq"] forState:(UIControlStateNormal)];
    _screeningBtn.backgroundColor = kColorRGB(246, 246, 246, 1);
    [_screeningBtn addTarget:self action:@selector(handleChooseTime) forControlEvents:(UIControlEventTouchUpInside)];
    _screeningBtn.frame = CGRectMake(kScreenWidth-kFit(46), 40, kFit(46), kFit(35));
    [self.view addSubview:_screeningBtn];
    self.RESearchView = [[DJRESearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [self.view addSubview:_RESearchView];
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
//    [self.view addSubview:self.dataEmptyView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJResumptionExplainListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJResumptionExplainListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = @"述职描述名称示例述职说明123";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFit(70);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kFit(35);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(35))];
    headView.backgroundColor = kColorRGB(246, 246, 246, 1);
    UILabel *titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(kFit(15), 0, 120, kFit(35))];
    titleLabel.text = @"2108年";
    titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:kFit(15)];
    titleLabel.textColor = kColorRGB(51, 51, 51, 1);
    [headView addSubview:titleLabel];
    if (section == 0) {
        //下拉展示 上啦消失 正常情况下展示的都是虚拟的
        UIButton *screeningBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [screeningBtn setImage:[UIImage imageNamed:@"DJ_lzsms_rq"] forState:(UIControlStateNormal)];
        [screeningBtn addTarget:self action:@selector(handleChooseTime) forControlEvents:(UIControlEventTouchUpInside)];
        screeningBtn.frame = CGRectMake(kScreenWidth-kFit(46), 0, kFit(46), kFit(35));
        [headView addSubview:screeningBtn];
    }
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    
    return footerView;
}

- (void)handleChooseTime{
    
    NSArray *timeArray = @[@[@"2015", @"2016", @"2017", @"2018"]];
    SMKPickerView *smkPickerView = [SMKPickerView SMKPickerWithArray:timeArray withHeadTitle:nil defaultIndex:0 withCall:^(SMKPickerView *pcikerView, NSString *choiceString) {
        [pcikerView dismissPicker];
        NSLog(@"choiceString%@", choiceString);
    }];
    [smkPickerView show];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < -40) {//隐藏
        self.screeningBtn.hidden = YES;
        self.RESearchView.hidden  =YES;
    }else {//显示
        self.screeningBtn.hidden = NO;
        self.RESearchView.hidden  =NO;
    }
    
    NSLog(@"scrollView%f", scrollView.contentOffset.y);
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
