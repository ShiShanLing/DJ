//
//  DJWorkingCalendarTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/14.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 工作行事历展示cell
 */
@interface DJWorkingCalendarTableViewCell : UITableViewCell

/**
 *类型
 */
@property (nonatomic, strong)UIImageView *typeImage;
/**
 *工作行事历name
 */
@property (nonatomic, strong)UILabel * CalendarsName;
/**
 *
 */
@property (nonatomic, strong)UILabel *subTitleLabel;
/**
 *
 */
@property (nonatomic, strong)UIButton * InstructionBtn;

/**
 *
 */
@property (nonatomic, strong)WorkingCalendarListModel * model;

@end
