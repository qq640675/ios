//
//  MeDynamicViewController.m
//  beijing
//
//  Created by yiliaogao on 2019/3/26.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "MeDynamicViewController.h"

//vc
#import "YLDynamicReleaseViewController.h"
#import "HVideoViewController.h"
#import "YLRechargeVipController.h"
#import "DynamicCommentListViewController.h"
#import "DynamicDetailViewController.h"
#import "VideoPlayViewController.h"
#import "DynamicMsgListViewController.h"

//tool
#import "DynamicVideoModel.h"
#import "DynamicListTableViewDataSource.h"
#import "SLAlertController.h"
#import "YLPushManager.h"

@interface MeDynamicViewController ()

<
DynamicListTableViewCellDelegate
>

@property (nonatomic, strong) DynamicCommentListViewController  *commentListVC;

@property (nonatomic, assign) NSInteger       page;

@property (nonatomic, assign) NSInteger       actionId;

@end

@implementation MeDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupUI];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


#pragma mark -- UI
- (void)setupUI {
    
    self.navigationItem.title = @"我的动态";
    
    //如果是主播才有资格发布动态
    if ([YLUserDefault userDefault].t_role == 1) {
        //设置navigationBar rightBtn
        UIButton *naviRightBtn = [UIManager initWithButton:CGRectMake(0, 0, 44, 44) text:nil font:0.0f textColor:[UIColor blackColor] normalImg:@"Dynamic_camera" highImg:nil selectedImg:nil];
        [naviRightBtn addTarget:self action:@selector(clickedNaviRightBtn) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:naviRightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }
    
    self.bNeedRefreshAction  = YES;
    self.bNeedLoadMoreAction = YES;
    [self createTableView];
    
    
}

- (void)clickedNaviRightBtn {
    YLDynamicReleaseViewController *releaseVC = [[YLDynamicReleaseViewController alloc] init];
    [self.navigationController pushViewController:releaseVC animated:YES];
}

- (void)initTableDatasource {
    
    SLTableViewCellBlock cellBlock = ^(SLBaseTableViewCell *cell, SLBaseListModel *model) {
        [self forCellDelegate:cell listModel:model];
    };
    
    self.dataSource = [[DynamicListTableViewDataSource alloc] initWithCellBlock:cellBlock];
    
    self.baseTableView.dataSource = self.dataSource;
    self.baseTableView.tableFooterView = [UIView new];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 35)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.baseTableView.tableHeaderView = self.headerView;
    
    
    self.dataSource.sections = [NSMutableArray new];
    SLTableViewSectionModel *secModel = [SLTableViewSectionModel new];
    [self.dataSource.sections addObject:secModel];
    
    [self.baseTableView.mj_header beginRefreshing];
    
}


#pragma mark -- Net
- (void)beginRefresh {
    
    _page = 1;
    [self getDataWithList];
    
}

- (void)loadMoreData {
    _page ++;
    [self getDataWithList];
}

- (void)getDataWithList {
    if (_page > 1) {
        [self.loadMoreView startLoadMore];
    }
    //全部主播动态
    [self getDataWithDynamicList];
}

- (void)getDataWithDynamicList {
    [YLNetworkInterface getMineDynamicList:[YLUserDefault userDefault].t_id page:_page block:^(NSMutableArray *listArray) {
        [self.baseTableView.mj_header endRefreshing];
        [self.loadMoreView stopLoadMore];
        if (self.page == 1) {
            SLTableViewSectionModel *secModel = [self.dataSource.sections firstObject];
            [secModel.listModels removeAllObjects];
        }
        if ([listArray count] < 10) {
            self.baseTableView.tableFooterView = [UIView new];
        } else {
            self.baseTableView.tableFooterView = self.loadMoreView;
        }
        NSArray *modelArray = [JsonToModelTool dynamicListJsonToModelWithJsonArray:listArray isMine:YES];
        SLTableViewSectionModel *secModel = [self.dataSource.sections firstObject];
        [secModel.listModels addObjectsFromArray:modelArray];
        [self.baseTableView reloadData];
    }];
}


- (void)postDataWithLove:(DynamicListModel *)model {

    [YLNetworkInterface dynamicLove:[YLUserDefault userDefault].t_id dynamicId:model.t_dynamicId block:^(BOOL isSuccess) {
        if (isSuccess) {

            model.isPraise = YES;
            model.t_praiseCount ++;
            [self.baseTableView reloadData];
        }
    }];
}

- (void)postDataWithFollow:(DynamicListModel *)model {
    
    [YLNetworkInterface addAttention:[YLUserDefault userDefault].t_id coverFollowUserId:(int)model.t_id block:^(BOOL isSuccess) {
        SLTableViewSectionModel *secModel = [self.dataSource.sections firstObject];
        for (int i = 0; i < [secModel.listModels count]; i++) {
            DynamicListModel *listModel = secModel.listModels[i];
            if (model.t_id == listModel.t_id) {
                listModel.isFollow = YES;
            }
        }
        [self.baseTableView reloadData];
    }];
}

- (void)postDataWithFollowed:(DynamicListModel *)model {
    
    [YLNetworkInterface cancelAtttention:[YLUserDefault userDefault].t_id coverFollowUserId:(int)model.t_id  block:^(BOOL isSuccess) {
        SLTableViewSectionModel *secModel = [self.dataSource.sections firstObject];
        for (int i = 0; i < [secModel.listModels count]; i++) {
            DynamicListModel *listModel = secModel.listModels[i];
            if (model.t_id == listModel.t_id) {
                listModel.isFollow = NO;
            }
        }
        [self.baseTableView reloadData];
    }];
}

