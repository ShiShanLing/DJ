//
//  DJTaskEvaluationTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/15.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJTaskEvaluationTableViewCellDelegate <NSObject>

- (void)EvaluationContentChange:(NSString *)str;

/**
 界面样式发生改变

 @param index  1-5 变高 0 变低 但是这个方法只要调用 基本不可能是0了
 */
- (void)InterfaceStyle:(NSInteger)index;

@end

//任务评价--和评论不同
@interface DJTaskEvaluationTableViewCell : UITableViewCell
/**
 *
 */
@property (nonatomic, strong)UITextView * contentTV;
/**
 *DJTaskEvaluationTableViewCellDelegate
 */
@property (nonatomic, assign)id<DJTaskEvaluationTableViewCellDelegate> delegate;

/**
 *
 */
@property (nonatomic, strong)NSString *promptCopywriting;
@end
