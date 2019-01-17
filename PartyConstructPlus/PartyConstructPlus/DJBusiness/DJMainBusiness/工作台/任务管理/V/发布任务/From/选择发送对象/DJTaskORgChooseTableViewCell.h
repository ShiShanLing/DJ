//
//  DJTaskORgChooseTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/6.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DJTaskORgChooseTableViewCellDelegate <NSObject>

/**
 全选组织 或者反选

 @param indexPath cell所属下标
 */
- (void)OrgChooseStateBtn:(NSIndexPath *)indexPath;

/**
 选择人员

 @param indexPath cell所属下标
 */
- (void)peopleChooseStateBtn:(NSIndexPath *)indexPath;

@end

/**
 任务发布人员选择
 */
@interface DJTaskORgChooseTableViewCell : UITableViewCell

/**
 *状态
 */
@property (nonatomic, strong)UIButton * orgChooseStateBtn;
/**
 *组织名字
 */
@property (nonatomic, strong)UILabel * orgNameLabel;
/**
 *选择人物
 */
@property (nonatomic, strong)UIButton * selectedNumStateBtn;

/**
 *指示箭头 或者分割线
 */
@property (nonatomic, strong)UIButton *arrowBtn;
/**
 *列表使用的
 */
@property (nonatomic, strong)LowerOrgModel *model;
/**
 *搜索使用的
 */
@property (nonatomic, strong)LowerOrgModel * searchOrgModel;
/**
 *记录该cell的下标
 */
@property (nonatomic, strong)NSIndexPath * indexPath;
/**
 *
 */
@property (nonatomic, assign)id<DJTaskORgChooseTableViewCellDelegate> delegate;
@end
