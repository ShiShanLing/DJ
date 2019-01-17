//
//  UserDataModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/20.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "UserDataModel+CoreDataProperties.h"

@implementation UserDataModel (CoreDataProperties)

+ (NSFetchRequest<UserDataModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"UserDataModel"];
}

@dynamic realName;
@dynamic status;
@dynamic tel;
@dynamic token;
@dynamic tokenTime;
@dynamic userName;
-(void)setValue:(id)value forKey:(NSString *)key {
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
    }else {
        [super setValue:[NSString stringWithFormat:@"%@", value] forKey:key];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
    
}
@end
