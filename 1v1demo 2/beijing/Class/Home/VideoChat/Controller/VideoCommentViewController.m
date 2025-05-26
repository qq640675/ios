//
//  VideoCommentViewController.m
//  Qiaqia
//
//  Created by 刘森林 on 2021/1/29.
//  Copyright © 2021 yiliaogaoke. All rights reserved.
//

#import "VideoCommentViewController.h"
#import "XHStarRateView.h"
#import "imageLabelHandle.h"

@interface VideoCommentViewController ()
{
    NSDictionary *videoDetailDic;
    NSArray *goodArray;
}

@property (nonatomic, strong) XHStarRateView *starRateView;
@property (nonatomic, strong) UIView *goodView;
@property (nonatomic, strong) UIView *badView;
@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, strong) UILabel   *nickNameLb;
@property (nonatomic, strong) UILabel   *goldLb;
@property (nonatomic, strong) UILabel   *timeLb;

@property (nonatomic, strong) NSMutableArray  *selectedGoodBtnArray;
@property (nonatomic, strong) NSMutableArray *selectedIds;
@property (nonatomic, strong) NSMutableArray  *selectedBadBtnArray;



@end

@implementation VideoCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    _selectedGoodBtnArray = [NSMutableArray new];
    _selectedIds = [NSMutableArray array];
    _selectedBadBtnArray = [NSMutableArray new];
    
//    [self setupUI];
    [self getVideoDetail];
