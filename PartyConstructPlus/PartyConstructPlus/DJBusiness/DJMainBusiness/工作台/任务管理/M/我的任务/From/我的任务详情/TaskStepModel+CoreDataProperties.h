//
//  TaskStepModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "TaskStepModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TaskStepModel (CoreDataProperties)

+ (NSFetchRequest<TaskStepModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *createTime;
@property (nullable, nonatomic, copy) NSString *evaRank;
@property (nullable, nonatomic, copy) NSString *img;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *dfsUrl;
-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
