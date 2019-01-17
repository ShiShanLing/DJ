//
//  DJSJFXTypeChooseView.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/9/13.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAttButton.h"
@protocol DJSJFXTypeChooseViewDelegate <NSObject>

- (void)ChooseDataType:(NSInteger)index;


@end

@interface DJSJFXTypeChooseView : UIView
@property (weak, nonatomic) id<DJSJFXTypeChooseViewDelegate>delegate;

@property (strong, nonatomic) NSArray * data;

@property (assign, nonatomic) NSInteger index;
/**
 *cell分割线
 */
@property (nonatomic, strong)UILabel *dividerLabel ;

- (instancetype)initWithFrame:(CGRect)frame buttonData:(NSArray *)data withType:(NSString *)type;
@end