//    [self getLabels];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)back {
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupUI {
    
//    self.navigationItem.title = @"本次视频评价";
    UILabel *titleL = [UIManager initWithLabel:CGRectMake(0, SafeAreaTopHeight-44, App_Frame_Width, 44) text:@"本次视频评价" font:18 textColor:XZRGB(0x333333)];
    titleL.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:titleL];
    
    UIButton *backB = [UIManager initWithButton:CGRectMake(0, SafeAreaTopHeight-44, 44, 44) text:@"" font:1 textColor:nil normalImg:@"nav_back" highImg:nil selectedImg:nil];
    [backB addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backB];
    
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, App_Frame_Width, APP_FRAME_HEIGHT-SafeAreaTopHeight)];
    [self.view addSubview:scr];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 30.0f;
    [scr addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.equalTo(scr);
        make.top.mas_equalTo(15);
    }];
    
    self.nickNameLb = [UIManager initWithLabel:CGRectZero text:@"昵称" font:20 textColor:XZRGB(0x333333)];
    [scr addSubview:_nickNameLb];
    [_nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scr);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
    }];
    
    self.goldLb = [UIManager initWithLabel:CGRectZero text:@"消费：" font:16 textColor:XZRGB(0x333333)];
    [scr addSubview:_goldLb];
    [_goldLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scr);
        make.top.equalTo(self.nickNameLb.mas_bottom).offset(15);
    }];
    
    self.timeLb = [UIManager initWithLabel:CGRectZero text:@"通话时长：" font:16 textColor:XZRGB(0x333333)];
    [scr addSubview:_timeLb];
    [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scr);
        make.top.equalTo(self.goldLb.mas_bottom).offset(7);
    }];
    
    self.starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, 180, 20) finish:^(CGFloat currentScore) {
        
    }];
    _starRateView.userInteractionEnabled = NO;
    _starRateView.currentScore = 5;
    [scr addSubview:_starRateView];
    [_starRateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scr);
        make.top.equalTo(self.timeLb.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(180, 28));
    }];
    
    imageLabelHandle *handle = [imageLabelHandle new];
    handle.t_label_name = @"不满意";
    handle.t_id = @"";
    NSArray *badArray = @[handle];
    
    UILabel *lb = [UIManager initWithLabel:CGRectZero text:@"好评" font:16 textColor:XZRGB(0x333333)];
    [scr addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8.5);
        make.top.mas_equalTo(240);
    }];
    
    CGFloat height = goodArray.count/4*50;
    if (goodArray.count%4 != 0) {
        height += 50;
    }
    self.goodView = [[UIView alloc] initWithFrame:CGRectZero];
    [scr addSubview:_goodView];
    [_goodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.equalTo(lb.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(APP_FRAME_WIDTH-16, height));
    }];
    
    CGFloat width = (APP_FRAME_WIDTH-80)/4;
    for (int i = 0; i < goodArray.count; i++) {
        imageLabelHandle *handle = goodArray[i];
        CGFloat j = i%4;
        CGFloat g = i/4;
        UIButton *btn = [UIManager initWithButton:CGRectMake((width+16)*j, g*50, width, 30) text:handle.t_label_name font:14 textColor:XZRGB(0x868686) normalImg:nil highImg:nil selectedImg:nil];
        [btn setTitleColor:XZRGB(0xAE4FFD) forState:UIControlStateSelected];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.0f;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = XZRGB(0xe9e9e9).CGColor;
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_goodView addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
            NSString *idStr = handle.t_id;
            [_selectedIds addObject:idStr];
            [_selectedGoodBtnArray addObject:btn];
            btn.layer.borderColor = XZRGB(0xAE4FFD).CGColor;
            btn.selected = YES;
        }
    }
    
    UILabel *lb1 = [UIManager initWithLabel:CGRectZero text:@"差评" font:16 textColor:XZRGB(0x333333)];
    [scr addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8.5);
        make.top.equalTo(self.goodView.mas_bottom).offset(3);
    }];
    
    CGFloat height1 = badArray.count/4*50;
    if (badArray.count%4 != 0) {
        height1 += 50;
    }
    self.badView = [[UIView alloc] initWithFrame:CGRectZero];
    [scr addSubview:_badView];
    [_badView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.top.equalTo(lb1.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(APP_FRAME_WIDTH-16, height1));
    }];

    for (int i = 0; i < badArray.count; i++) {
        imageLabelHandle *handle = badArray[i];
        CGFloat j = i%4;
        CGFloat g = i/4;
        UIButton *btn = [UIManager initWithButton:CGRectMake((width+16)*j, g*50, width, 30) text:handle.t_label_name font:14 textColor:XZRGB(0x868686) normalImg:nil highImg:nil selectedImg:nil];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.0f;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = XZRGB(0xe9e9e9).CGColor;
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_badView addSubview:btn];
    }
    
    UIButton *okBtn = [ToolManager defaultMutableColorButtonWithFrame:CGRectMake((App_Frame_Width-300)/2, 280+height+height1+70, 300, 49) title:@"提交评论" isCycle:YES];
    [okBtn addTarget:self action:@selector(clickedOkBtn:) forControlEvents:UIControlEventTouchUpInside];
    [scr addSubview:okBtn];
    
    scr.contentSize = CGSizeMake(App_Frame_Width, 280+height+height1+120+100);
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", videoDetailDic[@"t_handImg"]]] placeholderImage:[UIImage imageNamed:@"default"]];
    _nickNameLb.text = videoDetailDic[@"t_nickName"];
    if ([YLUserDefault userDefault].t_role == 1) {
        _goldLb.text = [NSString stringWithFormat:@"收益：%@金币", videoDetailDic[@"t_room_gold"]];
    } else {
        _goldLb.text = [NSString stringWithFormat:@"消费：%@金币", videoDetailDic[@"t_room_gold"]];
    }
    _timeLb.text = [NSString stringWithFormat:@"通话时长：%@",videoDetailDic[@"roomTime"]];
}

- (void)getVideoDetail {
    [YLNetworkInterface getVideoComsumerInfoWithRoomId:self.roomId userId:self.otherUserId success:^(NSDictionary *dataDic) {
        self->videoDetailDic = dataDic;
        [self getLabels];
    }];
}

