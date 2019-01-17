//
//  DJCirculationImageView.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJCirculationImageView.h"
#import <CoreFoundation/CFRunLoop.h>

#define W (self.bounds.size.width)
#define H (self.bounds.size.height)
@interface DJCirculationImageView ( ) <UIScrollViewDelegate>
@property (nonatomic, assign) BOOL          isURL;
@property (nonatomic, assign) NSInteger     index;
@property (nonatomic, strong) NSTimer       *timer;
@property (nonatomic, strong) NSArray       *titleArray;
@property (nonatomic, strong) NSArray       *imagesArray;
@property (nonatomic, strong) UILabel       *titleLbl;
@property (nonatomic, strong) UILabel       *PageNumber;
@property (nonatomic, strong) UIView        *titleView;

@property (nonatomic, strong) UIImage       *placeImage;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView   *leftImageView;
@property (nonatomic, strong) UIImageView   *rightImageView;
@property (nonatomic, strong) UIImageView   *centerImageView;
@property (nonatomic, strong) UIScrollView  *imageScrollView;
/**
 *
 */
@property (nonatomic, assign) CGSize imageSize;
@end

@implementation DJCirculationImageView

- (instancetype)init {
    
    @throw [NSException exceptionWithName:@"初始化方法" reason:@"请使用 initWithFrame: withImageName(URL)sArray: 初始化" userInfo:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    @throw [NSException exceptionWithName:@"初始化方法" reason:@"请使用 initWithFrame: withImageName(URL)sArray: 初始化" userInfo:nil];
}

- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array {
    
    return [self initWithFrame:frame andImageNamesArray:array andPlaceImage:nil];
}

- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage {
    
    return [self initWithFrame:frame andImageNamesArray:array andPlaceImage:placeImage andTitles:nil];
}

- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andTitles:(NSArray *)titles {
    
    return [self initWithFrame:frame andImageNamesArray:array andPlaceImage:nil andTitles:titles];
}

- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles {
    NSAssert(array.count > 2, @"图片的数量不能少于3张");
    if (titles != nil || titles.count > 0) {
        NSAssert(array.count == titles.count, @"图片和名称数组数量不对应");
    }
    self = [super initWithFrame:frame];
    
    self.imageSize = frame.size;
    //  NSLog(@"self.imageSize->height%f--self.imageSize->width%f",self.imageSize.height , self.imageSize.width);
    if (self) {
        self.index = 0;
        self.isURL = NO;
        self.placeImage = placeImage;
        self.imagesArray = array;
        self.titleArray = titles;
        [self setupLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array {
    
    return [self initWithFrame:frame andImageURLsArray:array andPlaceImage:nil];
}

- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage {
    
    return [self initWithFrame:frame andImageURLsArray:array andPlaceImage:placeImage andTitles:nil];
}

- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andTitles:(NSArray *)titles {
    
    return [self initWithFrame:frame andImageURLsArray:array andPlaceImage:nil andTitles:titles];
}

- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles {
    
    NSAssert(array.count > 0, @"图片的数量不能少于1张");
    if (titles != nil || titles.count > 0) {
        NSAssert(array.count == titles.count, @"图片和名称数组数量不对应");
    }
    
    self = [super initWithFrame:frame];
    self.imageSize = frame.size;
    //NSLog(@"self.imageSize->height%f--self.imageSize->width%f",self.imageSize.height , self.imageSize.width);
    if (self) {
        self.index = 0;
        self.isURL = YES;
        self.placeImage = placeImage;
        self.imagesArray = array;
        self.titleArray = titles;
        [self setupLayout];
    }
    return self;
}

#pragma mark - private method
//布局
- (void)setupLayout {
    
    self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W, H)];
    _leftImageView.backgroundColor = kColorRGB(173, 173, 173, 1);
    _leftImageView.clipsToBounds = YES;
    
    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(W, 0, W, H)];
    _centerImageView.backgroundColor = kColorRGB(173, 173, 173, 1);
    _centerImageView.clipsToBounds = YES;
    
    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(W * 2, 0, W, H)];
    _rightImageView.backgroundColor = kColorRGB(173, 173, 173, 1);
    _rightImageView.clipsToBounds = YES;
    
    [self setupImage];
    [self.imageScrollView addSubview:self.leftImageView];
    [self.imageScrollView addSubview:self.centerImageView];
    [self.imageScrollView addSubview:self.rightImageView];
    [self addSubview:self.titleView];
    [self startTimer];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [self addGestureRecognizer:tap];
}
//重新给UIImageView赋值
- (void)setupImage {
    if (self.isURL) {
        
        [self.centerImageView sd_setImageWithURL:[self pathToURL:self.index] placeholderImage:self.placeImage];
        [self.leftImageView sd_setImageWithURL:[self pathToURL:self.index-1>=0?self.index-1:self.imagesArray.count-1] placeholderImage:self.placeImage];
        
        [self.rightImageView sd_setImageWithURL:[self pathToURL:self.index+1 <=self.imagesArray.count-1?self.index+1:0] placeholderImage:self.placeImage];
    }
    else {
        self.centerImageView.image
        = [self addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imagesArray[self.index]]]];
        self.leftImageView.image
        = [self addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imagesArray[self.index-1>=0?self.index-1:self.imagesArray.count-1]]]];
        self.rightImageView.image
        = [self addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imagesArray[self.index+1 <=self.imagesArray.count-1?self.index+1:0]]]];
    }
}