- (void)postDataWithDelete:(DynamicListModel *)model {
    WEAKSELF
    [YLNetworkInterface dynamicDelete:[YLUserDefault userDefault].t_id dynamicId:model.t_dynamicId block:^(BOOL isSuccess) {
        if (isSuccess) {
            SLTableViewSectionModel *secModel = [weakSelf.dataSource.sections firstObject];
            [secModel.listModels removeObject:model];
            [weakSelf.baseTableView reloadData];
        }
    }];
}

- (void)forCellDelegate:(SLBaseTableViewCell *)tableCell listModel:(SLBaseListModel *)listModel {
    if ([tableCell isKindOfClass:[DynamicListTableViewCell class]]) {
        DynamicListTableViewCell *cell = (DynamicListTableViewCell *)tableCell;
        cell.delegate = self;
    }
}

- (void)clickedTableCell:(SLBaseListModel *)listModel {

}

- (void)didSelectDynamicListTableViewCellWithBtn:(NSInteger)btnTag curActionModel:(DynamicListModel *)curActionModel {
    switch (btnTag) {
        case 100:
        {
            //聊天
            [self pushChatVC:curActionModel];
        }
            break;
        case 101:
        {
            //全文
            curActionModel.isOpen = !curActionModel.isOpen;
            curActionModel.cellHeight = 0.0f;
            [self.baseTableView reloadData];
        }
            break;
        case 102:
        {
            //点赞
            if (curActionModel.isPraise) {
                return;
            }
            [self postDataWithLove:curActionModel];
        }
            break;
        case 103:
        {
            //评论
            self.commentListVC = [[DynamicCommentListViewController alloc] init];
            self.commentListVC.dynamicId  = curActionModel.t_dynamicId;
            self.commentListVC.commentedUserId = curActionModel.t_id;
            self.commentListVC.commentNum = [NSString stringWithFormat:@"%ld",(long)curActionModel.t_commentCount];
            self.commentListVC.view.frame = CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height);
            [[UIApplication sharedApplication].keyWindow addSubview:self.commentListVC.view];
            [self addChildViewController:self.commentListVC];
        }
            break;
        case 104:
        {
            //更多

        }
            break;
        case 105:
        {
            //关注

        }
            break;
        case 106:
        {
            //删除
            [self postDataWithDelete:curActionModel];
        }
            break;
            
        case 107:
        {
            //主播详情
            [YLPushManager pushAnchorDetail:curActionModel.t_id];
        }
            break;
            
        default:
            break;
    }
}

- (void)playVideo:(DynamicListModel *)model {
    [self payingVideo:model];
}

- (void)lookPrivateFile:(DynamicFileModel *)model {
    
}


- (void)updateVip {
    
}

- (void)presentAlertController {
    [SLAlertController alertControllerWithStyle:UIAlertControllerStyleActionSheet controller:self alertControllerTitle:@"请选择" alertControllerMessage:nil alertControllerSheetActionTitles:@[@"举报"] alertControllerSureActionTitle:nil alertControllerCancelActionTitle:@"取消" alertControllerSheetActionBlock:^(UIAlertAction *didSelectAction) {
        //举报
        [self pushReportVC];
    } alertControllerAlertSureActionBlock:nil alertControllerAlertCancelActionBlock:nil];
}

#pragma mark - Keyboard notification
- (void)keyboardShow:(NSNotification *)note {
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.commentListVC.commentTextView.y = APP_Frame_Height-50-deltaY;
    }];
    
}


- (void)keyboardHide:(NSNotification *)note {
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.commentListVC.commentTextView.y = APP_Frame_Height-50-SafeAreaBottomHeight+49;
    }];
    
}

#pragma mark -- Push
- (void)pushReportVC {
    [YLPushManager pushReportWithId:_actionId];
}

- (void)pushChatVC:(DynamicListModel *)model {
    
    [YLPushManager pushChatViewController:model.t_id otherSex:model.t_sex];
}

- (void)payingVideo:(DynamicListModel *)handle
{
    VideoPlayViewController *videoPlayVC = [[VideoPlayViewController alloc] init];
    videoPlayVC.godId = (int)handle.t_id;
    DynamicFileModel *fileModel = [handle.fileArrays firstObject];
    videoPlayVC.videoUrl = fileModel.t_file_url;
    videoPlayVC.coverImageUrl = fileModel.t_cover_img_url;
    videoPlayVC.videoId  = (int)fileModel.t_id;
    videoPlayVC.queryType = 1;
    [self.navigationController pushViewController:videoPlayVC animated:YES];
}


#pragma mark -- Cust
- (BOOL)isMediaTypeOpen {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        [SLAlertController alertControllerWithStyle:UIAlertControllerStyleAlert controller:self alertControllerTitle:@"温馨提示" alertControllerMessage:@"相机或相册权限未开启，是否去开启？" alertControllerSheetActionTitles:nil alertControllerSureActionTitle:@"去开启" alertControllerCancelActionTitle:@"取消" alertControllerSheetActionBlock:nil alertControllerAlertSureActionBlock:^{
            
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
            
        } alertControllerAlertCancelActionBlock:nil];
        return NO;
    }
    return YES;
}





@end

