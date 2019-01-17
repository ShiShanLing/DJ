//
//  DJmitationWeChatSearchBoxVIew.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/6.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJmitationWeChatSearchBoxVIewDelegate <NSObject>

/**
 开始搜索操作
 */
- (void)BeginYourSearch;

/**
 结束搜索操作
 */
-(void)endSearch;

/**
 搜索进行网络请求
 */
- (void)searchNetworkRequest;
@end

/**
 模仿微信搜索框
 */
@interface DJmitationWeChatSearchBoxVIew : UIView <UITextFieldDelegate>

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
 *0 用户名搜索 1 组织搜索 2履历说明说 3述职评议
 */
@property (nonatomic, assign)NSInteger searchType;
/**
 *搜索框代理
 */
@property (nonatomic, assign)id<DJmitationWeChatSearchBoxVIewDelegate> delegate;

@end
