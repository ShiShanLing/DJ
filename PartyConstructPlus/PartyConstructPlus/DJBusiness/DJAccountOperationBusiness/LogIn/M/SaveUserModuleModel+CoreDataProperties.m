//
//  SaveUserModuleModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "SaveUserModuleModel+CoreDataProperties.h"

@implementation SaveUserModuleModel (CoreDataProperties)

+ (NSFetchRequest<SaveUserModuleModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SaveUserModuleModel"];
}

@dynamic userModule;

@end
