//
//  DJMonthTranscriptTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/26.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 月成绩单展示
 */
@interface DJMonthTranscriptTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *  contentLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * timeLabel;
/**
 *
 */
@property (nonatomic, strong)UILabel * integralLabel;
@end
