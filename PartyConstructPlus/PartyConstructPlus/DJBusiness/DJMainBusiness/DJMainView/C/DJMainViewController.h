//
//  DJMainViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/24.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJBaseNavigationController.h"
#import "DJSidebarVC.h"
/**
 主界面
 */
@interface DJMainViewController : DJBaseNavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting>

@property (nonatomic, weak)DJSidebarVC *drawer;

@end
