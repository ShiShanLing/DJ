//
//  TaskPushMsgModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/2.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "TaskPushMsgModel+CoreDataProperties.h"

@implementation TaskPushMsgModel (CoreDataProperties)

+ (NSFetchRequest<TaskPushMsgModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TaskPushMsgModel"];
}

@dynamic tel;
@dynamic status;
@dynamic platform;
@dynamic msgType;
@dynamic magId;
@dynamic extras;
@dynamic createTime;
@dynamic content;
@dynamic alias;
@dynamic updateTime;
@dynamic type;
@dynamic title;
@dynamic userId;
@dynamic taskId;
-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"magId"]) {
        self.magId= [NSString stringWithFormat:@"%@", value] ;
    }else if([key isEqualToString:@"extras"]) {
        self.extras= [NSString stringWithFormat:@"%@", value] ;
        NSData *data = [self.extras dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *tempDictQueryDiamond = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *ketArray = [tempDictQueryDiamond allKeys];
        if ([ketArray containsObject:@"taskId"]) {
            self.taskId = [NSString stringWithFormat:@"%@", tempDictQueryDiamond[@"taskId"]];
        }else {
            self.taskId = @"";
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
