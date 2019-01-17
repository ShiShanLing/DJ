//
//  WorkingCalendarListModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/16.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "WorkingCalendarListModel+CoreDataProperties.h"

@implementation WorkingCalendarListModel (CoreDataProperties)

+ (NSFetchRequest<WorkingCalendarListModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"WorkingCalendarListModel"];
}

@dynamic wcId;
@dynamic wcName;
@dynamic orgId;
@dynamic stationId;
@dynamic status;
@dynamic type;
@dynamic userId;
@dynamic content;
-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.wcId =  [NSString stringWithFormat:@"%@", value];
    }else if ([key isEqualToString:@"name"]) {
        self.wcName = [NSString stringWithFormat:@"%@", value];
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
