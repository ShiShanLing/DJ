//
//  TaskImageShowCVCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/18.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJTaskImageShowCVCellDelegate <NSObject>

- (void)deletelImage:(NSIndexPath *)indexPath;

- (void)handleClickImage:(NSIndexPath *)indexPath;
@end

/**
 发布任务的图片展示cell
 */
@interface DJTaskImageShowCVCell : UICollectionViewCell
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
@property (nonatomic, assign)id<DJTaskImageShowCVCellDelegate> delegate;
@end
