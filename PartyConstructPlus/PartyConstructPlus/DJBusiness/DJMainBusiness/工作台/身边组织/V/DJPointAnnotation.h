//
//  DJPointAnnotation.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/21.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
//#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface DJPointAnnotation : BMKPointAnnotation
/**
 *
 */
@property (nonatomic, strong)NSString * orgName;
/**
 *
 */
@property (nonatomic, strong)NSString * userId;
@end
