//
//  TaskStepModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "TaskStepModel+CoreDataProperties.h"

@implementation TaskStepModel (CoreDataProperties)

+ (NSFetchRequest<TaskStepModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TaskStepModel"];
}

@dynamic content;
@dynamic createTime;
@dynamic evaRank;
@dynamic img;
@dynamic status;
@dynamic dfsUrl;
-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"createTime"]) {
        self.createTime = [NSString stringWithFormat:@"%@", value];
        NSDate *tempDate = [CommonUtil  getDateForString:self.createTime format:@"yyyy-MM-dd HH:mm:ss"];
        self.createTime = [CommonUtil getStringForDate:tempDate format:@"yyyy-MM-dd HH:mm"];
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
