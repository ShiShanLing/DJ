//
//  LowerOrgModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "LowerOrgModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LowerOrgModel (CoreDataProperties)

+ (NSFetchRequest<LowerOrgModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *orgId;
@property (nullable, nonatomic, copy) NSString *pid;
@property (nullable, nonatomic, retain) NSObject *orgUser;
@property (nullable, nonatomic, retain) NSObject *lowerOrg;
@property (nullable, nonatomic, copy) NSString *orgLevel;
@property (nullable, nonatomic, copy) NSString *chooseNum;
@property (nullable, nonatomic, copy) NSString *isSelectAll;


-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
