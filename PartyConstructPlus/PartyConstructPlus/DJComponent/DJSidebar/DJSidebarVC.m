//
//  DJSidebarVC.m
//  DJNewVersion
//
//  Created by 石山岭 on 2018/3/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import "DJSidebarVC.h"
#import "DJDropShadowView.h"
#import "DJSidebarViewController.h"

#define kICSDrawerControllerDrawerDepth  kFit(260.0f)

#define kICSDrawerControllerLeftViewInitialOffset  -kFit(260.0f)

/**
 *侧边栏移动的距离(默认位置).更改为0为不动 (根据需求)
 */

static const NSTimeInterval kICSDrawerControllerAnimationDuration = 0.5;
static const CGFloat kICSDrawerControllerOpeningAnimationSpringDamping = 0.7f;
static const CGFloat kICSDrawerControllerOpeningAnimationSpringInitialVelocity = 0.1f;
static const CGFloat kICSDrawerControllerClosingAnimationSpringDamping = 1.0f;
static const CGFloat kICSDrawerControllerClosingAnimationSpringInitialVelocity = 0.5f;
typedef NS_ENUM(NSInteger,DJDrawerControllerState)
{
    DJDrawerControllerStateClosed = 0,
    DJDrawerControllerStateOpening,
    DJDrawerControllerStateOpen,
    DJDrawerControllerStateClosing
};

@interface DJSidebarVC ()<UIGestureRecognizerDelegate>
@property(nonatomic, strong, readwrite) UINavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting> *leftViewController;
@property(nonatomic, strong, readwrite) UINavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting>  *centerViewController;
@property(nonatomic, strong) UIView *leftView;
@property(nonatomic, strong) DJDropShadowView *centerView;
@property(nonatomic, strong) UITapGestureRecognizer *centerViewTapGestureRecognizer;
/**
 *
 */
@property (nonatomic, strong)UIPanGestureRecognizer *leftViewPanGestureRecognizer ;

@property(nonatomic, assign) CGPoint panGestureStartLocation;
@property(nonatomic, assign) DJDrawerControllerState drawerState;

/**
 *背景view
 */
@property (nonatomic, strong)UIView  *baView;

@end

@implementation DJSidebarVC


- (UIView *)baView {
    if (!_baView) {
        _baView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _baView.backgroundColor = [UIColor blackColor];
        _baView.alpha = 0.0;
        [_centerViewController.view addSubview:_baView];
    }
    return _baView;
}

- (id)initWithLeftViewController:(UINavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting> *)leftViewController
            centerViewController:(UINavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting> *)centerViewController {
    NSParameterAssert(leftViewController);
    NSParameterAssert(centerViewController);
    
    self = [super init];
    if (self) {
        _leftViewController = leftViewController;
        _centerViewController = centerViewController;
        
        if ([_leftViewController respondsToSelector:@selector(setDrawer:)]) {
            _leftViewController.drawer = self;
        }
        if ([_centerViewController respondsToSelector:@selector(setDrawer:)]) {
            _centerViewController.drawer = self;
        }
    }
    return self;
}

- (void)addCenterViewController {
    NSParameterAssert(self.centerViewController);
    NSParameterAssert(self.centerView);
    
    [self addChildViewController:self.centerViewController];//吧主要是视图添加到self上
    self.centerViewController.view.frame = self.view.bounds;
    [self.centerView addSubview:self.centerViewController.view];
    [self.centerViewController didMoveToParentViewController:self];//把当前控制器设为self.centerViewController的子控制器
}

#pragma mark - Managing the view

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.centerView = [[DJDropShadowView alloc] initWithFrame:self.view.bounds];
    self.leftView.autoresizingMask = self.view.autoresizingMask;//自定调整和父视图直接的间距
    self.centerView.autoresizingMask = self.view.autoresizingMask;
    [self.view addSubview:self.centerView];
    [self addCenterViewController];
    [self setupGestureRecognizers];
}

