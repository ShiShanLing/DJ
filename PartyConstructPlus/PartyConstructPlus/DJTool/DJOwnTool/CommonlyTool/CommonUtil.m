//
//  CommonUtil.m
//  wedding
//
//  Created by duanjycc on 14/11/14.
//  Copyright (c) 2014年 daoshun. All rights reserved.
//

#import "CommonUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <Photos/Photos.h>
#import "NSDate+GFCalendar.h"
#import <CoreLocation/CoreLocation.h>
static CommonUtil *defaultUtil = nil;
static BOOL LoadResults = NO;
static dispatch_group_t  groupQueue;
@interface CommonUtil() <UIActionSheetDelegate>{
    AppDelegate *appDelegate;
    //图片是否加载完毕了
}

@end

@implementation CommonUtil



- (instancetype)init
{
    self = [super init];
    if (self) {
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    return self;
}

+ (instancetype)currentUtil
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUtil = [[CommonUtil alloc] init];
    });
    
    return defaultUtil;
}



+ (NSString *)stringForID:(id)objectid {
    if ([CommonUtil isEmpty:objectid]) {
        return @"";
    }
    
    if ([objectid isKindOfClass:[NSString class]]) {
        return objectid;
    }
    
    if ([objectid isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        return [numberFormatter stringFromNumber:objectid];
    } else {
        return [NSString stringWithFormat:@"%@", objectid];
    }
}

// 判断空字符串
+ (BOOL)isEmpty:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSString class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    } else {
        return NO;
    }
}
//分割字符串
+(NSArray *)segmentationStr:(NSString *)str   keyword:(NSString *)keyword
{
   
        NSArray *array = [str componentsSeparatedByString:keyword];
   
    return array;
}