//生成图片的RUL
- (NSURL *)pathToURL:(NSInteger)integer {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imagesArray[integer]]];
}
//设置默认图片
- (UIImage *)addImage:(UIImage *)image {
    if (image == nil) {
        return self.placeImage;
    } else {
        return image;
    }
}
//self 点击事件
- (void)clickImage:(UITapGestureRecognizer *)tap {
    [self closeTimer];
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self startTimer];
    }
    
    
    
    if ([_delegate respondsToSelector:@selector(CirculationImageClickEvent:)]) {
        [_delegate CirculationImageClickEvent:self.index];
    }
    
}

#pragma mark - get
//判断有没有设置轮播图的秒数. 如果没有默认给一个 3.0
- (float)pauseTime {
    
    return (_pauseTime ? _pauseTime : 5.0);
}


#pragma mark - set
//选择图片现实的方式 UIViewContentMode类型
- (void)setImageContentMode:(UIViewContentMode)imageContentMode {
    _imageContentMode = imageContentMode;
    _leftImageView.contentMode = imageContentMode;
    _centerImageView.contentMode = imageContentMode;
    _rightImageView.contentMode = imageContentMode;
}
//是否隐藏title
- (void)setHiddenTitleView:(BOOL)hiddenTitleView {
    
    self.titleView.hidden = hiddenTitleView;
}
//自定义 Page 圆点默认颜色
- (void)setDefaultPageColor:(UIColor *)defaultPageColor {
    
    self.pageControl.pageIndicatorTintColor = defaultPageColor;
}
//自定义 Page 圆点选中颜色
- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    self.pageControl.currentPageIndicatorTintColor = currentPageColor;
}
//自定义title样式
- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    
    _titleAlignment = titleAlignment;
    self.titleLbl.textAlignment = titleAlignment;
}
//设置title的颜色
- (void)setTitleColor:(UIColor *)titleColor {
    
    _titleColor = titleColor;
    self.titleLbl.textColor = titleColor;
}
//创建title
- (void)setTitleViewStatus:(SZTitleViewStatus)titleViewStatus {
    
    _titleViewStatus = titleViewStatus;
    [self.titleView removeFromSuperview];
    self.titleView = nil;
    [self addSubview:self.titleView];
}

#pragma mark - timer
- (void)startTimer {
    if(self.timer == nil){//
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.pauseTime target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
    }
}

- (void)closeTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
//轮播图跳转代码在这里
- (void)timerStart
{
    NSLog(@"pauseTime%d", self.pauseTime);
    self.imageScrollView.contentOffset = CGPointMake(0, 0);//吧ScrollView的 contentOffset 设置未 0 0 这是没有使用动画直接更改 contentOffset视觉上看不出有改变 其实已经改变了   从而实现的无限轮播
    [self.imageScrollView setContentOffset:CGPointMake(W, 0) animated:YES];//<<<<这是重点>>>>> 以动画的形式让界面跳转 现实图片更换效果
    
    self.index++;
    if (self.index  > self.imagesArray.count-1 ) {
        self.index = 0;
    }
    [self setupImage];
    self.pageControl.currentPage = self.index;
    self.PageNumber.text = [NSString stringWithFormat:@"%ld/%lu", (long)self.index + 1, (unsigned long)self.imagesArray.count];
    self.titleLbl.text = self.titleArray.count ? self.titleArray[self.index] : @"";
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self closeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (decelerate == NO) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x < W/2.0) {
        scrollView.contentOffset = CGPointMake(W, 0);
        self.index--;
        if (self.index < 0) {
            self.index = self.imagesArray.count-1;
        }
        [self setupImage];
    }
    if (scrollView.contentOffset.x > W *1.5) {
        scrollView.contentOffset = CGPointMake(W, 0);
        self.index++;
        if (self.index  > self.imagesArray.count-1 ) {
            self.index = 0;
        }
        [self setupImage];
    }
    self.pageControl.currentPage = self.index;
    self.PageNumber.text = [NSString stringWithFormat:@"%ld/%lu", (long)self.index + 1, (unsigned long)self.imagesArray.count];
    self.titleLbl.text = self.titleArray.count ? self.titleArray[self.index] : @"";
    [self startTimer];
}


#pragma mark - lazy load

