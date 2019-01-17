//
//  DJTaskDetalisHeadView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/18.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJTaskDetalisHeadViewDelegate <NSObject>

- (void)toCommentTask;

@end

@interface DJTaskDetalisHeadView : UITableViewHeaderFooterView
/**
 *
 */
@property (nonatomic, strong)UILabel * titleLabel;
/**
 *
 */
@property (nonatomic, strong)UIButton  *commentsBtn;
/**
 *DJTaskDetalisHeadViewDelegate
 */
@property (nonatomic, assign)id<DJTaskDetalisHeadViewDelegate> delegate;
@end
