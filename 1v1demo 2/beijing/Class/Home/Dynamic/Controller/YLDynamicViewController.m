//
//  YLDynamicViewController.m
//  beijing
//
//  Created by yiliaogao on 2018/12/25.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "YLDynamicViewController.h"

//vc
#import "YLDynamicReleaseViewController.h"
#import "HVideoViewController.h"
#import "YLRechargeVipController.h"
#import "DynamicCommentListViewController.h"
#import "DynamicDetailViewController.h"
#import "DynamicMsgListViewController.h"
#import "VideoPlayViewController.h"

//tool
#import "DynamicVideoModel.h"
#import "DynamicListTableViewDataSource.h"
#import "SLAlertController.h"
#import "YLInsufficientManager.h"
#import "YLPushManager.h"


@interface YLDynamicViewController ()

<
DynamicListTableViewCellDelegate
>


@property (nonatomic, strong) DynamicCommentListViewController  *commentListVC;

@property (nonatomic, strong) UIButton       *releaseBtn;

@property (nonatomic, strong) UILabel        *msgLb;

@property (nonatomic, assign) NSInteger       page;

@property (nonatomic, assign) NSInteger       actionId;

@property (nonatomic, assign) NSInteger       listType; // 0:全部 1:关注

@end

@implementation YLDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupUI];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    NSString *newMsg = (NSString *)[SLDefaultsHelper getSLDefaults:@"DynamicNewMsgNumber"];
    if ([newMsg integerValue] == 1) {
        [self getDataWithNewMsgNumber];
    }
    [self setupTableFrame];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


#pragma mark -- UI
- (void)setupUI {
    

    self.bNeedRefreshAction  = YES;
    self.bNeedLoadMoreAction = YES;
    [self createTableView];
    
    //如果是主播才有资格发布动态
//    if ([YLUserDefault userDefault].t_role == 1) {
//        //设置发布动态按钮
//        self.releaseBtn = [UIManager initWithButton:CGRectMake((App_Frame_Width-56)/2, APP_Frame_Height-SafeAreaBottomHeight-SafeAreaTopHeight-66, 56, 56) text:@"" font:1 textColor:nil normalBackGroudImg:@"dynamic_release" highBackGroudImg:nil selectedBackGroudImg:nil];
//
//        [_releaseBtn addTarget:self action:@selector(clickedReleaseBtnBtn) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_releaseBtn];
//
//    }
}

- (void)initTableDatasource {
    
    SLTableViewCellBlock cellBlock = ^(SLBaseTableViewCell *cell, SLBaseListModel *model) {
        [self forCellDelegate:cell listModel:model];
    };
    
    self.dataSource = [[DynamicListTableViewDataSource alloc] initWithCellBlock:cellBlock];
    
    self.baseTableView.dataSource = self.dataSource;
    self.baseTableView.tableFooterView = [UIView new];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 1)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.baseTableView.tableHeaderView = self.headerView;
    
    
    [self setupTableFrame];
    
    self.dataSource.sections = [NSMutableArray new];
    SLTableViewSectionModel *secModel = [SLTableViewSectionModel new];
    [self.dataSource.sections addObject:secModel];
    
    _listType = 0;
    if (self.isNear) {
        _listType = 2;
    }
    if (self.isFollow) {
        _listType = 1;
    }
    
    [self.baseTableView.mj_header beginRefreshing];
    
}

- (void)setupTableFrame {
    
    if (@available(iOS 11.0, *)) {

        self.baseTableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        self.baseTableView.scrollIndicatorInsets = self.baseTableView.contentInset;
    }
    self.baseTableView.height = APP_Frame_Height- SafeAreaBottomHeight-SafeAreaTopHeight;
}

#pragma mark -- Net
- (void)beginRefresh {
    
    _page = 1;
    [self getDataWithList];
    
    if ([YLUserDefault userDefault].t_role == 1) {
        [self getDataWithNewMsgNumber];
    }
    
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
    [YLNetworkInterface getDynamicList:[YLUserDefault userDefault].t_id page:_page reqType:_listType block:^(NSMutableArray *listArray) {
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
        NSArray *modelArray = [JsonToModelTool dynamicListJsonToModelWithJsonArray:listArray isMine:NO];
        SLTableViewSectionModel *secModel = [self.dataSource.sections firstObject];
        [secModel.listModels addObjectsFromArray:modelArray];
        [self.baseTableView reloadData];
    }];
}

