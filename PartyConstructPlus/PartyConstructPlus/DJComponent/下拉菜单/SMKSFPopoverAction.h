//
//  SMKSFPopoverAction.h
//  下拉菜单
//
//  Created by 石山岭 on 2018/3/21.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PopoverViewStyle) {
    PopoverViewStyleDefault = 0, // 默认风格, 白色
    PopoverViewStyleDark, // 黑色风格
    PopoverViewStyleDarkTranslucent,//黑色半透明
};
@interface SMKSFPopoverAction : NSObject

@property (nonatomic, strong, readonly) UIImage *image; ///< 图标 (建议使用 60pix*60pix 的图片)
@property (nonatomic, copy, readonly) NSString *title; ///< 标题
@property (nonatomic, copy, readonly) void(^handler)(SMKSFPopoverAction *action); ///< 选择回调, 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(SMKSFPopoverAction *action))handler;

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(SMKSFPopoverAction *action))handler;

@end
