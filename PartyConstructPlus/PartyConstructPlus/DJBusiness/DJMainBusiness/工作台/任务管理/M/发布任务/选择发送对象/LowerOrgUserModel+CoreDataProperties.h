//
//  LowerOrgUserModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "LowerOrgUserModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LowerOrgUserModel (CoreDataProperties)

+ (NSFetchRequest<LowerOrgUserModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *orgId;
@property (nullable, nonatomic, copy) NSString *stationId;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *orgName;
-(void)setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
