//
//  DJUploadImageCollectionViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DJUploadImageType) {
    
    DJUploadImageUploading = 0,
    DJUploadImageUploadSucce = 1,
    DJUploadImageUploadFailed = 2,
    DJUploadImageNoImage = 3
};

@class DJUploadImageCollectionViewCell;
@protocol DJUploadImageCollectionViewCellDelegate <NSObject>

- (void)deletelImage:(DJUploadImageCollectionViewCell *)view;

- (void)ClickSelf:(DJUploadImageCollectionViewCell *)view;
@end
@interface DJUploadImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *showImageView;
/**
 *
 */
@property (nonatomic, strong)UILabel *imageNameLabel;

/**
 *
 */
@property (nonatomic, strong)NSIndexPath *indexPath;
/**
 *删除图片按钮
 */
@property (nonatomic, strong)UIButton * deleteBtn;
/**
 *
 */
@property (nonatomic, strong)UILabel * imageSizeLabel;
/**
 *删除已经选中的图片
 */
@property (nonatomic, assign)id<DJUploadImageCollectionViewCellDelegate> delegate;
/**
 *
 */
@property (nonatomic)DJUploadImageType  state;
@end
