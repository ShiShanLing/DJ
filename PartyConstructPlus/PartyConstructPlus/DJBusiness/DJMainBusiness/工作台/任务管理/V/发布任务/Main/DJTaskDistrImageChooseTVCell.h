//
//  DJTaskDistrImageChooseTVCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/18.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJTaskDistrImageChooseTVCellDelegate <NSObject>

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

@end


@interface DJTaskDistrImageChooseTVCell : UITableViewCell

/**
 *图片点击
 */
@property (nonatomic, assign)id<DJTaskDistrImageChooseTVCellDelegate> delegate;
/**
 *缩略图 用来展示
 */
@property (nonatomic, strong)NSMutableArray * showImageMArray;


- (void)viewRenderingShowImageArray:(NSArray *)showImage originalImageArray:(NSArray *)originalImageArray  UploadProgress:(NSArray *)Progress;

@end
