//
//  IReceivedTaskModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "IReceivedTaskModel+CoreDataProperties.h"

@implementation IReceivedTaskModel (CoreDataProperties)

+ (NSFetchRequest<IReceivedTaskModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"IReceivedTaskModel"];
}

@dynamic createTime;
@dynamic endDate;
@dynamic isRead;
@dynamic startDate;
@dynamic stationId;
@dynamic status;
@dynamic tags;
@dynamic taskId;
@dynamic taskContent;
@dynamic updateTime;
@dynamic taskName;
@dynamic taskImg;
@dynamic sendUserName;
@dynamic currentTaskId;
@dynamic dfsUrl;
@dynamic totalNum;
@dynamic readNum;
@dynamic userName;
@dynamic userHeadUrl;
-(void)setValue:(id)value forKey:(NSString *)key {
    //我把id 设置为 taskId 发布人的任务id
    //我把taskId 设置为 currentTaskId  当前任务ID 请明了
    if ([key isEqualToString:@"taskId"]) {
        self.currentTaskId = [NSString stringWithFormat:@"%@", value];
    }else  if ([key isEqualToString:@"id"]) {
        self.taskId = [NSString stringWithFormat:@"%@", value];
    }else if ([key isEqualToString:@"createTime"]) {
        self.createTime = [NSString stringWithFormat:@"%@", value];
        NSDate *tempDate = [CommonUtil  getDateForString:self.createTime format:@"yyyy-MM-dd HH:mm:ss"];
        self.createTime = [CommonUtil getStringForDate:tempDate format:@"yyyy-MM-dd HH:mm"];
    }else  if ([key isEqualToString:@"updateTime"]) {
        self.updateTime = [NSString stringWithFormat:@"%@", value];
        NSDate *tempDate = [CommonUtil  getDateForString:self.updateTime format:@"yyyy-MM-dd HH:mm:ss"];
        self.updateTime = [CommonUtil getStringForDate:tempDate format:@"yyyy-MM-dd HH:mm"];
    }else  if ([key isEqualToString:@"endDate"]) {
        self.endDate = [NSString stringWithFormat:@"%@", value];
        NSDate *tempDate = [CommonUtil  getDateForString:self.endDate format:@"yyyy-MM-dd HH:mm:ss"];
        self.endDate = [CommonUtil getStringForDate:tempDate format:@"yyyy-MM-dd HH:mm"];
    }else  if ([key isEqualToString:@"startDate"]) {
        self.startDate = [NSString stringWithFormat:@"%@", value];
        NSDate *tempDate = [CommonUtil  getDateForString:self.startDate format:@"yyyy-MM-dd HH:mm:ss"];
        self.startDate = [CommonUtil getStringForDate:tempDate format:@"yyyy-MM-dd HH:mm"];
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
