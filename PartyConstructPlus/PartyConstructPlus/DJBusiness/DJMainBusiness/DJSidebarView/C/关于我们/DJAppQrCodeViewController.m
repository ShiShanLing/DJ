//
//  DJAppQrCodeViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/22.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJAppQrCodeViewController.h"

@interface DJAppQrCodeViewController ()

@end

@implementation DJAppQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"下载二维码";
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak DJAppQrCodeViewController *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    
    UIImageView *QrCodeImage = [UIImageView new];
    QrCodeImage.image = [UIImage imageNamed:@"DJ_App_download"];
    QrCodeImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:QrCodeImage];
    QrCodeImage.sd_layout.widthIs(kFit(165)).heightIs(kFit(165)).topSpaceToView(self.view, kFit(75)).centerXEqualToView(self.view);
    
    UILabel *TitleLable = [UILabel new];
    TitleLable.textAlignment = 1;
    TitleLable.text = @"Android、iOS用户均可扫描本二维码\n 下载杭州党建责任APP";
    TitleLable.textColor = kColorRGB(51, 51, 51, 1);
    TitleLable.font = MFont(kFit(14));
    TitleLable.numberOfLines =0;
    [self.view addSubview:TitleLable];
    TitleLable.sd_layout.widthIs(kScreenWidth).topSpaceToView(QrCodeImage, kFit(25)).centerXEqualToView(self.view).heightIs(kFit(60));
    
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
