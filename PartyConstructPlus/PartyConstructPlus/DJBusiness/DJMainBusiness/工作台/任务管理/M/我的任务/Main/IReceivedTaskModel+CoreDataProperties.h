//
//  IReceivedTaskModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "IReceivedTaskModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IReceivedTaskModel (CoreDataProperties)

+ (NSFetchRequest<IReceivedTaskModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *createTime;
@property (nullable, nonatomic, copy) NSString *endDate;
@property (nullable, nonatomic, copy) NSString *isRead;
@property (nullable, nonatomic, copy) NSString *startDate;
@property (nullable, nonatomic, copy) NSString *stationId;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *tags;
@property (nullable, nonatomic, copy) NSString *taskId;
@property (nullable, nonatomic, copy) NSString *taskContent;
@property (nullable, nonatomic, copy) NSString *updateTime;
@property (nullable, nonatomic, copy) NSString *taskName;
@property (nullable, nonatomic, copy) NSString *taskImg;
@property (nullable, nonatomic, copy) NSString *sendUserName;
@property (nullable, nonatomic, copy) NSString *currentTaskId;
@property (nullable, nonatomic, copy) NSString *dfsUrl;
@property (nullable, nonatomic, copy) NSString *totalNum;
@property (nullable, nonatomic, copy) NSString *readNum;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *userHeadUrl;
-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
