//
//  SmkBaseFuncation.h
//  demo
//
//  Created by HzCitizen on 15/12/29.
//  Copyright © 2015年 HzCitizen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
 #import "KeyChainStore.h"
@interface SmkBaseFuncation : NSObject
#pragma mark -AlertView
+(void)showAlertwithTitle:(NSString *)title andMessage:(NSString *)message andTag:(int)tag;//带标题的alertView
+(void)showAlertNoTitle:(NSString *)message andTag:(int)tag;//不带标题的alertView

#pragma mark -Time
+(NSString *)nowTimeSince1970;//当前时间
+(NSString *)timeFormat:(NSString *)time andDateFormat:(NSString *)format;//时间格式转化，time为时间，format为时间格式

#pragma mark -XML解析
+(NSDictionary *)xmlParse:(NSData *)data;
#pragma mark -去除tableView多余线
+(void)setExtraCellLineHidden: (UITableView *)tableView;

+(NSString *)replacWhiteLine:(NSString *)string;

+(NSString *)convertTime:(NSString *)time;

+(NSString *) md5:(NSString *)str;

+(NSString *)rsaRandomNumber;//16位随机数
#pragma mark 颜色十六进制转换
+ (UIColor *) getColor: (NSString *)color;
#pragma mark 根据文字字数计算高度
/**
 根据文字字数计算高度
 @param text 需要计算的文字
 @param font 文字的大小
 @param maxSize 显示控件的宽度
 @return 控件的高度
 */
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
#pragma mark 创建View
+(UIView *)createViewWithFrame:(CGRect)frame;
#pragma mark 创建ImageView
+(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString*)imageName;
#pragma mark 创建button
+(UIButton *)createButtonFrame:(CGRect)frame Title:(NSString*)title BgImageName:(NSString*)bgImageName ImageName:(NSString*)imageName Method:(SEL)sel target:(id)target;
#pragma mark 创建label
+(UILabel*)createLabelFrame:(CGRect)frame font:(float)font Text:(NSString*)text;
#pragma mark 创建textField
+(UITextField*)createTextFieldFrame:(CGRect)frame Placeholder:(NSString*)placeholder
                           leftView:(UIView*)leftView rightView:(UIView*)rightView BgImageName:(NSString*)bgImageName font:(float)font;

//+ (NSString *)getUUID;
#pragma mark -加密
+ (NSDictionary *)paramsEncrypt:(NSDictionary *)dic;
#pragma mark -解密
+ (NSDictionary *)paramsDecrypt:(NSString *)str;
//判断是否输入了emoji 表情
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (NSString *)disable_emoji:(NSString *)text;

+ (CGFloat )caculateCGSzieWidthWithStr:(NSString *)textStr  withHeight:(CGFloat)height;

@end
