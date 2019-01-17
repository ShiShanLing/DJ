//
//  DJSecurity.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSecurity.h"
#import <UIKit/UIKit.h>
#import "GTMBase64.h"
#import "NSData+Encryption.h"
#import <CommonCrypto/CommonCrypto.h>
#import "RSAEncrypt.h"
#define USER_APP_PATH @"/User/Applications/"
#define NumberOfChars 16
@interface DJSecurity ()
/**
*  设备是否安装了cydia
*
*  @return 返回YES说明已经越狱
*/
+ (BOOL)isJailBreakWithCydia;

/**
 *  是否可以读取系统所有应用的名称
 *
 *  @return 返回YES说明已经越狱
 */
+ (BOOL)isJailBreakWithAllAppName;

@end

@implementation DJSecurity

+ (DJSecurity *)sharedInstance
{
    static DJSecurity *_securiryUtilManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _securiryUtilManager = [[self alloc] init];
    });
    return _securiryUtilManager;
}

+(BOOL)isJailBreak
{
    return  ([DJSecurity isJailBreakWithAllAppName] || [DJSecurity isJailBreakWithCydia]);
}

+ (BOOL)isJailBreakWithCydia
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isJailBreakWithAllAppName
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH])
    {
        return YES;
    }
    
    return NO;
}


+ (NSString*)generateAESKey
{
    
    char data[NumberOfChars];
    for (int i = 0; i < NumberOfChars; i++)
    {
        data[i] = (char)('A' + (arc4random_uniform(26)));
    }
    
    NSString *randomStr = [[NSString alloc] initWithBytes:data length:NumberOfChars encoding:NSUTF8StringEncoding];
    
    return randomStr;
}

+ (NSString*)SMKAESEncrypt:(NSString*)codeString key:(NSString *)aesKey
{
    NSData* data = [codeString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encodeData = [data AES256EncryptWithKey:aesKey];
    NSString *postString = [GTMBase64 stringByEncodingData:encodeData];
    
    return postString;
}

+ (NSString*)SMKAESDecrypt:(NSString*)codeString key:(NSString *)aesKey
{
    NSData* decodeData = [GTMBase64 decodeString:codeString];
    NSData* base64Data =  [decodeData AES256DecryptWithKey:aesKey];
    NSString* requestString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return requestString;
}

+ (NSString*)SMKRSAEncrypt:(NSString*)codeString
{
    NSError* error = nil;
    RSAEncrypt *encrypt = [[RSAEncrypt alloc] init];
    SecKeyRef key = [encrypt getPublicKey];
    NSData *data = [encrypt encrypt:codeString usingKey:key error:&error];
    NSString *postString = [GTMBase64 stringByEncodingData:data];
    
    return postString;
}

+ (NSString*)encodeBase64String:(NSString * )input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64String:(NSString * )input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)encodeBase64Data:(NSData *)data
{
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data
{
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString *)aesEncrypt:(NSString*)codeString key:(NSString *)aesKey vector:(NSString *)aesVector
{
    NSData *codeData = [codeString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decrypResutJson = [NSData TripleAES:codeData encryptOrDecrypt:kCCEncrypt key:aesKey vector:aesVector];
    
    return [GTMBase64 stringByEncodingData:decrypResutJson];;
}

+ (NSString *)aesDecrypt:(NSString*)codeString key:(NSString *)aesKey vector:(NSString *)aesVector
{
    //    NSString *str = [self decodeBase64String:codeString];
    NSData *codeData = [GTMBase64 decodeString:codeString];
    NSData *decryptData = [NSData TripleAES:codeData encryptOrDecrypt:kCCDecrypt key:aesKey vector:aesVector];
    NSString *decryptString = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    //
    return decryptString;
    
    //    NSData *codeData = [codeString dataUsingEncoding:NSUTF8StringEncoding];
    //    NSData *decrypResutJson = [NSData TripleAES:codeData encryptOrDecrypt:kCCEncrypt key:aesKey vector:aesVector];
    //    return [GTMBase64 stringByEncodingData:decrypResutJson];;
    
}
@end
