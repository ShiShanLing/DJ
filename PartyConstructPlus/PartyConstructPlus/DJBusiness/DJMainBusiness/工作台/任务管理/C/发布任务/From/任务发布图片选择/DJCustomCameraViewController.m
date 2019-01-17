//
//  DJCustomCameraViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/4.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJCustomCameraViewController.h"
#import "DJChooseImageShowView.h"
#import "DJTaskDistrViewController.h"
//导入相机框架
#import <AVFoundation/AVFoundation.h>
//将拍摄好的照片写入系统相册中，所以我们在这里还需要导入一个相册需要的头文件iOS8
#import <Photos/Photos.h>
@interface DJCustomCameraViewController () <UIAlertViewDelegate, DJChooseImageShowViewDelegate>
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;
//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;
//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;
//照片输出流
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;
//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;
//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
// ------------- UI --------------
//闪光灯按钮
@property (nonatomic)UIButton *flashButton;
//聚焦
@property (nonatomic)UIView *focusView;
//是否开启闪光灯
@property (nonatomic)BOOL isflashOn;

/**
 *已经选择的图片展示
 */
@property (nonatomic, strong)DJChooseImageShowView* chooseImageShowView;
//----------------底部相机操作UI-------------
/**
 *底部操作view
 */
@property (nonatomic, strong)UIView * bottomOperationView;
/**
 *确定上传
 */
@property (nonatomic, strong)UIButton * determineBtn;
/**
 *拍照按钮
 */
@property (nonatomic)UIButton *photoButton;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * selectedImageArray;
/**
 *
 */
@property (nonatomic, strong)UIBarButtonItem *flashButtonItem;
/**
 *
 */
@property (nonatomic, strong)dispatch_semaphore_t semaphore;
@end


@implementation DJCustomCameraViewController {
    
    
    
}

- (NSMutableArray *)selectedImageArray {
    if (!_selectedImageArray) {
        _selectedImageArray = [NSMutableArray array];
    }
    return _selectedImageArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
    
}

- (DJChooseImageShowView *)chosenImageShowView {
    if (!_chooseImageShowView) {
        _chooseImageShowView = [[DJChooseImageShowView alloc] init];
        
        _chooseImageShowView.delegate = self;
        _chooseImageShowView.showType = DJChooseImageShowViewNoButton;
//        _chooseImageShowView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_chooseImageShowView];
        _chooseImageShowView.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, kFit(103)+kTabbarSafeBottomMargin).rightSpaceToView(self.view, 0).heightIs(90);
    }
    return _chooseImageShowView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.semaphore = dispatch_semaphore_create(1);
    self.navigationItem.title = @"拍照";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.returnButtonItem;
    __weak DJCustomCameraViewController *selfWeak = self;
    self.returnClickBlock = ^(NSString *strValue) {
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
    
    UIButton *flashButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    flashButton.frame = CGRectMake(0, 0, 50, 50);
    [flashButton setImage:[UIImage imageNamed:@"DJ_customCamera_flashOff"] forState:(UIControlStateNormal)];
    [flashButton setImage:[UIImage imageNamed:@"DJ_customCamera_flashOn"] forState:(UIControlStateSelected)];
    [flashButton addTarget:self action:@selector(handleFlashAccount:) forControlEvents:UIControlEventTouchUpInside];
    self.flashButtonItem = [[UIBarButtonItem alloc] initWithCustomView:flashButton];
    self.navigationItem.rightBarButtonItem = _flashButtonItem;
    
    if ( [self checkCameraPermission]) {
        
        [self customCamera];
        [self initSubViews];
        
        [self focusAtPoint:CGPointMake(0.5, 0.5)];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customCamera
{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc]init];
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
        
    }
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
        
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-kFit(90)-kTabbarSafeBottomMargin);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    
    //修改设备的属性，先加锁
    if ([self.device lockForConfiguration:nil]) {
        
        //闪光灯自动
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeOff];
        }
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        //解锁
        [self.device unlockForConfiguration];
    }
