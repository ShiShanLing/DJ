//
//  DJUserTool.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJUserTool.h"
#import "UserData.h"
@implementation DJUserTool
+ (instancetype)sharedInstance
{
    static DJUserTool *shareUserTools;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        shareUserTools = [[DJUserTool alloc] init];
    });
    return shareUserTools;
}


-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (NSMutableArray *)OrgInfoArray {
    if (!_OrgInfoArray) {
        _OrgInfoArray = [NSMutableArray array];
    }
    return _OrgInfoArray;
}
//保存用户相关信息
+ (void)saveLoginStatusWithUserId:(NSString *)userID  withPhone:(NSString *)userPhone withtokenn:(NSString *)usertoken withName:(NSString *)userName{
    
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USERID];
    [[NSUserDefaults standardUserDefaults] setObject:userPhone forKey:Phone];
    [[NSUserDefaults standardUserDefaults] setObject:usertoken forKey:userToken];
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:Name];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(void)doLoginWithData:(NSDictionary *)data {
    kNSLog(@"%@",data[@"name"]);
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LoginStatus];
    
    UserData *user = [UserData currentUser];
    user.headUrl = [self stringValueOfObject:data[@"headUrl"]];
    user.name = [self stringValueOfObject:data[@"name"]];
    user.phone = [self stringValueOfObject:data[@"phone"]];
    [[NSUserDefaults standardUserDefaults] setObject:user.headUrl forKey:HeadUrl];
    [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:Name];
    [[NSUserDefaults standardUserDefaults] setObject:user.phone forKey:Phone];
    [[NSUserDefaults standardUserDefaults] setObject:data[@"status"] forKey:LoginStatus];
    [[NSUserDefaults standardUserDefaults] setObject:data[@"token"] forKey:userToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    kNSLog(@"%@",user.name);
}

+ (void)updateHeadUrl:(NSString *)urlStr
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HeadUrl];
    [[NSUserDefaults standardUserDefaults] setObject:urlStr forKey:HeadUrl];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UserData *user = [UserData currentUser];
    user.headUrl = [[NSUserDefaults standardUserDefaults] objectForKey:HeadUrl];
}
+ (UserData *)getUserInfo{
    UserData *user = [UserData currentUser];
    user.headUrl = [[NSUserDefaults standardUserDefaults] objectForKey:HeadUrl];
    user.name = [[NSUserDefaults standardUserDefaults] objectForKey:Name];
    user.phone = [[NSUserDefaults standardUserDefaults] objectForKey:Phone];
    return user;
    kNSLog(@"%@", user.name);
}
//注销用户登录状态并清除存储值
+ (void)logOffLogin {
    //用户信息
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LoginStatus];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HeadUrl];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Name];
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PD"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//清除存储用户信息
+ (void)clearLoginInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HeadUrl];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Name];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Phone];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//用户是否登录
+ (BOOL)userIsLogin{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERID]) {
        return YES;
    }else
        return NO;
}
//用户是否实名认证
//+ (BOOL)userIsReal{
//
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:ISREAL]) {
//        return [[NSUserDefaults standardUserDefaults] boolForKey:ISREAL];
//    }else
//        return NO;
//}

//获取实名认证状态
//+ (NSString *)getRealStaus{
//
//    NSString *idStr = [[NSUserDefaults standardUserDefaults] objectForKey:ISREAL];
//    return idStr.length ? idStr:@"";
//
//}


//用户是党建用户
//+ (BOOL)isPartyUser{
//
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:ISPartyUser]) {
//        return [[NSUserDefaults standardUserDefaults] boolForKey:ISPartyUser];
//    }else
//        return NO;
//}

//获取用户ID
+ (NSString *)getUserID{
    
    NSString *idStr = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    return idStr.length ? idStr:@"";
    
}

+(NSString *)getUserPhone {
    NSString *PhoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:Phone];
    return PhoneStr.length ? PhoneStr:@"";
}
+(NSString *)getUserToken {
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:userToken];
    return tokenStr.length ? tokenStr:@"";
    
}
//获取用户BranchId
+ (NSString *)getBranchId{
    
    NSString *branchIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:BranchId];
    return branchIdStr.length ? branchIdStr:@"";
    
}

//获取组织
+ (NSString *)getOrganizeId{
    
    NSString *organizeIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:OrganizeId];
    return organizeIdStr.length ? organizeIdStr:@"";
    
}

+(NSString *)getUserHeadImage {
    
    NSString *idStr = [[NSUserDefaults standardUserDefaults] objectForKey:HeadUrl];
    return idStr.length ? idStr:@"";
    
}

+ (NSString *)getUserName {
    NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:UserName];
    return nameStr.length ? nameStr:@"";
}

//获取用户权限 permission        0,1,2 0-个人数据查看权限，1-组织数据查看权限，2-管理数据权限
+ (NSString *)getPermission{
    
    NSString *permissionStr = [[NSUserDefaults standardUserDefaults] objectForKey:Permission];
    return permissionStr.length ? permissionStr:@"";
    
}
+(void)setUserPhone:(NSString *)phone {
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:Phone];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)stringValueOfObject:(id)object
{
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }else if([object isKindOfClass:[NSNumber class]]){
        return [object stringValue];
    }else{
        return @"";
    }
}

+(void)setUserOrgAndCustom:(NSString  *)orgStr {
    [[NSUserDefaults standardUserDefaults] setObject:orgStr forKey:UserOrgConfig];
}

+(NSString *)getUserOrgAndCustom {
    NSString * userData = [[NSUserDefaults standardUserDefaults] objectForKey:UserOrgConfig];
    return userData;
}

+(NSString *)getUserCustomModule {
    NSString * userData = [[NSUserDefaults standardUserDefaults] objectForKey:UserModuleConfig];
    return userData;
}

+(void)setUserCustomModule:(NSString *)moduleStr {
    [[NSUserDefaults standardUserDefaults] setObject:moduleStr forKey:UserModuleConfig];
}

//设置版本号
+(void)setVersion:(NSString *)versionStr {
    [[NSUserDefaults standardUserDefaults] setObject:versionStr forKey:Version];
    
}
//获取版本号
+(NSString *)getVersion {
    NSString * versionStr = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:Version]];
    
    if (![versionStr isEmpty]) {
        return versionStr;
    }else {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDictionary));
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        return app_Version;
    }
}

//设置推送所需要的ID
+(void)setRegistrationID:(NSString *)registID {
    
    [[NSUserDefaults standardUserDefaults] setObject:registID forKey:JPushRegistrationID];
    
}
//获取推送所需要的ID
+(NSString *)getRegistID {
    NSString * registID  = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:JPushRegistrationID]];
    return registID;
}


//写入极光推送注册状态
+(void)setJPushRegState:(NSString *)state {
    
    [[NSUserDefaults standardUserDefaults] setObject:state forKey:JPushIsRegSuccess];
    
}
//读取极光推送注册状态
+(NSString *)getJPushRegState {
    NSString * state  = [[NSUserDefaults standardUserDefaults] objectForKey:JPushIsRegSuccess];
    return state;
}
@end
