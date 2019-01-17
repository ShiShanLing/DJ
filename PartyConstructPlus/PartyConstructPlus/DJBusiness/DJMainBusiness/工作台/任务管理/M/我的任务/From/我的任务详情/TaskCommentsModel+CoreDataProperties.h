//
//  TaskCommentsModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/22.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "TaskCommentsModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TaskCommentsModel (CoreDataProperties)

+ (NSFetchRequest<TaskCommentsModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *dfsUrl;
@property (nullable, nonatomic, copy) NSString *evaContent;
@property (nullable, nonatomic, copy) NSString *evaImg;
@property (nullable, nonatomic, copy) NSString *taskId;
@property (nullable, nonatomic, copy) NSString *orgId;
@property (nullable, nonatomic, copy) NSString *currentTaskId;
@property (nullable, nonatomic, copy) NSString *userHeadUrl;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *createTime;
@property (nullable, nonatomic, copy) NSString *sendUserName;
-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
