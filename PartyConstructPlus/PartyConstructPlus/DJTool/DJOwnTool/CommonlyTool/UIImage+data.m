//
//  UIImage+data.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/10.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "UIImage+data.h"

@implementation UIImage (data)

+ (NSString *)imageBase64WithDataURL:(UIImage *)image {
    NSData *imageData = nil;
    NSString *mimeType = nil;
    //图片要压缩的比例，此处100根据需求，自行设置
    CGFloat x = 100 / image.size.height;
    if (x > 1)
    {
        x = 1.0;
    }
    imageData = UIImageJPEGRepresentation(image, x);
//    mimeType = @"image/jpeg";
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


+ (NSString *)typeForImageData:(UIImage *)image {
    
    
    
    NSData *imageData = nil;
    
    //图片要压缩的比例，此处100根据需求，自行设置
    CGFloat x = 100 / image.size.height;
    if (x > 1)
    {
        x = 1.0;
    }
    imageData = UIImageJPEGRepresentation(image, 0.5);
    
    uint8_t c;
    [imageData getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"jpeg";
            
        case 0x89:
            
            return @"png";
            
        case 0x47:
            
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"tiff";
            
    }
    
    return nil;
    
}
+ (UIImage *)compressedImage:(UIImage *)image {
    
    CGFloat  hfactor = image.size.width / kScreenWidth;
    CGFloat vfactor = image.size.height / kScreenHeight;
    CGFloat factor = fmax(hfactor, vfactor);
    //画布大小
    CGFloat  newWith = image.size.width / factor ;
    CGFloat newHeigth= image.size.height / factor ;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWith*2, newHeigth*2));
    [image drawInRect:CGRectMake(0, 0, newWith*2, newHeigth*2) ];
    UIImage * tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //图像压缩
    
    return tempImage;
}
+(UIImage *)compressImageWith:(UIImage *)image

{
    
    float imageWidth = image.size.width;
    
    float imageHeight = image.size.height;
    
    float width = 375;
    
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    
    // 并把它设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(CGSizeMake(width*2, height*2));
    
    if (widthScale > heightScale) {
        
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
        
    }else {
        
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
        
    }
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
+ (UIImage *)pathPngFile:(NSString *)image{
    
    NSString *bgImage = [[NSBundle mainBundle] pathForResource:image ofType:@"png"];
    
    UIImage *bgImg = [[UIImage alloc] initWithContentsOfFile:bgImage];
    
    
    return bgImg;
    
}
@end
