//
//  DJNetworkStatusClass.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJNetworkStatusClass.h"

@implementation DJNetworkStatusClass
static DJNetworkStatusClass *__onetimeClass;
+(DJNetworkStatusClass *)sharedOneTimeClass {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        __onetimeClass = [[DJNetworkStatusClass alloc]init];
    });
    return __onetimeClass;
}

@end
