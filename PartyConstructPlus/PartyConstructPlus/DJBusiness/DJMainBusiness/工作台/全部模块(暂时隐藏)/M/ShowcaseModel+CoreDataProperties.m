//
//  ShowcaseModel+CoreDataProperties.m
//  展示台自定义
//
//  Created by 石山岭 on 2018/4/18.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "ShowcaseModel+CoreDataProperties.h"

@implementation ShowcaseModel (CoreDataProperties)

+ (NSFetchRequest<ShowcaseModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ShowcaseModel"];
}

@dynamic title;
@dynamic itemArray;
- (void)setValue:(id)value forKey:(NSString *)key {
    
    [self setValue:value forKey:key];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}

@end
