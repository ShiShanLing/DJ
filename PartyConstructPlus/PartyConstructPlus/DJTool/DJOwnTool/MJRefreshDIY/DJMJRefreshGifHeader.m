//
//  DJMJRefreshGifHeader.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJMJRefreshGifHeader.h"

@implementation DJMJRefreshGifHeader

- (void)prepare
{
    [super prepare];
    
    
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 1; i<21; i++) {
        @autoreleasepool {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loadIn%d", i]];
        [idleImages addObject:image];
        }
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<2; i++) {
        @autoreleasepool {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loadIn%d", i]];
        [refreshingImages addObject:image];
        }
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self  setImages:idleImages duration:1 forState:MJRefreshStateRefreshing];
}

@end
