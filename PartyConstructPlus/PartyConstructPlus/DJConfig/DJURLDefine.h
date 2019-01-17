//
//  DJURLDefine.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/4/19.
//  Copyright © 2018年 石山岭. All rights reserved.
//接口定义

#ifndef DJURLDefine_h
#define DJURLDefine_h
#import "DJNetworking.h"

//老党建使用的地址 地图相关接口还没出来 使用老接口进行测试界面
#define APIHost @"http://djzr.hzdj.gov.cn/party_building"

#define KLocationShare [NSString stringWithFormat:@"%@%@", APIHost, @"/getNearOrgShare.app"]

#define KDWNearList [NSString stringWithFormat:@"%@%@", APIHost, @"/nearorg/getNearorgListByUser.app"]

//内网 测试
//#define kLinkURL  @"http://192.168.23.200:8081"
//外网 测试
//#define kLinkURL @"http://115.236.162.166:8081"
//正式环境
#define kLinkURL @"http://djzr.hzdj.gov.cn"
//公用的图片上传接口
#define kFileUpload [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/file/upload.ext"]
//获取版本号信息
#define   kURL_VersionUpdate  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/version/getVersionMsg.ext"]
//注册发送验证码
#define kRUL_UserCodeRegistered [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/user/userRegistSendCode.ext"]
//注册
#define  kURL_UserRegistered [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/user/regist.ext"]
//登录
#define kURL_UserLogIn [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/user/login.ext"]
//获取版本号
#define kURL_VersionNumber [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/version/getVersionMsg.ext"]
//忘记密码 获取验证码
#define kURL_UserCodeForgotPassword [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/user/resetPasswordSendCode.ext"]
//忘记密码修改密码
#define kURL_UserForgotPWChangePW [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/user/resetPassword.ext"]
//用户修改密码
#define kURL_UserChangePassword   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/user/updatePassword.ext"]
//获取轮播图
#define kURL_ScrollFigure [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/slide/getSlideShow.ext"]
//根据组织邀请码 获取组织名称
#define kURL_GetOrganizationName [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/org/getOrgByCode.ext"]
//获取组织岗位信息列表
#define kURL_ObtainPostInfoList  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/station/getList.ext"]
//获取主界面可配置图标
#define kURL_configIcon  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/appcon/getList.ext"]
//获取用户详情信息接口
#define kURL_UserInfoDetails   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/user/getInfo.ext"]
//更换用户头像
#define kURL_ReplacePicture    [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/user/updateInfo.ext"]
//用户加入新组织
#define kURL_UserJoinOrg   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/org/joinOrg.ext"]
//用户退出组织
#define kURL_UserExitOrg   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/org/leaveOrg.ext"]
//用户变更组织
#define kURL_UserChangeOrg  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/org/updateOrg.ext"]

#pragma mark  -------------党建责任

//获取用户工作行事历
#define kURL_GetWorkingCalendar   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/taskPlan/appFindPageList.ext"]

//查询一个工作行事历的每次任务情况  (行事历详情接口)
#define kURL_WorkingCalendarDetails [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/taskPlan/planImplPageList.ext"]
//待办行事历列表
#define kURL_agendaWorkingCalendar   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/taskPlan/planImplNeedDo.ext"]
//完成待办行事历
#define kURL_finishWorkingCalendar   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/taskPlan/planImplDo.ext"]

//履历说明书列表接口
#define kURL_resumptionExplainList [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbJobDesc/appFindPageList.ext"]
//履历说明说详情接口
#define kURL_resumptionExplainDetails  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbJobDesc/pbJobDesc/load.ext"]
//述职评议列表接口
#define kURL_reviewDutyList [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbJobReport/appFindPageList.ext"]
//述职评议详情接口
#define kURL_reviewDutyDetails [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbJobReport/appFindPageList.ext"]
#pragma mark  ----------- 我的任务

