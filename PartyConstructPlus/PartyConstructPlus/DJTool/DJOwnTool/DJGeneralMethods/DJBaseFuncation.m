//
//  DJBaseFuncation.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseFuncation.h"
#import <CommonCrypto/CommonDigest.h>
#import "DJSecurity.h"
#import "DJNetworking.h"
@implementation DJBaseFuncation
#pragma mark-alertView
+(void)showAlertwithTitle:(NSString *)title andMessage:(NSString *)message andTag:(int)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alertView.tag = tag;
    [alertView show];
}
+(void)showAlertNoTitle:(NSString *)message andTag:(int)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alertView.tag = tag;
    [alertView show];
}

#pragma mark -time
+(NSString *)nowTimeSince1970//
{
    NSDate *date = [NSDate date];
    return [NSString stringWithFormat:@"%d", (int)[date timeIntervalSince1970]];
}
+(NSString *)timeFormat:(NSString *)time andDateFormat:(NSString *)format//时间格式转换
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}
#pragma mark -去除tableView多余线
+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark -去字符串空格
+(NSString *)replacWhiteLine:(NSString *)string
{
    NSString *newString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newString;
}

+(NSString *)convertTime:(NSString *)time
{
    NSString *timeValue = @"";
    if(time  && time.length == 14 )
    {
        NSString *year = [time substringWithRange:NSMakeRange(0,4)];
        NSString *month = [time substringWithRange:NSMakeRange(4,2)];
        NSString *day = [time substringWithRange:NSMakeRange(6,2)];
        
        
        NSString *hour = [time substringWithRange:NSMakeRange(8,2)];
        NSString *min = [time substringWithRange:NSMakeRange(10,2)];
        NSString *sec = [time substringWithRange:NSMakeRange(12,2)];
        timeValue = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,month,day,hour,min,sec];
        return timeValue;
    }
    return nil;
}
+(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}
+(NSString *)rsaRandomNumber;//16位随机数
{
    NSString *strRandom = @"";
    
    for(int i=0; i<16; i++)
    {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    //    NSLog(@"随机数: %@", strRandom);
    return strRandom;
}
+ (UIColor *) getColor:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    //3 * 45
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
//根据文字字数计算高度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName:font};
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+(UIView*)createViewWithFrame:(CGRect)frame {
    //创建View
    UIView*view=[[UIView alloc]initWithFrame:frame];
    return view;
}

+(UIImageView*)createImageViewFrame:(CGRect)frame imageName:(NSString*)imageName{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    //如果imageName传递是空，虽然不会崩溃，但是打印信息会显示很多GUI错误，所以要判断imageName是否为nil
    if (imageName) {
        imageView.image=[UIImage imageNamed:imageName];
        
    }
    imageView.userInteractionEnabled=YES;
    return imageView;
}
+(UIButton*)createButtonFrame:(CGRect)frame Title:(NSString*)title BgImageName:(NSString*)bgImageName ImageName:(NSString*)imageName Method:(SEL)sel target:(id)target
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        
    }
    if (bgImageName) {
        [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    //添加方法
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    //记住，这里无论手动还是自动都不需要释放！，因为button本身是使用类方法进行创建
    return button;
}

+(UILabel*)createLabelFrame:(CGRect)frame font:(float)font Text:(NSString*)text{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //设置折行方式，注意设置折行方式以后就无法使用sizeToFit，如果使用，需要设置回默认
    label.lineBreakMode=NSLineBreakByCharWrapping;
    //设置限制行数 0为不限制行数
    label.numberOfLines=0;
    //设置字号
    label.font = [UIFont systemFontOfSize:font];
    //设置文字
    label.text=text;
    return label;
}


+(UITextField*)createTextFieldFrame:(CGRect)frame Placeholder:(NSString*)placeholder leftView:(UIView*)leftView rightView:(UIView*)rightView BgImageName:(NSString*)bgImageName font:(float)font{
    
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    textField.placeholder=placeholder;
    //左边图像
    textField.leftViewMode=UITextFieldViewModeAlways;
    textField.leftView=leftView;
    //右边图像
    textField.rightViewMode=UITextFieldViewModeAlways;
    textField.rightView=rightView;
    if (bgImageName) {
        [textField setBackground:[UIImage imageNamed:bgImageName]];
    }
    
    textField.font=[UIFont systemFontOfSize:font];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
    
}
//+(NSString *)getUUID
//
//{
//
//    NSString * strUUID = (NSString *)[KeyChainStore load:@"com.company.app.usernamepassword"];
//
//
//
//    //首次执行该方法时，uuid为空
//
//    if ([strUUID isEqualToString:@""] || !strUUID)
//
//    {
//
//        //生成一个uuid的方法
//
//        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
//
//
//
//        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
//
//
//
//        //将该uuid保存到keychain
//
//        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
//
//
//
//    }
//
//    return strUUID;
//
//}

#pragma  mark *******************  解密  *******************

+ (NSDictionary *)paramsDecrypt:(NSString *)str
{
    if (str!=nil) {
        //        NSString *key = [[NSUserDefaults standardUserDefaults]objectForKey:@"sessionKey"];
        //        if ([Zhengze isEmpty:key]) {
        //            [self showAlertNoTitle:@"数据传输失败" andTag:0];
        //            return nil;
        //        }
        //        NSString *enStr = [SMKSecurity SMKAESDecrypt:str key:key];
        //        NSString *eee = @"l9tdvKU6wirG2LNbqC/X0k/uroesuakjZ4pUZqdncU1JalP9LzIP90+R4wlb6PUa18VMQysqgmqydSDLKiPrSQ==";
        NSString *enStr = [DJSecurity aesDecrypt:str key:kHOST_AES_KEY vector:kHOST_AES_VECTORKEY];
        
        
        //NSLog(@"enenenestr = %@",enStr);
        if([enStr isEqual:[NSNull null]])
        {
            
            [self showAlertNoTitle:@"数据传输失败" andTag:0];
            return nil;
        }
        NSData *jsonData = [enStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        if (jsonData == nil) {
            //NSLog(@"key = %@,str = %@",key,str);
            return nil;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err) {
            //            NSLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    }
    return nil;
}
#pragma  mark *******************  加密  *******************

+ (NSDictionary *)paramsEncrypt:(NSDictionary *)dic
{
    if (dic!=nil) {
        
        NSString *jsonStr = [NSString stringWithFormat:@"%@",[DJNetworking dataTOjsonString:dic]];
        
        NSString *enStr = [DJSecurity aesEncrypt:jsonStr key:kHOST_AES_KEY vector:kHOST_AES_VECTORKEY];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[@"body"] = enStr;
        return params;
    }
    return nil;
}

//判断是否输入了emoji 表情

+ (BOOL)stringContainsEmoji:(NSString *)string{
    
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
     
                               options:NSStringEnumerationByComposedCharacterSequences
     
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                
                                const unichar hs = [substring characterAtIndex:0];
                                
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    
                                    if (substring.length > 1) {
                                        
                                        const unichar ls = [substring characterAtIndex:1];
                                        
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            
                                            returnValue = YES;
                                            
                                        }
                                        
                                    }
                                    
                                } else if (substring.length > 1) {
                                    
                                    const unichar ls = [substring characterAtIndex:1];
                                    
                                    if (ls == 0x20e3) {
                                        
                                        returnValue = YES;
                                        
                                    }
                                    
                                    
                                    
                                } else {
                                    
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        
                                        returnValue = YES;
                                        
                                    }else if (hs == 0x200d){
                                        
                                        returnValue = YES;
                                        
                                    }
                                    
                                }
                                
                            }];
    
    
    
    return returnValue;
    
}

//禁止输入表情
+ (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}


+ (CGFloat )caculateCGSzieWidthWithStr:(NSString *)textStr withHeight:(CGFloat )height
{
    CGSize titleSize = [textStr boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size;
    float width = titleSize.width;
    return width;
    
}

@end
