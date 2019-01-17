//
//  ConfigModuleModel+CoreDataProperties.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "ConfigModuleModel+CoreDataProperties.h"

@implementation ConfigModuleModel (CoreDataProperties)

+ (NSFetchRequest<ConfigModuleModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ConfigModuleModel"];
}

@dynamic moduleId;
@dynamic moduleName;
@dynamic moduleImage;
@dynamic state;
@dynamic turn;
@dynamic url;
@dynamic dfsUrl;
@dynamic isDefault;
-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.moduleId= [NSString stringWithFormat:@"%@", value] ;
//        NSLog(@"self.moduleId%@", self.moduleId);
    }else if ([key isEqualToString:@"picture"]){
        [self setValue:[NSString stringWithFormat:@"%@", value]  forKey:self.moduleImage];
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
//- (id)copyWithZone:(NSZone *)zone {
//    id copyInstance = [[[self class] allocWithZone:zone] init];
//    size_t instanceSize = class_getInstanceSize([self class]);
//    memcpy((__bridge void *)(copyInstance), (__bridge const void *)(self), instanceSize);
//    return copyInstance;
//}
//
//- (id) initWithCoder: (NSCoder *)coder
//{
//    if (self = [super init])
//    {
//        self.moduleId = [coder decodeObjectForKey:@"moduleId"];
//        self.moduleName = [coder decodeObjectForKey:@"moduleName"];
//        self.moduleImage = [coder decodeObjectForKey:@"moduleImage"];
//        self.state = [coder decodeObjectForKey:@"state"];
//        self.turn = [coder decodeObjectForKey:@"turn"];
//        self.url = [coder decodeObjectForKey:@"url"];
//        self.dfsUrl = [coder decodeObjectForKey:@"dfsUrl"];
//        self.isDefault = [coder decodeObjectForKey:@"isDefault"];
//    }
//    return self;
//}
//
//
//- (void) encodeWithCoder: (NSCoder *)coder
//{
//    NSLog(@"self.moduleId%@", self.moduleId);
//    [coder encodeObject:self.moduleId forKey:@"moduleId"];
//    
//    [coder encodeObject:self.moduleName forKey:@"moduleName"];
//    [coder encodeObject:self.moduleImage forKey:@"moduleImage"];
//    [coder encodeObject:self.state forKey:@"state"];
//    [coder encodeObject:self.turn forKey:@"turn"];
//    [coder encodeObject:self.url forKey:@"url"];
//    [coder encodeObject:self.dfsUrl forKey:@"dfsUrl"];
//    [coder encodeObject:self.isDefault forKey:@"isDefault"];
//
//}
@end
