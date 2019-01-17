//
//  SegmentMenuView.h
//  PartyConstruct
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAttButton.h"
@protocol SegmentMenuViewDelegate <NSObject>

/**
 菜单点击事件

 @param index 点击的第几个菜单
 @param selBtn 点击的按钮
 @param tag tag值
 */
- (void) SegmentMenuViewSelectedWithIndex:(NSInteger) index slectBtn:(AddAttButton *)selBtn withTag:(NSInteger)tag;

@end

@interface SegmentMenuView : UIView

@property (weak, nonatomic) id<SegmentMenuViewDelegate>delegate;

@property (strong, nonatomic) NSArray * data;

@property (assign, nonatomic) NSInteger index;
/**
 *cell分割线
 */
@property (nonatomic, strong)UILabel *dividerLabel ;

- (instancetype)initWithFrame:(CGRect)frame buttonData:(NSArray *)data withType:(NSString *)type;

@end