- (UIScrollView *)imageScrollView {
    
    if (_imageScrollView == nil) {
        _imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.contentOffset = CGPointMake(W, 0);
        _imageScrollView.contentSize = CGSizeMake(W * 3, H);
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.delegate = self;
        _imageScrollView.bounces = NO;
        [self addSubview:_imageScrollView];
    }
    return _imageScrollView;
}
//创建title
- (UIView *)titleView {
    
    if (_titleView == nil) {
        
        CGRect prect = CGRectZero;
        CGRect trect = CGRectZero;
        CGRect rect = [self setupPageControlFrame:&prect titleLabelFrame:&trect];
        
        _titleView = [[UIView alloc] initWithFrame:rect];
        [self addSubview:_titleView];
        
        UILabel *mask = [[UILabel alloc] initWithFrame:_titleView.bounds];
        mask.backgroundColor = [UIColor clearColor];
        [_titleView addSubview:mask];
        
        if (self.titleViewStatus == SZTitleViewTopOnlyTitle) {
            
            _titleView.backgroundColor = kColorRGB(134, 134, 134,1.0);
            _titleView.layer.cornerRadius = kFit(53)/2;
            _titleView.alpha = 0.8;
            _titleView.layer.masksToBounds = YES;
            
            self.PageNumber = [[UILabel alloc] initWithFrame:trect];
            self.PageNumber.text = [NSString stringWithFormat:@"%d/%lu", 1, (unsigned long)self.imagesArray.count];
            _PageNumber.textAlignment = 1;
            _PageNumber.textColor = kColorRGB(255, 255, 255,1.0);
            _PageNumber.font = MFont(kFit(14));
            [self.titleView addSubview:_PageNumber];
        }
        
        if(prect.size.width != 0) {
            prect.origin.y -= 10;
            self.pageControl = [[UIPageControl alloc] initWithFrame:prect];
            
            self.pageControl.currentPage = self.index;
            self.pageControl.userInteractionEnabled = NO;
            self.pageControl.numberOfPages = self.imagesArray.count;
            
            self.pageControl.pageIndicatorTintColor = kColorRGB(134, 134, 134,1.0);
            self.pageControl.currentPageIndicatorTintColor = kColorRGB(255, 143, 0,1.0);
            [_titleView addSubview:self.pageControl];
        }
        
        self.titleLbl = [[UILabel alloc] initWithFrame:trect];
        self.titleLbl.font = [UIFont systemFontOfSize:14];
        self.titleLbl.text = self.titleArray.count ? self.titleArray[self.index] : @"";
        [_titleView addSubview:self.titleLbl];
    }
    return _titleView;
}
//这个是给指示器和title布局用的
- (CGRect)setupPageControlFrame:(CGRect *)frame titleLabelFrame:(CGRect *)titleFrame {
    
    CGRect rect = CGRectMake(0, H - H * 0.1, W, H * 0.1);
    CGRect prect = CGRectZero;
    CGRect trect = CGRectZero;
    switch (self.titleViewStatus) {
            
        case SZTitleViewBottomOnlyPageControl:
            prect = CGRectMake(0, 0, W, H * 0.1);
            break;
            
        case SZTitleViewBottomOnlyTitle:
            trect = CGRectMake(0, 0, W, H * 0.1);
            break;
            
        case SZTitleViewBottomPageControlAndTitle:
            prect = CGRectMake(0, 0, W * 0.3, H * 0.1);
            trect = CGRectMake(W * 0.3, 0, W * 0.7, H * 0.1);
            break;
            
        case SZTitleViewBottomPageTitleAndControl:
            trect = CGRectMake(0, 0, W * 0.7, H * 0.1);
            prect = CGRectMake(W * 0.7, 0, W * 0.3, H * 0.1);
            break;
            
        case SZTitleViewTopOnlyTitle:
            rect = CGRectMake(kScreenWidth-kFit(64), kFit(237), kFit(53), kFit(53));
            trect = CGRectMake(0, 0, kFit(53), kFit(53));
            break;
            
        case SZTitleViewTopOnlyPageControl:
            rect = CGRectMake(0, 0, W, H * 0.1);
            prect = CGRectMake(0, 0, W, H * 0.1);
            break;
            
        case SZTitleViewTopPageControlAndTitle:
            rect = CGRectMake(0, 0, W, H * 0.1);
            prect = CGRectMake(0, 0, W * 0.3, H * 0.1);
            trect = CGRectMake(W * 0.3, 0, W * 0.7, H * 0.1);
            break;
            
        case SZTitleViewTopPageTitleAndControl:
            rect = CGRectMake(0, 0, W, H * 0.1);
            trect = CGRectMake(0, 0, W * 0.7, H * 0.1);
            prect = CGRectMake(W * 0.7, 0, W * 0.3, H * 0.1);
            break;
            
        default:
            break;
    }
    *frame = prect;
    *titleFrame = trect;
    return rect;
}

- (void)dealloc {
    
    [self closeTimer];
}

-(void)setImageUrlArray:(NSArray *)ImageUrlArray {
    __weak DJCirculationImageView *selfweak = self;
    _imagesArray = ImageUrlArray;
    self.pageControl.numberOfPages = _imagesArray.count;
    [selfweak setupLayout];
    
}
@end
