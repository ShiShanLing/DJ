//
//  AppDelegate.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "AppDelegate.h"
#import "DJSidebarVC.h"
#import "DJSidebarViewController.h"
#import "DJMainViewController.h"
#import "DJNetworkStatusSingleton.h"
#import "DJBaseViewController.h"
#import <AdSupport/AdSupport.h>
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>

#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

BMKMapManager* _mapManager;
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /*
     62330136-76A2-41B3-A6E2-4F81792D3A06
     74094384-BB60-4D40-A083-1C45E258E84D
     */
    self.window.backgroundColor = [UIColor blackColor];
    [self setNotifications:launchOptions];///通知的设置
    
    //设置友盟
    [UMConfigure initWithAppkey:@"5b57ce808f4a9d41d70001ec" channel:@"App Store"];
    
    [MobClick setCrashReportEnabled:YES];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    BOOL ret = [_mapManager start:@"Syg1YUFWXquIoY5oQwflNlUfagYgwd0Y" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [DJNetworkStatusSingleton sharedNetworkStatusSingleton].isNerWork = YES;//默认网络加载状态
    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"deviceUUID%@", deviceUUID);
    [NSThread sleepForTimeInterval:1.0];//设置启动页面时间
    
    //设置图片加载
    
    [[SDImageCache sharedImageCache] setMaxMemoryCost:10];
    
    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    
    DJSidebarViewController *menuVC = [[DJSidebarViewController alloc] init];
    
    DJMainViewController *mainVC = [[DJMainViewController alloc] init];
    
    DJSidebarVC *drawer = [[DJSidebarVC alloc] initWithLeftViewController:menuVC
                                                     centerViewController:mainVC];
    self.window.rootViewController = drawer;
    [self.window makeKeyAndVisible];
    //设置全局状态栏字体颜色为黑色
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"有网");
            [DJNetworkStatusSingleton sharedNetworkStatusSingleton].isNerWork = YES;
            NSNotification * notification = [NSNotification notificationWithName:@"Network changes" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else {
            [DJNetworkStatusSingleton sharedNetworkStatusSingleton].isNerWork = NO;
            NSLog(@"没有网");
        }
    }];

    
    NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [self AccordingPushContentJumpInterface:pushNotificationKey];
    return YES;
    
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSLog(@"deviceToken%@", deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    
}

- (void)networkDidLogin:(NSNotification*)notification {
    NSLog(@"已登录");
    
    NSString *registrationIDStr = [JPUSHService registrationID];
    
    if(![CommonUtil isEmpty:registrationIDStr]){
        
        [DJUserTool setRegistrationID:registrationIDStr];
        NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [JPUSHService setAlias:udid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"iAlias%@", iAlias);
        } seq:0];
        [self RegisteredPush];
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
}





