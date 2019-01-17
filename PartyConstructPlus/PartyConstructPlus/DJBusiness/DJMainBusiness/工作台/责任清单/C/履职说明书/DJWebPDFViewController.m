//
//  DJWebPDFViewController.m
//  PartyConstructPlus
//
//  Created by 石山岭 on 2018/6/27.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJWebPDFViewController.h"

@interface DJWebPDFViewController ()<UIWebViewDelegate,SMKWebViewDelegate>
@property (nonatomic, weak) UIButton * backItem;
@property (nonatomic, weak) UIButton * closeItem;

@end

@implementation DJWebPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.title;
    [self initNaviBar];
    
    [self initWebView];
    
    self.dataEmptyView = [[DJDataEmptyView alloc] initWithFrame:CGRectMake(0, 2, kScreenWidth, kScreenHeight)];
    self.dataEmptyView.emptyImageView.image = [UIImage imageNamed:@"DJ_InLoad"];
    self.dataEmptyView.promptLabel.text = @"页面正在努力加载中,请耐心等待,\n如果长时间没有加载完成,请检查网络...";
    self.dataEmptyView.alpha = 1;
    [self.view addSubview:self.dataEmptyView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"review_title_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(commentClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initNaviBar{
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIButton * backItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 44)];
    [backItem setImage:[UIImage imageNamed:@"DJAllReturn"] forState:UIControlStateNormal];
    [backItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIEdgeInsets imageE = backItem.imageEdgeInsets;
    imageE.left -= 40;
    backItem.imageEdgeInsets = imageE;
    [backItem addTarget:self action:@selector(clickedBackItem:) forControlEvents:UIControlEventTouchUpInside];
    self.backItem = backItem;
    [backView addSubview:backItem];
    
    UIButton * closeItem = [[UIButton alloc]initWithFrame:CGRectMake(44+12, 0, 44, 44)];
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
    [self.navigationController popViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
