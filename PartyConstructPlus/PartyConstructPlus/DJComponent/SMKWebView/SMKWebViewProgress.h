//
//  IMY_NJKWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef SMK_weak
#if __has_feature(objc_arc_weak)
#define SMK_weak weak
#else
#define SMK_weak unsafe_unretained
#endif

extern const float SMKInitialProgressValue;
extern const float SMKInteractiveProgressValue;
extern const float SMKFinalProgressValue;

typedef void (^SMKWebViewProgressBlock)(float progress);
@protocol SMKWebViewProgressDelegate;
@interface SMKWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, SMK_weak) id<SMKWebViewProgressDelegate>progressDelegate;
@property (nonatomic, SMK_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) SMKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol SMKWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(SMKWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end

