//
//  DJNetworkStatusClass.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/7/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DJNetworkStatusSingleton;

@interface DJNetworkStatusSingleton : NSObject
+(DJNetworkStatusSingleton *)sharedNetworkStatusSingleton;
/**
 *
 */
@property (nonatomic, assign)BOOL isNerWork;

@end
