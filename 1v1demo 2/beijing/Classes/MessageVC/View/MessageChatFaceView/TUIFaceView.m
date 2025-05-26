//
//  TUIFaceView.m
//  UIKit
//
//  Created by kennethmiao on 2018/9/18.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "TUIFaceView.h"
#import "TUIFaceCell.h"
#import "TUIImageCache.h"
#import "BaseView.h"


@implementation TFaceGroup
@end


@interface TUIFaceView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *faceGroups;
@property (nonatomic, strong) NSMutableArray *sectionIndexInGroup;
@property (nonatomic, strong) NSMutableArray *pageCountInGroup;
@property (nonatomic, strong) NSMutableArray *groupIndexInSection;
@property (nonatomic, strong) NSMutableDictionary *itemIndexs;
@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) NSInteger curGroupIndex;
@end

@implementation TUIFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupViews];
        [self defaultLayout];
    }
    return self;
}

- (void)setupViews
{
    self.backgroundColor = XZRGB(0xe7e9f2);
    
    _faceFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    _faceFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _faceFlowLayout.minimumLineSpacing = 12.0f;
    _faceFlowLayout.minimumInteritemSpacing = 12.0f;
    _faceFlowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    _faceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_faceFlowLayout];
    [_faceCollectionView registerClass:[TUIFaceCell class] forCellWithReuseIdentifier:@"TUIFaceCell"];
    _faceCollectionView.collectionViewLayout = _faceFlowLayout;
    _faceCollectionView.pagingEnabled = YES;
    _faceCollectionView.delegate = self;
    _faceCollectionView.dataSource = self;
    _faceCollectionView.showsHorizontalScrollIndicator = NO;
    _faceCollectionView.showsVerticalScrollIndicator = NO;
    _faceCollectionView.backgroundColor = self.backgroundColor;
    _faceCollectionView.alwaysBounceHorizontal = YES;
    [self addSubview:_faceCollectionView];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor clearColor];
    [self addSubview:_lineView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_pageControl];
    
    _sendBtn = [UIManager initWithButton:CGRectZero text:@"发送" font:15.0f textColor:[UIColor whiteColor] normalImg:nil highImg:nil selectedImg:nil];
    _sendBtn.backgroundColor = [UIColor colorWithRed:44/255.0 green:145/255.0 blue:247/255.0 alpha:1.0];
    [_sendBtn addTarget:self action:@selector(clickedSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendBtn];
}

- (void)defaultLayout
{
    _lineView.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    _pageControl.frame = CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30);
    _sendBtn.frame = CGRectMake(self.frame.size.width-70, self.frame.size.height - 30, 50, 30);
    _faceCollectionView.frame = CGRectMake(0, _lineView.frame.origin.y + _lineView.frame.size.height + 12, self.frame.size.width, self.frame.size.height - _pageControl.frame.size.height - _lineView.frame.size.height - 2 * 12);
}

- (void)clickedSendBtn {
    if (_delegate && [_delegate respondsToSelector:@selector(faceViewDidSendMsg:)]) {
        [_delegate faceViewDidSendMsg:self];
    }
}


