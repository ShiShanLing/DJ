//
//  DJOrgMemberListView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJOrgMemberListView.h"



@interface DJOrgMemberListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation DJOrgMemberListView {
    
    BOOL SelectAll;
    
}

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        SelectAll= NO;
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [UILabel new];
        _titleLabel.text =@"上城组织人员";
        _titleLabel.textAlignment = 1;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font  =MFont(kFit(16));
        [self addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(41);
        [self createTableView];
        
        self.determinebtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_determinebtn setTitle:@"确定" forState:(UIControlStateNormal)];
        _determinebtn.titleLabel.textColor = [UIColor blackColor];
        _determinebtn.titleLabel.font = MFont(kFit(15));
        [_determinebtn addTarget:self action:@selector(handleDetermine) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_determinebtn];
        _determinebtn.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, kTabbarSafeBottomMargin).heightIs(44);
        UILabel *_SegmentationLineLabel =[UILabel new];
        _SegmentationLineLabel.backgroundColor = kCellColorDivider;
        [self addSubview:_SegmentationLineLabel];
        _SegmentationLineLabel.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(_determinebtn, 0).rightSpaceToView(self, 0).heightIs(kCellDividerHeight);
    }
    return self;
}

- (void)createTableView {
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, kScreenWidth, self.height-41-45-kTabbarSafeBottomMargin) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 0;
    }else {
        return self.dataArray.count+1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        SelectAll = YES;
        for (int i = 0; i < self.dataArray.count; i ++) {
            LowerOrgUserModel *model = self.dataArray[i];
            if (![model.state isEqualToString:@"1"]) {
                SelectAll = NO;
                break;
            }
        }
        cell.imageView.image = [UIImage imageNamed:SelectAll?@"DJLeaveOn":@"DJLeaveOff"];
        cell.textLabel.text = @"全部";
    }else {
        LowerOrgUserModel *model =  self.dataArray[indexPath.row-1];
        if (![model.state isEqualToString:@"1"]) {
            cell.imageView.image = [UIImage imageNamed:@"DJLeaveOff"];
        }else {
            cell.imageView.image = [UIImage imageNamed:@"DJLeaveOn"];
        }
        cell.textLabel.text = model.userName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        SelectAll = !SelectAll;
        if (SelectAll) {
            for (int i = 0; i < self.dataArray.count; i ++) {
                LowerOrgUserModel *model =  self.dataArray[i];
                model.state = @"1";
                                self.dataArray[i] = model;
            }
        }else {
            for (int i = 0; i < self.dataArray.count; i ++) {
                LowerOrgUserModel *model =  self.dataArray[i];
                model.state = @"0";
                                self.dataArray[i] = model;
            }
        }
    }else {
        
        LowerOrgUserModel *model =  self.dataArray[indexPath.row-1];
        if (![model.state isEqualToString:@"1"]) {
            model.state = @"1";
        }else {
            model.state = @"0";
            SelectAll = NO;
        }
        self.dataArray[indexPath.row-1] = model;
        SelectAll = YES;
        for (int i = 0; i < self.dataArray.count; i ++) {
            LowerOrgUserModel *model = self.dataArray[i];
            if (![model.state isEqualToString:@"1"]) {
                SelectAll = NO;
                break;
            }
        }
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

- (void)setDataArray:(NSMutableArray *)dataArray {
    
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
    [_tableView reloadData];
    
}

- (void)handleDetermine {
    if ([_delegate respondsToSelector:@selector(orgMembersEdit:)]) {
        [_delegate orgMembersEdit:self.dataArray];
    }
    
    
}
@end
