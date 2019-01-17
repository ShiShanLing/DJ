//
//  DJStarsCommentsView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJStarsCommentsView;

@protocol DJStarsCommentsViewDelegate <NSObject>

- (void)UserschangeCheck:(NSInteger)count;

@end

@interface DJStarsCommentsView : UIView
/**
 *
 */
@property (nonatomic, assign)NSInteger  starsNum;


-(instancetype)initStarsViewWithFrame:(CGRect)frame;

//设置展示分数
- (void)checkCount:(NSInteger)index;

/**
 *
 */
@property (nonatomic, assign)BOOL userGestureInteractionEnabled;
/**
 *DJStarsCommentsViewDelegate
 */
@property (nonatomic, assign)id<DJStarsCommentsViewDelegate> delegate;
@end
