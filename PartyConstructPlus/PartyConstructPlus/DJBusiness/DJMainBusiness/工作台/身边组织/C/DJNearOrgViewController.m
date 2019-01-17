//
//  DJNearOrgViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/20.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJNearOrgViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "DJmitationWeChatSearchBoxVIew.h"
#import "DJMapOrgShowTableViewCell.h"
#import "DJPointAnnotation.h"
#import "MapNearOrgModel+CoreDataProperties.h"
#import "DJMapOrgSearchViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DJLocationSharingViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface DJNearOrgViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, DJmitationWeChatSearchBoxVIewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, DJMapOrgShowTableViewCellDelegate, BMKOpenPanoramaDelegate>

@property (nonatomic, strong)BMKMapView *mapView;
/**
 *
 */
@property (nonatomic, strong)BMKLocationService* locService;
/**
 *履历搜索view
 */
@property (nonatomic, strong)DJmitationWeChatSearchBoxVIew *searchView;
/**
 *默认导航条
 */
@property (nonatomic, strong)DJCustomModuleNavigationBarView *defaultNavigationBarView;
/**
 *
 */
@property (nonatomic, strong)UITableView * orgShowTableView;
/**
 *承载tableview的view
 */
@property (nonatomic, strong)UIView * slidingView;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * orgArray;
/**
 *tableView滑动手势
 */
@property (nonatomic, strong)UIPanGestureRecognizer *tableViewPanGR;
/**
 *定位按钮
 */
@property (nonatomic, strong)UIButton * positioningBtn;
/**
 *共享位置按钮
 */
@property (nonatomic, strong)UIButton * LocationSharingBtn;
@end

@implementation DJNearOrgViewController {
    
    NSString *_latitudeStr;//地图移动之前的位置
    NSString *_longtitudeStr;//地图移动之前的位置
    //记录当前展示组织视图的位置
    NSInteger  orgShowViewState; //0隐藏状态 1展开 2某一个详情
    MapNearOrgModel *selectedOrgModel;
    BOOL viewSliding;//是否允许进行UITableVIew的frame改变
    BOOL isBackMyLocation;//是否允许回到我的位置
    
    CLLocationCoordinate2D MyLocation;//我的位置
    
}

- (UITableView *)orgShowTableView {
    if (!_orgShowTableView) {
        _orgShowTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50-kTabbarSafeBottomMargin, kScreenWidth, 50+kTabbarSafeBottomMargin) style:(UITableViewStyleGrouped)];
        _orgShowTableView.delegate = self;
        _orgShowTableView.dataSource = self;
        _orgShowTableView.scrollEnabled = NO;
        [_orgShowTableView registerClass:[DJMapOrgShowTableViewCell class] forCellReuseIdentifier:@"DJMapOrgShowTableViewCell"];
        [_orgShowTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _orgShowTableView.layer.shadowOffset = CGSizeMake(-10, -10);
        _orgShowTableView.layer.shadowOpacity = 1.0;
        _orgShowTableView.layer.shadowColor =[UIColor redColor].CGColor;
        _orgShowTableView.showsVerticalScrollIndicator = NO;
        _orgShowTableView.alpha = 0.0;
        _orgShowTableView.showsHorizontalScrollIndicator = NO;
        
    }
    return _orgShowTableView;
}