//NSUserDefaults
+ (id)getObjectFromUD:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)saveObjectToUD:(id)value key:(NSString *)key {
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutaDic = [value mutableCopy];
        NSArray *allkeys = mutaDic.allKeys;
        for (int i=0; i<[allkeys count]; i++) {
            NSString *key = [allkeys objectAtIndex:i];
            
            NSString *value = [mutaDic objectForKey:key];
            if ([CommonUtil isEmpty:value]) {
                [mutaDic setObject:@"" forKey:key];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:mutaDic forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteObjectFromUD:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//MD5加密
+ (NSString *)md5:(NSString *)password {
    const char *original_str = [password UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

//手机号码验证
+ (BOOL)checkPhonenum:(NSString *)phone {
    //手机号以1开头，11位数字
    NSString *phoneRegex = @"^[1]\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
//身份证号码验证
+(BOOL)checkUserID:(NSString *)userID
{
    //长度不为18的都排除掉
    if (userID.length!=18) {
        return NO;
    }
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:userID];
    
    if (!flag) {
        return flag;    //格式错误
    }else {
        //格式正确在判断是否合法
        
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[userID substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [userID substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel {
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];

    
    return phoneVersion;
}
//获取App版本
+ (NSString *)getAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appCurVersion;
}

/**
 * 判断是否登录
 */
- (BOOL)isLogin {
    return [self isLogin:YES];
}

- (BOOL)isLogin:(BOOL)needLogin {
    BOOL isLogin = NO;

    
    return isLogin;
}

- (NSString *)getLoginUserid {
    return nil;
}
/****************** 关于时间方法 ******************/
+ (NSString *)getTimeDiff:(NSDate *)fromdate{
    NSDate *nowDate = [NSDate date];
    // NSLog(@"系统零时区NSDate时间 = %@", nowDate);
    NSTimeInterval timeIn = [nowDate timeIntervalSince1970];
    //NSLog(@"系统零时区NSDate时间转化为时间戳 = %.0f", timeIn);
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeIn];
    NSLog(@"fromdate%@detaildate%@", fromdate, detaildate);
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentD =detaildate;
    NSDate *fromD = fromdate;
    NSTimeInterval current = [currentD timeIntervalSince1970]*1;
    NSTimeInterval from = [fromD timeIntervalSince1970]*1;
    NSTimeInterval value =  current-from;
//    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (3600);
    int day = (int)value / (24 * 3600);
    NSLog(@"day%d house%d minute%d",day, house, minute);
    NSString *str;
    if (day != 0) {
        if (day>=3) {
            
            NSInteger  currentYear = [currentD dateYear];
            NSInteger targetYear = [fromD dateYear];
            if (currentYear == targetYear) {
                str = [CommonUtil getStringForDate:fromdate format:@"MM-dd"];
            }else {
                str = [CommonUtil getStringForDate:fromdate format:@"yyyy-MM-dd"];
            }
            
        }else {
            str = [NSString stringWithFormat:@"%d天前",day];
        }
        
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"%d小时前",house];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%d分钟前",minute];
    }else{
        str = @"刚刚";
    }
    return str;
}
// Date 转换 NSString (默认格式：自定义)
+ (NSString *)getStringForDate:(NSDate *)date format:(NSString *)format {
    if (format == nil) format = @"yyyy-MM-dd HH:mm:ss";
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    return currentDateStr;
}
// NSString 转换 Date (默认格式：自定义)
+ (NSDate *)getDateForString:(NSString *)string format:(NSString *)format; {
    if (format == nil) format = @"yyyy-MM-dd HH:mm:ss";
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter dateFromString:string];
}


// 记录debug数据(log)
+ (void)writeDebugLogName:(NSString *)name data:(NSString *)data {
    // 创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 查找文件（设置目录）
    NSArray *directoryPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 传递 0 代表是找在Documents 目录下的文件。
    NSString *documentDirectory = [directoryPaths  objectAtIndex:0];
    // DBNAME 是要查找的文件名字，文件全名
    NSString *filePath = [documentDirectory  stringByAppendingPathComponent:@"debug.text"];
    NSLog(@"filePath  %@",filePath);
    // 用这个方法来判断当前的文件是否存在，如果不存在，就创建一个文件
    if ( ![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createFileAtPath:filePath  contents:nil attributes:nil];
    }
    
    // 获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    
    // 获取数据
    //    NSString* fileName = [documentDirectory stringByAppendingPathComponent:@"debug.text"];
    NSString *str = [NSString stringWithFormat:@"%@"@"  [%@]  "@"%@"@"\r\n",time,name,data];
    NSData *fileData = [str dataUsingEncoding:NSUTF8StringEncoding];
    //    [fileData writeToFile:fileName atomically:YES];
    
    // 追加写入数据
    NSFileHandle  *outFile;
    outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if(outFile == nil)
    {
        NSLog(@"Open of file for writing failed");
    }
    
    //找到并定位到outFile的末尾位置(在此后追加文件)
    [outFile seekToEndOfFile];
    [outFile writeData:fileData];
    
    //关闭读写文件
    [outFile closeFile];
}

// 根据文字，字号及固定宽(固定高)来计算高(宽) 需要计算什么，什么传值“0”
+ (CGSize)sizeWithString:(NSString *)text
                fontSize:(CGFloat)fontsize
               sizewidth:(CGFloat)width
              sizeheight:(CGFloat)height {
    
    // 用何种字体显示
    UIFont *font = [UIFont systemFontOfSize:fontsize];
    
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment=NSTextAlignmentLeft;
        
        NSAttributedString *attributeText=[[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle}];
        CGSize labelsize = [attributeText boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        expectedLabelSize = CGSizeMake(ceilf(labelsize.width),ceilf(labelsize.height));
    } else {
        expectedLabelSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, height) lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    // 计算出显示完内容的最小尺寸
    return expectedLabelSize;
}


// 窗口弹出动画
+ (void)shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.75;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [aView.layer addAnimation:animation forKey:nil];
}

+ (UIImage *)scaleImage:(UIImage *)image minLength:(float)length{
    if (image.size.width <= length || image.size.height <= length) {
        return image;
    }
    
    CGFloat scaleSize = MAX(length/image.size.width, length/image.size.height);
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (void) logout{
    // 清除本地账户信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefaults dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefaults removeObjectForKey:key];
        [userDefaults synchronize];
    }
    
    [CommonUtil saveObjectToUD:nil key:@"UserInfo"];
    
    [CommonUtil saveObjectToUD:nil key:@"loginusername"];
    [CommonUtil saveObjectToUD:nil key:@"loginpassword"];
}

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
//    NSLog(@"currentTimeString =  %@ -- %@datenow",currentTimeString, datenow);
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return currentTimeString;
    
}


//字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


//获取当前界面展示的视图是哪个
+ (UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}


+ (NSInteger)getCurrentTimeWithDateDifferenc:(NSDate *)targetDate {
    
    NSDate *currentDate = [NSDate date];
    
    double  intervalTime = [currentDate timeIntervalSinceReferenceDate] - [targetDate timeIntervalSinceReferenceDate];
    
    int iTime = (int)intervalTime;
    
    return iTime ;
}
+ (BOOL)isBlankDictionary:(NSDictionary *)dic {
    
    if (!dic) {
        
        return YES;
        
    }
    
    if ([dic isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if (!dic.count) {
        
        return YES;
        
    }
    
    if (dic == nil) {
        
        return YES;
        
    }
    
    if (dic == NULL) {
        
        return YES;
        
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isOpenPosition {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    }else {
        return YES;
    }
}

+ (NSString *)taskTagsHanziWithLetter:(NSString *)tag {
    NSMutableArray *tagArray = [NSMutableArray arrayWithArray:[tag componentsSeparatedByString:@","]];
    NSString *tagStr;
    NSDictionary * tempDic =@{@"A":@"主题党日",@"B":@"两学一做", @"C1":@"支部党员大会", @"C2":@"支部委员会", @"C3":@"党小组会", @"C4":@"党课"};
    for (int i = 0; i < tagArray.count; i ++) {
        NSString *tempTagStr = tagArray[i];
        NSString *vulueStr = [NSString stringWithFormat:@"%@", tempDic[tempTagStr]];
        
        if (i == 0 ) {
            if (![vulueStr isEmpty]) {
                tagStr = vulueStr;
            }else {
                tagStr = @"";
            }
        }else {
            if ([tagStr isEmpty]) {
                tagStr = vulueStr;
            }else {
                if ([vulueStr isEmpty]) {
                    
                }else {
                    tagStr = [NSString stringWithFormat:@"%@,%@", tagStr, vulueStr];
                }
                
            }
        }
        
    }
    return tagStr;
    
}
+ (NSString *)taskTagsLetterWithHanzi:(NSString *)tag {
    NSMutableArray *tagArray = [NSMutableArray arrayWithArray:[tag componentsSeparatedByString:@","]];
    NSString *tagStr;
    NSDictionary * tempDic =@{@"主题党日":@"A",@"两学一做":@"B", @"支部党员大会":@"C1", @"支部委员会":@"C2", @"党小组会":@"C3", @"党课":@"C4"};
    for (int i = 0; i < tagArray.count; i ++) {
        NSString *tempTagStr = tagArray[i];
        NSString *vulueStr = [NSString stringWithFormat:@"%@", tempDic[tempTagStr]];
        
        if (i == 0 ) {
            if (![vulueStr isEmpty]) {
                tagStr = vulueStr;
            }else {
                tagStr = @"";
            }
        }else {
            if ([tagStr isEmpty]) {
                tagStr = vulueStr;
            }else {
                if ([vulueStr isEmpty]) {
                    
                }else {
                    tagStr = [NSString stringWithFormat:@"%@,%@", tagStr, tempDic[tempTagStr]];
                }

            }
        }
    }
    
    return tagStr;
}
@end
