//
//  UserDataModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/20.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "UserDataModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserDataModel (CoreDataProperties)

+ (NSFetchRequest<UserDataModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *realName;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *tel;
@property (nullable, nonatomic, copy) NSString *token;
@property (nullable, nonatomic, copy) NSString *tokenTime;
@property (nullable, nonatomic, copy) NSString *userName;
-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
