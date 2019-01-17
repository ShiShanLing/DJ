//
//  OrgInfoModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "OrgInfoModel+CoreDataProperties.h"

@implementation OrgInfoModel (CoreDataProperties)

+ (NSFetchRequest<OrgInfoModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"OrgInfoModel"];
}

@dynamic chooseState;
@dynamic defaultState;
@dynamic orgId;
@dynamic orgName;
@dynamic state;
@dynamic stationId;
@dynamic stationName;
@dynamic userId;
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
