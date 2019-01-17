//
//  Des.h
//  MobileBank
//
//  Created by YK on 11-2-28.
//  Copyright 2011 P&C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
/**
 *暂时没有用
 */
@interface Des : NSObject {

}
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key;
@end
