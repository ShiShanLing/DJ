//
//  MapNearOrgModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "MapNearOrgModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MapNearOrgModel (CoreDataProperties)

+ (NSFetchRequest<MapNearOrgModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *lat;
@property (nullable, nonatomic, copy) NSString *lon;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *pid;
@property (nullable, nonatomic, copy) NSString *tel;
-(void)setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
