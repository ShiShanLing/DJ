//
//  NSString+DJString.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DJString)
//+ (NSURL *)pathToURL:(NSInteger)integer {
//    return [NSURL URLWithString:[NSString stringWithFormat:@"%@",@""]];
//}
//生成图片的RUL
- (BOOL)isURL;

+ (BOOL)stringContainsEmoji:(NSString *)string;
//第三方键盘表情
+ (BOOL)hasEmoji:(NSString*)string;
/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
+(BOOL)isNineKeyBoard:(NSString *)string;

+ (BOOL)isContainsTwoEmoji:(NSString *)string;

+(BOOL)isEmpty;
-(NSString *)isNullFormString;
@end
