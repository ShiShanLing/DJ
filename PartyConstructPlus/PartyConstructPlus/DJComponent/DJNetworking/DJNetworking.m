//
//  DJNetworking.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJNetworking.h"
#import "DJBaseFuncation.h"
#import "DJBaseViewController.h"
@implementation DJNetworking


#pragma mark -请求流水号
+(NSString *)getReqSeq
{
    NSString *time = [NSString stringWithFormat:@"%@",[DJBaseFuncation timeFormat:[DJBaseFuncation nowTimeSince1970] andDateFormat:@"yyyyMMddHHmmss"]];
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
+ (NSData *)jsonClassConvertToJosnDataWithJsonClass:(NSDictionary *)jsonClass
{
    NSError *error;
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:jsonClass options:NSJSONWritingPrettyPrinted error:&error];
    
    return dataJson;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}



+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
        
        
    }
    
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:0
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

+ (NSDictionary *)jsonToDic:(NSString *)jsonStr {
    NSError *parseError = nil;
    NSData * getJsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * getDict = [NSJSONSerialization JSONObjectWithData:getJsonData options:0 error:&parseError];

    return getDict;
    
}

+ (void)getJSONDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(DJSuccessResponseBlock)success failure:(DJFailResponseBlock)failure {
//        NSString *version = kCLIENT_VERSION;
        AFHTTPSessionManager *httpSessionManager = [AFHTTPSessionManager manager];
    
        httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
//    Response.removesKeysWithNullValues = YES;
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *token = [DJUserTool getUserToken];
    NSLog(@"token%@", token);
        if (token.length == 0) {
        }else {
            [httpSessionManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        }
    
        [httpSessionManager.requestSerializer setValue:@"com.party.test" forHTTPHeaderField:@"appId"];
        [httpSessionManager.requestSerializer setValue:[CommonUtil getAppVersion]  forHTTPHeaderField:@"version"];
        [httpSessionManager.requestSerializer setValue:[CommonUtil getCurrentDeviceModel]  forHTTPHeaderField:@"deviceVersion"];
        [httpSessionManager.requestSerializer setValue:@"ios"  forHTTPHeaderField:@"systemVersion"];
    NSLog(@"version%@ deviceVersion%@", [CommonUtil getAppVersion], [CommonUtil getCurrentDeviceModel]);
//        //这个步骤是加密
//        NSDictionary *keyParams = [DJBaseFuncation paramsEncrypt:parameters];
        [httpSessionManager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject allKeys] containsObject:@"body"]) {
                NSString *bodyStr = [responseObject objectForKey:@"body"];
                if([@"" isEqualToString:bodyStr]) {
                    success(responseObject);
                } else {
                    NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:[DJBaseFuncation paramsDecrypt:bodyStr]];
                    success(responseDic);
                }
            } else {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
        [httpSessionManager.operationQueue cancelAllOperations];
    
}

//查询实体类
+ (UserDataModel *)queryModel {
    
    DJBaseViewController *VC = [[DJBaseViewController alloc] init];
    VC.djCoreDataManager = [DJCoreDataManager shareInstance];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserDataModel"
                                              inManagedObjectContext:VC.djCoreDataManager.managedObjectContext];
    ///创建查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    ///设置查询请求的 实体
    [request setEntity:entity];
    //    //添加查询条件
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age=10"];
    //    [request setPredicate:predicate];
    ///获取查询的结果
    NSArray *resultArray = [VC.djCoreDataManager.managedObjectContext executeFetchRequest:request
                                                                                      error:nil];
    if (resultArray.count != 0) {
        UserDataModel *model = resultArray[0];
        return model;
    }
    return nil;
}

@end
