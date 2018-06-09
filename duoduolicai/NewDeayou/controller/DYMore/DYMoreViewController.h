//
//  DYMoreViewController.h
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/11.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYBaseVC.h"

#define kMoreBackgroundColor kCOLOR_R_G_B_A(246, 246, 246, 1)

typedef enum {
  MoreTypeActionCenter = 0,         //活动中心
  MoreTypeMessageCenter,            //多多新闻
  MoreTypeHelpCenter,               //帮助中心
  MoreTypeForwardFriends,           //转发好友
  MoreTypeFeedback,                 //意见反馈
  MoreTypePayAttentionToOur,        //关注我们
  MoreTypeAboutUs,                  //关于多多理财
  MoreTypeCurrentVersion,            //当前版本
  MoreTypeGroupIntroduction,         //团队介绍
  MoreTypeSafetyControl,            //安全保障
  MoreTypeRecommendReward,           //三级推荐奖励
  MoreTypeShare,                    //分享多多
  MoreTypeMessage,                   //消息
  MoreTypeServiceCenter,            //服务中心
    MoreTypeTypecompanycredit   //公司资信

}MoreType;
@interface DYMoreViewController : DYBaseVC

@end