//    self.focusView = [[UIView alloc]init];
//    self.focusView.layer.borderWidth = 1.0;
//    self.focusView.layer.borderColor = [UIColor greenColor].CGColor;
//    [self.view addSubview:self.focusView];
//    self.focusView.sd_layout.widthIs(80).heightIs(80).centerXEqualToView(self.view).centerYEqualToView(self.view);
//    self.focusView.hidden = YES;
    
}

- (void)initSubViews{
    
    

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.chosenImageShowView.hidden = YES;
    self.bottomOperationView = [[UIView alloc] init];
    _bottomOperationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomOperationView];
    _bottomOperationView.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).rightSpaceToView(self.view, kFit(62)).heightIs(kFit(103)+kTabbarSafeBottomMargin);
    [_bottomOperationView updateLayout];
    
    self.determineBtn = [UIButton new];
    [_determineBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [_determineBtn setTitleColor:kColorRGB(253, 115, 77, 1) forState:(UIControlStateNormal)];
    _determineBtn.titleLabel.font = MFont(kFit(16));
    _determineBtn.backgroundColor =  [UIColor whiteColor];
    [_determineBtn addTarget:self action:@selector(handleDetermineBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_determineBtn];
    _determineBtn.sd_layout.rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0+kTabbarSafeBottomMargin).widthIs(kFit(62)).heightIs(kFit(103));
    [_determineBtn updateLayout];
    
    UILabel *_dividerLabel  = [UILabel new];
    _dividerLabel.backgroundColor = kCellColorDivider;
    [_determineBtn addSubview:_dividerLabel];
    _dividerLabel.sd_layout.leftSpaceToView(_determineBtn, 0).bottomSpaceToView(_determineBtn, 0).widthIs(kCellDividerHeight).topSpaceToView(_determineBtn, 0);
    
    self.photoButton = [UIButton new];
    
    [self.photoButton setBackgroundImage:[UIImage imageNamed:@"DJ_customCamera_start"] forState:(UIControlStateNormal)];
    [self.photoButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.photoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomOperationView addSubview:self.photoButton];
    _photoButton.sd_layout.widthIs(kFit(90)).heightIs(kFit(80)).centerXEqualToView(_bottomOperationView).topSpaceToView(_bottomOperationView, kFit(11));
}
//确定按钮 点击上传图片
- (void)handleDetermineBtn {
    // 2.创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"TakingPictures" object:nil userInfo:@{@"image":self.selectedImageArray}];
    // 3.通过 通知中心 发送 通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    DJTaskDistrViewController *VC = nil;
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[DJTaskDistrViewController class]]) {
            VC = (DJTaskDistrViewController *)temp;
            break;
        }
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//点击聚焦
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    // focusPoint 函数后面Point取值范围是取景框左上角（0，0）到取景框右下角（1，1）之间,按这个来但位置就是不对，只能按上面的写法才可以。前面是点击位置的y/PreviewLayer的高度，后面是1-点击位置的x/PreviewLayer的宽度
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );
    NSLog(@"focusPoint,x%f, focusPoint.y%f", focusPoint.x, focusPoint.y-0.2);
    if ([self.device lockForConfiguration:nil]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            //曝光量调节
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
    
}

- (void)handleFlashAccount:(UIButton *)sender{
    if ([_device lockForConfiguration:nil]) {
        if (_isflashOn) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                _isflashOn = NO;
                sender.selected = NO;
            }
        }else{
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
                _isflashOn = YES;
                sender.selected = YES;
            }
        }
        
        [_device unlockForConfiguration];
    }
}
//切换摄像头
- (void)changeCamera{
    //获取摄像头的数量
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    //摄像头小于等于1的时候直接返回
    if (cameraCount <= 1) return;
    
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    //获取当前相机的方向(前还是后)
    AVCaptureDevicePosition position = [[self.input device] position];
    
    //为摄像头的转换加转场动画
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.type = @"oglFlip";
    
    if (position == AVCaptureDevicePositionFront) {
        //获取后置摄像头
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        animation.subtype = kCATransitionFromLeft;
    }else{
        //获取前置摄像头
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        animation.subtype = kCATransitionFromRight;
    }
    
    [self.previewLayer addAnimation:animation forKey:nil];
    //输入流
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    
    
    if (newInput != nil) {
        
        [self.session beginConfiguration];
        //先移除原来的input
        [self.session removeInput:self.input];
        
        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.input = newInput;
            
        } else {
            //如果不能加现在的input，就加原来的input
            [self.session addInput:self.input];
        }
        
        [self.session commitConfiguration];
        
    }
    
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}

