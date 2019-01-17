//
//  DJUserTranscriptShowHeadView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/20.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 用户成绩单展示的头部
 */
@interface DJUserTranscriptShowHeadView : UIView

/**
 *
 */
@property (nonatomic, strong)NSDictionary * dataDic;
/**
 *0 本月 1历史月 2整年的成绩 3空界面
 */
@property (nonatomic, assign)NSInteger state;
/**
 *当前排名展示
 */
@property (nonatomic, strong)UILabel * rankingLabel;

/**
 用户头像
 */
@property (nonatomic, strong)UIImageView *headImageView;
/**
 *用户name
 */
@property (nonatomic, strong)UILabel * userNameLabel;
/**
 *用户组织name
 */
@property (nonatomic, strong)UILabel * orgNameLabel;

/**
 *显示成绩所属的image
 */
@property (nonatomic, strong)UIImageView *resultsImageView;
/**
 *成绩状态
 */
@property (nonatomic, strong)UILabel * resultsState;

/**
 *cell分割线
 */
@property (nonatomic, strong)UILabel *dividerLabel ;
@end

