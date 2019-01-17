//
//  DJResumptionExplainView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJResumptionExplainView.h"
#import "DJResumptionExplainListTableViewCell.h"
#import "DJBaseViewController.h"
@interface DJResumptionExplainView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong)UITableView *tableView;
/**
 *搜索的历史记录
 */
@property (nonatomic, strong)NSMutableArray * searchHistoricalRecordArray;
/**
 *空白界面
 */
@property (nonatomic, strong)DJDataEmptyView * dataEmptyView;
@end

@implementation DJResumptionExplainView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        [self createTableView];
        
    }
    return self;
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, kScreenHeight - kStatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[DJResumptionExplainListTableViewCell class] forCellReuseIdentifier:@"DJResumptionExplainListTableViewCell"];
    [self addSubview:_tableView];
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, self.width, kScreenHeight - kStatusBarAndNavigationBarHeight)];
    self.dataEmptyView.dividerLabel.hidden = YES;
    self.dataEmptyView.hidden = YES;
    self.dataEmptyView.promptLabel.text = @"没有相关结果,试试其他关键字吧!";
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"self.searchStr%@", self.searchStr);
    if (self.searchDataArray.count == 0) {
        if (self.searchStr.length == 0) {
            return self.searchHistoricalRecordArray.count;
        }else {
            return 0;
        }
    }else {
        return self.searchDataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchDataArray.count == 0  && self.searchHistoricalRecordArray.count != 0 && self.searchStr.length == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.searchHistoricalRecordArray[indexPath.row];
        cell.imageView.image = nil;
        UILabel *dividerLabel = [UILabel new];
        dividerLabel.backgroundColor = kCellColorDivider;
        [cell.contentView addSubview:dividerLabel];
        dividerLabel.sd_layout.leftSpaceToView(cell.contentView, kFit(15)).bottomSpaceToView(cell.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(cell.contentView, 0);
        return cell;
    }else {
        DJResumptionExplainListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJResumptionExplainListTableViewCell" forIndexPath:indexPath];
        NSDictionary *taskDic = self.searchDataArray[indexPath.row];
        
        cell.titleLabel.text = taskDic[@"title"];
        NSString *timeStr = taskDic[@"createTime"];
        if (timeStr.length >= 12) {
            timeStr = [timeStr substringToIndex:11];
        }else {
        }
        cell.timeLabel.text = timeStr;
        cell.jobsLabel.text = [NSString stringWithFormat:@"%@  |  %@", taskDic[@"stationName"],taskDic[@"orgName"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *dividerLabel = [UILabel new];
        dividerLabel.backgroundColor = kCellColorDivider;
        [cell.contentView addSubview:dividerLabel];
        dividerLabel.sd_layout.leftSpaceToView(cell.contentView, kFit(15)).bottomSpaceToView(cell.contentView, 0).heightIs(kCellDividerHeight).rightSpaceToView(cell.contentView, 0);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchDataArray.count == 0) {
        
        NSString *string= self.searchHistoricalRecordArray[indexPath.row];
        self.searchStr = string;
        if ([_delegate respondsToSelector:@selector(SearchHistoryChoose:)]) {
            [_delegate SearchHistoryChoose:string];
        }
    }else {
        if (self.searchStr.length != 0) {
            NSDictionary *taskDic = self.searchDataArray[indexPath.row];
            if ([_delegate respondsToSelector:@selector(searchDataChoose:)]) {
                [_delegate searchDataChoose:taskDic];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchDataArray.count == 0  && self.searchHistoricalRecordArray.count != 0) {
        return 50;
    }else {
        if (self.searchType == 0) {
            return kFit(70);
        }else {
            return 50;
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
    if (self.searchDataArray.count == 0) {
        if (self.searchStr.length == 0) {
            if (self.searchHistoricalRecordArray.count == 0) {
                return 0.01;
            }else{
                return 52;
            }
        }else {
            return 0.01;
        }
    }else {
        return 52;
    }
    
 
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat  height = 0.0;
    
    if (self.searchDataArray.count == 0) {
        if (self.searchStr.length == 0) {
            if (self.searchHistoricalRecordArray.count == 0) {
                height = 0.01;
            }else{
                height = 52;
            }
        }else {
            height = 0.01;
        }
    }else {
        height = 52;
    }
    
    
    UIView *headView  = [[UIView alloc] init];
    
    
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, kScreenWidth, height);
    if (height < 1) {
        
    }else {
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
    UILabel *dividerLabel = [UILabel new];
    dividerLabel.backgroundColor = kCellColorDivider;
    [headView addSubview:dividerLabel];
    dividerLabel.sd_layout.leftSpaceToView(headView, kFit(15)).bottomSpaceToView(headView, 0).heightIs(kCellDividerHeight).rightSpaceToView(headView, 0);
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
//查询
- (void)takeData:(NSInteger )type {
    
    [self.searchHistoricalRecordArray removeAllObjects];
    NSString *key = @"";
    switch (type) {
        case 0:
            key = @"re";
            break;
        case 1:
            key = @"rd";
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
            key = @"re";
            break;
        case 1:
            key = @"rd";
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

- (void)setSearchType:(NSInteger)searchType {
    __weak DJResumptionExplainView *selfWeak = self;
    [selfWeak takeData:searchType];
}

-(void)setSearchDataArray:(NSMutableArray *)searchDataArray {
    _searchDataArray = searchDataArray;
    if (_searchDataArray.count == 0 && _searchStr.length != 0) {
        _dataEmptyView.hidden = NO;
    }else {
        _dataEmptyView.hidden = YES;
        [_tableView reloadData];
    }
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
    
}



@end
