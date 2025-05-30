//
//  TiUIManager.h
//
//  Created by iMacA1002 on 2019/12/2.
//  Copyright © 2020 Tillusory Tech. All rights reserved.
//

/*
 *     ⣠⣇
 *     ⡙⣿⣤⣾⣿⣿⣿⣶⣄
 *     ⣨⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⣠⡶⠋
 *     ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡶⠶⠒
 *     ⢻⣿⡟⣾⡙⠧⣊⢚⣪⡊⣸⢻⣟⠶⣄
 *     ⣀⣙⣷⠙⠀⠀⠀⢇⢽⣞⡏⣸⠋
 *     ⠙⢛⣻⠟⠒⠀⠀⠀⠀⠀⣩⠋
 *     ⣿⡏⠀⠀⠀⡗⢄⠀⡠⠛
 *     ⠋⠀⠀⠀⠉⠙⢄⠉
 *     ⢎⠑⣇⣸⠶⣧⣸⠶⡎⠑⣇
 *        新一保佑
 *       代码无BUG
 *     真相通常只有一个
 *
 */

#import "TiUIMainMenuView.h"
#import <UIKit/UIKit.h>
#import "TiUIDefaultButtonView.h"

// --- 全局变量 ---
extern bool isswitch_makeup;
extern bool isswitch_greenEdit;

@protocol TiUIManagerDelegate <NSObject>

@optional
/**
 * 点击退出手势
 */
- (void)didClickOnExitTap;
/**
 * 切换摄像头
 */
- (void)didClickSwitchCameraButton;
/**
 * 拍照
 */
- (void)didClickCameraCaptureButton;

@end

@interface TiUIManager : NSObject
/**
*   初始化单例
*/
+ (TiUIManager *)shareManager;

/**
 *   是否隐藏默认UI视图按钮  默认是NO 不显示，该属性在load方法之前设置
*/
@property(nonatomic) BOOL showsDefaultUI;

//主窗口
@property(nonatomic, strong) UIWindow *superWindow;

//添加退出手势的View
@property(nonatomic, strong) UIView *exitTapView;

/**
 *   弹出功能页UI
*/
- (void)showMainMenuView;

-(void)hiddenAllViews:(BOOL)YESNO;

-(void)popAllViews;

//默认UI按钮
@property(nonatomic, strong) TiUIDefaultButtonView *defaultButton;

//设置提示语
-(void)setInteractionHintL:(NSString *)hint;

/**
 *  加载UI 通过Window默认初始化在当前页面最上层 
 */
- (void)loadToWindowDelegate:(id<TiUIManagerDelegate>)delegate;
/**
*  加载UI 通过传入View
*/
- (void)loadToView:(UIView* )view forDelegate:(id<TiUIManagerDelegate>)delegate;
/**
*  加载UI 返回一个View视图
*/
- (UIView*)returnLoadToViewDelegate:(id<TiUIManagerDelegate>)delegate;
/**
 * 释放UI资源
 */
- (void)destroy;

//美颜模块主要功能UI
@property(nonatomic,strong) TiUIMainMenuView *tiUIViewBoxView;
@property(nonatomic, weak) id <TiUIManagerDelegate> delegate;

//美颜模块主要功能UI
//@property(nonatomic,strong) TiUIMainView *tiUIMainView;

@end
