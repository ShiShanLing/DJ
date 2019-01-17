//
//  UserData.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "UserData.h"

@implementation UserData
+(instancetype)currentUser
{
    static UserData *currentUser;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        currentUser = [[UserData alloc] init];
    });
    
    return currentUser;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
@end
