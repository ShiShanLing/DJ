//
//  DJAboutUsViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/22.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJAboutUsViewController.h"
#import "DJLogoShowTableViewCell.h"
#import "DJAppQrCodeViewController.h"
@interface DJAboutUsViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong)UITableView *tableView;



@end

@implementation DJAboutUsViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于我们";
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak DJAboutUsViewController *selfWeak  =self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    
    
    [self createTableView];
}





- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[DJLogoShowTableViewCell class] forCellReuseIdentifier:@"DJLogoShowTableViewCell"];
    [self.view addSubview:_tableView];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 2;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DJLogoShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJLogoShowTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        
        NSArray *imageArray = @[@"DJ_AboutUs_QrCode", @"DJ_AboutUs_comment"];
        NSArray *titleArray = @[@"下载二维码", @"去app store评价"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
        cell.textLabel.text = titleArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            UILabel *_dividerLabel  = [UILabel new];
            _dividerLabel.backgroundColor = kColorRGB(237, 237, 237, 1);
            [cell addSubview:_dividerLabel];
            _dividerLabel.sd_layout.leftSpaceToView(cell, kFit(15)).bottomSpaceToView(cell, 0).heightIs(kCellDividerHeight).rightSpaceToView(cell, 0);
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                DJAppQrCodeViewController *VC = [[DJAppQrCodeViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E6%9D%AD%E5%B7%9E%E5%85%9A%E5%BB%BA%E8%B4%A3%E4%BB%BB/id1239300314?mt=8"]];

                break;
                
            default:
                break;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kFit(197);
    }else {
        return kFit(50);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    return footerView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
