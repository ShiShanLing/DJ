//
//  DJSJFXOrgChooseView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/9/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DJSJFXOrgChooseViewDelegate <NSObject>
/**
 *这个方法用来告诉视图我点的是UITableView里面的第几个cell
 */
- (void)OrgChooseWithIndex:(NSInteger) index;


@end
@interface DJSJFXOrgChooseView : UIView
@property (weak, nonatomic) id<DJSJFXOrgChooseViewDelegate>Delegate;
@property (strong, nonatomic) NSArray *dataArr;

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIScrollView *tableBack;
/**
 *是否显示视图 默认是 NO 就是不显示
 */
@property(nonatomic,assign)BOOL  isConceal;


- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
