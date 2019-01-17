//
//  DJNetworking.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^DJSuccessResponseBlock)(id responseObject);
typedef void (^DJFailResponseBlock)(NSError* error);
@interface DJNetworking : NSObject

+(NSString *)getReqSeq;//获取请求流水号
+(int)getRandomNumber;//1-10000随机数
+(NSString *)dataTOjsonString:(id)object;//转json
+(NSString *)UrlValueEncode:(NSString*)str;//转码

+(void)getJSONDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(DJSuccessResponseBlock)success
                  failure:(DJFailResponseBlock)failure;
@end
