//
//  DJCustomModuleShowCVCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/30.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowcaseModel+CoreDataProperties.h"
#import "DJButton.h"

@class DJCustomModuleShowCVCell;

@protocol DJCustomModuleShowCVCellDelegate <NSObject>

- (void)operationItmeIndexPath:(NSIndexPath *)indexPath  cell:(DJCustomModuleShowCVCell *)cell;

@end

/**
 自定义模块界面展示模块的cell
 */
@interface DJCustomModuleShowCVCell : UICollectionViewCell
/**
 *模块编辑时的状态(有没有选中)
 */
@property (nonatomic, strong)DJButton * editorStateBtn;

@property (nonatomic, strong)ConfigModuleModel *itmeModel;
/**
 *编辑时显示的颜色view
 */
@property (nonatomic, strong)UIView * editorColorView;

- (void)assignmentModel:(ShowcaseModel *)model indexPath:(NSIndexPath *)indexPath;

/**
 *
 */
@property (nonatomic, assign)id<DJCustomModuleShowCVCellDelegate> delegate;
/**
 *
 */
@property (nonatomic, strong)UIImageView * defaultImageView;
@end
