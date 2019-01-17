//
//  DJTaskContentEditorTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/17.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJTaskContentEditorTableViewCellCellDelegate <NSObject>

- (void)taskContentChange:(NSString *)nameStr;

@end

/**
 任务发布  之 任务的内容
 */
@interface DJTaskContentEditorTableViewCell : UITableViewCell
/**
 *
 */
@property (nonatomic, assign)id<DJTaskContentEditorTableViewCellCellDelegate> delegate;

@property (nonatomic, strong)UITextView *taskContentTV;

@property (nonatomic, strong)NSString *promptCopywriting;
/**
 *cell分割线
 */
@property (nonatomic, strong)UILabel *dividerLabel ;
@end