- (NSMutableArray *)orgArray {
    if (!_orgArray) {
        _orgArray = [NSMutableArray array];
    }
    return _orgArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    _locService.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![CommonUtil isOpenPosition]) {
        CLLocationCoordinate2D coor;
        coor.latitude =30.251863;
        coor.longitude =  120.216481;
        [_mapView setCenterCoordinate:coor animated:YES];
    }
    if (![CommonUtil isOpenPosition]) {
        [self.positioningBtn setImage:[UIImage imageNamed:@"DJ_sbzz_myLocation_ban"] forState:(UIControlStateNormal)];
        [self.positioningBtn setImage:[UIImage imageNamed:@"DJ_sbzz_myLocation_ban"] forState:(UIControlStateHighlighted)];
        [self.LocationSharingBtn setImage:[UIImage imageNamed:@"DJ_sbzz_wzgx_ban"] forState:(UIControlStateNormal)];
        [self.LocationSharingBtn setImage:[UIImage imageNamed:@"DJ_sbzz_wzgx_ban"] forState:(UIControlStateHighlighted)];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    [_locService stopUserLocationService];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"身边组织";
    self.view.backgroundColor = [UIColor whiteColor];
    isBackMyLocation = YES;
    orgShowViewState = 0;
    _longtitudeStr = @"";
    _latitudeStr = @"";
    self.defaultNavigationBarView = [[DJCustomModuleNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.defaultNavigationBarView.leftBtn setImage:[UIImage imageNamed:@"DJAllReturn"] forState:(UIControlStateNormal)];
    _defaultNavigationBarView.titleLabel.text = @"身边组织";
    self.defaultNavigationBarView.rightBtn.hidden= YES;
    [self.defaultNavigationBarView.leftBtn addTarget:self action:@selector(handleReturnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.defaultNavigationBarView.SegmentationLineLabel.hidden = YES;
    self.defaultNavigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.defaultNavigationBarView];
    
    self.searchView = [[DJmitationWeChatSearchBoxVIew alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenWidth, 40)];
    self.searchView.defaultStateBtn.userInteractionEnabled = NO;
    
    _searchView.delegate = self;
    _searchView.searchTF.placeholder = @"输入组织名称.地址搜索";
    [_searchView.defaultStateBtn addTarget:self action:@selector(handleSearchOrg) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:_searchView];
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleGoToSearch)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    
    [_searchView addGestureRecognizer:singleFingerOne];

    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight+40, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-40)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 17;//地图显示比例
    [self.view addSubview:_mapView];
    {//地图上的按钮
        //定位按钮 回到自己的位置
        self.positioningBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_positioningBtn setImage:[UIImage imageNamed:@"DJ_sbzz_myLocation"] forState:(UIControlStateNormal)];
        [_positioningBtn setImage:[UIImage imageNamed:@"DJ_sbzz_myLocation"] forState:(UIControlStateHighlighted)];
        [_positioningBtn addTarget:self action:@selector(handlePositioningBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_mapView addSubview:_positioningBtn];
        _positioningBtn.sd_layout.rightSpaceToView(_mapView, kFit(15)).topSpaceToView(_mapView, kFit(40)).widthIs(40).heightIs(40);
        //共享位置按钮
        //共享位置按钮
        self.LocationSharingBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_LocationSharingBtn setImage:[UIImage imageNamed:@"DJ_sbzz_wzgx"] forState:(UIControlStateNormal)];
        [_LocationSharingBtn setImage:[UIImage imageNamed:@"DJ_sbzz_wzgx"] forState:(UIControlStateHighlighted)];
        
        [_LocationSharingBtn addTarget:self action:@selector(handleLocationSharingBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_mapView addSubview:_LocationSharingBtn];
        _LocationSharingBtn.sd_layout.rightSpaceToView(_mapView, kFit(15)).topSpaceToView(_positioningBtn, kFit(20)).widthIs(40).heightIs(40);
        
        UIButton *centerIconBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [centerIconBtn setImage:[UIImage imageNamed:@"ic_map_1"] forState:(UIControlStateNormal)];
        centerIconBtn.userInteractionEnabled = NO;
        [_mapView addSubview:centerIconBtn];
        centerIconBtn.sd_layout.widthIs(kFit(50)).heightIs(kFit(50)).centerXEqualToView(_mapView).centerYEqualToView(_mapView);

    }
    
    
    self.locService = [[BMKLocationService alloc] init];
    
    _locService.delegate = self;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    self.tableViewPanGR= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableViewPanGR:)];
    self.tableViewPanGR.delegate = self;
    [self.orgShowTableView addGestureRecognizer:self.tableViewPanGR];

    [self.view addSubview:self.orgShowTableView];

    
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
        self.orgShowTableView.alpha = 0.0;
    }else{
        
    }

}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //如果点击视图为uitableview 则忽略手势
      NSLog(@"view class:%@",[touch.view class]);
    if([touch.view isKindOfClass:[UITableView class]]){
        
        
        return NO;
    }
    return YES;
}
- (void)handleGoToSearch {
    DJMapOrgSearchViewController *VC = [[DJMapOrgSearchViewController alloc] init];
    
    [self presentToNextViewController:VC];
}
//改变UITableVIew的frame
- (void)handleTableViewPanGR:(UIPanGestureRecognizer *)pan {
    //tableview早滑动之前 漏出的高度 判断用户是想要关闭还是打开
    static  CGFloat  tvH;
    if (pan.state == UIGestureRecognizerStateBegan) {

        tvH =  self.orgShowTableView.height;
        orgShowViewState = 1;
        [self.orgShowTableView reloadData];
        CGRect frame= self.orgShowTableView.frame;
        frame.size.height = kFit(320)+kTabbarSafeBottomMargin;
        self.orgShowTableView.frame =frame;
        
    }
    
    CGPoint transP = [pan translationInView:self.orgShowTableView];
//    NSLog(@"transP = %@", NSStringFromCGPoint(transP));
    self.orgShowTableView.transform = CGAffineTransformTranslate(self.orgShowTableView.transform, 0, transP.y);
    //清零,不要累加
    [pan setTranslation:CGPointZero inView:self.orgShowTableView];

    if (self.orgShowTableView.mj_y<kScreenHeight-kFit(320)-kTabbarSafeBottomMargin) {
        CGRect frame= self.orgShowTableView.frame;
        frame.origin.y = kScreenHeight-kFit(320)-kTabbarSafeBottomMargin;
        self.orgShowTableView.frame =frame;
    }
    if (self.orgShowTableView.mj_y>kScreenHeight-50-kTabbarSafeBottomMargin) {
        CGRect frame= self.orgShowTableView.frame;
        frame.origin.y = kScreenHeight-50-kTabbarSafeBottomMargin;
        self.orgShowTableView.frame =frame;
    }
        if (pan.state == UIGestureRecognizerStateEnded) {
        NSLog(@"self.orgShowTableView.height%f  kFit(320)+kTabbarSafeBottomMargin%f", tvH, kFit(320)+kTabbarSafeBottomMargin);
        if (tvH == kFit(320)+kTabbarSafeBottomMargin) {//如果是展开状态的那么滑动就是要做关闭处理
            //        UITableVIew 漏出的高度
            CGFloat tvHeight = kScreenHeight - self.orgShowTableView.mj_y;
            if (tvHeight >= kFit(320)+kTabbarSafeBottomMargin-50) {//kFit(320)+kTabbarSafeBottomMargin-50 理解为tableview的高度 - 一个cell的高度 如果低于这个高度就关闭
                CGRect frame= self.orgShowTableView.frame;
                frame.origin.y = kScreenHeight-kFit(320)-kTabbarSafeBottomMargin;
                [UIView animateWithDuration:0.6 animations:^{
                    self.orgShowTableView.frame =frame;
                } completion:^(BOOL finished) {
                    
                    [self touchManagement:1];
                }];
                
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    self.orgShowTableView.frame = CGRectMake(0, kScreenHeight-50-kTabbarSafeBottomMargin, kScreenWidth, 50+kTabbarSafeBottomMargin);
                } completion:^(BOOL finished) {
                    [self touchManagement:0];
                }];
            }
        }else {//否者都是作为展开处理
            CGFloat tvHeight = kScreenHeight - self.orgShowTableView.mj_y;
            if (tvHeight >= 50+kTabbarSafeBottomMargin+50) {//kFit(320)+kTabbarSafeBottomMargin-50 理解为tableview的高度 - 一个cell的高度 如果低于这个高度就关闭
                
                [UIView animateWithDuration:0.6 animations:^{
                    CGRect frame= self.orgShowTableView.frame;
                    frame.origin.y = kScreenHeight-kFit(320)-kTabbarSafeBottomMargin;
                    self.orgShowTableView.frame =frame;
                }completion:^(BOOL finished) {
                    [self touchManagement:1];
                }];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    self.orgShowTableView.frame =CGRectMake(0, kScreenHeight-50-kTabbarSafeBottomMargin, kScreenWidth, 50+kTabbarSafeBottomMargin);
                } completion:^(BOOL finished) {
                    [self touchManagement:0];
                }];
            }
        }
    }
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
        isBackMyLocation = YES;
        [_mapView setCenterCoordinate:MyLocation animated:YES];
    }

}
//位置共享
- (void)handleLocationSharingBtn {
    
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
        DJLocationSharingViewController *VC = [[DJLocationSharingViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (void)handleReturnBtn {
    [self.locService stopUserLocationService];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)handleSearchOrg {
    
}
//请求身边组织
- (void) requestSideOrg{
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"distance"] = @"1000";
    URL_Dic[@"lat"] = _latitudeStr;
    URL_Dic[@"lon"] = _longtitudeStr;
    [self showHud:@"" title:@""];
    [self getJSONDataWithUrl:kURL_nearOrgList parameters:URL_Dic success:^(id responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self parsingOrgDic:responseObject[@"response"]];
        }else {
            [self ShowWarningHudMid:responseObject[@"msg"]];
        }
        [self hudDissmiss];
    } failure:^(NSError *error) {
        [self hudDissmiss];
    }];
}

