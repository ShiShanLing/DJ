//
//  DJChooseMissionPersonnelViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/6.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"


typedef void(^SelectTaskReceiveUser) (NSArray *orgArray);
/**
 选择任务执行人员
 该界面逻辑比较复杂
 1.orgAllDataArray数组 吧用户请求过的所有的组织放进该数组 该数组数据不是最新的,只记录用户进入选人界面第一次请求的数据
 2.currentZOrgAndsuperOrgArray 吧当前界面的组织放进该数组  格式为 下标0为上级组织 展示的时候字体加黑,下面的是该组织的下级组织 例如23333 ,34444 该数组的数据一直是最新的
 3.currentChooseMemberTheOrg 用一个组织model记录当前操作的组织 如果用户之前操作过该组织model 那么该组织model就为旧model  该组织model的作用是,要他的组织名字和组织ID 以及上次操作的的记录(选择的用户)
    过程 <1>把请求的所有组织数据都放进orgAllDataArray数组 <2>把当前界面的数据放进 currentZOrgAndsuperOrgArray
 
 点击选择组织用户.根据点击的当前组织信息在所有的组织里面找该组织 并使用 currentChooseMemberTheOrg 记录该组织 在获取该组织人员信息后,拿currentChooseMemberTheOrg(旧信息)里面的组织人员和新获取的组织人员作对比,如果 currentChooseMemberTheOrg里面有已经被选的人了 就把 新获取的信息里面的该人员也标记成被选状态 这样再打开列表用户上次选择的用户就会默认选中
 在每次选择完人员之后 循环遍历一下 orgAllDataArray 查询里面的组织有多少被选中的人员 并展示出来
 这样做不管用户组织下面有多少组织 都没关系 都不影响用户记录之前选择的人员,
 
 
 */
@interface DJChooseMissionPersonnelViewController : DJBaseViewController


/**
 *
 */
@property (nonatomic, copy)SelectTaskReceiveUser taskReceiveUser;

/**
 *
 */
@property (nonatomic, strong)NSArray* echoOrgUserArray;
@end
