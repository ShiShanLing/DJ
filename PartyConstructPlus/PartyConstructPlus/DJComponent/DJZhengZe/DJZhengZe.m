//
//  DJZhengZe.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJZhengZe.h"

@implementation DJZhengZe
#pragma mark -验证手机号码 原来是
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *phoneStr = @"0?(13|14|15|16|17|18|19)[0-9]{9}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneStr];
    
    
    return  [regextestmobile evaluateWithObject:mobileNum];
}
#pragma mark -验证用户名 只能是英文+数字，数字不能以0开头
+ (BOOL)isUsername:(NSString *)username//用户名
{
    NSString * p = @"^(?!0)[A-Za-z0-9]+$";
    
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", p];
    
    if ([regextest evaluateWithObject:username] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark -验证用户姓名 只能中文或英文
+ (BOOL)isName:(NSString *)username//用户姓名
{
    NSString * p = @"^(?!0)[a-zA-Z\u4E00-\u9FA5·]+$";
    
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", p];
    
    if ([regextest evaluateWithObject:username] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark -验证密码 只能英文+数字的组合，位数6-20位
+ (BOOL)isPassord:(NSString *)password
{
    NSString * p = @"^(?=.*?[a-zA-Z])(?=.*?[0-9])[a-zA-Z0-9]{6,20}$";
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", p];
    
    if ([regextest evaluateWithObject:password] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -验证字符串是否为空
+(BOOL)isEmpty:(NSString *)str {
    
    if (str==nil) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else
        {
            return false;
        }
    }
}
#pragma mark -验证中文
+ (BOOL)isChinese:(NSString *)str//判断中文
{
    NSString * p = @"^(?!0)[\u4E00-\u9FA5]+$";
    
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", p];
    
    if ([regextest evaluateWithObject:str] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark -检测Email是否合法
+(BOOL)isEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark -验证身份证
+ (BOOL) isIdentityCard: (NSString *)value
{
    value = [value uppercaseString];
    if ([value length] != 18 && [value length]!= 15) {
        return NO;
    }else if ([value length] == 15)
    {
        NSString *pattern = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isMatch = [pred evaluateWithObject:value];
        return isMatch;
    }
    else
    {
        NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
        NSString *leapMmdd = @"0229";
        NSString *year = @"(19|20)[0-9]{2}";
        NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
        NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
        NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
        NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
        NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
        NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9X]"];
        
        NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if (![regexTest evaluateWithObject:value]) {
            return NO;
        }
        int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
        + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
        + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
        + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
        + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
        + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
        + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
        + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
        + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
        NSInteger remainder = summary % 11;
        NSString *checkBit = @"";
        NSString *checkString = @"10X98765432";
        checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
        return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
    }
    
}

+ (BOOL)isUrl:(NSString *)url
{
    NSString *regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:url] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    //    return [pred evaluateWithObject:self];
}

@end
