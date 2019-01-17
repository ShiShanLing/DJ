//
//  SaveUserOrgModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "SaveUserOrgModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SaveUserOrgModel (CoreDataProperties)

+ (NSFetchRequest<SaveUserOrgModel *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSObject *userOrg;

@end

NS_ASSUME_NONNULL_END
