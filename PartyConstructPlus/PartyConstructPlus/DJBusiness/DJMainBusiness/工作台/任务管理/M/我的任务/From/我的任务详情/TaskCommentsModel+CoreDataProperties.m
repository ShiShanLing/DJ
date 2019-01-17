//
//  TaskCommentsModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/22.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "TaskCommentsModel+CoreDataProperties.h"

@implementation TaskCommentsModel (CoreDataProperties)

+ (NSFetchRequest<TaskCommentsModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TaskCommentsModel"];
}

@dynamic dfsUrl;
@dynamic evaContent;
@dynamic evaImg;
@dynamic taskId;
@dynamic orgId;
@dynamic currentTaskId;
@dynamic userHeadUrl;
@dynamic userName;
@dynamic createTime;
@dynamic sendUserName;
-(void)setValue:(id)value forKey:(NSString *)key {
    
    
    if ([key isEqualToString:@"id"]) {
        self.currentTaskId = [NSString stringWithFormat:@"%@", value];
    }else   if ([key isEqualToString:@"createTime"]) {
        self.createTime = [NSString stringWithFormat:@"%@", value];
        NSDate *tempDate = [CommonUtil  getDateForString:self.createTime format:@"yyyy-MM-dd HH:mm:ss"];
        self.createTime = [CommonUtil getStringForDate:tempDate format:@"yyyy-MM-dd HH:mm"];
    }else{
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