#pragma mark - Configuring the view’s layout behavior

- (UINavigationController *)childViewControllerForStatusBarHidden
{
    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);
    if (self.drawerState == DJDrawerControllerStateOpening) {
        return self.leftViewController;
    }
    return self.centerViewController;
}

- (UINavigationController *)childViewControllerForStatusBarStyle
{
    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);
    
    if (self.drawerState == DJDrawerControllerStateOpening) {
        return self.leftViewController;
    }
    return self.centerViewController;
}

#pragma mark - Gesture recognizers

- (void)setupGestureRecognizers
{
    NSParameterAssert(self.centerView);
    
    //leftview的滑动手势 用来关闭left菜单
    self.leftViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanGestureRecognize:)];
    self.leftViewPanGestureRecognizer.delegate =self;
    [self.leftView addGestureRecognizer:_leftViewPanGestureRecognizer];
    
    //centerView的点击手势 用来关闭left菜单
    self.centerViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];//添加一个点击手势
    [self.centerView addSubview:self.baView];//吧背景视图添加到centerView
    self.baView.hidden = YES;//默认不显示
    
    //centerView的滑动手势 用来关闭left菜单
    UIPanGestureRecognizer *centerViewShutLeftTapGestureRecognizer= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanGestureRecognize:)];
    centerViewShutLeftTapGestureRecognizer.delegate = self;
    [self.baView addGestureRecognizer:centerViewShutLeftTapGestureRecognizer];
    
    //centerView的边缘滑动手势 用来打开left菜单
    self.screenEdgePanGestureRecognize = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanGestureRecognize:)];//添加一个滑动手势
    _screenEdgePanGestureRecognize.edges = UIRectEdgeLeft;
    self.screenEdgePanGestureRecognize.delegate = self;
    [self.centerView addGestureRecognizer:self.screenEdgePanGestureRecognize];//把滑动手势添加到主界面(现实功能模块的界面),实现右滑现实菜单
}
//
- (void)addClosingGestureRecognizers
{
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.screenEdgePanGestureRecognize);
    
    [self.baView addGestureRecognizer:self.centerViewTapGestureRecognizer];
}

- (void)removeClosingGestureRecognizers
{
    
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.screenEdgePanGestureRecognize);
    [self.baView setHidden:YES];
    [self.baView removeGestureRecognizer:self.centerViewTapGestureRecognizer];
}

#pragma mark Tap to close the drawer
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self close];
    }
}

#pragma mark Pan to open/close the drawer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSParameterAssert([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]);
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view];
    
    if (self.drawerState == DJDrawerControllerStateClosed && velocity.x > 0.0f) {
        return YES;
    }
    else if (self.drawerState == DJDrawerControllerStateOpen && velocity.x < 0.0f) {
        return YES;
    }
    return NO;
}

