//
//  DJImageUploadModel.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/25.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJImageUploadModel : NSObject

/**
 *
 */
@property (nonatomic, strong)NSString * ImageUrl;
/**
 *
 */
@property (nonatomic, strong)NSString * imageState;
/**
 *
 */
@property (nonatomic, strong)UIImage  *image;

-(void)setValue:(id)value forKey:(NSString *)key;

@end
