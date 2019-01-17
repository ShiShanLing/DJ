//
//  AddAttButton.h
//  PartyConstruct
//
//  Created by 石山岭 on 2018/2/1.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *给UIButton添加属性 来实现一些羞羞的功能
 */
@interface AddAttButton : UIButton
/**
 *下拉菜单中UIButton的selected值 已经用作判断更换图片了(特殊原因)和文字颜色了  还需要一个bool来判断点击状态 作用类似于UIButton的selected (默认没有被点击NO(弹窗隐藏) 点击之后YES(弹窗出现))
 */
@property (nonatomic, assign)BOOL ClickClicking;

@end
