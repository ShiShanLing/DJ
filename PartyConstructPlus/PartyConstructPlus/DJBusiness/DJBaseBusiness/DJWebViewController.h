//
//  DJWebViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/22.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"
@class SMKWebView;
@interface DJWebViewController : DJBaseViewController
@property (nonatomic, strong) SMKWebView * webView;
@property (nonatomic, copy) NSString * url;
@property (strong, nonatomic) NSString *titleStr;
@end
