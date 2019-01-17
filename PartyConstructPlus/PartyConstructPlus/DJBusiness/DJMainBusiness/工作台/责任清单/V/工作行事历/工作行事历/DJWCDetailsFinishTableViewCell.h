//
//  DJWCDetailsFinishTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DJWCDetailsFinishTableViewCell;
@protocol DJWCDetailsFinishTableViewCellDelegate <NSObject>

- (void)ClickImageIndex:(NSInteger)index  cell:(DJWCDetailsFinishTableViewCell*)cell;

@end

/**
 工作行事历详情界面已经完成的cell
 */
@interface DJWCDetailsFinishTableViewCell : UITableViewCell

/**
 *内容
 */
@property (nonatomic, strong)UILabel * contentLabel;
/**
 *时间
 */
@property (nonatomic, strong)UILabel * timeLabel;
/**
 *展示图片的view
 */
@property (nonatomic, strong)UIView * imageShowView;
/**
 *model
 */
@property (nonatomic, strong)AgendaWorkingCalendarListModel * model;
/**
 *
 */
@property (nonatomic, assign)id<DJWCDetailsFinishTableViewCellDelegate> delegate;
@end
