//
//  DJPhotosChooseViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/1.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"

typedef void (^DJMoreImageUpload)(NSArray *imageArray,NSArray *thumbnailImageArray);

/**
 党建里面使用的所有多图片上传使用的例子
 */
@interface DJPhotosChooseViewController : DJBaseViewController
/**
 *已经上传的图片数量
 */
@property (nonatomic, assign)NSInteger  existingImageNum;//图片数量 加上已经选的不能超过6张


/**
 *
 */
@property (nonatomic, copy)DJMoreImageUpload imageUpload;
@end