- (void)screenEdgePanGestureRecognize:(UIPanGestureRecognizer *)panGestureRecognizer//滑动效果,是分居滑动手势判断出滑动的速度和距离然后动态改变试图的frame来实现的
{
    NSParameterAssert(self.leftView);
    NSParameterAssert(self.centerView);
    
    UIGestureRecognizerState state = panGestureRecognizer.state;
    CGPoint location = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    switch (state) {
            
        case UIGestureRecognizerStateBegan:
            self.panGestureStartLocation = location;
            if (self.drawerState == DJDrawerControllerStateClosed) {
                
                [self willOpen];
            } else {
                [self willClose];
            }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat delta = 0.0f;
            if (self.drawerState == DJDrawerControllerStateOpening) {
                delta = location.x - self.panGestureStartLocation.x;
            } else if (self.drawerState == DJDrawerControllerStateClosing) {
                delta = kICSDrawerControllerDrawerDepth - (self.panGestureStartLocation.x - location.x);
            }
            CGRect l = self.leftView.frame;
            CGRect c = self.centerView.frame;
            if (delta > kICSDrawerControllerDrawerDepth) {//如果已经滑倒最右边就把功能界面固定位置
                l.origin.x = 0.0f;
                c.origin.x = kICSDrawerControllerDrawerDepth;
            }else if (delta < 0.0f) {//否则已经滑倒了最左边
                l.origin.x = kICSDrawerControllerLeftViewInitialOffset;
                c.origin.x = 0.0f;
            } else {//否则就是正在移动
                // While the centerView can move up to kICSDrawerControllerDrawerDepth points, to achieve a parallax effect
                // the leftView has move no more than kICSDrawerControllerLeftViewInitialOffset points
                l.origin.x = kICSDrawerControllerLeftViewInitialOffset
                - (delta * kICSDrawerControllerLeftViewInitialOffset) / kICSDrawerControllerDrawerDepth;
                c.origin.x = delta;
            }
            self.leftView.frame = l;
            CGFloat proportion = fabs( c.origin.x/kICSDrawerControllerDrawerDepth)  * 0.3;
            NSLog(@"screenEdgePanGestureRecognize%f  \n proportion%f", c.origin.x,proportion);
            self.centerView.frame = c;
            self.baView.alpha = proportion;
            
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            if (self.drawerState == DJDrawerControllerStateOpening) {//如果是打开的状态
                
                CGFloat centerViewLocation = self.centerView.frame.origin.x;
                if (centerViewLocation == kICSDrawerControllerDrawerDepth) {
                    // Open the drawer without animation, as it has already being dragged in its final position
                    [self setNeedsStatusBarAppearanceUpdate];
                    [self didOpen];
                } else if (centerViewLocation > self.view.bounds.size.width / 3
                           && velocity.x > 0.0f) {
                    // Animate the drawer opening
                    [self animateOpening];
                }
                else {
                    // Animate the drawer closing, as the opening gesture hasn't been completed or it has
                    // been reverted by the user
                    [self didOpen];
                    [self willClose];
                    [self animateClosing];
                }
                
            } else if (self.drawerState == DJDrawerControllerStateClosing) {
                
                CGFloat centerViewLocation = self.centerView.frame.origin.x;
                if (centerViewLocation == 0.0f) {
                    // Close the drawer without animation, as it has already being dragged in its final position
                    [self setNeedsStatusBarAppearanceUpdate];
                    [self didClose];
                }
                else if (centerViewLocation < (2 * self.view.bounds.size.width) / 3
                         && velocity.x < 0.0f) {
                    // Animate the drawer closing
                    [self animateClosing];
                }
                else {
                    // Animate the drawer opening, as the opening gesture hasn't been completed or it has
                    // been reverted by the user
                    [self didClose];
                    // Here we save the current position for the leftView since
                    // we want the opening animation to start from the current position
                    // and not the one that is set in 'willOpen'
                    CGRect l = self.leftView.frame;
                    [self willOpen];
                    self.leftView.frame = l;
                    
                    [self animateOpening];
                }
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Animations
#pragma mark Opening animation
- (void)animateOpening
{
    NSParameterAssert(self.drawerState == DJDrawerControllerStateOpening);
    NSParameterAssert(self.leftView);
    NSParameterAssert(self.centerView);
    
    // Calculate the final frames for the container views
    CGRect leftViewFinalFrame = self.view.bounds;
    CGRect centerViewFinalFrame = self.view.bounds;
    centerViewFinalFrame.origin.x = kICSDrawerControllerDrawerDepth;
    __weak __typeof(self) weakself= self;
    [UIView animateWithDuration:kICSDrawerControllerAnimationDuration
                          delay:0
         usingSpringWithDamping:kICSDrawerControllerOpeningAnimationSpringDamping
          initialSpringVelocity:kICSDrawerControllerOpeningAnimationSpringInitialVelocity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         weakself.centerView.frame = centerViewFinalFrame;
                         weakself.leftView.frame = leftViewFinalFrame;
                         weakself.baView.alpha = 0.3;
                         [weakself setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {
                         [weakself didOpen];
                     }];
}
#pragma mark Closing animation
- (void)animateClosing
{
    NSParameterAssert(self.drawerState == DJDrawerControllerStateClosing);
    NSParameterAssert(self.leftView);
    NSParameterAssert(self.centerView);
    
    // Calculate final frames for the container views
    CGRect leftViewFinalFrame = self.leftView.frame;
    leftViewFinalFrame.origin.x = kICSDrawerControllerLeftViewInitialOffset;
    CGRect centerViewFinalFrame = self.view.bounds;
    __weak __typeof(self) weakself= self;
    [UIView animateWithDuration:kICSDrawerControllerAnimationDuration
                          delay:0
         usingSpringWithDamping:kICSDrawerControllerClosingAnimationSpringDamping
          initialSpringVelocity:kICSDrawerControllerClosingAnimationSpringInitialVelocity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         weakself.centerView.frame = centerViewFinalFrame;
                         weakself.leftView.frame = leftViewFinalFrame;
                         weakself.baView.alpha = 0.0;
                         [weakself setNeedsStatusBarAppearanceUpdate];
                     }
                     completion:^(BOOL finished) {
                         [weakself didClose];//动画关闭完毕之后,就把侧栏视图移除掉
                     }];
}

#pragma mark - Opening the drawer

- (void)open
{
    NSParameterAssert(self.drawerState == DJDrawerControllerStateClosed);
    
    [self willOpen];//加载侧栏等操作
    DJSidebarViewController *VC = self.leftViewController;
    [VC refreshData];
    [self animateOpening];//动画吧侧栏移出来
}

- (void)willOpen
{
    self.baView.hidden = NO;
    NSParameterAssert(self.drawerState == DJDrawerControllerStateClosed);
    NSParameterAssert(self.leftView);
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);
    
    // Keep track that the drawer is opening
    self.drawerState = DJDrawerControllerStateOpening;
    
    // Position the left view
    CGRect f = self.view.bounds;
    f.origin.x = kICSDrawerControllerLeftViewInitialOffset;
    NSParameterAssert(f.origin.x < 0.0f);
    //NSLog(@"willOpen%f----%f", f.origin.y,f.size.height);
    self.leftView.frame = f;
    
    // Start adding the left view controller to the container
    [self addChildViewController:self.leftViewController];//添加一个子视图
    self.leftViewController.view.frame = self.leftView.bounds;
    [self.leftView addSubview:self.leftViewController.view];
    // Add the left view to the view hierarchy
    [self.view insertSubview:self.leftView belowSubview:self.centerView];//展示侧边栏
    // Notify the child view controllers that the drawer is about to open
    
    
    if ([self.leftViewController respondsToSelector:@selector(drawerControllerWillOpen:)]) {//再打开侧边栏的时候   关闭主界面的用户交互
        [self.leftViewController drawerControllerWillOpen:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(drawerControllerWillOpen:)]) {
        [self.centerViewController drawerControllerWillOpen:self];
    }
}

- (void)didOpen
{
    NSParameterAssert(self.drawerState == DJDrawerControllerStateOpening);
    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);
    
    // Complete adding the left controller to the container
    [self.leftViewController didMoveToParentViewController:self];
    //当侧边栏即将出现的时候将手势识别器添加上.
    [self addClosingGestureRecognizers];
    
    // Keep track that the drawer is open
    self.drawerState = DJDrawerControllerStateOpen;
    
    // Notify the child view controllers that the drawer is open
    if ([self.leftViewController respondsToSelector:@selector(drawerControllerDidOpen:)]) {
        [self.leftViewController drawerControllerDidOpen:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(drawerControllerDidOpen:)]) {
        [self.centerViewController drawerControllerDidOpen:self];
    }
}

#pragma mark - Closing the drawer

- (void)close
{
    NSParameterAssert(self.drawerState == DJDrawerControllerStateOpen);
    
    [self willClose];//做一系列关闭的操作,
    [self animateClosing];//做关闭界面的动画
}

- (void)willClose
{
    NSParameterAssert(self.drawerState == DJDrawerControllerStateOpen);
    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);
    
    // Start removing the left controller from the container
    [self.leftViewController willMoveToParentViewController:nil];
    
    // Keep track that the drawer is closing
    self.drawerState = DJDrawerControllerStateClosing;
    
    // Notify the child view controllers that the drawer is about to close
    if ([self.leftViewController respondsToSelector:@selector(drawerControllerWillClose:)]) {
        [self.leftViewController drawerControllerWillClose:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(drawerControllerWillClose:)]) {
        [self.centerViewController drawerControllerWillClose:self];
    }
}

