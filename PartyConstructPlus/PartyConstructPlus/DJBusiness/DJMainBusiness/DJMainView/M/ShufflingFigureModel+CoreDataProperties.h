//
//  ShufflingFigureModel+CoreDataProperties.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/17.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "ShufflingFigureModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ShufflingFigureModel (CoreDataProperties)

+ (NSFetchRequest<ShufflingFigureModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *dfsUrl;
@property (nullable, nonatomic, copy) NSString *imgId;
@property (nullable, nonatomic, copy) NSString *picture;
@property (nullable, nonatomic, copy) NSString *turn;
-(void)setValue:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
