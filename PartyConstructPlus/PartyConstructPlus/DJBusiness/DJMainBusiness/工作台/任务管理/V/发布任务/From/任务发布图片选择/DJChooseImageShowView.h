//
//  DJChooseImageShowView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>

typedef NS_ENUM(NSInteger, DJImageShow) {
    DJChooseImageShowViewDefault = 0,//默认
    DJChooseImageShowViewNoButton  = 1   // 没有确定按钮
};

@protocol DJChooseImageShowViewDelegate <NSObject>
//删除这个对象
-(void)deletelAsset:(NSInteger)index;

- (void)deleteImage:(UIImage *)image;

/**
 点击确认上传图片
 */
- (void)ConfirmUpload;
@end

/**
 创建任务 任务完成时 操作图片时显示已被选择的图片
 */
@interface DJChooseImageShowView : UIView

@property(nonatomic)DJImageShow showType;
/**
 *
 */
@property (nonatomic, strong)UIView * backgroundView;

/**
 *展示图片
 */
@property (nonatomic, strong)NSMutableArray * chooseImageArray;
/**
 *预览图片
 */
@property (nonatomic, strong)NSMutableArray * showImageObjcArray;
/**
 *
 */
@property (nonatomic, strong)UILabel * numberShowLabel;
/**
 *图片删除view代理
 */
@property (nonatomic, assign)id<DJChooseImageShowViewDelegate> delegate;
/**
 *加载中iamge
 */
@property (nonatomic, strong)UIImageView *loadImgView;

/**
 *插入一条数据
 */
- (void)InsertData:(ALAsset *)asset index:(NSInteger)index;
/**
 删除一条数据
 */
- (void)deleteData:(NSInteger)index;
/**
 *插入一个image
 */
- (void)InsertImage:(UIImage *)image index:(NSInteger)index;


@end