- (void)didClose
{
    self.baView.hidden = YES;
    NSParameterAssert(self.drawerState == DJDrawerControllerStateClosing);
    NSParameterAssert(self.leftView);
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.leftViewController);
    NSParameterAssert(self.centerViewController);
    
    // Complete removing the left view controller from the container
    [self.leftViewController.view removeFromSuperview];
    [self.leftViewController removeFromParentViewController];
    
    // Remove the left view from the view hierarchy
    [self.leftView removeFromSuperview];
    //当侧边栏即将消失的时候将手势识别器消失掉.
    [self removeClosingGestureRecognizers];
    
    // Keep track that the drawer is closed
    self.drawerState = DJDrawerControllerStateClosed;
    
    // Notify the child view controllers that the drawer is closed
    if ([self.leftViewController respondsToSelector:@selector(drawerControllerDidClose:)]) {
        [self.leftViewController drawerControllerDidClose:self];
    }
    if ([self.centerViewController respondsToSelector:@selector(drawerControllerDidClose:)]) {
        [self.centerViewController drawerControllerDidClose:self];
    }
}
#pragma mark - Reloading/Replacing the center view controller
- (void)reloadCenterViewControllerUsingBlock:(void (^)(void))reloadBlock
{
    
    NSParameterAssert(self.drawerState == DJDrawerControllerStateOpen);
    NSParameterAssert(self.centerViewController);

    [self willClose];
    
    CGRect f = self.centerView.frame;
    f.origin.x = self.view.bounds.size.width;
    __weak __typeof(self) weakself= self;
    [UIView animateWithDuration: kICSDrawerControllerAnimationDuration / 2
                     animations:^{
                         weakself.centerView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         // The center view controller is now out of sight
                         if (reloadBlock) {
                             reloadBlock();
                         }
                         // Finally, close the drawer
                         [weakself animateClosing];
                     }];
}

