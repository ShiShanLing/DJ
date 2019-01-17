//
//  SMKNetConnect.m
//  demo
//
//  Created by HzCitizen on 15/12/30.
//  Copyright © 2015年 HzCitizen. All rights reserved.
//

#import "SMKNetConnect.h"
#import "SmkBaseFuncation.h"

@implementation SMKNetConnect
#pragma mark -请求流水号
+(NSString *)getReqSeq
{
    NSString *time = [NSString stringWithFormat:@"%@",[SmkBaseFuncation timeFormat:[SmkBaseFuncation nowTimeSince1970] andDateFormat:@"yyyyMMddHHmmss"]];
    NSString *rNumber = [NSString stringWithFormat:@"%d",[self getRandomNumber]];
    NSString *reqSeq = [time stringByAppendingString:rNumber];
    return reqSeq;
}
+(int)getRandomNumber
{
    return (int)(1 + (arc4random() % (100000)));
}

+(NSString *)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
+(NSString *)UrlValueEncode:(NSString*)str
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)str,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

#pragma mark -获取到SessionKey方法
+(void)getJSONDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SMKSuccessResponseBlock)success
                  failure:(SMKFailResponseBlock)failure {
    
 //   NSLog(@"获取加密前的数据请求接口  urlString==%@parameters==%@", urlString,parameters);
    if ([NSJSONSerialization isValidJSONObject:parameters]) {
        NSString *sessionId = nil;
        if ([DJZhengZe isEmpty:[KUserDefaults objectForKey:@"sessionId"]]) {
            sessionId = @"";
        } else {
            sessionId = [KUserDefaults objectForKey:@"sessionId"];
        }
        NSString *userID = nil;//这里是登录名
        if ([DJZhengZe isEmpty:[KUserDefaults objectForKey:USERID]]) {
            userID = @"";
        }
        else
        {
            userID = [KUserDefaults objectForKey:USERID];
        }
        NSString *registerId = nil;
        if ([DJZhengZe isEmpty:[KUserDefaults objectForKey:@"RegistrationID"]]) {
            registerId = @"";
        }
        else
        {
            registerId = [KUserDefaults objectForKey:@"RegistrationID"];
        }
        NSString *version = kCLIENT_VERSION;
        AFHTTPSessionManager *httpSessionManager = [AFHTTPSessionManager manager];
        [httpSessionManager.requestSerializer setTimeoutInterval:60];
        httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [httpSessionManager.requestSerializer setValue:sessionId forHTTPHeaderField:@"sessionId"];
        [httpSessionManager.requestSerializer setValue:userID forHTTPHeaderField:@"userId"];
        [httpSessionManager.requestSerializer setValue:version forHTTPHeaderField:@"currVersion"];
        [httpSessionManager.requestSerializer setValue:registerId forHTTPHeaderField:@"registerId"];
        [httpSessionManager.requestSerializer setValue:@"com.party.ios" forHTTPHeaderField:@"appId"];
        //这个步骤是加密
        NSDictionary *keyParams = [SmkBaseFuncation paramsEncrypt:parameters];

        [httpSessionManager POST:urlString parameters:keyParams progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject allKeys] containsObject:@"body"]) {
                NSString *bodyStr = [responseObject objectForKey:@"body"];
                if([@"" isEqualToString:bodyStr]) {
                    success(responseObject);
                } else {
                    NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:[SmkBaseFuncation paramsDecrypt:bodyStr]];
                    success(responseDic);
                }
            } else{
                success(responseObject);
            }
//            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
        [httpSessionManager.operationQueue cancelAllOperations];
    }
}


@end
