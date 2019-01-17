//
//  DJSidebarViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/24.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseNavigationController.h"
#import "DJSidebarVC.h"
/**
侧边栏
 */
@interface DJSidebarViewController : DJBaseNavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting>

@property (nonatomic, weak)DJSidebarVC *drawer;

- (void)refreshData;

@end