- (void)getDataWithNewMsgNumber {
    [YLNetworkInterface getDynamicNewMsgNumber:[YLUserDefault userDefault].t_id block:^(int total) {
        if (total > 0) {
            [self.headerView addSubview:self.msgLb];
            [self.msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headerView).offset(10);
                make.centerX.equalTo(self.headerView.mas_centerX);
                make.height.offset(25);
            }];
            self.msgLb.text = [NSString stringWithFormat:@" %d条新消息  ",total];
            [SLDefaultsHelper saveSLDefaults:@"0" key:@"DynamicNewMsgNumber"];
        }
    }];
}

- (void)postDataWithLove:(DynamicListModel *)model {
    [SVProgressHUD showWithStatus:@"点赞中..."];
    [YLNetworkInterface dynamicLove:[YLUserDefault userDefault].t_id dynamicId:model.t_dynamicId block:^(BOOL isSuccess) {
        if (isSuccess) {
            [SVProgressHUD showInfoWithStatus:@"点赞成功"];
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

#pragma mark -- Action
- (void)clickedReleaseBtnBtn {
    YLDynamicReleaseViewController *releaseVC = [[YLDynamicReleaseViewController alloc] init];
    [self.navigationController pushViewController:releaseVC animated:YES];
}

- (void)clickedNewMsgLb {
    DynamicMsgListViewController *vc = [[DynamicMsgListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.msgLb removeFromSuperview];
}


#pragma mark -- Delegate
- (void)forCellDelegate:(SLBaseTableViewCell *)tableCell listModel:(SLBaseListModel *)listModel {
    if ([tableCell isKindOfClass:[DynamicListTableViewCell class]]) {
        DynamicListTableViewCell *cell = (DynamicListTableViewCell *)tableCell;
        cell.delegate = self;
    }
}

- (void)clickedTableCell:(SLBaseListModel *)listModel {
//    DynamicDetailViewController *detailVC = [[DynamicDetailViewController alloc] init];
//    detailVC.listModel = (DynamicListModel *)listModel;
//    [self.navigationController pushViewController:detailVC animated:YES];
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
                [SVProgressHUD showInfoWithStatus:@"你已经赞过了～"];
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
            _actionId = curActionModel.t_id;
            [self presentAlertController];
        }
            break;
        case 105:
        {
            //关注
            if (curActionModel.isFollow) {
                [self postDataWithFollowed:curActionModel];
            } else {
                [self postDataWithFollow:curActionModel];
            }
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

- (void)lookPrivateFile:(DynamicFileModel *)model {
    [YLNetworkInterface postDynamicPay:[YLUserDefault userDefault].t_id fileId:model.t_id
                                 block:^(int code) {
                                     //0315
                                     if (code > 0) {
                                         model.isPrivate = NO;
                                         model.isConsume = YES;
                                         [self.baseTableView reloadData];
                                     }else if (code == -1){
                                         //余额不足
                                         [[YLInsufficientManager shareInstance] insufficientShow];
                                     }
                                 }];
}

- (void)updateVip {
    [YLPushManager pushVipWithEndTime:nil];
}

- (void)playVideo:(DynamicListModel *)model {
    [self payingVideo:model];
}

- (void)presentAlertController {
    [SLAlertController alertControllerWithStyle:UIAlertControllerStyleActionSheet controller:self alertControllerTitle:@"请选择" alertControllerMessage:nil alertControllerSheetActionTitles:@[@"举报"] alertControllerSureActionTitle:nil alertControllerCancelActionTitle:@"取消" alertControllerSheetActionBlock:^(UIAlertAction *didSelectAction) {
        //举报
        [self pushReportVC];
    } alertControllerAlertSureActionBlock:nil alertControllerAlertCancelActionBlock:nil];
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    _releaseBtn.hidden = YES;
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    _releaseBtn.hidden = YES;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    _releaseBtn.hidden = NO;
//}



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

#pragma mark -- Lazy loading
- (UILabel *)msgLb {
    if (!_msgLb) {
        _msgLb = [UIManager initWithLabel:CGRectZero text:@"" font:15.0f textColor:XZRGB(0x353553)];
        _msgLb.backgroundColor = XZRGB(0xebebeb);
        _msgLb.userInteractionEnabled = YES;
        _msgLb.clipsToBounds = YES;
        _msgLb.layer.cornerRadius = 5.0f;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedNewMsgLb)];
        [_msgLb addGestureRecognizer:tap];
    }
    return _msgLb;
    
}


@end
