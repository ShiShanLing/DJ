//
//  DJOrgChooseView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJOrgChooseView.h"
#import "DJOrgChooseTableViewCell.h"




@interface DJOrgChooseView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

/**
 *标题
 */
@property (nonatomic, strong)UILabel *titleLabel;
/**
 *确认
 */
@property (nonatomic, strong)UIButton * confirmBtn;
@end

@implementation DJOrgChooseView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"选择组织";
        _titleLabel.textAlignment =1;
        _titleLabel.textColor = kColorRGB(51, 51, 51, 1);
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(18)];
        [self addSubview:_titleLabel];
        _titleLabel.sd_layout.leftSpaceToView(self, kFit(15)).rightSpaceToView(self, kFit(15)).topSpaceToView(self, kFit(25)).heightIs(kFit(18));
        
        [self createTableView];
        
        UILabel *dividerLabel = [UILabel new];
        dividerLabel.backgroundColor = kCellColorDivider;
        [self addSubview:dividerLabel];
        dividerLabel.sd_layout.leftSpaceToView(self, kFit(15)).bottomSpaceToView(self, kFit(50)).heightIs(kCellDividerHeight).rightSpaceToView(self, 0);
        
        self.confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_confirmBtn setTitleColor:kColorRGB(89, 135, 198, 1) forState:(UIControlStateNormal)];
        [_confirmBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateSelected)];
        _confirmBtn.font = MFont(kFit(kFit(16)));
        _confirmBtn.userInteractionEnabled = NO;
        [_confirmBtn addTarget:self action:@selector(handleConfirmBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_confirmBtn];
        _confirmBtn.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, kFit(2)).rightSpaceToView(self, 0).heightIs(kFit(47.5));
        _confirmBtn.selected = YES;
    }
    return self;
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[DJOrgChooseTableViewCell class] forCellReuseIdentifier:@"DJOrgChooseTableViewCell"];
    [self addSubview:_tableView];
    _tableView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(_titleLabel, kFit(13)).rightSpaceToView(self, 0).bottomSpaceToView(self, kFit(50));
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJOrgChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJOrgChooseTableViewCell" forIndexPath:indexPath];
    OrgInfoModel *model = self.modelArray[indexPath.row];
    cell.model= model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (OrgInfoModel *tempModel in self.modelArray) {
        tempModel.chooseState = @"0";
    }
    OrgInfoModel *model = self.modelArray[indexPath.row];
    model.chooseState = @"1";
    _confirmBtn.selected = NO;
    _confirmBtn.userInteractionEnabled = YES;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFit(65);
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

- (void)setModelArray:(NSMutableArray *)modelArray {
    for (OrgInfoModel *tempModel in modelArray) {
        if ([tempModel.chooseState isEqualToString:@"1"]) {
            _confirmBtn.selected = NO;
            _confirmBtn.userInteractionEnabled = YES;
        }
    }
    
    _modelArray = (NSMutableArray *)[[modelArray reverseObjectEnumerator] allObjects];
    [_tableView reloadData];
}

- (void)handleConfirmBtn {
    OrgInfoModel *model ;
    for (OrgInfoModel *tempModel in self.modelArray) {
        if ([tempModel.chooseState isEqualToString:@"1"]) {
            model = tempModel;
        }
    }
    if (model == nil) {
        
        return;
    }
    if ([_delegate respondsToSelector:@selector(confirmChoicesOrg:)]) {
        [_delegate confirmChoicesOrg:model];
    }
    
}

@end
