//
//  DJBaseViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJCoreDataManager;
#import "DJCoreDataManager.h"
#import "DJLoadFailedView.h"
typedef void (^DJSuccessResponseBlock)(id responseObject);
typedef void (^DJFailResponseBlock)(NSError* error);

typedef void (^ReturnButtonBlock) (NSString *strValue);

typedef void (^ImageUpload) (NSString * imageUrl);
typedef void (^proceResults) (BOOL  results);
@interface DJBaseViewController : UIViewController

@property(nonatomic, strong)DJCoreDataManager *djCoreDataManager;
/**
 *公用的返回按钮
 */
@property (nonatomic, strong)UIBarButtonItem *returnButtonItem;

@property(nonatomic, copy) ReturnButtonBlock returnClickBlock;
/**
 *空白界面
 */
@property (nonatomic, strong)DJDataEmptyView * dataEmptyView;
/**
 *网络请求失败界面
 */
@property (nonatomic, strong)DJLoadFailedView * networkRequestFailedView;

-(void)getJSONDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(DJSuccessResponseBlock)success failure:(DJFailResponseBlock)failure;

//页面跳转
- (void)pushViewControllerAccordingUrl:(NSString *)url;//根据URL跳转至某一页面
-(void)pushToNextViewController:(UIViewController *)viewController;//跳转下一页面
-(void)presentToNextViewController:(UIViewController *)viewController;//跳转下一页面
-(void)backView;//返回上一页面
-(void)backToRootView;//返回根页面
-(void)backToIndexView:(int)index;//返回到指定页面
#pragma mark -去除tableview多余线
-(void)setExtraCellLineHidden:(UITableView *)tableView;
#pragma mark -警告hud
-(void)hudDissmiss;
-(void)ShowWarningHud:(NSString *)message;
- (void)showHud:(NSString *)message title:(NSString *)title;
-(void)ShowWarningHudMid:(NSString *)message;
- (void)userLogIn;

- (void)showAlert:(NSString *) _message time:(CGFloat)time;
//查询实体类
- (NSArray *)queryModel:(NSString *)modelName;
- (void)deleteModel :(NSString *)modelStr;//删除实体类
//上传图片
- (void)ImageUpload:(UIImage *)image results:(ImageUpload)results;
//创建一个滑动视图
- (void)setFullScreenImageShow:(NSArray *)imageArray  defaultIndex:(NSInteger)index;
//刷新个人数据
- (void)refreshUserInfo:(proceResults)results;
//获取当前默认的组织
- (OrgInfoModel *)getDefaultOrg;
/**
 清除存储的数据
 @param modelStr 实体类的名字
 */
///- (void)deleteModel :(NSString *)modelStr;
@end
