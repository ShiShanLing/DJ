//
//  RegisteredDataModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "RegisteredDataModel+CoreDataProperties.h"

@implementation RegisteredDataModel (CoreDataProperties)

+ (NSFetchRequest<RegisteredDataModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"RegisteredDataModel"];
}

@dynamic oName;
@dynamic oId;
@dynamic userName;
@dynamic jobsName;
@dynamic jobsID;

-(void)setValue:(id)value forKey:(NSString *)key {
    NSLog(@"value%@ key%@", value,key);
    if ([key isEqualToString:@"name"]) {
        self.oName  = [NSString stringWithFormat:@"%@", value];
    }else   if ([key isEqualToString:@"id"]) {
        self.oId  = [NSString stringWithFormat:@"%@", value];
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
