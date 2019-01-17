//
//  KeyChainStore.h
//  PartyConstruct
//
//  Created by 廖锦锐 on 2016/10/26.
//  Copyright © 2016年 廖锦锐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject


+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)deleteKeyData:(NSString *)service;

@end
