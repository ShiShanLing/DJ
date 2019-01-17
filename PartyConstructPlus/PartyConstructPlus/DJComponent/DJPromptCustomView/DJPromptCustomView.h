//
//  DJPromptCustomView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/31.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJPromptCustomView : UIView

/**
 *
 */
@property (nonatomic, strong) UILabel *promptLabel;
/**
 *承载label的view
 */
@property (nonatomic, strong) UIView *bezelView;
/**
 *
 */
@property (nonatomic, strong)UIView * backgroundView;

@end