- (void)replaceCenterViewControllerWithViewController:(UINavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting> *)viewController
{
    NSParameterAssert(self.drawerState == DJDrawerControllerStateOpen);
    NSParameterAssert(viewController);
    NSParameterAssert(self.centerView);
    NSParameterAssert(self.centerViewController);
    
    [self willClose];
    
    CGRect f = self.centerView.frame;
    f.origin.x = self.view.bounds.size.width;
    
    [self.centerViewController willMoveToParentViewController:nil];
    [UIView animateWithDuration: kICSDrawerControllerAnimationDuration / 2
                     animations:^{
                         self.centerView.frame = f;
                     }
                     completion:^(BOOL finished) {
                         // The center view controller is now out of sight
                         
                         // Remove the current center view controller from the container
                         if ([self.centerViewController respondsToSelector:@selector(setDrawer:)]) {
                             self.centerViewController.drawer = nil;
                         }
                         [self.centerViewController.view removeFromSuperview];
                         [self.centerViewController removeFromParentViewController];
                         
                         // Set the new center view controller
                         self.centerViewController = viewController;
                         if ([self.centerViewController respondsToSelector:@selector(setDrawer:)]) {
                             self.centerViewController.drawer = self;
                         }
                         
                         // Add the new center view controller to the container
                         [self addCenterViewController];
                         
                         // Finally, close the drawer
                         [self animateClosing];
                     }];
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
