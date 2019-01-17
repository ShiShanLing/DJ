//
//  DJWebViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/8/22.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJWebViewController.h"

@interface DJWebViewController ()<UIWebViewDelegate,SMKWebViewDelegate>
@property (nonatomic, weak) UIButton * backItem;
@property (nonatomic, weak) UIButton * closeItem;

@end

@implementation DJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = self.title;
    [self initNaviBar];
    
    [self initWebView];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"review_title_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(commentClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initNaviBar{
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(-10, 0, 100, 44)];
    UIButton * backItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 44)];
    [backItem setImage:[UIImage imageNamed:@"DJAllReturn"] forState:UIControlStateNormal];
    [backItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIEdgeInsets imageE = backItem.imageEdgeInsets;
    imageE.left -= 50;
    backItem.imageEdgeInsets = imageE;
    [backItem addTarget:self action:@selector(clickedBackItem:) forControlEvents:UIControlEventTouchUpInside];
    self.backItem = backItem;
    [backView addSubview:backItem];
    
    UIButton * closeItem = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 44, 44)];
    [closeItem setTitle:@"关闭" forState:UIControlStateNormal];
    [closeItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeItem addTarget:self action:@selector(clickedCloseItem:) forControlEvents:UIControlEventTouchUpInside];
    closeItem.hidden = YES;
    self.closeItem = closeItem;
    [backView addSubview:closeItem];
    
    UIBarButtonItem * leftItemBar = [[UIBarButtonItem alloc]initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftItemBar;
}
#pragma mark - clickedBackItem
- (void)clickedBackItem:(UIBarButtonItem *)btn{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        self.closeItem.hidden = NO;
    }else{
        [self clickedCloseItem:nil];
    }
}
#pragma mark - clickedCloseItem
- (void)clickedCloseItem:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (self.webView.canGoBack) {
        self.closeItem.hidden = NO;
    }
    return YES;
}
- (void)initWebView{
    
    if (kIS_iOS7) {
        _webView = [[SMKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) usingUIWebView:YES];
        _webView.delegate = self;
    }else{
        _webView = [[SMKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _webView.delegate = self;
    }
    __weak typeof(self)  weakSelf=  self;
    
    _webView.webViewLoadingEndBlock = ^{
        weakSelf.dataEmptyView.alpha = 0;
    };
    [self.view addSubview:_webView];
    
    NSLog(@"---%@ ---",self.url);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0]];
}
- (void)webViewDidFinishLoad:(SMKWebView*)webView
{
    // Disable user selection
    if (kIS_iOS7) {
        [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
        // Disable callout
        
        [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
        
    }else{
        [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
        [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
        
    }
    
}
@end
