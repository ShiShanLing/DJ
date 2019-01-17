//
//  TaskPushMsgModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/2.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "TaskPushMsgModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

/**
 推送的消息model
 */
@interface TaskPushMsgModel (CoreDataProperties)

+ (NSFetchRequest<TaskPushMsgModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *tel;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *platform;
@property (nullable, nonatomic, copy) NSString *msgType;
@property (nullable, nonatomic, copy) NSString *magId;
@property (nullable, nonatomic, copy) NSString *extras;
@property (nullable, nonatomic, copy) NSString *createTime;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *alias;
@property (nullable, nonatomic, copy) NSString *updateTime;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *taskId;

-(void)setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
