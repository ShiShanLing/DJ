//
//  ConfigModuleModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/9.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "ConfigModuleModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ConfigModuleModel (CoreDataProperties)<NSCopying>

+ (NSFetchRequest<ConfigModuleModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *moduleId;
@property (nullable, nonatomic, copy) NSString *moduleName;
@property (nullable, nonatomic, copy) NSString *moduleImage;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *turn;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *dfsUrl;
@property (nullable, nonatomic, copy) NSString *isDefault;

-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
