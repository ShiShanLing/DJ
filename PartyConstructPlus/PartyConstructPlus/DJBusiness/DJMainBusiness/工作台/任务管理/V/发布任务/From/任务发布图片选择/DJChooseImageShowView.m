//
//  DJChooseImageShowView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJChooseImageShowView.h"
#import "DJTaskImageShowCVCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
@interface DJChooseImageShowView ()<UICollectionViewDataSource,UICollectionViewDelegate, DJTaskImageShowCVCellDelegate>

@property(nonatomic, strong)UICollectionView *collectionView;

/**
 *
 */
@property (nonatomic, strong)CAGradientLayer * gradientLayer;
@end

@implementation DJChooseImageShowView
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        //初始化CAGradientlayer对象，使它的大小为UIView的大小
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = _numberShowLabel.bounds;
        //设置渐变区域的起始和终止位置（范围为0-1）
        _gradientLayer.startPoint = CGPointMake(0, 1);
        _gradientLayer.endPoint = CGPointMake(1, 1);
        //设置颜色数组
        _gradientLayer.colors = @[(__bridge id)kColorRGB(251, 88, 68, 1).CGColor,
                                  (__bridge id)kColorRGB(254, 141, 85, 1).CGColor];
        //设置颜色分割点（范围：0-1）
        _gradientLayer.locations = @[@(0.3f), @(1.0f)];
//        _gradientLayer.hidden = YES;
    }
    return _gradientLayer;
}
- (NSMutableArray *)showImageObjcArray {
    if (!_showImageObjcArray) {
        _showImageObjcArray = [NSMutableArray array];
    }
    return _showImageObjcArray;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] init];
        
        _backgroundView.backgroundColor = kColorRGB(246, 246, 246, 1);
        _backgroundView.alpha = 0.3;
        [self addSubview:_backgroundView];
        _backgroundView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self,0).bottomSpaceToView(self, 0);
        [_backgroundView updateLayout];
        
//        [_backgroundView.layer addSublayer:self.gradientLayer];
        
        self.numberShowLabel = [UILabel new];
        _numberShowLabel.text =@"4/6\n确定";
        _numberShowLabel.textAlignment = 1;
        _numberShowLabel.numberOfLines = 2;
        _numberShowLabel.backgroundColor = [UIColor clearColor];
        _numberShowLabel.userInteractionEnabled = YES;
        _numberShowLabel.textColor = kColorRGB(253, 115, 77, 1);
        _numberShowLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        [self addSubview:_numberShowLabel];
        _numberShowLabel.sd_layout.rightSpaceToView(self, 0).topSpaceToView(self, 0).heightIs(90).widthIs(kFit(62));
        
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleConfirmUpload)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        
        [_numberShowLabel addGestureRecognizer:singleFingerOne];
        
        [_numberShowLabel updateLayout];

        UILabel *_dividerLabelH = [UILabel new];
        _dividerLabelH.backgroundColor = kColorRGB(216, 216, 216, 1);
        [_numberShowLabel addSubview:_dividerLabelH];
        _dividerLabelH.sd_layout.leftSpaceToView(_numberShowLabel, 0).topSpaceToView(_numberShowLabel, 0).heightIs(kCellDividerHeight).rightSpaceToView(_numberShowLabel, 0);
        
        UILabel *_dividerLabelV = [UILabel new];
        _dividerLabelV.backgroundColor = kColorRGB(216, 216, 216, 1);
        [_numberShowLabel addSubview:_dividerLabelV];
        _dividerLabelV.sd_layout.leftSpaceToView(_numberShowLabel, 0).topSpaceToView(_numberShowLabel, 0).widthIs(kCellDividerHeight).bottomSpaceToView(_numberShowLabel, 0);
        
        UIImage *image = [[UIImage imageNamed:@"DJ_Image_Inload"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        self.loadImgView = [[UIImageView alloc] initWithImage:image];
        _loadImgView.contentMode = UIViewContentModeScaleToFill;
        _loadImgView.hidden = YES;
        CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        anima.toValue = @(M_PI*2);
        anima.duration = 1.5f;
        anima.repeatCount = UID_MAX;
        [_loadImgView.layer addAnimation:anima forKey:nil];
        
        [self addSubview:_loadImgView];
        _loadImgView.sd_layout.widthIs(kFit(28)).heightIs(kFit(28)).rightSpaceToView(self, kFit(17.5)).centerYEqualToView(_numberShowLabel);
        [_loadImgView updateLayout];
////        /初始化CAGradientlayer对象，使它的大小为UIView的大小
//        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
//        gradientLayer.frame = _numberShowLabel.bounds;
//
//        //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
//        [_numberShowLabel.layer addSublayer:gradientLayer];
//
//        //设置渐变区域的起始和终止位置（范围为0-1）
//        gradientLayer.startPoint = CGPointMake(0, 1);
//        gradientLayer.endPoint = CGPointMake(1, 1);
//
//        //设置颜色数组
//        gradientLayer.colors = @[(__bridge id)kColorRGB(251, 88, 68, 1).CGColor,(__bridge id)kColorRGB(254, 141, 85, 1).CGColor];
//        //设置颜色分割点（范围：0-1）
//        gradientLayer.locations = @[@(0.3f), @(1.0f)];
//        gradientLayer.hidden = YES;
//        gradientLayer.hidden = NO;
        [self setCollectionView];
    }
    return self;
}

