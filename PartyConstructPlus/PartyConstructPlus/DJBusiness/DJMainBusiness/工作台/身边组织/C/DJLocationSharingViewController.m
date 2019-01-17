//
//  DJLocationSharingViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/31.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJLocationSharingViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "YZLocationManager.h"
#import "DJPointAnnotation.h"
#import "UserData.h"
#import "DJMapUserShowView.h"
@interface DJLocationSharingViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;

@property (nonatomic, strong)BMKMapView *mapView;
/**
 *
 */
@property (nonatomic, strong)BMKLocationService* locService;
/**
 *定位按钮
 */
@property (nonatomic, strong)UIButton * positioningBtn;

@property (strong, nonatomic) YZLocationManager *locationManager ;
/**
 *存储搜索到的人员信息
 */
@property (nonatomic, strong)NSMutableArray * userListArray;
/**
 *
 */
@property (nonatomic, strong)DJMapUserShowView *userDataShowView;

@end

@implementation DJLocationSharingViewController {
    
    NSString *_latitudeStr;
    NSString *_longtitudeStr;
    
}

- (NSMutableArray *)userListArray {
    if (!_userListArray) {
        _userListArray = [NSMutableArray array];
    }
    return _userListArray;
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    _locService.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    displayParam.locationViewImgName= @"DJ_sbzz_wzgx_me";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
    _locService.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"位置共享";
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.leftBtn.hidden = YES;
    [self.defaultNavigationBarView.rightBtn setTitle:@"终止共享" forState:(UIControlStateNormal)];
    [self.defaultNavigationBarView.rightBtn addTarget:self action:@selector(handleRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.defaultNavigationBarView.rightBtn updateLayout];
    
    self.defaultNavigationBarView.rightBtn.sd_layout.rightSpaceToView(self.defaultNavigationBarView, 0).bottomSpaceToView(self.defaultNavigationBarView, 10).widthIs(100).heightIs(25);
    self.defaultNavigationBarView.SegmentationLineLabel.hidden = YES;
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 17;//地图显示比例
    [self.view addSubview:_mapView];
    self.locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
 
    // 9.0以后这个必须要加不加是不能实现后台持续定位的的
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        _locService.allowsBackgroundLocationUpdates = YES;
        
    }
    _locService.pausesLocationUpdatesAutomatically = NO;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    
    {//地图上的按钮
        //定位按钮 回到自己的位置
        self.positioningBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_positioningBtn setImage:[UIImage imageNamed:@"DJ_sbzz_myLocation"] forState:(UIControlStateNormal)];
        [_positioningBtn setImage:[UIImage imageNamed:@"DJ_sbzz_myLocation"] forState:(UIControlStateHighlighted)];
        [_positioningBtn addTarget:self action:@selector(handlePositioningBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_mapView addSubview:_positioningBtn];
        _positioningBtn.sd_layout.rightSpaceToView(_mapView, kFit(15)).topSpaceToView(_mapView, kFit(40)).widthIs(40).heightIs(40);
    }
    
    _locationManager = [YZLocationManager sharedLocationManager];
    _locationManager.isBackGroundLocation = YES;
    _locationManager.locationInterval = 5;
    //    @weakify(manager)
    __weak typeof(self) weakSelf = self;
    [_locationManager setYZBackGroundLocationHander:^(CLLocationCoordinate2D coordinate) {
        [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
        _latitudeStr = [NSString stringWithFormat:@"%f",coordinate.latitude];
        _longtitudeStr = [NSString stringWithFormat:@"%f",coordinate.longitude];
        [weakSelf startLocationSharing];
    }];
    [_locationManager startLocationService];
    
    
    self.userDataShowView = [[DJMapUserShowView alloc] init];
    _userDataShowView.hidden = YES;
    [self.view addSubview:_userDataShowView];
    _userDataShowView.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(kFit(80+kTabbarSafeBottomMargin));
}
//再次定位
- (void)handlePositioningBtn{
    if (![CommonUtil isOpenPosition]) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"打开[定位服务]来允许[杭州党建责任]确定您的位置" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启杭州党建责任)" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        
        [alertCtrl addAction:cancelAction];
        [alertCtrl addAction:sureAction];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }else{
        
        [_locService startUserLocationService];
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
    }
}

