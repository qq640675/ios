//
//  YLGiftCabinetController.m
//  beijing
//
//  Created by zhou last on 2018/10/26.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLGiftCabinetController.h"
#import "giftCabinetCell.h"
#import "DefineConstants.h"
#import "giftCabinetView.h"
#import <Masonry.h>
#import "YLNetworkInterface.h"
#import <UIImageView+WebCache.h>
#import "newIntimateHandle.h"
#import "NSString+Util.h"
#import "SVProgressHUD.h"

@interface YLGiftCabinetController ()<UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *giftListArray;//礼物柜
}

@property (weak, nonatomic) IBOutlet UICollectionView *giftCollectView;

@end

@implementation YLGiftCabinetController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self getGiftCabinet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self giftCustomUI];
}

#pragma mark ---- giftCustomUI
- (void)giftCustomUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.giftCollectView registerNib:[UINib nibWithNibName:@"giftCabinetCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"giftCabinetCell"];
    [self.giftCollectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"giftHeadView"];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.giftCollectView.collectionViewLayout;
    layout.headerReferenceSize = CGSizeMake(App_Frame_Width, 55);
    [self.giftCollectView setCollectionViewLayout:layout animated:YES];
}

#pragma mark ---- 礼物柜
- (void)getGiftCabinet
{
    dispatch_queue_t queue = dispatch_queue_create("礼物柜", DISPATCH_QUEUE_CONCURRENT);
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        self->giftListArray = [NSMutableArray array];
        [YLNetworkInterface getAnthorGiftList:self.godId block:^(NSMutableArray *listArray) {
            self->giftListArray = listArray;
            if (listArray.count == 0){
                [SVProgressHUD showInfoWithStatus:@"没有数据"];
            }
            
            [self.giftCollectView reloadData];
        }];
    });
}

#pragma mark ---- uicollectionView
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"giftHeadView" forIndexPath:indexPath];
        reusableview = headerV;
        
        headerV.backgroundColor = KWHITECOLOR;

        
        NSArray *xibArray = [[NSBundle mainBundle]loadNibNamed:@"giftCabinetView" owner:nil options:nil];
        giftCabinetView *giftCView = xibArray[0];
        [headerV addSubview:giftCView];
        
        if (giftListArray.count == 0) {
            giftCView.giftTotalLabel.text = @"0";
        }else{
            newIntimateHandle *handle = giftListArray[0];
            giftCView.giftTotalLabel.text = [NSString stringWithFormat:@"%d",handle.total];
        }
      
        
        [giftCView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(App_Frame_Width);
            make.height.mas_equalTo(55);
        }];
    }
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID=@"giftCabinetCell";
    giftCabinetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    newIntimateHandle *handle = giftListArray[indexPath.row];
    //礼物图片
    if (![NSString isNullOrEmpty:handle.t_gift_still_url]) {
        [cell.giftImgView sd_setImageWithURL:[NSURL URLWithString:handle.t_gift_still_url] placeholderImage:[UIImage imageNamed:@"loading"]];
    }
    
    //数量
    cell.giftPriceLabel.text = [NSString stringWithFormat:@"×%d",handle.totalCount];
    
    //礼物名称
    cell.giftNameLabel.text = handle.t_gift_name;
    
    return cell;
}

//* 每组cell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return giftListArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//#pragma mark -- UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    return CGSizeMake((App_Frame_Width - 15)/2., 214);
    
    if (IS_iPhone_5 || IS_iPhone_4S) {
        return CGSizeMake((App_Frame_Width -2 )/3., 140.);
    }else{
        return CGSizeMake((App_Frame_Width -3 )/4., 140.);
    }
}

//* section的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
     return 1.;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
     return 1.;
}



@end