//获取下级组织信息
#define kURL_LowerOrg [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskSend/childrenOrg.ext"]
//获取组织成员
#define kURL_orgUser [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskSend/getOrgUser.ext"]
//发布任务
#define kURL_TaskSend  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskSend/addTask.ext"]
//模糊查询 用户 或者组织
#define kURL_fuzzySearchUserOrOrg [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskSend/queryUserOrOrg.ext"]

//查询我收到的任务列表
#define kURL_myReceivedTask  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskReceive/receiveFindPage.ext"]

//我收到的任务详情
#define kURL_myReceivedTaskDetails  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskReceive/info.ext"]
//标记当前任务为已读
#define kURL_tagTaskRead  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTask/read.ext"]
//执行我收到的任务
#define kURL_performMyReceivedTask   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskReceive/do.ext"]
//我交办的任务
#define kURL_myAssignedTask  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskSend/sendFindPage.ext"]

#define kURL_myAssignedTaskDetails [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskSend/info.ext"]
//查询任务的执行步骤
#define kURL_queryTaskStep  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskReceive/impl.ext"]
//下发任务用户完成情况
#define kURL_myAssignedTaskMemberState  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskSend/userTaskInfo.ext"]
//意见反馈
#define kURL_Feedback [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbCusOpinion/doSave.ext"]
//任务评论
#define kURL_taskComments  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskEva/evaTask.ext"]
//查询任务评论列表
#define kURL_taskCommentsList [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbTaskEva/evaList.ext"]

#pragma mark   ------------------------------成绩单
//查询某月的总分数
#define kURL_currentMonthTotalScore [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbUserScore/monthInfo.ext"]
//查询任意月份的成绩单详情
#define kURL_anyMonthTranscript [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbUserScore/monthImpl.ext"]
//查询某年所有月份的分数
#define kURL_queryYearsEachMonthTotalScore [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbUserScore/yearImpl.ext"]
//查询年度总分
#define kURL_queryYearTotalScore [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbUserScore/yearInfo.ext"]
//查询用户所有的组织 包括已经离开的
#define kURL_queryAllOrg  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/org/userFindList.ext"]
//推送注册
#define kURL_RegisteredPush  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/extPushBind.ext"]
//获取最新的消息(每种一条)
#define kURL_GetNewPushContent [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbPush/extGetNewPushContent.ext"]
//获取消息通知列表
#define kURL_getPushMsgList   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbPush/extGetPushMsg.ext"]
//根据传的类型清空消息
#define kURL_emptyMsgList  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/pbPush/extDeletePushMsg.ext"]

#pragma mark  --------------------身边组织
//获取附近的组织
#define kURL_nearOrgList  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/org/getNearbyOrg.ext"]
//没网的时候获取所有的组织
#define kURL_allOrgList  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/org/getHaveLonOrg.ext"]
//按照关键字搜索组织
#define kURL_mapSearchOrg   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/org/searchOrg.ext"]
//开始位置分享
#define kURL_startLocationSharing  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/user/startShareLocation.ext"]
//结束位置分享
#define kURL_endLocationSharing  [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/user/endShareLocation.ext"]

#pragma mark   ------------------------------数据分析 个人
//统计个人本月任务完成个数
#define kURL_myThisMonthTaskCompleteNumber   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/extCountMonthTaskNum.ext"]
//   我的年度任务数据
#define kURL_myAnnualTaskData   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/extCountYearTaskInfo.ext"]
//个人本月实时排名
#define kURL_myThisMonthRanking   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/extCountUserMonthRankInfo.ext"]
#pragma mark   ------------------------------数据分析 组织
//统计组织本月任务完成个数
#define kURL_orgThisMonthTaskCompleteNumber   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/extCountOrgMonthTaskNum.ext"]
//   组织年度任务数据
#define kURL_orgAnnualTaskData   [NSString stringWithFormat:@"%@%@", kLinkURL, @"/smk_party/extCountOrgYearTaskInfo.ext"]


#endif /* DJURLDefine_h */