- (void)parsingOrgDic:(NSArray *)dataArray{
    [self.orgArray removeAllObjects];
    if (![dataArray isKindOfClass:[NSArray class]]) {
        return;
    }
    _orgShowTableView.alpha = 1.0;
    for (NSDictionary *tempDic in dataArray) {
        MapNearOrgModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"MapNearOrgModel" inManagedObjectContext:self.djCoreDataManager.managedObjectContext];
        for (NSString *key in tempDic) {
            [model setValue:tempDic[key] forKey:key];
        }
        [self.orgArray addObject:model];
    }
            NSMutableArray *locationArray = [NSMutableArray array];
            for (int i = 0; i < self.orgArray.count; i ++) {
                MapNearOrgModel *model = self.orgArray[i];
                NSDictionary  *tempDic = _orgArray[i];
                DJPointAnnotation *point = [[DJPointAnnotation alloc] init];
                CLLocationCoordinate2D coor;
                coor.latitude = [model.lat floatValue];
                coor.longitude = [model.lon floatValue];
                point.coordinate = coor;
                point.orgName = model.name;
                [locationArray addObject:point];
            }
            //向地图添加标注
    [self.mapView addAnnotations:locationArray];
    [self.orgShowTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser {
    NSLog(@"start locate");
}
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation];
}
#pragma mark  *地图区域改变完成后会调用此接口
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//    [_locService stopUserLocationService];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:_latitudeStr.floatValue longitude:_longtitudeStr.floatValue];
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    NSLog(@"(_longtitudeStr%@ _latitudeStr%@) location1.lon%f  location1.lat%f ", _longtitudeStr, _latitudeStr, mapView.centerCoordinate.longitude, mapView.centerCoordinate.latitude);
    _longtitudeStr =   [NSString stringWithFormat:@"%f", mapView.centerCoordinate.longitude];
    _latitudeStr =   [NSString stringWithFormat:@"%f", mapView.centerCoordinate.latitude];
    
    if (distance < 10 ) {
        return;
    }
    if (![CommonUtil isOpenPosition]) {
        return;
    }
    
    
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.orgShowTableView.frame = CGRectMake(0, kScreenHeight-50-kTabbarSafeBottomMargin, kScreenWidth, 50+kTabbarSafeBottomMargin);
    } completion:^(BOOL finished) {
        [self touchManagement:0];
        [self requestSideOrg];
    }];
}
/**
 *点中底图空白处会回调此接口
 *@param mapView 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    [UIView animateWithDuration:0.4 animations:^{
        self.orgShowTableView.frame = CGRectMake(0, kScreenHeight-50-kTabbarSafeBottomMargin, kScreenWidth, 50+kTabbarSafeBottomMargin);
    } completion:^(BOOL finished) {
        [self touchManagement:0];
    }];
    
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    MyLocation= userLocation.location.coordinate;
    if (isBackMyLocation) {
        isBackMyLocation = NO;
        [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    }
    if ([_longtitudeStr isEmpty]) {
        _longtitudeStr =   [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
        _latitudeStr =   [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
        [self touchManagement:0];
        [self requestSideOrg];
    }
    [_LocationSharingBtn setImage:[UIImage imageNamed:@"DJ_sbzz_wzgx"] forState:(UIControlStateNormal)];
    [_LocationSharingBtn setImage:[UIImage imageNamed:@"DJ_sbzz_wzgx"] forState:(UIControlStateHighlighted)];
    [_positioningBtn setImage:[UIImage imageNamed:@"DJ_sbzz_myLocation"] forState:(UIControlStateNormal)];
    [_positioningBtn setImage:[UIImage imageNamed:@"DJ_sbzz_myLocation"] forState:(UIControlStateHighlighted)];
  
//    [_mapView updateLocationData:userLocation];
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser {
    NSLog(@"stop locate");
}
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    [self.positioningBtn setImage:[UIImage imageNamed:@"DJ_sbzz_myLocation_ban"] forState:(UIControlStateNormal)];
    [self.positioningBtn setImage:[UIImage imageNamed:@"DJ_sbzz_myLocation_ban"] forState:(UIControlStateHighlighted)];
    [self.LocationSharingBtn setImage:[UIImage imageNamed:@"DJ_sbzz_wzgx_ban"] forState:(UIControlStateNormal)];
    [self.LocationSharingBtn setImage:[UIImage imageNamed:@"DJ_sbzz_wzgx_ban"] forState:(UIControlStateHighlighted)];
    NSLog(@"location error");
}

#pragma mark == DJmitationWeChatSearchBoxVIewDelegate
/**
 开始搜索..
 */
