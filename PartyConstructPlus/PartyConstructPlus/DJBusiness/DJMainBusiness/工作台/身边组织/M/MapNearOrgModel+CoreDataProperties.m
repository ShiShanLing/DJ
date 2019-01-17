//
//  MapNearOrgModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "MapNearOrgModel+CoreDataProperties.h"

@implementation MapNearOrgModel (CoreDataProperties)

+ (NSFetchRequest<MapNearOrgModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"MapNearOrgModel"];
}

@dynamic address;
@dynamic content;
@dynamic lat;
@dynamic lon;
@dynamic name;
@dynamic pid;
@dynamic tel;

-(void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:@"" forKey:key];
    }else {
        [super setValue:[NSString stringWithFormat:@"%@", value] forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end
