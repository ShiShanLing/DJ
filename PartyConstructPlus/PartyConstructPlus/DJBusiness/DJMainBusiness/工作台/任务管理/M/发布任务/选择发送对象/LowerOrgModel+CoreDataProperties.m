//
//  LowerOrgModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "LowerOrgModel+CoreDataProperties.h"

@implementation LowerOrgModel (CoreDataProperties)

+ (NSFetchRequest<LowerOrgModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"LowerOrgModel"];
}

@dynamic content;
@dynamic name;
@dynamic orgId;
@dynamic pid;
@dynamic orgUser;
@dynamic lowerOrg;
@dynamic orgLevel;
@dynamic chooseNum;
@dynamic isSelectAll;
-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.orgId = [NSString stringWithFormat:@"%@", value];
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
