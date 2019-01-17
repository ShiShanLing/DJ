//
//  DJLeaveOrgViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJLeaveOrgViewController.h"
#import "ChangeColourView.h"
#import "DJPersonalCenterVC.h"
@interface DJLeaveOrgViewController ()<UITableViewDelegate, UITableViewDataSource, ChangeColourViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
/**
 确认按钮
 */
@property (nonatomic, strong)UIButton *ContinueBtn;


@property (nonatomic, strong)CAGradientLayer  *gradientLayer;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * meunArray;

@end

@implementation DJLeaveOrgViewController


- (NSMutableArray *)meunArray {
    if (!_meunArray) {
        _meunArray = [NSMutableArray array];
    }
    return _meunArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"离开现组织";
    
    self.meunArray  =  [NSMutableArray arrayWithArray:[self queryModel:@"OrgInfoModel"]];
    [self createTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak  DJLeaveOrgViewController *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.scrollEnabled = NO;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor =  kColorRGB(246, 246, 246, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meunArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        UILabel *dividerLabelThree = [[UILabel alloc] init];
        dividerLabelThree.backgroundColor  =kCellColorDivider;
        [cell.contentView addSubview:dividerLabelThree];
        dividerLabelThree.sd_layout.leftSpaceToView(cell.contentView, kFit(14.5)).heightIs(kCellDividerHeight).rightSpaceToView(cell.contentView, 0).bottomSpaceToView(cell.contentView, 0);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i = 0; i < self.meunArray.count; i ++) {
        OrgInfoModel *tempModel = self.meunArray[i];
        if (indexPath.row == i) {
            if (tempModel.state.integerValue == 1) {
                tempModel.state = @"0";
            }else {
                tempModel.state = @"1";
            }
        }else{
            tempModel.state = @"0";
        }
    }
  
   
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFit(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kFit(45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kFit(85);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(45))];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFit(15), kFit(17), 200, kFit(17))];
    headView.backgroundColor = kColorRGB(246, 246, 246, 1);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"请选择您要离开的组织";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:kFit(17)];
    [headView addSubview:titleLabel];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    ChangeColourView *footerView  = [[ChangeColourView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFit(85))];
    footerView.delegate = self;
    footerView.backgroundColor = kColorRGB(246, 246, 246, 1);
    BOOL  isChoose = NO;
    for (int i  = 0; i <self.meunArray.count; i ++) {
        OrgInfoModel *model = self.meunArray[i];
        if (model.state.integerValue == 1) {
            isChoose = YES;
            break;
        }
    }
    
    if (isChoose) {
        footerView.ContinueBtn.userInteractionEnabled = YES;
        footerView.gradientLayer.hidden = NO;
    }else {
        footerView.ContinueBtn.userInteractionEnabled = NO;
        footerView.gradientLayer.hidden = YES;
        
    }
    return footerView;
    
}

- (void)handleExitOrg {
    
    NSString *orgId=@"";
    NSString *orgName=@"";
    for (int i  = 0; i <self.meunArray.count; i ++) {
        OrgInfoModel *model = self.meunArray[i];
        if (model.state.integerValue == 1) {
            NSLog(@"model%@", model);
            orgId = model.orgId;
            orgName = model.orgName;
            break;
        }
    }
    
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"离开组织确认" message:[NSString stringWithFormat:@"您即将从%@离岗, 确认执行吗?", orgName] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        [URL_Dic setObject:orgId forKey:@"orgId"];
        NSLog(@"URL_Dic%@", URL_Dic);
        [self  getJSONDataWithUrl:kURL_UserExitOrg parameters:URL_Dic success:^(id responseObject) {
            NSLog(@"responseObject%@", responseObject);
            NSString *codeStr = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
            
            if ([codeStr isEqualToString:@"0"]) {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[DJPersonalCenterVC class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                        [self deleteModel:@"OrgInfoModel"];
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
