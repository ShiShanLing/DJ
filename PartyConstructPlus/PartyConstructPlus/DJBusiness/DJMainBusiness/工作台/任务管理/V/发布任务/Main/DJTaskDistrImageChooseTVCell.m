//
//  DJTaskDistrImageChooseTVCell.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/18.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJTaskDistrImageChooseTVCell.h"
#import "DJTaskImageShowView.h"
@interface DJTaskDistrImageChooseTVCell ()<UIScrollViewDelegate, DJTaskImageShowViewDelegate>
@property(nonatomic, strong)UIScrollView *scrollView ;
/**
 *
 */
@property (nonatomic, strong)UIView *ScrollContentView;
/**
 *
 */
@property (nonatomic, strong)UILabel * lastRightLine;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * viewArray;

/**
 *
 */
@property (nonatomic, strong)NSMutableArray * showImageObjcArray;
@end

@implementation DJTaskDistrImageChooseTVCell

- (NSMutableArray *)viewArray {
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return    _viewArray;
}

- (NSMutableArray *)showImageObjcArray {
    if (!_showImageObjcArray) {
        _showImageObjcArray = [NSMutableArray array];
    }
    return _showImageObjcArray;
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
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    self.scrollView = [UIScrollView new];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.userInteractionEnabled = YES;
    _scrollView.delegate = self;
    [self.contentView addSubview:_scrollView];
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    self.ScrollContentView = [UIView new];
    _ScrollContentView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.ScrollContentView];
    [self.scrollView setupAutoContentSizeWithRightView:_ScrollContentView rightMargin:0];
    
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
    return [NSString stringWithFormat:@"%.3f %@", dataLength, typeArray[index]];
    
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


- (void)viewRenderingShowImageArray:(NSArray *)showImage originalImageArray:(NSArray *)originalImageArray UploadProgress:(NSArray *)Progress{
    [self.showImageObjcArray removeAllObjects];
    [self.ScrollContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0;i < self.viewArray.count; i ++) {
        DJTaskImageShowView *view = self.viewArray[i];
        [view removeFromSuperview];
    }
    _showImageMArray = [NSMutableArray arrayWithArray:showImage];
    CGFloat X = 15;
    for (int i = 0; i < showImage.count +1 ; i ++) {
        DJTaskImageShowView *view  = [[DJTaskImageShowView alloc] initWithFrame:CGRectMake(X, 0, 120, 154)];
        view.delegate = self;
        view.tag = 1000+i;
        if (i != showImage.count) {
            UIImage *image = originalImageArray[i];
            view.showImageView.image =image;
            view.imageNameLabel.text = [NSString stringWithFormat:@"IMG00%d.JPG", i+1];
      __block  NSString *imageSize= @"0.0M";
            __weak __typeof(self) weakself= self;
            
            
            dispatch_queue_t Pqueue = dispatch_queue_create("jisuandaxiao", DISPATCH_QUEUE_CONCURRENT);
            //异步并发//开辟子线程
            dispatch_async(Pqueue, ^{
                // 子线程执行任务（比如获取较大数据）
                imageSize =  [self  calulateImageFileSize:image];

                dispatch_async(dispatch_get_main_queue(), ^{
                    // 通知主线程刷新 神马的
                    view.imageSizeLabel.text = imageSize;
                });


            });

            
            
            NSString * state = Progress[i];
            if ([state isEqualToString:@"0"]) {
                view.deleteBtn.hidden = YES;
            }
            if ([state isEqualToString:@"1"]) {
                view.deleteBtn.hidden = NO;
            }
            if ([state isEqualToString:@"2"]) {
                view.deleteBtn.hidden = YES;
            }
            
            
            view.state = state.integerValue;
        }else {
            view.imageNameLabel.text = @"";
            view.imageSizeLabel.text = @"";
            view.showImageView.image = [UIImage imageNamed:@"DJ_fbrw_AddImage"];
            view.deleteBtn.hidden = YES;
            view.state = DJTaskImagShowNoImage;
        }
        
        [self.ScrollContentView addSubview:view];
        view.sd_layout.leftSpaceToView(self.ScrollContentView, X).topSpaceToView(self.ScrollContentView, 0).bottomSpaceToView(self.ScrollContentView, 0).widthIs(120);
        X += 120;
        [self.viewArray addObject:view];
        if (i == showImage.count) {
            self.lastRightLine = [UILabel new];
            [self.ScrollContentView addSubview:self.lastRightLine];
            self.lastRightLine.sd_layout.leftSpaceToView(view, 0).topSpaceToView(self.ScrollContentView, 0).bottomSpaceToView(self.ScrollContentView, 0).widthIs(1);
        }else {
            LBPhotoLocalItem *item = [[LBPhotoLocalItem alloc]initWithImage:originalImageArray[i] frame:view.frame];
            [self.showImageObjcArray addObject:item];
        }
        [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
      }
    self.ScrollContentView.sd_layout.
    leftEqualToView(self.scrollView)
    .bottomEqualToView(self.scrollView)
    .topEqualToView(self.scrollView);
    [self.ScrollContentView setupAutoWidthWithRightView:self.lastRightLine rightMargin:0];
}

#pragma DJTaskImageShowViewDelegate

- (void)deletelImage:(DJTaskImageShowView *)view {
    if ([_delegate respondsToSelector:@selector(cancelSelectedImage:)]) {
        [_delegate cancelSelectedImage:view.tag - 1000];
    }
}

- (void)ClickSelf:(DJTaskImageShowView *)view {
    
    
    NSInteger index = view.tag - 1000;
    if (index ==self.showImageMArray.count) {
        if (self.showImageMArray.count == 6) {
            [self ShowWarningHudMid:@"最多可上传6张图片作为附件哦！"];
            return;
        }
        if ([_delegate respondsToSelector:@selector(ClickUploadImage:)]) {
            [_delegate ClickUploadImage:index];
        }
    }else {
           [[LBPhotoBrowserManager defaultManager] showImageWithLocalItems:self.showImageObjcArray selectedIndex:view.tag - 1000 fromImageViewSuperView:self.ScrollContentView];
//        if ([_delegate respondsToSelector:@selector(amplificationImage:)]) {
//            [_delegate amplificationImage:index];
//        }
    }
    
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
@end
