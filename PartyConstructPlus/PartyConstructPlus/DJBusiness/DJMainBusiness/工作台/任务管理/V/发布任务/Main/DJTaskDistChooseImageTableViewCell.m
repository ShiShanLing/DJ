//
//  DJTaskDistChooseImageTableViewCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskDistChooseImageTableViewCell.h"
#import "DJUploadImageCollectionViewCell.h"
#import "DJTaskImageShowView.h"
#import "DJImageUploadModel.h"
@interface DJTaskDistChooseImageTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate, DJUploadImageCollectionViewCellDelegate>
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * showImageMArray;

@property(nonatomic, strong)UICollectionView *collectionView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * showImageObjcArray;
/**
 *记录图片的大小
 */
@property (nonatomic, strong)NSMutableArray * imageSizeArray;

@end

@implementation DJTaskDistChooseImageTableViewCell
- (NSMutableArray *)imageSizeArray {
    if (!_imageSizeArray) {
        _imageSizeArray = [NSMutableArray array];
    }
    return _imageSizeArray;
}

- (NSMutableArray *)showImageObjcArray {
    if (!_showImageObjcArray) {
        _showImageObjcArray = [NSMutableArray array];
    }
    return _showImageObjcArray;
}

- (NSMutableArray *)showImageMArray {
    if (!_showImageMArray) {
        _showImageMArray = [NSMutableArray array];
    }
    return _showImageMArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.contentView.backgroundColor = [UIColor redColor];
        self.imageSizeArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0"]];
        [self setCollectionView];
    }
    return self;
}

- (void)setUI {

 
    
    
    
}


- (void)setCollectionView {
    /*
     <>
     
     #define kIphone6Height 667.0
     #define kIphone6Width 375.0
     //iphone 6为标准 自使用各个屏幕下的大小
     #define kFit(x) ((x)*(kScreenWidth/kIphone6Width))
     #define kScreenWidth  [UIScreen mainScreen].bounds.size.width//屏幕宽度
     #define kScreenHeight  [UIScreen mainScreen].bounds.size.height//屏幕高度
     */
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //添加页眉
    // [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);//设置页眉的高度
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.itemSize = CGSizeMake(120, 154);
//    layout.headerReferenceSize = CGSizeMake(kScreenWidth, kFit(15));
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170) collectionViewLayout:layout];
    _collectionView .dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[DJUploadImageCollectionViewCell class] forCellWithReuseIdentifier:@"DJUploadImageCollectionViewCell"];
    [self.contentView addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showImageMArray.count +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DJUploadImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DJUploadImageCollectionViewCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if (indexPath.row != self.showImageMArray.count) {
        NSLog(@"self.showImageMArray%@", self.showImageMArray);
        __block DJImageUploadModel *model = self.showImageMArray[indexPath.row];
        cell.showImageView.image =model.image;
        __block  NSString *imageSize= self.imageSizeArray[indexPath.row];
        if ([imageSize isEqualToString:@"0"]) {
            __weak __typeof(self) weakself= self;
            dispatch_async(dispatch_queue_create(0, 0), ^{
                imageSize =  [self  calulateImageFileSize:model.image];
                _imageSizeArray[indexPath.row] = imageSize;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageSizeLabel.text = imageSize;
                });
            });
        }else {
            cell.imageSizeLabel.text = imageSize;
        }
        
        cell.imageNameLabel.text = [NSString stringWithFormat:@"IMG00%ld.JPG", indexPath.row+1];
        
        NSString * state = model.imageState;
        
        if ([state isEqualToString:@"0"]) {
            cell.deleteBtn.hidden = YES;
        }else
        if ([state isEqualToString:@"1"]) {
            cell.deleteBtn.hidden = NO;
        }else
        if ([state isEqualToString:@"2"]) {
            cell.deleteBtn.hidden = NO;
        }
        cell.state = state.integerValue;

    }else {
        cell.imageNameLabel.text = @"";
        cell.imageSizeLabel.text = @"";
        cell.deleteBtn.hidden = YES;
        cell.state = DJUploadImageNoImage;
    }
    

    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row ==self.showImageMArray.count) {//如果点击的是最后一个cell
        if (self.showImageMArray.count == 6) {//如果已经选择6张照片了
            [self ShowWarningHudMid:@"最多选择6张照片"];
            return;
        }
        //否者就小于6个照片 可以继续上传图片
        if ([_delegate respondsToSelector:@selector(ClickUploadImage:)]) {
            [_delegate ClickUploadImage:indexPath.row];
        }
    }else {//否者点击的不是最后一个cell 会有两种情况
        DJImageUploadModel *model = self.showImageMArray[indexPath.row];

        if ([model.imageState isEqualToString:@"2"]) {//1.点击的图片是上传失败的图片
            //从新上传
            if ([_delegate respondsToSelector:@selector(uploadAgainImage:)]) {
                [_delegate uploadAgainImage:indexPath.row];
            }
        } else {//2.点击的是正在上传或者上传成功的照片
            //展示图片
            [[[LBPhotoBrowserManager defaultManager] showImageWithLocalItems:self.showImageObjcArray selectedIndex:indexPath.row fromImageViewSuperView:_collectionView] addCollectionViewLinkageStyle:UICollectionViewScrollPositionCenteredHorizontally cellReuseIdentifier:@"DJUploadImageCollectionViewCell"];
        }
    }

}
//返回每个cell的布局左右上下间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(0.01, 10, 10, 10);
}
//单独返回每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(120, 154);
}

- (void)refreshImageUpLoadProgressArray:(NSArray *)Progress  index:(NSInteger)index {
    self.showImageMArray = [NSMutableArray arrayWithArray:Progress];
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];

}

- (void)viewRenderingShowImageArray:(NSArray *)showImage{
    
    self.showImageMArray = [NSMutableArray arrayWithArray:showImage];
    self.imageSizeArray = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0"]];
    [self.showImageObjcArray removeAllObjects];
    for (int i = 0; i < self.showImageMArray.count; i ++) {
        DJImageUploadModel *model = self.showImageMArray[i];
        LBPhotoLocalItem *item = [[LBPhotoLocalItem alloc]initWithImage:model.image frame:CGRectMake(0, 0, 120, 154)];
        [self.showImageObjcArray addObject:item];
    }
    [self.collectionView reloadData];
}

#pragma DJTaskImageShowViewDelegate

- (void)deletelImage:(DJTaskImageShowView *)view {
    
    if ([_delegate respondsToSelector:@selector(cancelSelectedImage:)]) {
        [_delegate cancelSelectedImage:view.indexPath.row];
    }
}

- (void)ClickSelf:(DJTaskImageShowView *)view {
    
}

- (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        NSLog(@"data.length%ld maxLength%ld",data.length, maxLength);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}
//警告
-(void)ShowWarningHudMid:(NSString *)message {
    MBProgressHUD *warning = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    warning.mode = MBProgressHUDModeText;
    warning.label.text = message;
    warning.label.textColor = [UIColor whiteColor];;
    warning.label.lineBreakMode = NSLineBreakByWordWrapping;
    warning.label.numberOfLines = 0;
    warning.bezelView.backgroundColor = [UIColor blackColor];
    warning.bezelView.alpha = 0.8;
    warning.offset = CGPointMake(0.f, 100);
    [warning hideAnimated:YES afterDelay:1.0f];
}


- (NSString *)calulateImageFileSize:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 0.5);//需要改成0.5才接近原图片大小，原因请看下文
    }
    double dataLength = [data length];
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    return [NSString stringWithFormat:@"%.1f %@", dataLength, typeArray[index]];
    
}

@end
