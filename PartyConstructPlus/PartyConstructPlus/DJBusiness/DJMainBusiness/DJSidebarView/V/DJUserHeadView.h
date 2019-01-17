//
//  DJUserHeadView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DJUserHeadViewDelegate <NSObject>

- (void)ClickUserCenter;

@end

@interface DJUserHeadView : UIView
/**
 *
 */
@property (nonatomic, strong)UIImageView * headImage;
/**
 *
 */
@property (nonatomic, strong)UIButton * nameBtn;
/**
 *
 */
@property (nonatomic, strong)UIImageView  *bottomImage;

/**
 *
 */
@property (nonatomic, assign)id<DJUserHeadViewDelegate> delegate;

@end
