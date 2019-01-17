//
//  DJdjDutyFunctionTVCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MsgView;
/**
 党建责任界面的cell
 */
@interface DJdjDutyFunctionTVCell : UITableViewCell
/**
 *
 */
@property (nonatomic, strong)UILabel * titleLabel;
/**
 *46 X 46
 */
@property (nonatomic, strong)UIButton  *showImageBtn;
/**
 *
 */
@property (nonatomic, strong)MsgView *redView;

- (void)ChangeLayout;

@end
