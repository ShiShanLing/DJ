//
//  DJChangeOrgViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJChangeOrgViewController.h"
#import "DJJoinOrgTableViewCell.h"
#import "RegisteredDataModel+CoreDataProperties.h"
#import "DJPersonalCenterVC.h"
@interface DJChangeOrgViewController ()<UITableViewDelegate, UITableViewDataSource,DJJoinOrgTableViewCellDelegate>

@property (nonatomic, strong)UITableView *tableView;


/**
 *
 */
@property (nonatomic, strong)NSMutableArray * meunArray;

@end

@implementation DJChangeOrgViewController  {
    BOOL  isChooseDelete;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (NSMutableArray *)meunArray {
    if (!_meunArray) {
        _meunArray = [NSMutableArray array];
    }
    return _meunArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isChooseDelete =NO;
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"变更组织";
    self.meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
    [self createTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak  DJChangeOrgViewController *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.scrollEnabled = NO;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = kColorRGB(246, 246, 246, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[DJJoinOrgTableViewCell class] forCellReuseIdentifier:@"DJJoinOrgTableViewCell"];
    [self.view addSubview:_tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
    return self.meunArray.count;
    }else {
        return 1;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrgInfoModel *model = self.meunArray[indexPath.row];
    if (model.state.integerValue == 1) {
        cell.imageView.image = [UIImage imageNamed:@"DJLeaveOn"];
    }else {
        cell.imageView.image = [UIImage imageNamed:@"DJLeaveOff"];
    }
    cell.textLabel.text = model.orgName;
        
        if (indexPath.row != self.meunArray.count -1) {
            UILabel *dividerLabelTwo= [[UILabel alloc] init];
            dividerLabelTwo.backgroundColor  =kCellColorDivider;
            [cell addSubview:dividerLabelTwo];
            dividerLabelTwo.sd_layout.leftSpaceToView(cell, kFit(14.5)).heightIs(kCellDividerHeight).rightSpaceToView(cell, 0).bottomSpaceToView(cell, 0);
        }
    return cell;
    }else {
        DJJoinOrgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJJoinOrgTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.isChooseDelete = isChooseDelete;
        [cell refreshControlState];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (int i = 0; i < self.meunArray.count; i ++) {
        OrgInfoModel *tempModel = self.meunArray[i];
        if (indexPath.row == i) {
            if (tempModel.state.integerValue == 1) {
                tempModel.state = @"0";
                isChooseDelete = NO;
            }else {
                tempModel.state = @"1";
                isChooseDelete = YES;
            }
        }else{
            tempModel.state = @"0";
        }
    }
    [self.tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kFit(50);
    }else {
        return kFit(280);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kFit(45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(45))];
    headView.backgroundColor = kColorRGB(246, 246, 246, 1);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFit(15), kFit(17), kScreenWidth-25, kFit(17))];
    titleLabel.textColor = [UIColor blackColor];
    if (section == 0) {
        titleLabel.text = @"请选择您要离开的组织";
    }else {
        titleLabel.text = @"请输入您要加入的组织信息";
    }
    
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(17)];
    [headView addSubview:titleLabel];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];

    return footerView;
}

#pragma mark DJJoinOrgTableViewCellDelegate
- (void)SubmitApplication:(RegisteredDataModel *)model {
    if (!isChooseDelete) {
        [self ShowWarningHudMid:@"请选择您要脱离的组织"];
    }else {
        
        NSString *oldOrgId;
        OrgInfoModel *oldModel ;
        for (int i  = 0; i <self.meunArray.count; i ++) {
            OrgInfoModel *tempModel = self.meunArray[i];
            if (tempModel.state.integerValue == 1) {
                oldOrgId = tempModel.orgId;
                oldModel = tempModel;
                break;
            }
        }
        
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"组织变更确认" message:[NSString stringWithFormat:@"您即将从%@离职, 加入%@, 在新组织的岗位为%@,确认进行变更吗?", oldModel.orgName, model.oName, model.jobsName] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
            [URL_Dic setObject:model.oId forKey:@"newOrgId"];
            [URL_Dic setObject:oldOrgId forKey:@"oldOrgId"];
            [URL_Dic setObject:model.jobsID forKey:@"stationId"];
            NSLog(@"URL_Dic%@", URL_Dic);
            [self showHud:@"" title:@""];
            [self  getJSONDataWithUrl:kURL_UserChangeOrg parameters:URL_Dic success:^(id responseObject) {
                [self hudDissmiss];
                NSLog(@"responseObject%@", responseObject);
                NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
                if ([codeStr isEqualToString:@"0"]) {
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[DJPersonalCenterVC class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                }
                
                [self ShowWarningHudMid:responseObject[@"msg"] ];
            } failure:^(NSError *error) {
                [self ShowWarningHudMid:@"请求失败,请稍后重试"];
                NSLog(@"error%@", error);
            }];
            
        }];
        // 3.将“取消”和“确定”按钮加入到弹框控制器中
        [alertV addAction:cancle];
        [alertV addAction:confirm];
        // 4.控制器 展示弹框控件，完成时不做操作
        [self presentViewController:alertV animated:YES completion:^{
            nil;
        }];

    }

}
@end
