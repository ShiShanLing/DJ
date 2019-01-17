//
//  DJOrgChooseView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/23.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJOrgChooseViewDelegate <NSObject>

- (void)confirmChoicesOrg:(OrgInfoModel *)model;

@end

@interface DJOrgChooseView : UIView
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * modelArray;

/**
 *
 */
@property (nonatomic, assign)id<DJOrgChooseViewDelegate> delegate;

@end
