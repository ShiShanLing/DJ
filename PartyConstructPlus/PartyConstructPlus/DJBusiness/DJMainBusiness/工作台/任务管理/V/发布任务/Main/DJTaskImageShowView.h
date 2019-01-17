//
//  DJTaskImageShowView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/6.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DJTaskImagShowType) {
    
    DJTaskImagShowAreUploading = 0,
    DJTaskImagShowUploadSucce = 1,
    DJTaskImagShowUploadFailed = 2,
    DJTaskImagShowNoImage = 3
};

@class DJTaskImageShowView;
@protocol DJTaskImageShowViewDelegate <NSObject>

- (void)deletelImage:(DJTaskImageShowView *)view;

- (void)ClickSelf:(DJTaskImageShowView *)view;

@end
/**
 发布任务的图片展示view
 */
@interface DJTaskImageShowView : UIView
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
@property (nonatomic, assign)id<DJTaskImageShowViewDelegate> delegate;
/**
 *
 */
@property (nonatomic)DJTaskImagShowType  state;
@end
