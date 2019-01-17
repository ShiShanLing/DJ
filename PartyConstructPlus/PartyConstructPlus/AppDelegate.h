//
//  AppDelegate.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
static NSString *appKey = @"fa35ee71cce126521d2a6f47";
//static NSString *appKey = @"bff39ab5632c42790ce8de16"; //测试App使用
static NSString *channel = @"";
//static NSString *channel = @"App Store";
static BOOL isProduction = YES;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

