//
//  DJTaskDistChooseImageTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJTaskDistChooseImageTableViewCellDelegate <NSObject>
/**
 点击上传图片
 
 @param indexPath NSIndexPath
 */
- (void)ClickUploadImage:(NSInteger )index;

/**
 取消选中某张图片
 @param indexPath NSIndexPath
 */
- (void)cancelSelectedImage:(NSInteger )index;

/**
 放大某张图片
 
 @param indexPath NSIndexPath
 */
- (void)amplificationImage:(NSInteger )index;

/**
 如果图片上传失败 就重新上传图片

 @param index 需要重新上传的图片下标
 */
- (void)uploadAgainImage:(NSInteger)index;


@end
@interface DJTaskDistChooseImageTableViewCell : UITableViewCell
/**
*图片点击
*/
@property (nonatomic, assign)id<DJTaskDistChooseImageTableViewCellDelegate> delegate;


- (void)viewRenderingShowImageArray:(NSArray *)showImage;

- (void)refreshImageUpLoadProgressArray:(NSArray *)Progress  index:(NSInteger)index;

@end
