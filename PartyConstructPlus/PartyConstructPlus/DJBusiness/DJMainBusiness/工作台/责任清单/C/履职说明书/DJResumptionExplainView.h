//
//  DJResumptionExplainView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJResumptionExplainViewDelegate <NSObject>

- (void)searchDataChoose:(NSDictionary *)dataDic;

-(void)SearchHistoryChoose:(NSString *)string;
- (void)viewResponse;
@end
/**
 履历说明书搜索界面
 */
@interface DJResumptionExplainView : UIView
/**
 *
 */
@property (nonatomic, strong)NSMutableArray * searchDataArray;
/**
 *
 */
@property (nonatomic, assign)NSInteger  searchType;
/**
 *
 */
@property (nonatomic, assign)id<DJResumptionExplainViewDelegate> delegate;
/**
 *搜索的关键字
 */
@property (nonatomic, strong)NSString * searchStr;
@end
