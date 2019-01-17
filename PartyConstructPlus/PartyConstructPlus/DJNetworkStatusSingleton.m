//
//  DJNetworkStatusClass.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJNetworkStatusSingleton.h"

@implementation DJNetworkStatusSingleton
static DJNetworkStatusSingleton *__onetimeClass;
+(DJNetworkStatusSingleton *)sharedNetworkStatusSingleton {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        __onetimeClass = [[DJNetworkStatusSingleton alloc]init];
    });
    return __onetimeClass;
}

@end
