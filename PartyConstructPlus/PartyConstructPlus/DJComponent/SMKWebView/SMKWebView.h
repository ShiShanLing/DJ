//
//  IMYWebView.h
//  IMY_ViewKit
//
//  Created by ljh on 15/7/1.
//  Copyright (c) 2015年 IMY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DJWebViewLoadingEndBlock)();
@protocol WKScriptMessageHandler;
@class SMKWebView, JSContext;

@protocol SMKWebViewDelegate <NSObject>
@optional

- (void)webViewDidStartLoad:(SMKWebView *)webView;
- (void)webViewDidFinishLoad:(SMKWebView *)webView;
- (void)webView:(SMKWebView *)webView didFailLoadWithError:(NSError*)error;
- (BOOL)webView:(SMKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

///无缝切换UIWebView   会根据系统版本自动选择 使用WKWebView 还是  UIWebView
@interface SMKWebView : UIView

///使用UIWebView
- (instancetype)initWithFrame:(CGRect)frame usingUIWebView:(BOOL)usingUIWebView;

///会转接 WKUIDelegate，WKNavigationDelegate 内部未实现的回调。
@property (strong, nonatomic) id<SMKWebViewDelegate> delegate;

///内部使用的webView
@property (nonatomic, readonly) id realWebView;
///是否正在使用 UIWebView
@property (nonatomic, readonly) BOOL usingUIWebView;
///预估网页加载进度
@property (nonatomic, readonly) double estimatedProgress;

@property (nonatomic, readonly) NSURLRequest* originRequest;

///只有ios7以上的UIWebView才能获取到，WKWebView 请使用下面的方法.
@property (nonatomic, readonly) JSContext* jsContext;
///WKWebView 跟网页进行交互的方法。
- (void)addScriptMessageHandler:(id<WKScriptMessageHandler>)scriptMessageHandler name:(NSString*)name;

///back 层数
- (NSInteger)countOfHistory;
- (void)gobackWithStep:(NSInteger)step;

///---- UI 或者 WK 的API
@property (nonatomic, readonly) UIScrollView* scrollView;

- (id)loadRequest:(NSURLRequest*)request;
- (id)loadHTMLString:(NSString*)string baseURL:(NSURL*)baseURL;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly) NSURLRequest* currentRequest;
@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;
@property (nonatomic, readonly) BOOL canGoBack;
@property (nonatomic, readonly) BOOL canGoForward;

- (id)goBack;
- (id)goForward;
- (id)reload;
- (id)reloadFromOrigin;
- (void)stopLoading;

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaScriptString;

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id  result, NSError *  error))completionHandler;

///是否根据视图大小来缩放页面  默认为YES
@property (nonatomic) BOOL scalesPageToFit;

/**
 *加载完毕的回调
 */
@property (nonatomic, copy)DJWebViewLoadingEndBlock  webViewLoadingEndBlock;

@end