- (void)BeginYourSearch {

}

/**
 结束搜索
 */
-(void)endSearch {

}

/**
 搜索进行网络请求
 */
- (void)searchNetworkRequest {
    
    
}
#pragma mark implement BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
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
    annotationView.image = [UIImage imageNamed:@"DJ_party_Icon"];
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    UIImageView *areaPaoView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 154, 40)];
    areaPaoView.image = [UIImage imageNamed:@"DJMapOrgNameBackground"];
    DJPointAnnotation *DJAnnotation = annotation;
    UILabel * pointName = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 154, 30)];
    pointName.text = DJAnnotation.orgName;
    pointName.textColor = [UIColor whiteColor];
    pointName.font = MFont(kFit(14));
    pointName.textAlignment = NSTextAlignmentCenter;
    [areaPaoView addSubview:pointName];
    BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:areaPaoView];
    annotationView.paopaoView= paopao;
    return annotationView;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    if (![view.annotation isKindOfClass:[DJPointAnnotation class]]) {
        return;
    }
    DJPointAnnotation *DJannotation = view.annotation;
    MapNearOrgModel *selectedModel;
   
    for (int i = 0; i < self.orgArray.count; i ++) {
        MapNearOrgModel *model = self.orgArray[i];
        if ([model.name isEqualToString:DJannotation.orgName]) {
            selectedModel = model;
            break;
        }
    }
    orgShowViewState = 2;
    [self touchManagement:2];
    selectedOrgModel = selectedModel;
    [self.orgShowTableView reloadData];
    [UIView animateWithDuration:0.4 animations:^{
        self.orgShowTableView.frame = CGRectMake(0, kScreenHeight-kFit(151)-kTabbarSafeBottomMargin, kScreenWidth, kFit(151)+kTabbarSafeBottomMargin);
    }];
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    NSLog(@"didAddAnnotationViews");
}
#pragma mark  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (orgShowViewState == 0) {//刚进来隐藏
        return 1;
    }else if (orgShowViewState == 1) {//展开
        return self.orgArray.count;
    }else {//展示一个组织
        return 2;
    }
}

