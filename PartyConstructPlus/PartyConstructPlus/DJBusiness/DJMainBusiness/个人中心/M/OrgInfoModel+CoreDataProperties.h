//
//  OrgInfoModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "OrgInfoModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OrgInfoModel (CoreDataProperties)

+ (NSFetchRequest<OrgInfoModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *chooseState;
@property (nullable, nonatomic, copy) NSString *defaultState;
@property (nullable, nonatomic, copy) NSString *orgId;
@property (nullable, nonatomic, copy) NSString *orgName;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *stationId;
@property (nullable, nonatomic, copy) NSString *stationName;
@property (nullable, nonatomic, copy) NSString *userId;
-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
