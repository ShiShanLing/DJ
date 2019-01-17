//
//  AgendaWorkingCalendarListModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/16.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "AgendaWorkingCalendarListModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN
//待办行事历列表展示model
@interface AgendaWorkingCalendarListModel (CoreDataProperties)

+ (NSFetchRequest<AgendaWorkingCalendarListModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *wcId;
@property (nullable, nonatomic, copy) NSString *orgId;
@property (nullable, nonatomic, copy) NSString *planId;
@property (nullable, nonatomic, copy) NSString *stationId;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *taskContent;
@property (nullable, nonatomic, copy) NSString *taskName;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *beginTime;
@property (nullable, nonatomic, copy) NSString *endTime;
@property (nullable, nonatomic, copy) NSString *doMsg;
@property (nullable, nonatomic, copy) NSString *doImg;
@property (nullable, nonatomic, copy) NSString *dfsUrl;
@property (nullable, nonatomic, copy) NSString *orgName;
-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
