//
//  DJNoticePromptTVCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJNoticePromptTVCell : UITableViewCell
/**
 对应的icon
 */
@property (nonatomic, strong)UIButton *iconBtn;
/**
 *对应的标题
 */
@property (nonatomic, strong)UILabel * titleLabel;

/**
 对应的副标题
 */
@property (nonatomic, strong)UILabel * subtitleLabel;
/**
 *对应的提示语
 */
@property (nonatomic, strong)UILabel * timetLabel;
/**
 *红点lalbel;
 */
@property (nonatomic, strong)UILabel * redPointLabel;

@end
