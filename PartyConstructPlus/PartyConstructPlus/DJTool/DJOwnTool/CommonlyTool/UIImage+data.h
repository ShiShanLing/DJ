//
//  UIImage+data.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/10.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (data)
#pragma mark //将image转成NSData，在进行base64加密，只要将image对象传承NSData类型，然后在进行base64加密就可以了
+ (NSString *)imageBase64WithDataURL:(UIImage *)image;
//获取图片的格式
+ (NSString *)typeForImageData:(UIImage *)image;
+ (UIImage *)compressedImage:(UIImage *)image;
+(UIImage *)compressImageWith:(UIImage *)image;
+ (UIImage *)pathPngFile:(NSString *)image;
@end
