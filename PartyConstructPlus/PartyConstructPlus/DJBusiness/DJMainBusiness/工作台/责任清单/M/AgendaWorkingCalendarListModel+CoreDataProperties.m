//
//  AgendaWorkingCalendarListModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/16.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "AgendaWorkingCalendarListModel+CoreDataProperties.h"

@implementation AgendaWorkingCalendarListModel (CoreDataProperties)

+ (NSFetchRequest<AgendaWorkingCalendarListModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"AgendaWorkingCalendarListModel"];
}

@dynamic wcId;
@dynamic orgId;
@dynamic planId;
@dynamic stationId;
@dynamic status;
@dynamic taskContent;
@dynamic taskName;
@dynamic type;
@dynamic userId;
@dynamic beginTime;
@dynamic endTime;
@dynamic dfsUrl;
@dynamic doImg;
@dynamic doMsg;
@dynamic orgName;
-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.wcId = [NSString stringWithFormat:@"%@", value];
    }else if([key isEqualToString:@"createTime"]){
        NSString *timeStr = [NSString stringWithFormat:@"%@", value];
        if (timeStr.length > 10) {
            self.beginTime = [timeStr substringToIndex:10];
        }else {
            self.beginTime = timeStr;
        }
    }else if([key isEqualToString:@"outTime"]){
        NSString *timeStr = [NSString stringWithFormat:@"%@", value];
        if (timeStr.length > 10) {
            self.endTime = [timeStr substringToIndex:10];
        }else {
            self.endTime = timeStr;
        }
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
