//
//  SaveUserModuleModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "SaveUserModuleModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SaveUserModuleModel (CoreDataProperties)

+ (NSFetchRequest<SaveUserModuleModel *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSObject *userModule;

@end

NS_ASSUME_NONNULL_END
