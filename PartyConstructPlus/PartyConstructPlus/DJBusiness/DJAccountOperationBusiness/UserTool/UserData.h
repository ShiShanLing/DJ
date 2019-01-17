//
//  UserData.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserData : NSObject
@property (nonatomic, strong)NSString *headUrl; //头像地址
@property (nonatomic, strong)NSString *name;//姓名
@property (nonatomic, strong)NSString *phone;//手机号


+(instancetype)currentUser;

@end
