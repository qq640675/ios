//
//  LiveRoomViewController.m
//  Demo03_创建直播间
//
//  Created by jameskhdeng(邓凯辉) on 2018/3/30.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "LiveRoomViewController.h"
#import <ILiveSDK/ILiveCoreHeader.h>
#import "DefineConstants.h"
#import <TILLiveSDK/TILLiveSDK.h>
#import "YLUserDefault.h"
#import "YLTapGesture.h"
#import <Masonry.h>

@interface LiveRoomViewController ()<ILiveMemStatusListener>
{
    ILiveFrameDispatcher *frameDispatcher;
    NSMutableArray  *pointsArray;
    
}

@property (nonatomic, strong) NSMutableDictionary *placeholderViews;
@property (nonatomic, strong) NSMutableDictionary *renderViews;

@end

@implementation LiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播间";
    
    pointsArray = [NSMutableArray array];
    
    [pointsArray addObject:[NSNumber numberWithInt:[YLUserDefault userDefault].t_id]];
}

//// 房间销毁时记得调用退出房间接口
//- (void)dealloc {
//    [[ILiveRoomManager getInstance] quitRoom:^{
//        NSLog(@"退出房间成功");
//    } failed:^(NSString *module, int errId, NSString *errMsg) {
//        NSLog(@"退出房间失败 %d : %@", errId, errMsg);
//    }];
//}

//#pragma mark - ILiveMemStatusListener
- (BOOL)onEndpointsUpdateInfo:(QAVUpdateEvent)event updateList:(NSArray *)endpoints {
    
    
    if (endpoints.count <= 0) {
        return NO;
    }
    
    switch (event) {
        case QAV_EVENT_ID_ENDPOINT_HAS_CAMERA_VIDEO:
        {
            if (_roomType == YLRoomTypeJoinRoom) {
                ILiveFrameDispatcher *frameDispatcher = [[ILiveRoomManager getInstance] getFrameDispatcher];
                
                ILiveRenderView *renderView =  [frameDispatcher addRenderAt:self.view.bounds forIdentifier:[NSString stringWithFormat:@"%d",_godId] srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                [self.view addSubview:renderView];
                
                ILiveRenderView *myView =  [frameDispatcher addRenderAt:CGRectMake(App_Frame_Width - 130, 0, 130, 160) forIdentifier:[NSString stringWithFormat:@"%d",[YLUserDefault userDefault].t_id] srcType:QAVVIDEO_SRC_TYPE_CAMERA];
                [self.view addSubview:myView];
            }else{
                for (int j= 0; j< endpoints.count; j++) {
                    int endPoint = [[endpoints[j] identifier] intValue];;
                    
                    if (endPoint == [YLUserDefault userDefault].t_id) {
                        break;
                    }
                    
                    if (pointsArray.count < 2 && j == endpoints.count -1) {
                        [pointsArray addObject:[NSNumber numberWithInt:endPoint]];
                    }
                }
                
                if (pointsArray.count == 0) {
                    break;
                }
                
                [self haveVideo];
            }
        }
            break;
        case QAV_EVENT_ID_ENDPOINT_NO_CAMERA_VIDEO:
        {
            // 移除渲染视图
            [[TILLiveManager getInstance] removeAllAVRenderViews];
            
            ILiveRenderView *myView = [[TILLiveManager getInstance] addAVRenderView:self.view.bounds forIdentifier:[NSString stringWithFormat:@"%d",[YLUserDefault userDefault].t_id] srcType:QAVVIDEO_SRC_TYPE_CAMERA];
            [self.view insertSubview:myView atIndex:0];
            
            // 房间内上麦用户数量变化，重新布局渲染视图
        }
            break;
        default:
            break;
    }
    return YES;
}

- (void)haveVideo
{
    [[TILLiveManager getInstance] removeAVRenderView:[NSString stringWithFormat:@"%d",[YLUserDefault userDefault].t_id] srcType:QAVVIDEO_SRC_TYPE_CAMERA];
    
    if (pointsArray.count == 1) {
        ILiveRenderView *otherView = [[TILLiveManager getInstance] addAVRenderView:self.view.bounds forIdentifier:pointsArray[0] srcType:QAVVIDEO_SRC_TYPE_CAMERA];
        [self.view insertSubview:otherView atIndex:0];
    }else{
        ILiveRenderView *otherView = [[TILLiveManager getInstance] addAVRenderView:self.view.bounds forIdentifier:pointsArray[1] srcType:QAVVIDEO_SRC_TYPE_CAMERA];
        [self.view insertSubview:otherView atIndex:0];
        
        ILiveRenderView *myView = [[TILLiveManager getInstance] addAVRenderView:CGRectMake(0, 0, 130, 130) forIdentifier:[NSString stringWithFormat:@"%d",[YLUserDefault userDefault].t_id] srcType:QAVVIDEO_SRC_TYPE_CAMERA];
        [self.view insertSubview:myView atIndex:1];
        
        [myView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(160);
        }];
    }
}


