//
//  SMKNetConnect.h
//  demo
//
//  Created by HzCitizen on 15/12/30.
//  Copyright © 2015年 HzCitizen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SMKSuccessResponseBlock)(id responseObject);
typedef void (^SMKFailResponseBlock)(NSError* error);

@interface SMKNetConnect : NSObject

+(NSString *)getReqSeq;//获取请求流水号
+(int)getRandomNumber;//1-10000随机数
+(NSString *)dataTOjsonString:(id)object;//转json
+(NSString *)UrlValueEncode:(NSString*)str;//转码
//获取到sessionkey后的接口调用方法
+(void)getJSONDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SMKSuccessResponseBlock)success
                  failure:(SMKFailResponseBlock)failure;

@end
