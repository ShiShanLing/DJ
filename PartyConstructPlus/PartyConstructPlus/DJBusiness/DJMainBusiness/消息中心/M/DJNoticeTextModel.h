//
//  DJNoticeTextModel.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/11.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJNoticeTextModel : NSObject

/**
 *
 */
@property (nonatomic, strong)NSString * titleStr;

@property (nonatomic, strong)NSString * subtitleStr;



//下面是行事历详情使用的model

/**
 组织名字
 */
@property(nonatomic, strong)NSString *orgNameStr;
/**
 *行事历名字
 */
@property (nonatomic, strong)NSString * WCNameStr;
/**
 *类型
 */
@property (nonatomic, strong)NSString * WCTypeStr;
/**
 详情介绍
 */
@property (nonatomic, strong)NSString *WCDetailsStr;

@property (nonatomic, assign)NSInteger  imageNum;

/**
 *
 */
@property (nonatomic, strong)NSString *timeStr ;
@end