- (void)handleReturnBtn {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"终止位置共享" message:@"确定终止共享位置吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"终止" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self endLocationSharing];
            [_locationManager stopLocationService];
            _locationManager.isBackGroundLocation = NO;
            [_locService stopUserLocationService];
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        [alertCtrl addAction:cancelAction];
        [alertCtrl addAction:sureAction];
        [self presentViewController:alertCtrl animated:YES completion:nil];
   
}
//停止共享
- (void)handleRightBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        [self handleReturnBtn];
    }else {
        [self startLocationSharing];
        [_locationManager startLocationService];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    _longtitudeStr =   [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
    _latitudeStr =   [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
    [_mapView updateLocationData:userLocation];
//    [_locService stopUserLocationService];
}
#pragma mark implement BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 用户头像 名字 组织名称
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    annotationView.image = [UIImage imageNamed:@"DJ_sbzz_wzgx_other"];
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = NO;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    UIImageView *areaPaoView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 154, 40)];
    areaPaoView.image = [UIImage imageNamed:@"DJMapOrgNameBackground"];
    
    UILabel * pointName = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 154, 30)];
    pointName.textColor = [UIColor whiteColor];
    pointName.font = MFont(kFit(14));
    pointName.textAlignment = NSTextAlignmentCenter;
    [areaPaoView addSubview:pointName];
    BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:areaPaoView];
    annotationView.paopaoView= paopao;
    return annotationView;
}




- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    
    DJPointAnnotation *djAnn =  view.annotation;
    if ([djAnn.title isEqualToString:@"我的位置"]) {
        UserData  *model = [DJUserTool getUserInfo];
        self.userDataShowView.userNameLabel.text = model.name;
        self.userDataShowView.userAddressLabel.text = [self getDefaultOrg].orgName;
        [self.userDataShowView.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[DJUserTool getUserHeadImage]]] placeholderImage:[UIImage imageNamed:@"DJUserDefaultHead"]];
        self.userDataShowView.hidden = NO;
    }else {
        
        for (int i = 0; i < self.userListArray.count; i ++) {
            NSDictionary *userDic = self.userListArray[i];
            if ([[NSString stringWithFormat:@"%@", userDic[@"userId"]] isEqualToString:djAnn.userId]) {
                
                NSString *userhead = userDic[@"headUrl"];
                if ([userhead isURL]) {
                    [self.userDataShowView.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:userhead] placeholderImage:[UIImage imageNamed:@"DJUserDefaultHead"] options:0];
                }else {
                    userhead = [NSString stringWithFormat:@"%@%@",userDic[@"dfsUrl"], userhead];
                    [self.userDataShowView.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:userhead] placeholderImage:[UIImage imageNamed:@"DJUserDefaultHead"] options:0];
                }
                self.userDataShowView.userNameLabel.text = userDic[@"name"];
                self.userDataShowView.userAddressLabel.text = userDic[@"orgName"];
                self.userDataShowView.hidden = NO;
                break;
            }
        }
    }
    
    
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)startLocationSharing {
    static   int  i = 0 ;
    NSLog(@"LocationSharing%d", i);
    i ++;
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    [URL_Dic setValue:_latitudeStr forKey:@"lat"];
    [URL_Dic setValue:_longtitudeStr forKey:@"lon"];
    [URL_Dic setValue:[self getDefaultOrg].orgId forKey:@"orgId"];
    NSLog(@"URL_Dic%@", URL_Dic);
    [self getJSONDataWithUrl:kURL_startLocationSharing parameters:URL_Dic success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self parsingLocationData:responseObject];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        NSLog(@"kURL_startLocationSharing%@", responseObject);
    } failure:^(NSError *error) {
        
    }];
}
- (void)parsingLocationData:(NSDictionary *)response {
    [self.userListArray removeAllObjects];
    NSArray *arrayData = response[@"response"];
    if (![arrayData isKindOfClass:[NSArray class]]) {
        return;
    }
    
    self.userListArray = [NSMutableArray arrayWithArray:arrayData];
   //向地图添加标注
    
    
        NSMutableArray *locationArray = [NSMutableArray array];
        for (int i = 0; i < arrayData.count; i ++) {
            NSDictionary *dataDic =arrayData[i];
            DJPointAnnotation *point = [[DJPointAnnotation alloc] init];
            CLLocationCoordinate2D coor;
            coor.latitude = [ dataDic[@"lat"] floatValue];
            coor.longitude = [dataDic[@"lon"] floatValue];
            point.coordinate = coor;
            point.userId = [NSString stringWithFormat:@"%@", dataDic[@"userId"]];
            [locationArray addObject:point];
            [self.userListArray addObject:dataDic];
        }
        //向地图添加标注
//        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotations:locationArray];
    NSLog(@"self.userListArray%@", self.userListArray);
}

- (void)endLocationSharing {
            [self.mapView removeAnnotations:self.mapView.annotations];
    [self getJSONDataWithUrl:kURL_endLocationSharing parameters:nil success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            
        }
//        NSLog(@"kURL_startLocationSharing%@", responseObject);
    } failure:^(NSError *error) {
        
    }];
}

- (void)mapAddAnnotation {
    
    
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
