//
//  YLGifExtension.m
//  beijing
//
//  Created by zhou last on 2018/6/30.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLGifExtension.h"
#import "DefineConstants.h"
#import "YLBasicView.h"
#import "giftListHandle.h"
#import <UIImageView+WebCache.h>
#import "YLTapGesture.h"

@interface YLGifExtension ()
{
    NSMutableArray     *giftListArray;
    UIView *lastView;
}

@property (nonatomic ,strong) JSONGiftListHandleBlock giftBlock;


@end


@implementation YLGifExtension

#pragma mark ---- 实例
+ (id)shareInstance
{
    static YLGifExtension *giftExtension = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!giftExtension) {
            giftExtension = [YLGifExtension new];
        }
    });
    
    return giftExtension;
}

- (void)createGifView:(NSMutableArray *)gifArray scrollView:(UIScrollView *)scrollView block:(JSONGiftListHandleBlock)block
{
    _giftBlock = block;
    giftListArray = [NSMutableArray array];
    giftListArray = gifArray;
    
    float width = 80;
    float height = 80;
    float x = (App_Frame_Width -320)/5.;
    float y = 0;
    float blank = (App_Frame_Width -320)/5.;
    for (int j= 0; j< gifArray.count; j++) {
        int page = j / 8;
        
        UIView *View = [UIView new];
        View.backgroundColor = KCLEARCOLOR;
        View.frame = CGRectMake(x, y, width, height);
        [View.layer setCornerRadius:5.];
        View.userInteractionEnabled = YES;
        if (j == 0) {
            View.backgroundColor = IColor(220, 220, 220);
            lastView = View;
        }
        View.tag = 100 + j;
        [YLTapGesture tapGestureTarget:self sel:@selector(giftViewTap:) view:View];
        [scrollView addSubview:View];
        
        UIImageView *giftImgView = [UIImageView new];
        giftImgView.frame = CGRectMake(20, 10, 40, 40);
        giftListHandle *Handle = gifArray[j];
        [giftImgView sd_setImageWithURL:[NSURL URLWithString:Handle.t_gift_still_url]];
//        giftImgView.image = [YLBasicView imageCompressFitSizeScale:[UIImage imageNamed:@"testImage"] targetSize:CGSizeMake(40, 40)];
        [giftImgView.layer setCornerRadius:5.];
        giftImgView.contentMode = UIViewContentModeScaleAspectFill;
        [giftImgView setClipsToBounds:YES];
        [View addSubview:giftImgView];
        
        UILabel *gifNameLabel = [UILabel new];
        gifNameLabel.frame = CGRectMake(0, 52, 80, 12);
        gifNameLabel.text = Handle.t_gift_name;
        gifNameLabel.textColor = IColor(38, 38, 38);
        gifNameLabel.textAlignment = NSTextAlignmentCenter;
        gifNameLabel.font = PingFangSCFont(10);
        [View addSubview:gifNameLabel];
        
        UILabel *coinsLabel = [UILabel new];
        coinsLabel.frame = CGRectMake(0, 64, 80, 12);
        coinsLabel.text = [NSString stringWithFormat:@"%@金币",Handle.t_gift_gold];
        coinsLabel.font = PingFangSCFont(10);
        coinsLabel.textColor = IColor(139, 139, 139);
        coinsLabel.textAlignment = NSTextAlignmentCenter;
        [View addSubview:coinsLabel];
        
        
        
        if ((j + 1) % 8 == 0){
            x = blank + App_Frame_Width * (page + 1);
            y = 0;
        }else{
            if ((j+1) % 4 == 0){
                y += height + 1;
                x = blank +page * App_Frame_Width;
            }else{
                x += width + blank;
            }
        }
    }
    
    int page = gifArray.count/8 == (gifArray.count / 8.0) ? (int)gifArray.count/8 : (int)gifArray.count / 8 + 1;
    [scrollView setContentSize:CGSizeMake(page * App_Frame_Width, 162)];
}

- (void)giftViewTap:(UITapGestureRecognizer *)tap
{
    giftListHandle *Handle = giftListArray[tap.view.tag - 100];
    UIView *view = tap.view;
    lastView.backgroundColor = KCLEARCOLOR;
    view.backgroundColor = IColor(220, 220, 220);
    lastView = view;

    _giftBlock(Handle);
}

@end
