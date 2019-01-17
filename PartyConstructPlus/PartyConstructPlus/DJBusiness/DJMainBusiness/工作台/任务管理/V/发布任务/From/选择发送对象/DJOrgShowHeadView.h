//
//  DJOrgShowHeadView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/8.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJOrgShowHeadViewDelegate <NSObject>

/**
 组织名字点击方法

 @param index  12345 代表组织等级
 */
- (void)OrgNameClick:(NSInteger)index;

@end

@interface DJOrgShowHeadView : UIView

- (void)protocolIsSelect:(NSArray *)strArray;
/**
 *组织名字点击 返回上层组织使用
 */
@property (nonatomic, assign)id<DJOrgShowHeadViewDelegate> delegate;
@end
