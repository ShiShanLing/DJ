//
//  RegisteredDataModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "RegisteredDataModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RegisteredDataModel (CoreDataProperties)

+ (NSFetchRequest<RegisteredDataModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *oName;
@property (nullable, nonatomic, copy) NSString *oId;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *jobsName;
@property (nullable, nonatomic, copy) NSString *jobsID;

-(void)setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
