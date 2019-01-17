//
//  InterfaceTestVC.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/26.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "InterfaceTestVC.h"

@interface InterfaceTestVC ()

@end

@implementation InterfaceTestVC

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)dataTOjsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (IBAction)handleBtn:(id)sender {
    
    
    NSString *urlStr = @"http://192.168.8.206:8080/smk_party/user/userRegistSendCode.ext";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"18668015893" forKey:@"tel"];
    
    [self getJSONDataWithUrl:urlStr parameters:dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSString *)JsonModel:(NSDictionary *)dictModel {
    if ([NSJSONSerialization isValidJSONObject:dictModel])
    {
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictModel options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonStr;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//登录
- (IBAction)handleLogin:(UIButton *)sender {
    NSString *URL_Str = @"http://192.168.23.200:8081/smk_party/user/login.ext";
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:@"123456" forKey:@"password"];
    [URL_Dic setValue:@"15990096417" forKey:@"tel"];
    [self getJSONDataWithUrl:kURL_UserLogIn parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        [self DataParsingEntityWithDictionary:responseObject];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
//忘记密码发短信
- (IBAction)handleRPSMS:(UIButton *)sender {
    [self deleteModel:@"UserDataModel"];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:@"18668015893" forKey:@"tel"];
    [self getJSONDataWithUrl:kRUL_UserCodeRegistered parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
//忘记密码改密码
- (IBAction)handleRetrievePassword:(UIButton *)sender {
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:@"18668015893" forKey:@"tel"];
    [URL_Dic setValue:@"aaa123" forKey:@"password"];
    [URL_Dic setValue:@"1234" forKey:@"code"];
    [self getJSONDataWithUrl: kURL_UserForgotPWChangePW parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
//注册
- (IBAction)handleRegistered:(UIButton *)sender {
    [self deleteModel:@"UserDataModel"];
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setObject:@"1234" forKey:@"code"];
    [URL_Dic setObject:@"2" forKey:@"orgId"];
    [URL_Dic setObject:@"aaa123" forKey:@"password"];
    [URL_Dic setObject:@"1" forKey:@"stationId"];
    [URL_Dic setObject:@"18668015893" forKey:@"tel"];
    [URL_Dic setObject:@"石山岭" forKey:@"userName"];
    [self getJSONDataWithUrl: kURL_UserRegistered parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
//获取更新数据信息
- (IBAction)handleAppUpDate:(id)sender {
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setObject:@"ios" forKey:@"sysType"];
    
    [self  getJSONDataWithUrl:kURL_VersionNumber parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}

//修改密码
- (IBAction)handleChangePW:(UIButton *)sender {
    
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    
    [URL_Dic setObject:@"1234567" forKey:@"password"];
    
    [URL_Dic setObject:@"123456" forKey:@"oldPassword"];
    [self getJSONDataWithUrl:kURL_UserChangePassword parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
//获取轮播图
- (IBAction)handleScrollFigure:(UIButton *)sender {
    
    
    [self getJSONDataWithUrl:kURL_ScrollFigure parameters:nil success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
//根据组织编号获取组织名字
- (IBAction)handleGetOrganizationName:(UIButton *)sender {
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:@"8afc9ukk" forKey:@"inviteCode"];
    [self getJSONDataWithUrl:kURL_GetOrganizationName  parameters:nil success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
    
}
//获取组织岗位信息
- (IBAction)handleGetPostInfo:(UIButton *)sender {
    
    [self getJSONDataWithUrl:kURL_ObtainPostInfoList parameters:nil success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}





//存储实体类
- (void)DataParsingEntityWithDictionary:(NSDictionary *)dic {
    NSString  *code = [NSString stringWithFormat:@"%@", dic[@"code"]];
    if (![code isEqualToString:@"0"]) {
        return;
    }
    id  tempDic =dic[@"response"];
    if (![tempDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    //先删除里面的数据
    [self deleteModel:@"UserDataModel"];
    NSDictionary *dataDic = dic[@"response"];
    UserDataModel *userModel = [NSEntityDescription insertNewObjectForEntityForName:@"UserDataModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
    for (NSString *key in dataDic) {
        [userModel setValue:dataDic[key] forKey:key];
    }
    [self.djCoreDataManager save];
    //查询数据
    NSArray *datarray =  [self queryModel:@"UserDataModel"];
    NSLog(@"查询数据datarray%@", datarray);
}






- (IBAction)handleReturn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
