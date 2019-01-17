//
//  DJTaskNameEditorTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/17.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJTaskNameEditorTableViewCellDelegate <NSObject>

- (void)taskNameChange:(NSString *)nameStr;

@end

//任务发布 之 任务的名字
@interface DJTaskNameEditorTableViewCell : UITableViewCell

/**
 *
 */
@property (nonatomic, assign)id<DJTaskNameEditorTableViewCellDelegate> delegate;

@property (nonatomic, strong)UITextView *taskNameTV;
/**
 *
 */
@property (nonatomic, strong)NSString *promptCopywriting;
/**
 *cell分割线
 */
@property (nonatomic, strong)UILabel *dividerLabel ;
@end