- (void)RegisteredPush {

    NSMutableDictionary *tempDic  = [NSMutableDictionary dictionary];
    [tempDic setObject:[DJUserTool  getRegistID] forKey:@"registId"];
    [tempDic setObject:[DJUserTool getUserPhone] forKey:@"tel"];
    NSLog(@"tempDic%@", tempDic);
    DJBaseViewController *VC = [[DJBaseViewController alloc] init];
    [VC  getJSONDataWithUrl:kURL_RegisteredPush parameters:tempDic success:^(id responseObject) {
        NSLog(@"RegisteredPush%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [DJUserTool setJPushRegState:@"YES"];
        }else {
            [DJUserTool setJPushRegState:@"NO"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
}


- (void)networkDidReceiveMessage:(NSNotification*)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    NSLog(@"content%@ messageID%@ extras%@ customizeField1%@", content, messageID, extras, customizeField1);
}

- (void)setNotifications:(NSDictionary *)launchOptions {
    
    NSLog(@"[DJUserTool getRegistID]%@", [DJUserTool getRegistID] );
    NSString *RegistID = [NSString stringWithFormat:@"%@", [DJUserTool  getRegistID]];
    
    if ([[DJUserTool getRegistID] isEmpty] || [RegistID isEqualToString:@"(null)"]) {//如果 RegistrationID 是空的, 那么就检测极光登录状态登录的话保存RegistrationID 并向后台注册
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                          selector:@selector(networkDidLogin:)
         
                              name:kJPFNetworkDidLoginNotification
         
                            object:nil];
    }

    
    NSNotificationCenter *receiveMessageCenter = [NSNotificationCenter defaultCenter];
    [receiveMessageCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {//点击远程通知启动
//        [self performSelector:@selector(delayPush:) withObject:remoteNotification/*可传任意类型参数*/ afterDelay:3.0];
    }
   
    
}
#pragma mark iOS7-IOS10之后 收到通知 会走下面的方法：
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSLog(@"userInfo%@  [[[UIDevice currentDevice] systemVersion] intValue]%d", userInfo,  [[[UIDevice currentDevice] systemVersion] intValue]);
    if (application.applicationState == UIApplicationStateActive && [[[UIDevice currentDevice] systemVersion] intValue] < 10) {
        
        id  temp = userInfo[@"aps"][@"alert"];
        
        if ([temp isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        UIWindow  *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        alertWindow.rootViewController = [[UIViewController alloc] init];
        
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        
        [alertWindow makeKeyAndVisible];
        
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"新消息" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* updateAction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self AccordingPushContentJumpInterface:userInfo];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertvc addAction:cancelAction];
        [alertvc addAction:updateAction];
        
        [alertWindow.rootViewController presentViewController:alertvc animated:YES completion:nil];
        [JPUSHService setBadge:0];//清空JPush服务器中存储的badge值
        [self resetBageNumber];
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    int badge =[userInfo[@"aps"][@"badge"] intValue];
    [self resetBageNumber];
    [JPUSHService setBadge:0];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self resetBageNumber];
    [JPUSHService setBadge:0];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
[self resetBageNumber];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"PartyConstructPlus"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark -------------------- JPUSHRegisterDelegate ------------------------
/*
 1.接收到通知会走这个方法
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    
//    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

    }
    else {
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

#pragma mark  点击通知会走这个方法  -JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [JPUSHService setBadge:+1];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self AccordingPushContentJumpInterface:userInfo];
    } else {
        // 判断为本地通知
    }
    completionHandler();  // 系统要求执行这个方法
}

//根据推送内容跳转界面
- (void)AccordingPushContentJumpInterface:(NSDictionary *)pushDic {
    
    if (pushDic == NULL) {
        return;
    }
    //因为设计的原因 主界面和侧拉栏使用的 UINavigationController (只能使用)  而其它界面使用了 UIViewController
    if ([[CommonUtil getCurrentVC] isKindOfClass:[DJMainViewController class]] || [[CommonUtil getCurrentVC] isKindOfClass:[DJSidebarViewController class]] ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"presentPushMsg" object:pushDic];//需要模态进入通知需要的界面
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushPushMsg" object:pushDic];
    }
}

-(void)resetBageNumber{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 11.0){
        /*
         iOS 11后，直接设置badgeNumber = -1就生效了
         */
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    }else{
        UILocalNotification *clearEpisodeNotification = [[UILocalNotification alloc] init];
        clearEpisodeNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(0.3)];
        clearEpisodeNotification.timeZone = [NSTimeZone defaultTimeZone];
        clearEpisodeNotification.applicationIconBadgeNumber = -1;
        [[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];
    }
}

//警告
-(void)ShowWarningHudMid:(NSString *)message {
    UIWindow  *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    alertWindow.rootViewController = [[UIViewController alloc] init];
    
    alertWindow.windowLevel = UIWindowLevelAlert + 1;
    
    [alertWindow makeKeyAndVisible];
    
    //初始化弹窗口控制器
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    //显示弹出框
    
    [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];

}

@end
