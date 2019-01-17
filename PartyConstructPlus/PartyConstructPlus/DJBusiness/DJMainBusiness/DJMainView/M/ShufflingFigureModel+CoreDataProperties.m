//
//  ShufflingFigureModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/17.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "ShufflingFigureModel+CoreDataProperties.h"

@implementation ShufflingFigureModel (CoreDataProperties)

+ (NSFetchRequest<ShufflingFigureModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ShufflingFigureModel"];
}

@dynamic dfsUrl;
@dynamic imgId;
@dynamic picture;
@dynamic turn;
-(void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        self.imgId = [NSString stringWithFormat:@"%@", value];
    }else {
        
        if ([value isKindOfClass:[NSNull class]]) {
            [super setValue:@"" forKey:key];
        }else {
            [super setValue:[NSString stringWithFormat:@"%@", value] forKey:key];
        }
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}
@end
