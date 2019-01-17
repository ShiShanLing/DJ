//
//  DJZhengZe.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *正则表达式
 */
@interface DJZhengZe : NSObject
+ (BOOL)isMobileNumber:(NSString *)mobileNum;//验证手机号码是否合法
+ (BOOL)isUsername:(NSString *)username;//验证注册、登陆的用户名是否合法
+ (BOOL)isPassord:(NSString *)password;//验证登陆密码是否合法
+ (BOOL) isIdentityCard: (NSString *)value;//验证身份证是否合法
+ (BOOL)isEmpty:(NSString *)str;//判断是否为空值
+ (BOOL)isName:(NSString *)username;//用户姓名  中文和英文
+ (BOOL)isChinese:(NSString *)str;//判断是否是中文
+ (BOOL)isEmail:(NSString *)email;//检测email
+ (BOOL)isUrl:(NSString *)url;
@end
