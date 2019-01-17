//
//  DJOrgSearchView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJOrgSearchViewDelegate <NSObject>

- (void)viewResponse;

/**
 搜索的类型转换

 @param type 0 用户姓名搜索  组织名字搜索
 */
- (void)SearchType:(NSInteger)type;

/**
 选择的用户信息发生了变化

 @param model 组织model  现在要做的  A吧记录的所有的数据 告诉B  B拿着A的数据和刚获取的数据作对比,如果A记录的数据里面有刚刚搜索的数据那么就拿出旧数据 覆盖掉刚刚搜索的 并展示出来  如果用户操作了B界面的数据  吧B界面的数据变化告诉A  A在记录了B的变化之后 再通知B我已经记录了这次操作  这时B再刷新界面    历史搜索.如果,searchDataArray为空说明用户还未进行搜索 那么需要展示历史搜索 根据所选择的搜索类型
 */

/**
 组织信息发生变化(改变搜索到的组织人员状态)

 @param orgModel 操作的组织
 */
- (void)orgInfoChange:(LowerOrgModel *)orgModel;

/**
 人员信息发生变化

 @param userModel 操作的人员
 @param orgAlUserArray 人员所在的组织里面的所有人员
 */
- (void)userInfoChange:(LowerOrgUserModel *)userModel orgAlUser:(NSArray *)orgAlUserArray;

/**
 快捷搜索(点击历史搜索关键字)

 @param searchStr 搜索关键字
 */
- (void)QuickSearch:(NSString *)searchStr;


@end

/**
 组织和用户信息搜索结果展示界面
 */
@interface DJOrgSearchView : UIView

/**
 *
 */
@property (nonatomic, assign)id<DJOrgSearchViewDelegate> delegate;
/**
 *
 */
@property (nonatomic, strong)NSString *searchStr;
/**
 *组织ID
 */
@property (nonatomic, strong)NSString * orgId;
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * searchDataArray;
/**
 *
 */
@property (nonatomic, assign)NSUInteger searchType;
/**
 *目前存储的所有的组织信息
 */
@property (nonatomic, strong)NSMutableArray * allOrgDataArray;
@end