- (void)handleOpenList {
    [self touchManagement:1];
}
//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (orgShowViewState == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        UILabel *textLabel = [UILabel new];
        textLabel.textAlignment = 1;
        textLabel.textColor = kColorRGB(251, 85, 64, 1);
        textLabel.font = MFont(kFit(15));
        textLabel.backgroundColor = [UIColor whiteColor];
        textLabel.text = [NSString stringWithFormat:@"附近共%ld个组织", self.orgArray.count];
        
        UIButton *titleBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [titleBtn setTitle:[NSString stringWithFormat:@"附近共%ld个组织", self.orgArray.count] forState:(UIControlStateNormal)];
        [titleBtn setTitleColor:kColorRGB(251, 85, 64, 1) forState:(UIControlStateNormal)];
        titleBtn.backgroundColor = [UIColor whiteColor];
        titleBtn.titleLabel.font = MFont(kFit(15));
        [titleBtn addTarget:self action:@selector(handleOpenList) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contentView addSubview:titleBtn];
        titleBtn.sd_layout.leftSpaceToView(cell.contentView, 0).topSpaceToView(cell.contentView, 0).rightSpaceToView(cell.contentView, 0).bottomSpaceToView(cell.contentView, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(orgShowViewState == 1){
        DJMapOrgShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJMapOrgShowTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        MapNearOrgModel *model = self.orgArray[indexPath.row];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.orgName.text = model.name;
        cell.phoneLabel.hidden = YES;
        cell.orgLocationLabel.text = model.address;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        
        if (indexPath.row == 0) {
            DJMapOrgShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DJMapOrgShowTableViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.orgName.text =selectedOrgModel.name;
            cell.orgLocationLabel.text = selectedOrgModel.address;
            cell.phoneLabel.text = [NSString stringWithFormat:@"联系方式: %@", selectedOrgModel.tel] ;
            cell.phoneLabel.hidden = NO;
            cell.phoneStr =selectedOrgModel.tel;
            return cell;
        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *textLabel = [UILabel new];
            textLabel.textAlignment = 1;
            textLabel.textColor = kColorRGB(251, 85, 64, 1);
            textLabel.font = MFont(kFit(15));
            textLabel.backgroundColor = [UIColor whiteColor];
            textLabel.text = [NSString stringWithFormat:@"附近共%ld个组织", self.orgArray.count];
            UIButton *titleBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [titleBtn setTitle:[NSString stringWithFormat:@"附近共%ld个组织", self.orgArray.count] forState:(UIControlStateNormal)];
            [titleBtn setTitleColor:kColorRGB(251, 85, 64, 1) forState:(UIControlStateNormal)];
            titleBtn.backgroundColor = [UIColor whiteColor];
            titleBtn.titleLabel.font = MFont(kFit(15));
            [titleBtn addTarget:self action:@selector(handleOpenList) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.contentView addSubview:titleBtn];
            titleBtn.sd_layout.leftSpaceToView(cell.contentView, 0).topSpaceToView(cell.contentView, 0).rightSpaceToView(cell.contentView, 0).bottomSpaceToView(cell.contentView, 0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (orgShowViewState == 0) {
        [self touchManagement:1];
    }else if(orgShowViewState == 1){
        [self touchManagement:2];
        MapNearOrgModel *model = self.orgArray[indexPath.row];
        selectedOrgModel = model;
        CLLocationCoordinate2D coor;
        coor.latitude = [model.lat floatValue];
        coor.longitude = [model.lon floatValue];
        DJPointAnnotation *pointAnnotation = [[DJPointAnnotation alloc]init];
        pointAnnotation.coordinate = coor;
        pointAnnotation.orgName = model.name;
        [_mapView selectAnnotation:_mapView.annotations[indexPath.row] animated:YES];
    }else {
        if (indexPath.row == 1) {
            orgShowViewState = 1;
            [self touchManagement:1];
            [self.orgShowTableView reloadData];
            [UIView animateWithDuration:0.4 animations:^{
                self.orgShowTableView.frame = CGRectMake(0, kScreenHeight-kFit(320)-kTabbarSafeBottomMargin, kScreenWidth, kFit(320)+kTabbarSafeBottomMargin);
            }];
            
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (orgShowViewState == 0) {//刚进来隐藏
        return 50;
    }else if (orgShowViewState == 1){
        return 81;
    }else {
        if (indexPath.row == 0) {
            return kFit(101);
        }else {
            return kFit(50);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
    return footerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidLayoutSubviews{
    if ([_orgShowTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_orgShowTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_orgShowTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_orgShowTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    viewSliding = YES;
    
}

#pragma DJMapOrgShowTableViewCellDelegate

- (void)navigationGoToOrg:(NSIndexPath *)indexPath {
    
    
    MapNearOrgModel *model = self.orgArray[indexPath.row];
    

    NSString * modeBaiDu = @"driving";

    NSString *url = [[NSString stringWithFormat:@"baidumap://map/direction?destination=%@,%@&mode=%@&src=ios.上海睿民.杭州党建责任 ",model.lat,model.lon,modeBaiDu] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])// -- 使用 canOpenURL 判断需要在info.plist 的 LSApplicationQueriesSchemes 添加 baidumap 。
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"您没有安装百度地图" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //首先在顶部下拉了 --- 再则 tableVIew的Y要大于默认位置 说明tablevire 已经移动过了
    int Y = (int)(self.orgShowTableView.mj_y);
    int height = (int)( kScreenHeight -kFit(320) - kTabbarSafeBottomMargin);
    NSLog(@"啦啦啦啦啦%f",self.orgShowTableView.contentOffset.y);
    NSLog(@" Y = %d  height=%d",  Y, height);
    if (self.orgShowTableView.contentOffset.y < 0 || Y> height) {
        //如果移动过程中., tablevie的Y小于默认位置那么吧Y值设置Wie默认位置
        if ( Y+1< height) {
            CGRect frame =  self.orgShowTableView.frame;
            frame.origin.y = kScreenHeight -kFit(320) - kTabbarSafeBottomMargin;
            self.orgShowTableView.frame = frame;
        }else {
            if (viewSliding) {
                CGRect frame =  self.orgShowTableView.frame;
                frame.origin.y -= self.orgShowTableView.contentOffset.y;
                self.orgShowTableView.frame = frame;
                [self.orgShowTableView setContentOffset:CGPointZero];
                if (self.orgShowTableView.mj_y < kScreenHeight - self.orgShowTableView.height) {
                    frame.origin.y = kScreenHeight - self.orgShowTableView.height;
                    self.orgShowTableView.frame = frame;
                }
            }
        }
    }
    
    if (self.orgShowTableView.contentOffset.y <= 0) {
        self.orgShowTableView.bounces = YES;
        [self.orgShowTableView setContentOffset:CGPointZero];
    }else if (self.orgShowTableView.contentOffset.y >= 0){
//        self.orgShowTableView.bounces = NO;
    }
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidZoom%f",scrollView.origin.y);
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    NSLog(@"scrollViewDidScrollToTop%f",scrollView.origin.y);
    
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat tvHeight = kScreenHeight - self.orgShowTableView.mj_y;
    
    if (tvHeight >= kFit(320)+kTabbarSafeBottomMargin-81) {//kFit(320)+kTabbarSafeBottomMargin-81 理解为tableview的高度 - 一个cell的高度 如果低于这个高度就关闭
        if (self.orgShowTableView.contentOffset.y == 0) {
            [self touchManagement:1];
        }
        
    }else {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.orgShowTableView.frame = CGRectMake(0, kScreenHeight-50-kTabbarSafeBottomMargin, kScreenWidth, 50+kTabbarSafeBottomMargin);
        } completion:^(BOOL finished) {
            [self touchManagement:0];
        }];
    }
    NSLog(@"结束啦1");
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    viewSliding = NO;
    NSLog(@"结束啦2");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSLog(@"结束啦1");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"结束啦4");
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    
    NSLog(@"结束啦5");
}



- (void)touchManagement:(NSInteger)index {
    
    switch (index) {
        case 0:{//关闭
            self.orgShowTableView.scrollEnabled = NO;
            self.tableViewPanGR.enabled = YES;
            orgShowViewState = 0;
            [self.orgShowTableView reloadData];
        }
            break;
        case 1:{//打开
            orgShowViewState = 1;
            [self.orgShowTableView reloadData];
            [UIView animateWithDuration:0.4 animations:^{
                self.orgShowTableView.frame = CGRectMake(0, kScreenHeight-kFit(320)-kTabbarSafeBottomMargin, kScreenWidth, kFit(320)+kTabbarSafeBottomMargin);
            }];
            self.orgShowTableView.scrollEnabled = YES;
            self.tableViewPanGR.enabled = NO;
        }
            break;
        case 2:{//详情
            orgShowViewState = 2;
            [self.orgShowTableView reloadData];
            [UIView animateWithDuration:0.4 animations:^{
                self.orgShowTableView.frame = CGRectMake(0, kScreenHeight-kFit(151)-kTabbarSafeBottomMargin, kScreenWidth, kFit(151)+kTabbarSafeBottomMargin);
            }];
            self.orgShowTableView.scrollEnabled = NO;
            self.tableViewPanGR.enabled = YES;
        }
            break;
        default:
            break;
    }
    
    
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
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