#pragma mark- 拍照
- (void)shutterCamera
{


    __weak DJCustomCameraViewController *selfWeak = self;
    

        AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
        if (videoConnection ==  nil) {
            return;
        }
        [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            if (imageDataSampleBuffer == nil) {
                return;
            }
            if ((selfWeak.selectedImageArray.count + selfWeak.existingImageNum) >=6) {
                [selfWeak  ShowWarningHudMid:@"最多可上传6张图片作为附件哦！"];
                return;
            }
            NSData *imageData =  [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            image = [UIImage compressedImage:image];
            [selfWeak.selectedImageArray addObject:image];
//            [selfWeak.chosenImageShowView.showImageObjcArray removeAllObjects];
            [selfWeak.chooseImageShowView InsertImage:image index:0];
            if (selfWeak.selectedImageArray.count == 1) {
                selfWeak.chosenImageShowView.chooseImageArray = self.selectedImageArray;
            }
            selfWeak.chosenImageShowView.hidden = NO;
            [selfWeak.photoButton setBackgroundImage:[UIImage imageNamed:@"DJ_customCamera_selected"] forState:(UIControlStateNormal)];
            [selfWeak.photoButton setTitle:[NSString stringWithFormat:@"%ld/6", selfWeak.selectedImageArray.count + _existingImageNum] forState:(UIControlStateNormal)];
            selfWeak.determineBtn.userInteractionEnabled = YES;
            if ((selfWeak.selectedImageArray.count + selfWeak.existingImageNum) >=6) {
                [selfWeak.photoButton setBackgroundImage:[UIImage imageNamed:@"DJ_customCamera_end"] forState:(UIControlStateNormal)];
                
            }
            
            //        [self saveImageWithImage:[UIImage imageWithData:imageData]];
        }];
        
    
}


/**
 * 保存图片到相册
 */
- (void)saveImageWithImage:(UIImage *)image {
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                if (@available(iOS 9.0, *)) {
                    createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
                } else {
                    // Fallback on earlier versions
                }
            } error:&error];
            
            if (error) {
                NSLog(@"保存失败：%@", error);
                return;
            }
        });
    }];
}


#pragma mark- 检测相机权限
- (BOOL)checkCameraPermission
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
    
    if (buttonIndex == 1 && alertView.tag == 100) {
        
#warning  这里让界面消失
        //
    }
    
}

- (void)deleteImage:(UIImage *)image {
    
    for (int i = 0; i < self.selectedImageArray.count; i ++) {
        UIImage *tempImage = self.selectedImageArray[i];
        if (tempImage == image) {
            [self.selectedImageArray removeObjectAtIndex:i];
            break;
        }
    }
    if (self.selectedImageArray.count == 0) {
        self.chooseImageShowView.hidden = YES;
        [self.photoButton setBackgroundImage:[UIImage imageNamed:@"DJ_customCamera_start"] forState:(UIControlStateNormal)];
        [self.photoButton setTitle:@"" forState:(UIControlStateNormal)];
    }else {
        
        [self.photoButton setBackgroundImage:[UIImage imageNamed:@"DJ_customCamera_selected"] forState:(UIControlStateNormal)];
            [self.photoButton setTitle:[NSString stringWithFormat:@"%ld/6", self.selectedImageArray.count + _existingImageNum] forState:(UIControlStateNormal)];
    }
    
}

@end
