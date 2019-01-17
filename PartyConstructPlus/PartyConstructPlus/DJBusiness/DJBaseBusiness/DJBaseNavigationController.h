//
//  DJBaseNavigationController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/5/10.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJCoreDataManager;
#import "DJCoreDataManager.h"
typedef void (^DJSuccessResponseBlock)(id responseObject);
typedef void (^DJFailResponseBlock)(NSError* error);

typedef void (^ReturnButtonBlock) (NSString *strValue);

typedef void (^ImageUpload) (NSString * imageUrl);
typedef void (^proceResults) (BOOL  results);
@interface DJBaseNavigationController : UINavigationController

@property(nonatomic, strong)DJCoreDataManager *djCoreDataManager;
/**
 *公用的返回按钮
 */
@property (nonatomic, copy)UIBarButtonItem *returnButtonItem;

@property(nonatomic, copy) ReturnButtonBlock returnClickBlock;

-(void)getJSONDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(DJSuccessResponseBlock)success failure:(DJFailResponseBlock)failure;

//页面跳转
/**
 根据传进来的 url 进行跳转指定界面

 @param url  url有两种 一种是http开头.一种是app开头
 */
- (void)pushViewControllerAccordingUrl:(NSString *)url;

/**
 根据传进来的 视图 跳转到下一界面

 @param viewController 需要跳转的界面
 */
-(void)pushToNextViewController:(UIViewController *)viewController;//跳转下一页面

/**
 根据传进来的 视图 跳转到下一界面

 @param viewController 需要跳转的界面
 */
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

/**
 上传图片
 @param image 传进来的uimage对象
 @param results 返回数据的block传输的是图片URL
 */
- (void)ImageUpload:(UIImage *)image results:(ImageUpload)results;
//创建一个滑动视图
- (void)setFullScreenImageShow:(NSArray *)imageArray  defaultIndex:(NSInteger)index;
//刷新个人数据
- (void)refreshUserInfo:(proceResults)results;
//删除历史搜索
- (void)DeleteHistorySearchData;


/**
 清除存储的数据
 @param modelStr 实体类的名字
 */
///- (void)deleteModel :(NSString *)modelStr;
//获取默认组织
- (OrgInfoModel *)getDefaultOrg;
@end
