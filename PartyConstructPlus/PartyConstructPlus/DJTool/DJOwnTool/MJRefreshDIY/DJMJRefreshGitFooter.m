//
//  DJMJRefreshGitFooter.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMJRefreshGitFooter.h"

@implementation DJMJRefreshGitFooter

- (void)prepare
{
    [super prepare];
//
//    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i<21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loadIn%d", i]];
        [refreshingImages addObject:image];
    }
     [self setImages:@[refreshingImages[0]]forState:MJRefreshStateIdle];
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [self setTitle:@"页面加载中,请稍后" forState:MJRefreshStateRefreshing];
    [self setTitle:@"" forState:MJRefreshStateNoMoreData];
    
    
    
}



@end
