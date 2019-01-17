//
//  DJPhotosChooseViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/1.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJPhotosChooseViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>

#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "DJPhotoOptionWayView.h"
#import "DJChooseImageShowView.h"
#import "DJCustomCameraViewController.h"

#import "DJPhotosChooseCVCell.h"
#import "FBKVOController.h"

#define kEachRowCellNumber 4
#define kLineSpacing 3
#define kColumnSpacing  3
#define k



@interface DJPhotosChooseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, DJChooseImageShowViewDelegate>
@property(nonatomic, strong)UICollectionView *collectionView;


/**所有相册里的所有图片*/
@property (nonatomic, strong) NSMutableArray *imageArr;
/**ALAssetsLibrary*/
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * imageStateArray;

/**
 *选中的图片展示view
 */
@property (nonatomic, strong)DJChooseImageShowView * chosenImageShowView;
/**
 *为选择图片时展示的view
 */
@property (nonatomic, strong)DJPhotoOptionWayView *photoOptionWayView;
/**
 *已经被标记的照片 Assets
 */
@property (nonatomic, strong)NSMutableArray * markImageArray;

/**
 *已经被标记的原始图片
 */
@property (nonatomic, strong)NSMutableArray * markOriginalImageArray;

/**
 已经被标记的缩略图
 */
@property (nonatomic, strong)NSMutableArray * markThumbnailImageArray;
/**
 *
 */
@property (nonatomic, strong)FBKVOController * KVOController;
/**
 *
 */
@property (nonatomic, assign)NSInteger comprImagNum;//正在压缩的图片个数


@end

@implementation DJPhotosChooseViewController {
    
    
    
}

- (NSMutableArray *)markThumbnailImageArray {
    if (!_markThumbnailImageArray) {
        _markThumbnailImageArray = [NSMutableArray array];
    }
    return _markThumbnailImageArray;
}

- (NSMutableArray *)markImageArray {
    if (!_markImageArray) {
        _markImageArray = [NSMutableArray array];
        
    }
    return _markImageArray;
}

- (NSMutableArray *)markOriginalImageArray {
    if (!_markOriginalImageArray) {
        _markOriginalImageArray = [NSMutableArray array];
        
    }
    return _markOriginalImageArray;
}

- (NSMutableArray *)imageStateArray {
    if (!_imageStateArray) {
        _imageStateArray = [NSMutableArray array];
    }
    return _imageStateArray;
}

