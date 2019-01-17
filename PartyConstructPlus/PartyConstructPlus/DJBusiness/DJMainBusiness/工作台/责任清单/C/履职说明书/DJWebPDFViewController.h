//
//  DJWebPDFViewController.h
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJBaseViewController.h"

@interface DJWebPDFViewController : DJBaseViewController
@property (nonatomic, strong) SMKWebView * webView;
@property (nonatomic, copy) NSString * url;
@property (strong, nonatomic) NSString *userName;
/**  述职报告id */
@property (strong, nonatomic) NSString *shuZhiID;

/**
 *
 */
@property (nonatomic, strong)NSString * title;

- (void)initWebView;

@end
