//
//  DJSidebarVC.h
//  DJNewVersion
//
//  Created by 石山岭 on 2018/3/7.
//  Copyright © 2018年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJDrawerControllerChild;
@protocol DJDrawerControllerPresenting;

/**
 *侧拉菜单主控制器
 */
@interface DJSidebarVC : UINavigationController

@property(nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognize;
/**
 @name Child controllers
 */
/**
 The left view controller.
 
 This controller shows up when the drawer opens. You add it when initializing the drawer object.
 
 @see initWithLeftViewController:centerViewController:
 */
@property(nonatomic, strong, readonly) UINavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting> *leftViewController;
/**
 The center view controller.
 
 This is the main view controller. When needed, it is possible to replace the current center view controller with a different one
 by calling `replaceCenterViewControllerWithViewController:`.
 
 @see replaceCenterViewControllerWithViewController:
 */
@property(nonatomic, strong, readonly) UINavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting> *centerViewController;
/**
 @name Initialization
 */
- (id)initWithLeftViewController:(UINavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting> *)leftViewController
            centerViewController:(UINavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting> *)centerViewController;


/**
 @name Drawer functionality
 */

/**
 Opens the drawer.
 
 Typically, you call this method as a result of tapping on a button in your center view controller.
 */
- (void)open;
/**
 Closes the drawer.
 
 Call this method when you want to programmatically close the drawer.
 Typically, this is the case of a tap in the left view controller leading to exactly the same center view controller currently shown.
 
 From the user's point of view, the result of calling this method is the same of tapping on the center view controller to close it.
 */
- (void)close;
/**
 Reloads the current center view controller and then closes the drawer.
 
 Call this method when you need to reload the contents of the current center view controller. The center view controller will be moved
 out of the right edge of the screen and the given `reloadBlock` will be then invoked. Finally, the drawer will be closed.
 
 @param reloadBlock The reload block
 */
- (void)reloadCenterViewControllerUsingBlock:(void (^)(void))reloadBlock;
/**
 Replaces the current center view controller with the given `viewController` and then closes the drawer.
 
 @param viewController The view controller object that will replace the current center view controller.
 */
- (void)replaceCenterViewControllerWithViewController:(UINavigationController<DJDrawerControllerChild, DJDrawerControllerPresenting> *)viewController;

@end


/**
 The `ICSDrawerControllerChild` protocol is used by the `ICSDrawerController`'s child controllers to communicate with the drawer.
 
 When the child controller is added to the drawer controller, the drawer object automatically sets this property to point to itself.
 */
@protocol DJDrawerControllerChild  <NSObject>

/**
  The drawer object for this child controller
 */
@property (nonatomic, weak)DJSidebarVC *drawer;

@end

/**
 The `ICSDrawerControllerPresenting` protocol is used by `ICSDrawerController` to communicate changes in the open/closed
 state of the drawer to its child controllers.
 
 As an example, you may want to implement these methods in your drawer's center view controller to be able to disable/enable
 the user interaction when the drawer is open/closed.
 */
@protocol DJDrawerControllerPresenting <NSObject>


@optional
/**
 *抽屉即将打开
 */
- (void)drawerControllerWillOpen:(DJSidebarVC *)drawerController;
/**
 *抽屉已经打开
 */
- (void)drawerControllerDidOpen:(DJSidebarVC *)drawerController;
/**
 *抽屉即将关闭
 */
- (void)drawerControllerWillClose:(DJSidebarVC *)drawerController;
/**
 *抽屉已经关闭
 */
- (void)drawerControllerDidClose:(DJSidebarVC *)drawerController;

@end