- (DJPhotoOptionWayView *)photoOptionWayView {
    if (!_photoOptionWayView) {
        _photoOptionWayView = [[DJPhotoOptionWayView alloc] init];
        _photoOptionWayView.backgroundColor = [UIColor whiteColor];
        [_photoOptionWayView.cameraBtn addTarget:self action:@selector(handleCamera) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:_photoOptionWayView];
        _photoOptionWayView.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(48+kTabbarSafeBottomMargin);
    }
    return _photoOptionWayView;
}
- (DJChooseImageShowView *)chosenImageShowView {
    if (!_chosenImageShowView) {
        _chosenImageShowView = [[DJChooseImageShowView alloc] init];
        _chosenImageShowView.delegate = self;
        _chosenImageShowView.backgroundColor = [UIColor whiteColor];
        _chosenImageShowView.backgroundView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_chosenImageShowView];
        _chosenImageShowView.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(90+kTabbarSafeBottomMargin);
    }
    return _chosenImageShowView;
}
//拍照
- (void)handleCamera {
    DJCustomCameraViewController *VC = [[DJCustomCameraViewController alloc] init];
    VC.existingImageNum = _existingImageNum;
    [self pushToNextViewController:VC];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hudDissmiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _comprImagNum = 0;
    self.view.backgroundColor = kColorRGB(246, 246, 246, 1);
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择图片";
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak DJPhotosChooseViewController *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    [self setCollectionView];
    self.assetsLibrary = [[ALAssetsLibrary alloc]init];
    self.imageArr = [NSMutableArray array];
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result)
                {
                    [self.imageArr addObject:result];
                    [self.imageStateArray addObject:@"0"];
                }
            }];
        }
        [self.collectionView reloadData];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"获取相册失败");
    }];
    self.KVOController = [FBKVOController controllerWithObserver:self];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //添加页眉
    // [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);//设置页眉的高度
    layout.minimumInteritemSpacing = kColumnSpacing;
    layout.minimumLineSpacing = kLineSpacing;
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 0.01);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight - 48 - kTabbarSafeBottomMargin) collectionViewLayout:layout];
    _collectionView .dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[DJPhotosChooseCVCell class] forCellWithReuseIdentifier:@"DJPhotosChooseCVCell"];
    
    [self.view addSubview:_collectionView];
    
    self.photoOptionWayView.hidden = NO;
    
    self.chosenImageShowView.hidden = YES;
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DJPhotosChooseCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DJPhotosChooseCVCell" forIndexPath:indexPath];
    ALAsset *result = [self.imageArr objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageWithCGImage: result.thumbnail];
    cell.showImageView.image = image;
    NSString *stateStr = self.imageStateArray[indexPath.row];
    if ([stateStr isEqualToString:@"0"]) {
        [cell.stateBtn setImage:[UIImage imageNamed:@"DJ_photo_uncheck"] forState:(UIControlStateNormal)];
    }else {
        [cell.stateBtn setImage:[UIImage imageNamed:@"DJ_photo_selected"] forState:(UIControlStateNormal)];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ALAsset *assset = [self.imageArr objectAtIndex:indexPath.row];
    NSString *stateStr = self.imageStateArray[indexPath.row];
    if ([stateStr isEqualToString:@"0"]) {//添加
        
        if (self.markImageArray.count+_existingImageNum >= 6) {
            [self  ShowWarningHudMid:@"最多可上传6张图片作为附件哦！"];
            return;
        }
        
        self.imageStateArray[indexPath.row] = @"1";
        

        [self.markOriginalImageArray insertObject:assset atIndex:0];
        [self.markImageArray insertObject:assset atIndex:0];
        [self.chosenImageShowView InsertData:assset index:0];
        
    }else {//取消
        
        if (self.comprImagNum <= 0) {
            
        }else {
            self.comprImagNum --;
        }
        self.imageStateArray[indexPath.row] = @"0";
        
        for (int  i  =0;  i < self.markImageArray.count; i ++) {
            ALAsset *tempAss = self.markImageArray[i];
            if (tempAss == assset) {
                [self.markOriginalImageArray removeObjectAtIndex:i];
                [self.markImageArray removeObjectAtIndex:i];
                [self.chosenImageShowView deleteData:i];
                break;
            }
        }
    }
    
    
    if (self.markImageArray.count <= 0) {
        self.chosenImageShowView.chooseImageArray =@[];
        self.chosenImageShowView.hidden = YES;
        [self reloadCollectionViewFrame:0];
    }else {
        self.chosenImageShowView.hidden = NO;
        if (self.markImageArray.count == 1) {
                self.chosenImageShowView.chooseImageArray =self.markImageArray;
        }
        
        [self reloadCollectionViewFrame:1];

    }
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}
//返回每个cell的布局左右上下间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(3, 3, 3, 3);
}
//单独返回每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //计算    cell的宽度 =  ( 屏幕宽 - (cell数量+1) * cell之间的间距 ) 除以 一行cell的数量
    CGFloat cellW = (kScreenWidth - (kEachRowCellNumber+1) * kLineSpacing)/kEachRowCellNumber;
    return CGSizeMake(cellW, cellW);
    
}
#pragma mark  DJChooseImageShowViewDelegate
- (void)deletelAsset:(NSInteger)index {
    NSLog(@"self.markImageArray%d", self.markImageArray.count);
    
    NSInteger row = 0;
    ALAsset *Asset = self.markImageArray[index];
    for (int i = 0; i < self.imageArr.count; i ++) {//重置展示图片的状态
        ALAsset *tempAss = self.imageArr[i];
        if (tempAss == Asset) {
            self.imageStateArray[i] = @"0";
            row = i;
            break;
        }
    }
    [self.markImageArray removeObjectAtIndex:index];
    [self.markOriginalImageArray removeObjectAtIndex:index];
    
    if (self.markImageArray.count <= 0) {
        [self reloadCollectionViewFrame:0];
        self.chosenImageShowView.hidden = YES;  
    }else {
        self.chosenImageShowView.hidden = NO;
        [self reloadCollectionViewFrame:1];//刷新显示的shu'liang
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]];
    
}

- (void)ConfirmUpload {
    
    if (self.markImageArray.count == 0) {
        [self ShowWarningHudMid:@"请先选择图片"];
        return;
    }
    

    
    self.chosenImageShowView.numberShowLabel.text = @"";
    self.chosenImageShowView.loadImgView.hidden = NO;
    NSMutableArray *tempArray = [NSMutableArray array];
    __weak __typeof(self) weakself= self;
    self.comprImagNum = _markOriginalImageArray.count;
    for (int i = 0; i < weakself.markOriginalImageArray.count; i ++) {
        
        ALAsset *assset = weakself.markOriginalImageArray[i];
        dispatch_queue_t Pqueue = dispatch_queue_create("com.GCD.www", DISPATCH_QUEUE_CONCURRENT);
        //异步并发//开辟子线程
        dispatch_async(Pqueue, ^{
            [tempArray addObject: [self assetToImageForALAsset:assset]];
            self.comprImagNum --;
            if (self.comprImagNum == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.chosenImageShowView.loadImgView.hidden = YES;
                    self.imageUpload(tempArray, tempArray);
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                });
            }
        });
    }
    
    
    
    
//    NSLog(@"self.markThumbnailImageArray%d comprImagNum%d", self.markThumbnailImageArray.count, _comprImagNum);
    
    
}

- (void)reloadCollectionViewFrame:(NSInteger)index {
    self.chosenImageShowView.numberShowLabel.text = [NSString stringWithFormat:@"%d/6\n确定", self.markImageArray.count+_existingImageNum];
    switch (index) {
        case 0:{//刚进入界面的默认frame
            CGRect frame = self.collectionView.frame;
            frame.size.height = kScreenHeight-kStatusBarAndNavigationBarHeight - 48 - kTabbarSafeBottomMargin;
            self.collectionView.frame = frame;
      
        }
            break;
        case 1:{//选择完照片的frame
            CGRect frame = self.collectionView.frame;
            frame.size.height = kScreenHeight-kStatusBarAndNavigationBarHeight - 90 - kTabbarSafeBottomMargin;
            self.collectionView.frame = frame;
 
        }
            break;
        default:
            break;
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
        tempImg = [UIImage compressedImage:tempImg];
    }
    return tempImg;
}

-(void)dealloc {
    
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
