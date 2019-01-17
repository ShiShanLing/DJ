//
//  SaveUserOrgModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "SaveUserOrgModel+CoreDataProperties.h"

@implementation SaveUserOrgModel (CoreDataProperties)

+ (NSFetchRequest<SaveUserOrgModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SaveUserOrgModel"];
}

@dynamic userOrg;

@end