- (void)onCameraNumChange {
    // 获取当前所有渲染视图
    NSArray *allRenderViews = [[[ILiveRoomManager getInstance] getFrameDispatcher] getAllRenderViews];
    
    // 检测异常情况
    if (allRenderViews.count == 0) {
        return;
    }
    
    // 计算并设置每一个渲染视图的frame
    CGFloat renderViewHeight = [UIScreen mainScreen].bounds.size.height / allRenderViews.count;
    CGFloat renderViewWidth = [UIScreen mainScreen].bounds.size.width;
    __block CGFloat renderViewY = 0.f;
    CGFloat renderViewX = 0.f;
    
    [allRenderViews enumerateObjectsUsingBlock:^(ILiveRenderView *renderView, NSUInteger idx, BOOL * _Nonnull stop) {
        renderViewY = renderViewY + renderViewHeight * idx;
        CGRect frame = CGRectMake(renderViewX, renderViewY, renderViewWidth, renderViewHeight);
        renderView.frame = frame;
    }];
}

//
//#pragma mark - ILiveRoomDisconnectListener
///**
// SDK主动退出房间提示。该回调方法表示SDK内部主动退出了房间。SDK内部会因为30s心跳包超时等原因主动退出房间，APP需要监听此退出房间事件并对该事件进行相应处理
//
// @param reason 退出房间的原因，具体值见返回码
//
// @return YES 执行成功
// */
//- (BOOL)onRoomDisconnect:(int)reason {
//    NSLog(@"房间异常退出：%d", reason);
//    return YES;
//}




// 房间销毁时记得调用退出房间接口
- (void)dealloc {
    [[ILiveRoomManager getInstance] quitRoom:^{
        NSLog(@"退出房间成功");
    } failed:^(NSString *module, int errId, NSString *errMsg) {
        NSLog(@"退出房间失败 %d : %@", errId, errMsg);
    }];
}

// 上/下麦
- (IBAction)upToVideo:(id)sender {
    //    if ([[self.upVideoButton titleForState:UIControlStateNormal] isEqualToString:@"上麦"]) {
    //        // 上麦，打开摄像头和麦克风
    //        [[ILiveRoomManager getInstance] enableCamera:CameraPosFront enable:YES succ:^{
    //            NSLog(@"打开摄像头成功");
    //        } failed:^(NSString *module, int errId, NSString *errMsg) {
    //            NSLog(@"打开摄像头失败");
    //        }];
    //
    //        [[ILiveRoomManager getInstance] enableMic:YES succ:^{
    //            NSLog(@"打开麦克风成功");
    //        } failed:^(NSString *module, int errId, NSString *errMsg) {
    //            NSLog(@"打开麦克风失败");
    //        }];
    //
    //        [self.upVideoButton setTitle:@"下麦" forState:UIControlStateNormal];
    //    } else {
    //        // 下麦，关闭摄像头和麦克风
    //        [[ILiveRoomManager getInstance] enableCamera:CameraPosFront enable:NO succ:^{
    //            NSLog(@"打开摄像头成功");
    //        } failed:^(NSString *module, int errId, NSString *errMsg) {
    //            NSLog(@"打开摄像头失败");
    //        }];
    //
    //        [[ILiveRoomManager getInstance] enableMic:NO succ:^{
    //            NSLog(@"打开麦克风成功");
    //        } failed:^(NSString *module, int errId, NSString *errMsg) {
    //            NSLog(@"打开麦克风失败");
    //        }];
    //
    //        [self.upVideoButton setTitle:@"上麦" forState:UIControlStateNormal];
    //    }
}

#pragma mark - Custom Action

// 房间内上麦用户数量变化时调用，重新布局所有渲染视图，这里简单处理，从上到下等分布局

#pragma mark - ILiveRoomDisconnectListener
/**
 SDK主动退出房间提示。该回调方法表示SDK内部主动退出了房间。SDK内部会因为30s心跳包超时等原因主动退出房间，APP需要监听此退出房间事件并对该事件进行相应处理
 
 @param reason 退出房间的原因，具体值见返回码
 
 @return YES 执行成功
 */
- (BOOL)onRoomDisconnect:(int)reason {
    NSLog(@"房间异常退出：%d", reason);
    return YES;
}


@end
