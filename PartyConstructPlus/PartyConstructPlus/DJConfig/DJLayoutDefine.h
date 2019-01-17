//
//  DJAdapterDefine.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//适配定义

#ifndef DJAdapterDefine_h
#define DJAdapterDefine_h

#define kWeakSelf(type)__weak typeof(type)weak##type = type;

#define kStrongSelf(type)__strong typeof(type)type = weak##type;

//根据屏幕大小自适应间距
#define kIphone6Height 667.0
#define kIphone6Width 375.0
//iphone 6为标准 自使用各个屏幕下的大小

#define MFont(f) [UIFont systemFontOfSize:f] //字体大小

#define kFit(x) ((x)*(kScreenWidth/kIphone6Width))
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width//屏幕宽度
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height//屏幕高度
#define kiPhoneX (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
#define kStatusBarAndNavigationBarHeight  (kiPhoneX ? 88.f : 64.f)
#define kTabbarSafeBottomMargin  (kiPhoneX ? 34.f : 0.f)
//iphoneX比普通手机导航条高出的距离
#define kXNavigationBarExtraHeight  ( kiPhoneX ? 24.0f : 0.0f)

#define  kiOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]*10000
#define  kIS_iOS7 [[[UIDevice currentDevice] systemVersion] intValue] == 7
#define  kIS_iOS8 [[[UIDevice currentDevice] systemVersion] intValue] == 8
#define  kIS_iOS9 [[[UIDevice currentDevice] systemVersion] intValue] == 9
#define  kIS_iOS10 [[[UIDevice currentDevice] systemVersion] intValue] == 10
#define  kIS_iOS11 [[[UIDevice currentDevice] systemVersion] intValue] == 11

//工具
#define kNSLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else //发布状态
// 关闭LOG功能
//#define kNSLog(s, ...)

#endif /* DJAdapterDefine_h */