- (void)getLabels {
    [YLNetworkInterface getLabelList:[YLUserDefault userDefault].t_id block:^(NSMutableArray *listArray) {
        self->goodArray = listArray;
        [self setupUI];
    }];
}

- (void)clickedBtn:(UIButton *)btn {
    if (btn.tag > 999) {
        //差评
        if (!btn.selected) {
            btn.layer.borderColor = XZRGB(0xAE4FFD).CGColor;
            
            if (_selectedBadBtnArray.count == 3) {
                UIButton *badBtn = [_selectedBadBtnArray firstObject];
                badBtn.layer.borderColor = XZRGB(0xe9e9e9).CGColor;
                badBtn.selected = NO;
                [_selectedBadBtnArray removeObject:badBtn];
            }
            
            [_selectedBadBtnArray addObject:btn];
            
            
            for (UIButton *goodBtn in _selectedGoodBtnArray) {
                goodBtn.layer.borderColor = XZRGB(0xe9e9e9).CGColor;
                goodBtn.selected = NO;
            }
            [_selectedGoodBtnArray removeAllObjects];
            [_selectedIds removeAllObjects];
            
        } else {
            btn.layer.borderColor = XZRGB(0xe9e9e9).CGColor;
            [_selectedBadBtnArray removeObject:btn];
        }
        btn.selected = !btn.selected;
        
        NSInteger score = 5-_selectedBadBtnArray.count;
        _starRateView.currentScore = score;
        
    } else {
        
        _starRateView.currentScore = 5;
        
        //好评
        if (!btn.selected) {
            btn.layer.borderColor = XZRGB(0xAE4FFD).CGColor;
            
            if (_selectedGoodBtnArray.count == 3) {
                UIButton *goodBtn = [_selectedGoodBtnArray firstObject];
                goodBtn.layer.borderColor = XZRGB(0xe9e9e9).CGColor;
                goodBtn.selected = NO;
                [_selectedGoodBtnArray removeObject:goodBtn];
                NSString *idStr = [_selectedIds firstObject];
                [_selectedIds removeObject:idStr];
            }
            
            [_selectedGoodBtnArray addObject:btn];
            NSInteger index = btn.tag-100;
            imageLabelHandle *handle = goodArray[index];
            NSString *idStr = [NSString stringWithFormat:@"%@", handle.t_id];
            [_selectedIds addObject:idStr];
            
            for (UIButton *badBtn in _selectedBadBtnArray) {
                badBtn.layer.borderColor = XZRGB(0xe9e9e9).CGColor;
                badBtn.selected = NO;
            }
            [_selectedBadBtnArray removeAllObjects];
            
        } else {
            btn.layer.borderColor = XZRGB(0xe9e9e9).CGColor;
            [_selectedGoodBtnArray removeObject:btn];
            NSInteger index = btn.tag-100;
            imageLabelHandle *handle = goodArray[index];
            NSString *idStr = [NSString stringWithFormat:@"%@", handle.t_id];
            [_selectedIds removeObject:idStr];
        }
        btn.selected = !btn.selected;
    }
}

- (void)clickedOkBtn:(UIButton *)btn {
    
    btn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.userInteractionEnabled = YES;
    });
    
    if (_selectedGoodBtnArray.count == 0 && _selectedBadBtnArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择评价标签"];
        btn.enabled = YES;
        return;
    }
        
    int score = _starRateView.currentScore;
    NSString *labelStr = @"";
    for (NSString *ID  in _selectedIds) {
        if (labelStr.length == 0) {
            labelStr = ID;
        }else{
            labelStr = [labelStr stringByAppendingString:[NSString stringWithFormat:@",%@",ID]];
        }
    }
    [YLNetworkInterface saveCommentUserId:[YLUserDefault userDefault].t_id coverCommUserId:self.otherUserId commScore:score comment:@"" lables:labelStr block:^(BOOL isSuccess) {
        if (isSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}



@end
