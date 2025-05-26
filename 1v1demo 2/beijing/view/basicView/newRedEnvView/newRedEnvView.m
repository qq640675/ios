//
//  newRedEnvView.m
//  beijing
//
//  Created by zhou last on 2018/10/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "newRedEnvView.h"
#import <Masonry.h>
#import "DefineConstants.h"
#import "YLBasicView.h"
#import "YLTapGesture.h"
#import "giftListHandle.h"
#import "NSString+Util.h"
#import <UIImageView+WebCache.h>

@interface newRedEnvView ()
{
    UIView *lastTapView; //礼物
    UIView *lastRedTapView;//红包
    NSMutableArray *giftListArray; //礼物
}

@property (nonatomic ,strong) YLNewRedEnvBlock redEnvBlock;
@property (nonatomic ,strong) YLNewRedEnvBlock giftBlock;

@end

@implementation newRedEnvView

#pragma mark ---- 圆角
- (void)cordius{
    [self.dashangBtn.layer setCornerRadius:15.];
    [self.dashangBtn setClipsToBounds:YES];
}

#pragma mark ---- 移除滚动框的子视图
- (void)removeScrollViewSubviews
{
    [self.giftScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark ---- 99
- (void)redEnvViewTap:(UITapGestureRecognizer *)tap
{
    
    [lastRedTapView.layer setBorderWidth:0.];
    [lastRedTapView.layer setBorderColor:KCLEARCOLOR.CGColor];
    
    [tap.view.layer setBorderWidth:1.];
    [tap.view.layer setBorderColor:XZRGB(0xAE4FFD).CGColor];
    lastRedTapView = tap.view;
    
    self.redEnvBlock((int)tap.view.tag,@"[金币]",@"",@"",(int)tap.view.tag);
}


#pragma mark ---- 礼物
- (void)createGift:(NSMutableArray *)array block:(nonnull YLNewRedEnvBlock)block
{
    giftListArray = [NSMutableArray array];
    giftListArray = array;
    self.giftBlock = block;
    float orightX = 0.;
    float orighY = 0.;
    float width = App_Frame_Width/4.;
    float heigh = 212/2.;
    int page = 0;
    
    for (int index = 0; index < array.count; index ++) {
        giftListHandle *handle = array[index];
        
        //背景
        UIView *giftBgView = [UIView new];
        giftBgView.frame = CGRectMake(orightX, orighY, width, heigh - .5);
        giftBgView.backgroundColor = KCLEARCOLOR;
        giftBgView.userInteractionEnabled = YES;
        giftBgView.tag = index;
        [YLTapGesture tapGestureTarget:self sel:@selector(giftViewTap:) view:giftBgView];
        [self.giftScrollView addSubview:giftBgView];
        
        //竖线
        UIView *verticallineView = [UIView new];
        verticallineView.backgroundColor = XZRGB(0x474752);
        verticallineView.frame = CGRectMake(orightX + width, orighY, 1, heigh);
        [self.giftScrollView addSubview:verticallineView];
        
        //横线
        UIView *HorizontalView = [UIView new];
        HorizontalView.backgroundColor = XZRGB(0x474752);
        HorizontalView.frame = CGRectMake(orightX, orighY + heigh, width, 1);
        [self.giftScrollView addSubview:HorizontalView];
        
        //礼物
        UIImageView *giftImgView = [UIImageView new];
        if (![NSString isNullOrEmpty:handle.t_gift_still_url]) {
            [giftImgView sd_setImageWithURL:[NSURL URLWithString:handle.t_gift_still_url] placeholderImage:[UIImage imageNamed:@"loading"]];
        }
        [giftBgView addSubview:giftImgView];
        [giftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(giftBgView.frame.size.width/2. - 23);
            make.top.mas_equalTo(13);
            make.width.mas_equalTo(46);
            make.height.mas_equalTo(46);
        }];
        
        //礼物名称
        UILabel *giftNameLabel = [YLBasicView createLabeltext:handle.t_gift_name size:PingFangSCFont(10) color:KWHITECOLOR textAlignment:NSTextAlignmentCenter];
        [giftBgView addSubview:giftNameLabel];
        [giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(3);
            make.top.mas_equalTo(giftImgView.mas_bottom).offset(9);
            make.width.mas_equalTo(width - 6);
            make.height.mas_equalTo(10);
        }];
        
        //金币数
        UILabel *coinLabel = [YLBasicView createLabeltext:[NSString stringWithFormat:@"%@金币",handle.t_gift_gold] size:PingFangSCFont(10) color:XZRGB(0xff9a28) textAlignment:NSTextAlignmentCenter];
        [giftBgView addSubview:coinLabel];
        [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(3);
            make.top.mas_equalTo(giftNameLabel.mas_bottom).offset(8);
            make.width.mas_equalTo(width - 6);
            make.height.mas_equalTo(10);
        }];
        
        
        if ((index + 1) % 8 == 0) {
            //n页
            page ++;
            orighY = 0.;
            orightX = page * App_Frame_Width;
        }else{
            if ((index + 1) % 4 == 0) {
                orightX = page * App_Frame_Width;
                orighY = 214/2.;
            }else{
                orightX += width;
            }
        }
    }
    
    if (array.count/8 == array.count/8.) {
        self.giftScrollView.contentSize = CGSizeMake(App_Frame_Width * array.count/8, 212);
    }else{
        self.giftScrollView.contentSize = CGSizeMake(App_Frame_Width * (array.count/8 + 1), 212);
    }
}

- (void)giftViewTap:(UITapGestureRecognizer *)tap
{
    [lastTapView.layer setBorderWidth:0.];
    [lastTapView.layer setBorderColor:KCLEARCOLOR.CGColor];

    [tap.view.layer setBorderWidth:1.];
    [tap.view.layer setBorderColor:XZRGB(0xAE4FFD).CGColor];
    
    
    giftListHandle *handle = giftListArray[tap.view.tag];
    int giftId = [handle.t_gift_id intValue];;
    
    lastTapView = tap.view;
    
    self.giftBlock(giftId,[NSString stringWithFormat:@"%@",handle.t_gift_name],handle.t_gift_still_url,handle.t_gift_gif_url,[handle.t_gift_gold intValue]);
}

@end
