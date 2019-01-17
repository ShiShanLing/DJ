//
//  DJSelectTaskTagViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/25.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"

typedef void(^SelectTaskTag) (NSArray *tagArray);

@interface DJSelectTaskTagViewController : DJBaseViewController

/**
 *
 */
@property (nonatomic, copy)SelectTaskTag taskTagBlock;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * defaultDataArray;

@end