- (void)setCollectionView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //添加页眉
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-kFit(62), 90) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[DJTaskImageShowCVCell class] forCellWithReuseIdentifier:@"DJTaskImageShowCVCell"];
    [self addSubview:_collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _chooseImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DJTaskImageShowCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DJTaskImageShowCVCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if ([[_chooseImageArray objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]) {
        UIImage *image =   [_chooseImageArray objectAtIndex:indexPath.row];
        cell.showImageView.image =[UIImage  compressedImage:image];

        
    }else {
        ALAsset *result = [_chooseImageArray objectAtIndex:indexPath.row];
        UIImage *image = [UIImage imageWithCGImage: result.thumbnail];

        cell.showImageView.image = image;
       
    }


    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.deleteBtn.hidden = NO;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
}

- (void)handleClickImage:(NSIndexPath *)indexPath {
    
     [[[LBPhotoBrowserManager defaultManager] showImageWithLocalItems:self.showImageObjcArray selectedIndex:indexPath.row fromImageViewSuperView:_collectionView] addCollectionViewLinkageStyle:UICollectionViewScrollPositionCenteredHorizontally cellReuseIdentifier:@"DJTaskImageShowCVCell"];
    
}
//返回每个cell的布局左右上下间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(0, 15, 15, 5);
}
//单独返回每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(75, 75);
    
}

/**
 *插入一条数据
 */
- (void)InsertData:(ALAsset *)asset index:(NSInteger)index {

    if (self.chooseImageArray.count == 0) {

        [self.chooseImageArray addObject:asset];
    }else {

        [self.chooseImageArray insertObject:asset atIndex:index];
    }

        [self.collectionView reloadData];
    
    UIImage *image = [UIImage imageWithCGImage: asset.thumbnail];
    LBPhotoLocalItem *thItem = [[LBPhotoLocalItem alloc]initWithImage:image  frame:self.frame];
    
    if (self.showImageObjcArray.count == 0 ) {
        [self.showImageObjcArray addObject:thItem];
        UIImage *tempImage = [UIImage  compressedImage:[self assetToImageForALAsset:asset]];
        LBPhotoLocalItem *item = [[LBPhotoLocalItem alloc]initWithImage:tempImage  frame:self.frame];
        self.showImageObjcArray[0] = item;
        
    }else {
        [self.showImageObjcArray insertObject:thItem atIndex:index];
        UIImage *tempImage = [UIImage  compressedImage:[self assetToImageForALAsset:asset]];
        LBPhotoLocalItem *item = [[LBPhotoLocalItem alloc]initWithImage:tempImage  frame:self.frame];
        self.showImageObjcArray[index] = item;
    }
    
   
    
    
}
/**
 *插入一个image
 */
- (void)InsertImage:(UIImage *)image index:(NSInteger)index {
    LBPhotoLocalItem *tempItem = [[LBPhotoLocalItem alloc]initWithImage:image  frame:self.frame];
    if (self.chooseImageArray.count == 0) {
        [self.chooseImageArray addObject:image];
        [self.showImageObjcArray addObject:tempItem];
    }else {
        [self.chooseImageArray insertObject:image atIndex:index];
        [self.showImageObjcArray insertObject:tempItem atIndex:index];
    }
    NSLog(@"self.showImageObjcArray%@", self.showImageObjcArray);
    [self.collectionView reloadData];
}


#pragma mark DJTaskImageShowCVCellDelegate
- (void)deletelImage:(NSIndexPath *)indexPath {
    NSLog(@"_chooseImageArray%@ indexPath.row%ld", _chooseImageArray, indexPath.row);
    if ([[_chooseImageArray objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]) {
        UIImage *image = [_chooseImageArray objectAtIndex:indexPath.row];
        if ([_delegate respondsToSelector:@selector(deleteImage:)]) {
            [_delegate deleteImage:image];
        }
    }else {
        if ([_delegate respondsToSelector:@selector(deletelAsset:)]) {
            [_delegate deletelAsset:indexPath.row];
        }
    }
    
    [self.chooseImageArray removeObjectAtIndex:indexPath.row];
    if (self.showImageObjcArray.count == 0) {
        
    }else {
        [self.showImageObjcArray removeObjectAtIndex:indexPath.row];
    }
    if (self.chooseImageArray.count != 0) {
        [self.collectionView reloadData];
    }
}


- (void)deleteData:(NSInteger)index {
    [self.chooseImageArray removeObjectAtIndex:index];
    if (self.showImageObjcArray.count == 0) {
        
    }else {
        [self.showImageObjcArray removeObjectAtIndex:index];
    }
    
    if (self.chooseImageArray.count != 0) {
        [self.collectionView reloadData];
    }
}


-(void)setChooseImageArray:(NSMutableArray *)chooseImageArray {
    _chooseImageArray = [NSMutableArray arrayWithArray:chooseImageArray];
    [_collectionView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setShowType:(DJImageShow)showType {
    
    switch (showType) {
        case DJChooseImageShowViewDefault:
            
            break;
        case DJChooseImageShowViewNoButton:
            _numberShowLabel.hidden = YES;
            CGRect frame = _collectionView.frame;
            frame.size.width = kScreenWidth;
            _collectionView.frame = frame;
            break;
            
        default:
            break;
    }    
}


- (void)handleConfirmUpload {
    
    if ([_delegate respondsToSelector:@selector(ConfirmUpload)]) {
        [_delegate ConfirmUpload];
    }
}
//获取原图
-(UIImage *)assetToImageForALAsset:(ALAsset *)asset{
    
    UIImage *tempImg = nil;
    ALAssetRepresentation *image_representation = [asset defaultRepresentation];
    Byte *buffer = (Byte*)malloc(image_representation.size);
    NSUInteger length = [image_representation getBytes:buffer fromOffset: 0.0 length:image_representation.size error:nil];
    if (length != 0)  {
        NSData *adata = [[NSData alloc] initWithBytesNoCopy:buffer length:image_representation.size freeWhenDone:YES];
        tempImg = [UIImage imageWithData:adata];
    }
    
    
    return tempImg;
}
@end