- (void)setData:(NSArray *)data
{
    _faceGroups = data;
    [self defaultLayout];
    
    _sectionIndexInGroup = [NSMutableArray array];
    _groupIndexInSection = [NSMutableArray array];
    _itemIndexs = [NSMutableDictionary dictionary];
    _pageCountInGroup = [NSMutableArray array];
    
    NSInteger sectionIndex = 0;
    for (NSInteger groupIndex = 0; groupIndex < _faceGroups.count; ++groupIndex) {
        TFaceGroup *group = _faceGroups[groupIndex];
        [_sectionIndexInGroup addObject:@(sectionIndex)];
        int itemCount = group.rowCount * group.itemCountPerRow;
        int sectionCount = ceil(group.faces.count * 1.0 / (itemCount  - (group.needBackDelete ? 1 : 0)));
        [_pageCountInGroup addObject:@(sectionCount)];
        for (int sectionIndex = 0; sectionIndex < sectionCount; ++sectionIndex) {
            [_groupIndexInSection addObject:@(groupIndex)];
        }
        sectionIndex += sectionCount;
    }
    _sectionCount = sectionIndex;
    
    
    for (NSInteger curSection = 0; curSection < _sectionCount; ++curSection) {
        NSNumber *groupIndex = _groupIndexInSection[curSection];
        NSNumber *groupSectionIndex = _sectionIndexInGroup[groupIndex.integerValue];
        TFaceGroup *face = _faceGroups[groupIndex.integerValue];
        NSInteger itemCount = face.rowCount * face.itemCountPerRow - face.needBackDelete;
        NSInteger groupSection = curSection - groupSectionIndex.integerValue;
        for (NSInteger itemIndex = 0; itemIndex < itemCount; ++itemIndex) {
            // transpose line/row
            NSInteger row = itemIndex % face.rowCount;
            NSInteger column = itemIndex / face.rowCount;
            NSInteger reIndex = face.itemCountPerRow * row + column + groupSection * itemCount;
            [_itemIndexs setObject:@(reIndex) forKey:[NSIndexPath indexPathForRow:itemIndex inSection:curSection]];
        }
    }

    _curGroupIndex = 0;
    if(_pageCountInGroup.count != 0){
        _pageControl.numberOfPages = [_pageCountInGroup[0] intValue];
    }
    [_faceCollectionView reloadData];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _sectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int groupIndex = [_groupIndexInSection[section] intValue];
    TFaceGroup *group = _faceGroups[groupIndex];
    return group.rowCount * group.itemCountPerRow;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TUIFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TUIFaceCell" forIndexPath:indexPath];
    int groupIndex = [_groupIndexInSection[indexPath.section] intValue];
    TFaceGroup *group = _faceGroups[groupIndex];
    int itemCount = group.rowCount * group.itemCountPerRow;
    if(indexPath.row == itemCount - 1 && group.needBackDelete){
        TFaceCellData *data = [[TFaceCellData alloc] init];
        data.path = TUIKitFace(@"del_normal");;
        [cell setData:data];
    }
    else{
        NSNumber *index = [_itemIndexs objectForKey:indexPath];
        if(index.integerValue < group.faces.count){
            TFaceCellData *data = group.faces[index.integerValue];
            [cell setData:data];
        }
        else{
            [cell setData:nil];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int groupIndex = [_groupIndexInSection[indexPath.section] intValue];
    TFaceGroup *faces = _faceGroups[groupIndex];
    int itemCount = faces.rowCount * faces.itemCountPerRow;
    if(indexPath.row == itemCount - 1 && faces.needBackDelete){
        if(_delegate && [_delegate respondsToSelector:@selector(faceViewDidBackDelete:)]){
            [_delegate faceViewDidBackDelete:self];
        }
    }
    else{
        NSNumber *index = [_itemIndexs objectForKey:indexPath];
        if(index.integerValue < faces.faces.count){
            if(_delegate && [_delegate respondsToSelector:@selector(faceView:didSelectItemAtIndexPath:)]){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index.integerValue inSection:groupIndex];
                [_delegate faceView:self didSelectItemAtIndexPath:indexPath];
            }
        }
        else{
            
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int groupIndex = [_groupIndexInSection[indexPath.section] intValue];
    TFaceGroup *group = _faceGroups[groupIndex];
    CGFloat width = (self.frame.size.width - 20 * 2 - 12 * (group.itemCountPerRow - 1)) / group.itemCountPerRow;
    CGFloat height = (collectionView.frame.size.height -  12 * (group.rowCount - 1)) / group.rowCount;
    return CGSizeMake(width, height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger curSection = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSNumber *groupIndex = _groupIndexInSection[curSection];
    NSNumber *startSection = _sectionIndexInGroup[groupIndex.integerValue];
    NSNumber *pageCount = _pageCountInGroup[groupIndex.integerValue];
    if(_curGroupIndex != groupIndex.integerValue){
        _curGroupIndex = groupIndex.integerValue;
        _pageControl.numberOfPages = pageCount.integerValue;
//        if(_delegate && [_delegate respondsToSelector:@selector(faceView:scrollToFaceGroupIndex:)]){
//            [_delegate faceView:self scrollToFaceGroupIndex:_curGroupIndex];
//        }
    }
    _pageControl.currentPage = curSection - startSection.integerValue;
}


- (void)scrollToFaceGroupIndex:(NSInteger)index
{
    if(index > _sectionIndexInGroup.count){
        return;
    }
    NSNumber *start = _sectionIndexInGroup[index];
    NSNumber *count = _pageCountInGroup[index];
    NSInteger curSection = ceil(_faceCollectionView.contentOffset.x / _faceCollectionView.frame.size.width);
    if(curSection > start.integerValue && curSection < start.integerValue + count.integerValue){
        return;
    }
    CGRect rect = CGRectMake(start.integerValue * _faceCollectionView.frame.size.width, 0, _faceCollectionView.frame.size.width, _faceCollectionView.frame.size.height);
    [_faceCollectionView scrollRectToVisible:rect animated:NO];
    [self scrollViewDidScroll:_faceCollectionView];
}
@end
