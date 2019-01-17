//
//  SMKSFPopoverAction.m
//  下拉菜单
//
//  Created by 石山岭 on 2018/3/21.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "SMKSFPopoverAction.h"
@interface SMKSFPopoverAction ()

@property (nonatomic, strong, readwrite) UIImage *image; ///< 图标
@property (nonatomic, copy, readwrite) NSString *title; ///< 标题
@property (nonatomic, copy, readwrite) void(^handler)(SMKSFPopoverAction *action); ///< 选择回调

@end
@implementation SMKSFPopoverAction
+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(SMKSFPopoverAction *action))handler {
    return [self actionWithImage:nil title:title handler:handler];
}

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(SMKSFPopoverAction *action))handler {
    SMKSFPopoverAction *action = [[self alloc] init];
    action.image = image;
    action.title = title ? : @"";
    action.handler = handler ? : NULL;
    
    return action;
}
@end
