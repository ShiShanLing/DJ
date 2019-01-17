//
//  ArrayTransformer.m
//  展示台自定义
//
//  Created by 石山岭 on 2018/4/18.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "ArrayTransformer.h"

@implementation ArrayTransformer
+ (Class)transformedValueClass
{
    return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
