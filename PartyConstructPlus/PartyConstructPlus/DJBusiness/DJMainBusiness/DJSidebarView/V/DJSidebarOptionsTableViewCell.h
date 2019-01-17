//
//  DJSidebarOptionsTableViewCell.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
//侧边栏里面的单个选项
@interface DJSidebarOptionsTableViewCell : UITableViewCell
/**
 *
 */
@property (nonatomic, strong)UIButton * iconBtn;
/**
 *
 */
@property (nonatomic, strong)UILabel * titleLabel;

/**
 *
 */
@property (nonatomic, strong)NSDictionary * dataDic;

@end
