//
//  DJUserTool.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <Foundation/Foundation.h>
//用户组织配置 (默认组织)
#define UserOrgConfig  [NSString stringWithFormat:@"%@Org",  [[NSUserDefaults standardUserDefaults] objectForKey:USERID]]
//用户自定义模块配置 (默认展示模块)
#define UserModuleConfig  [NSString stringWithFormat:@"%@Module",  [[NSUserDefaults standardUserDefaults] objectForKey:USERID]]

#define USERID @"id"
//用户名
#define UserName   @"userName"
//登录状态
#define LoginStatus @"status"
//市民卡号 cardNo
#define CardNo @"cardNo"
//身份证号 idNo
#define IdNo @"idNo"
//头像地址 headUrl
#define HeadUrl @"headUrl"
//头像的IP

//姓名 name
#define Name @"name"
//手机号 phone
#define Phone @"tel"

#define userToken  @"token"
#define  USER @"User"
#define RANK @"rank"
#define  ISREAL @"isReal"
#define  ISPartyUser @"isPartyUser"
#define BranchId @"BRANCHID"
#define OrganizeId @"ORGANIZEDID"
#define Version  @"version"
#define Permission @"Permission"
#define KSESSIONID @"sessionId"
//推送所需的ID
#define JPushRegistrationID @"registrationID"
//记录向后台注册的推送有没有成功
#define JPushIsRegSuccess @"JPushRegState"
@class UserData;
@interface DJUserTool : NSObject

@property (nonatomic, strong)UserData *user;
@property (nonatomic, strong)NSMutableArray *OrgInfoArray;
+(instancetype) sharedInstance;


+ (void)saveLoginStatusWithUserId:(NSString *)userID  withPhone:(NSString *)userPhone withtokenn:(NSString *)usertoken withName:(NSString *)userName;

+ (void)logOffLogin;
//用户是否登录
+ (BOOL)userIsLogin;
//用户实名认证状态
//+ (BOOL)userIsReal;
//+ (NSString *)getRealStaus;
//用户是否党建用户
//+ (BOOL)isPartyUser;
//获取用户ID
+ (NSString *)getUserID;
+(NSString *)getUserPhone;
+(NSString *)getUserToken;
//获取用户BranchId
+ (NSString *)getBranchId;
//获取用户权限permission
+ (NSString *)getPermission;
//获取组织
+ (NSString *)getOrganizeId;
//获取用户头像
+(NSString *)getUserHeadImage;
+ (NSString *)getUserName;
+(void)setUserPhone:(NSString *)phone;

+ (void)clearLoginInfo;

+(void)doLoginWithData:(NSDictionary *)data;
+ (void)updateHeadUrl:(NSString *)urlStr;

+ (UserData *)getUserInfo;

//获取用户ID所对应的存储的默认组织名称
+(NSString *)getUserOrgAndCustom;
//吧用户存储默认组织ID存起来
+(void)setUserOrgAndCustom:(NSString  *)orgStr;
//获取用户ID所对应的存储的默认展示模块
+(NSString *)getUserCustomModule;
//把用户存储的默认实现模块存储起来 (存储方式 模块ID用","分割开拼接成字符串)
+(void)setUserCustomModule:(NSString *)moduleStr;
//记录网络状态
//设置版本号
+(void)setVersion:(NSString *)versionStr;
//获取版本号
+(NSString *)getVersion;
//设置推送所需要的ID
+(void)setRegistrationID:(NSString *)registID;
//获取推送所需要的ID
+(NSString *)getRegistID;
//写入极光推送注册状态
+(void)setJPushRegState:(NSString *)state;
//读取极光推送注册状态
+(NSString *)getJPushRegState;
@end
