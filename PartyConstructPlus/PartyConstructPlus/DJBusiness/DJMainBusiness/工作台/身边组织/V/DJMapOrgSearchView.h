//
//  DJMapOrgSearchView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/24.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DJMapOrgSearchViewDelegate <NSObject>
/**
 结束搜索操作
 */
-(void)endSearch;

/**
 搜索进行网络请求
 */
- (void)searchNetworkRequest;
/**
 实时搜索
 */
- (void)RealTimeSearch:(NSString *)str;

@end

@interface DJMapOrgSearchView : UIView <UITextFieldDelegate>

/**
 *默认状态搜索框
 */
@property (nonatomic, strong)UIButton * defaultStateBtn;
/**
 *取消按钮
 */
@property (nonatomic, strong)UIButton * cancelBtn;
/**
 *真正的搜索框
 */
@property (nonatomic, strong)UITextField *searchTF;
/**
 *
 */
@property (nonatomic, strong)UIView * backgroundView;

/**
 *搜索框代理
 */
@property (nonatomic, assign)id<DJMapOrgSearchViewDelegate> delegate;

@end
