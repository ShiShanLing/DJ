//
//  LowerOrgUserModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "LowerOrgUserModel+CoreDataProperties.h"

@implementation LowerOrgUserModel (CoreDataProperties)

+ (NSFetchRequest<LowerOrgUserModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"LowerOrgUserModel"];
}

@dynamic orgId;
@dynamic stationId;
@dynamic userId;
@dynamic userName;
@dynamic state;
@dynamic orgName;


-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"name"]) {
        self.orgName = [NSString stringWithFormat:@"%@", value];
    }else {
        if ([value isKindOfClass:[NSNull class]]) {
            [super setValue:@"" forKey:key];
        }else {
            [super setValue:[NSString stringWithFormat:@"%@", value] forKey:key];
        }
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end
