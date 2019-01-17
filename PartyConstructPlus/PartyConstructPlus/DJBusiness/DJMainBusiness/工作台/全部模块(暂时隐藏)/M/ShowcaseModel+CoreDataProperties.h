//
//  ShowcaseModel+CoreDataProperties.h
//  展示台自定义
//
//  Created by 石山岭 on 2018/4/18.
//  Copyright © 2018年 石山岭. All rights reserved.
//
//

#import "ShowcaseModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ShowcaseModel (CoreDataProperties)

+ (NSFetchRequest<ShowcaseModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) NSObject *itemArray;

- (void)setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
