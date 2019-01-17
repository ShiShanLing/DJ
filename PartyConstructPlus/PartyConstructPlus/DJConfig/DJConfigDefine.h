//
//  DJConfigDefine.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//配置定义一般是第三方的配置

#ifndef DJConfigDefine_h
#define DJConfigDefine_h
//获取用户资料
#define  KUserDefaults   [NSUserDefaults standardUserDefaults]

#define  kCLIENT_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define kHOST_AES_KEY @"567456@abc123789"
#define kHOST_AES_VECTORKEY @"1234567ab2345678"
#define kEachPageRowNum  10

//正式环境(上线使用) bundle  id com.hzdj.PartyConstruct
//测试环境(测试使用) bundle  id  com.hzdj.PartyConstruct-ceshi

#endif /* DJConfigDefine_h */
