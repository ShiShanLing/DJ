//
//  DJVersionUpdateView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DJVersionUpDataBlock)(NSInteger type);

/**
 版本更新展示的view
 */
@interface DJVersionUpdateView : UIView
/**
 *
 */
@property (nonatomic, strong)UILabel *contentLabel;
/**
 *
 */
@property (nonatomic, copy)DJVersionUpDataBlock versionUpData;

/**
 *
 */
@property (nonatomic, assign) NSInteger upDatatype;
/**
 *
 */
@property (nonatomic, strong)UIImageView *upDataImageView;
/**
 *
 */
@property (nonatomic, strong)UIButton *upDataBtn;
/**
 *
 */
@property (nonatomic, strong)UIButton *LaterUpDataBtn;
@end
