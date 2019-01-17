//
//  WorkingCalendarListModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/16.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "WorkingCalendarListModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN
//工作行事历列表展示model
@interface WorkingCalendarListModel (CoreDataProperties)

+ (NSFetchRequest<WorkingCalendarListModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *wcId;
@property (nullable, nonatomic, copy) NSString *wcName;
@property (nullable, nonatomic, copy) NSString *orgId;
@property (nullable, nonatomic, copy) NSString *stationId;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *content;
-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
