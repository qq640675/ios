//
//  LFPhotoPickerController.m
//  LFImagePickerController
//
//  Created by LamTsanFeng on 2017/2/13.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "LFPhotoPickerController.h"
#import "LFImagePickerController.h"
#import "LFImagePickerController+property.h"
#import "LFPhotoPreviewController.h"

#import "LFImagePickerHeader.h"
#import "UIView+LFFrame.h"
#import "UIView+LFAnimate.h"
#import "UIImage+LFCommon.h"
#import "UIImage+LF_Format.h"

#import "LFAlbum.h"
#import "LFAsset.h"
#import "LFAssetCell.h"
#import "LFAssetManager+Authorization.h"
#import "LFAssetManager+SaveAlbum.h"

#ifdef LF_MEDIAEDIT
#import "LFPhotoEditManager.h"
#import "LFPhotoEdit.h"
#import "LFVideoEditManager.h"
#import "LFVideoEdit.h"
#endif

#import <MobileCoreServices/UTCoreTypes.h>

#define kBottomToolBarHeight 50.f

@interface LFCollectionView : UICollectionView

@end

@implementation LFCollectionView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end

@interface LFPhotoPickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    UIView *_bottomSubToolBar;
    UIButton *_editButton;
    UIButton *_previewButton;
    UIButton *_doneButton;
    
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLabel;
    
    BOOL _shouldScrollToBottom;
    BOOL _showTakePhotoBtn;
}
@property (nonatomic, weak) UIView *nonePhotoView;
@property (nonatomic, weak) LFCollectionView *collectionView;
@property (nonatomic, weak) UIView *bottomToolBar;

@property (nonatomic, strong) NSMutableArray <LFAsset *>*models;

@property (nonatomic, assign) BOOL isPhotoPreview;
@property (nonatomic, copy) void (^doneButtonClickBlock)(void);

@end

@interface LFPhotoPickerController () <UIViewControllerPreviewingDelegate, PHPhotoLibraryChangeObserver>

@end

@implementation LFPhotoPickerController

/** 图片预览模式 */
- (instancetype)initWithPhotos:(NSArray <LFAsset *>*)photos completeBlock:(void (^)(void))completeBlock
{
    self = [super init];
    if (self) {
        _isPhotoPreview = YES;
        _models = [NSMutableArray arrayWithArray:photos];
        _doneButtonClickBlock = completeBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    self.view.backgroundColor = [UIColor whiteColor];
    _shouldScrollToBottom = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:imagePickerVc.cancelBtnTitleStr style:UIBarButtonItemStylePlain target:imagePickerVc action:@selector(cancelButtonClick)];
#pragma clang diagnostic pop
    
    if (!imagePickerVc.isPreview) { /** 非预览模式 */
        /** 优先赋值 */
        self.navigationItem.title = _model.name;
        [imagePickerVc showProgressHUD];
        
        __weak typeof(self) weakSelf = self;
        dispatch_globalQueue_async_safe(^{
            
            long long start = [[NSDate date] timeIntervalSince1970] * 1000;
            void (^initDataHandle)() = ^{
                if (weakSelf.model) {
                    if (weakSelf.model.models.count) { /** 使用缓存数据 */
                        weakSelf.models = [NSMutableArray arrayWithArray:weakSelf.model.models];
                        /** check selected data */
                        dispatch_main_async_safe(^{
                            [weakSelf initSubviews];
                        });
                    } else {
                        /** 倒序情况下。iOS8的result已支持倒序,这里的排序应该为顺序 */
                        BOOL ascending = imagePickerVc.sortAscendingByCreateDate;
                        if (@available(iOS 8.0, *)){
                            if (!imagePickerVc.sortAscendingByCreateDate) {
                                ascending = !imagePickerVc.sortAscendingByCreateDate;
                            }
                        }
                        [[LFAssetManager manager] getAssetsFromFetchResult:weakSelf.model.result allowPickingVideo:imagePickerVc.allowPickingVideo allowPickingImage:imagePickerVc.allowPickingImage fetchLimit:0 ascending:ascending completion:^(NSArray<LFAsset *> *models) {
                            /** 缓存数据 */
                            weakSelf.model.models = models;
                            weakSelf.models = [NSMutableArray arrayWithArray:models];
                            [weakSelf checkDefaultSelectedModels];
                            dispatch_main_async_safe(^{
                                long long end = [[NSDate date] timeIntervalSince1970] * 1000;
                                NSLog(@"%lu Photo loading time-consuming: %lld milliseconds", (unsigned long)models.count, end - start);
                                [weakSelf initSubviews];
                            });
                        }];
                    }
                } else {
                    dispatch_main_async_safe(^{
                        [weakSelf initSubviews];
                    });
                }
            };
            
            if (_model == nil) { /** 没有指定相册，默认显示相片胶卷 */
                if (imagePickerVc.defaultAlbumName) { /** 有指定相册 */
                    [[LFAssetManager manager] getAllAlbums:imagePickerVc.allowPickingVideo allowPickingImage:imagePickerVc.allowPickingImage ascending:imagePickerVc.sortAscendingByCreateDate completion:^(NSArray<LFAlbum *> *models) {
                        for (LFAlbum *album in models) {
                            if (album.count) {
                                if ([[album.name lowercaseString] isEqualToString:[imagePickerVc.defaultAlbumName lowercaseString]]) {
                                    weakSelf.model = album;
                                    break;
                                }
                            }
                        }
                        long long end = [[NSDate date] timeIntervalSince1970] * 1000;
                        NSLog(@"Loading album time-consuming: %lld milliseconds", end - start);
                        initDataHandle();
                    }];
                } else {
                    [[LFAssetManager manager] getCameraRollAlbum:imagePickerVc.allowPickingVideo allowPickingImage:imagePickerVc.allowPickingImage fetchLimit:0 ascending:imagePickerVc.sortAscendingByCreateDate completion:^(LFAlbum *model) {
                        weakSelf.model = model;
                        long long end = [[NSDate date] timeIntervalSince1970] * 1000;
                        NSLog(@"Loading album time-consuming: %lld milliseconds", end - start);
                        initDataHandle();
                    }];
                }
            } else { /** 已存在相册数据 */
                initDataHandle();
            }
        });
        
        if (imagePickerVc.syncAlbum) {
            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];    //创建监听者
        }
    } else if (self.isPhotoPreview) {
        [self checkDefaultSelectedModels];
        [self initSubviews];
    }
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat toolbarHeight = kBottomToolBarHeight;
    if (@available(iOS 11.0, *)) {
        toolbarHeight += self.view.safeAreaInsets.bottom;
    }
    
    CGRect collectionViewRect = [self viewFrameWithoutNavigation];
    collectionViewRect.size.height -= toolbarHeight;
    if (@available(iOS 11.0, *)) {
        collectionViewRect.origin.x += self.view.safeAreaInsets.left;
        collectionViewRect.size.width -= self.view.safeAreaInsets.left + self.view.safeAreaInsets.right;
    }
    _collectionView.frame = collectionViewRect;
    
    /* 适配底部栏 */
    CGFloat yOffset = self.view.height - toolbarHeight;
    _bottomToolBar.frame = CGRectMake(0, yOffset, self.view.width, toolbarHeight);
    
    CGRect bottomToolbarRect = _bottomToolBar.bounds;
    if (@available(iOS 11.0, *)) {
        bottomToolbarRect.origin.x += self.view.safeAreaInsets.left;
        bottomToolbarRect.size.width -= self.view.safeAreaInsets.left + self.view.safeAreaInsets.right;
    }
    _bottomSubToolBar.frame = bottomToolbarRect;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Determine the size of the thumbnails to request from the PHCachingImageManager
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDealloc
{
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    if (imagePickerVc.syncAlbum) {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];    //移除监听者
    }
}

- (void)dealloc
{
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)initSubviews {
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    if (!imagePickerVc.isPreview) {
        if (imagePickerVc.defaultAlbumName && !_model) {
            [imagePickerVc showAlertWithTitle:[NSString stringWithFormat:[NSBundle lf_localizedStringForKey:@"_noDefaultAlbumName"], imagePickerVc.defaultAlbumName] complete:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                if ([imagePickerVc respondsToSelector:@selector(cancelButtonClick)]) {
                    [imagePickerVc performSelector:@selector(cancelButtonClick)];
                }
#pragma clang diagnostic pop
            }];
        }
    }
    /** 可能没有model的情况，补充赋值 */
    self.navigationItem.title = _model.name;
    [imagePickerVc hideProgressHUD];

    _showTakePhotoBtn = imagePickerVc.allowTakePicture;
    
    if (_models.count == 0 && !_showTakePhotoBtn) {
        [self configNonePhotoView];
    } else {
        [self configCollectionView];
        [self configBottomToolBar];
        [self scrollCollectionViewToBottom];
    }
    
}

- (void)configNonePhotoView {
    
    if (_nonePhotoView) {
        [_nonePhotoView removeFromSuperview];
    }
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    UIView *nonePhotoView = [[UIView alloc] initWithFrame:[self viewFrameWithoutNavigation]];
    nonePhotoView.backgroundColor = [UIColor clearColor];
    
    NSString *text = [NSBundle lf_localizedStringForKey:@"_LFPhotoPickerController_noMediaTipText"];
    if (!imagePickerVc.allowPickingImage && imagePickerVc.allowPickingVideo) {
        text = [NSBundle lf_localizedStringForKey:@"_LFPhotoPickerController_noVideoTipText"];
    } else if (imagePickerVc.allowPickingImage && !imagePickerVc.allowPickingVideo) {
        text = [NSBundle lf_localizedStringForKey:@"_LFPhotoPickerController_noPhotoTipText"];
    }
    UIFont *font = [UIFont systemFontOfSize:18];
    
    UILabel *label = [[UILabel alloc] initWithFrame:nonePhotoView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.text = text;
    label.textColor = [UIColor lightGrayColor];
    
    [nonePhotoView addSubview:label];
    nonePhotoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:nonePhotoView];
    _nonePhotoView = nonePhotoView;
}

- (void)configCollectionView {
    
    if (_collectionView) {
        [_collectionView removeFromSuperview];
        _collectionView = nil;
    }
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = isiPad ? 15 : 8;
    CGFloat screenWidth = MIN(self.view.width, self.view.height);
    CGFloat itemWH = (screenWidth - (imagePickerVc.columnNumber + 1) * margin) / imagePickerVc.columnNumber;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    
    CGRect collectionViewRect = [self viewFrameWithoutNavigation];
    CGFloat toolbarHeight = kBottomToolBarHeight;
    if (@available(iOS 11.0, *)) {
        toolbarHeight += self.view.safeAreaInsets.bottom;
    }
    collectionViewRect.size.height -= toolbarHeight;
    
    LFCollectionView *collectionView = [[LFCollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.alwaysBounceHorizontal = NO;
    collectionView.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    if (_showTakePhotoBtn) {
        collectionView.contentSize = CGSizeMake(self.view.width, ((_models.count + imagePickerVc.columnNumber) / imagePickerVc.columnNumber) * self.view.width);
    } else {
        collectionView.contentSize = CGSizeMake(self.view.width, ((_models.count + imagePickerVc.columnNumber - 1) / imagePickerVc.columnNumber) * self.view.width);
    }
    [collectionView registerClass:[LFAssetCell class] forCellWithReuseIdentifier:@"LFAssetPhotoCell"];
    [collectionView registerClass:[LFAssetCell class] forCellWithReuseIdentifier:@"LFAssetVideoCell"];
    [collectionView registerClass:[LFAssetCameraCell class] forCellWithReuseIdentifier:@"LFAssetCameraCell"];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
}

- (void)configBottomToolBar {
    
    if (_bottomToolBar) {
        [_bottomToolBar removeFromSuperview];
    }
    
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    
    CGFloat height = kBottomToolBarHeight;
    if (@available(iOS 11.0, *)) {
        height += self.view.safeAreaInsets.bottom;
    }
    CGFloat yOffset = self.view.height - height;
    
    UIColor *toolbarBGColor = imagePickerVc.toolbarBgColor;
    UIColor *toolbarTitleColorNormal = imagePickerVc.toolbarTitleColorNormal;
    UIColor *toolbarTitleColorDisabled = imagePickerVc.toolbarTitleColorDisabled;
    UIFont *toolbarTitleFont = imagePickerVc.toolbarTitleFont;
    
    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, yOffset, self.view.width, height)];
    bottomToolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    bottomToolBar.backgroundColor = toolbarBGColor;
    
    UIView *bottomSubToolBar = [[UIView alloc] initWithFrame:bottomToolBar.bounds];
    bottomSubToolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [bottomToolBar addSubview:bottomSubToolBar];
    _bottomSubToolBar = bottomSubToolBar;
    
    CGFloat buttonX = 12;
    
    //    if (imagePickerVc.allowEditing) {
    //        CGFloat editWidth = [imagePickerVc.editBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:toolbarTitleFont} context:nil].size.width + 2;
    //        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _editButton.frame = CGRectMake(10, 3, editWidth, 44);
    //        _editButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //        [_editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //        _editButton.titleLabel.font = toolbarTitleFont;
    //        [_editButton setTitle:imagePickerVc.editBtnTitleStr forState:UIControlStateNormal];
    //        [_editButton setTitle:imagePickerVc.editBtnTitleStr forState:UIControlStateDisabled];
    //        [_editButton setTitleColor:toolbarTitleColorNormal forState:UIControlStateNormal];
    //        [_editButton setTitleColor:toolbarTitleColorDisabled forState:UIControlStateDisabled];
    //        _editButton.enabled = imagePickerVc.selectedModels.count==1;
    //
    //        buttonX = CGRectGetMaxX(_editButton.frame);
    //    }
    
    
    if (imagePickerVc.allowPreview) {
        CGSize previewSize = [imagePickerVc.previewBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:toolbarTitleFont} context:nil].size;
        previewSize.width += 10.f;
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewButton.frame = CGRectMake(buttonX, 0, previewSize.width, kBottomToolBarHeight);
        _previewButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_previewButton addTarget:self action:@selector(previewButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _previewButton.titleLabel.font = toolbarTitleFont;
        [_previewButton setTitle:imagePickerVc.previewBtnTitleStr forState:UIControlStateNormal];
        [_previewButton setTitle:imagePickerVc.previewBtnTitleStr forState:UIControlStateDisabled];
        [_previewButton setTitleColor:toolbarTitleColorNormal forState:UIControlStateNormal];
        [_previewButton setTitleColor:toolbarTitleColorDisabled forState:UIControlStateDisabled];
        _previewButton.enabled = imagePickerVc.selectedModels.count;
        
//        buttonX = CGRectGetMaxX(_previewButton.frame);
    }
    
    
    if (imagePickerVc.allowPickingOriginalPhoto && imagePickerVc.isPreview==NO) {
        CGFloat fullImageWidth = [imagePickerVc.fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:toolbarTitleFont} context:nil].size.width;
        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat originalButtonW = fullImageWidth + 56;
        _originalPhotoButton.frame = CGRectMake((CGRectGetWidth(bottomToolBar.frame)-originalButtonW)/2, 0, originalButtonW, kBottomToolBarHeight);
        _originalPhotoButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _originalPhotoButton.titleLabel.font = toolbarTitleFont;
        [_originalPhotoButton setTitle:imagePickerVc.fullImageBtnTitleStr forState:UIControlStateNormal];
        [_originalPhotoButton setTitle:imagePickerVc.fullImageBtnTitleStr forState:UIControlStateSelected];
        [_originalPhotoButton setTitle:imagePickerVc.fullImageBtnTitleStr forState:UIControlStateDisabled];
        [_originalPhotoButton setTitleColor:toolbarTitleColorNormal forState:UIControlStateNormal];
        [_originalPhotoButton setTitleColor:toolbarTitleColorNormal forState:UIControlStateSelected];
        [_originalPhotoButton setTitleColor:toolbarTitleColorDisabled forState:UIControlStateDisabled];
        [_originalPhotoButton setImage:bundleImageNamed(imagePickerVc.photoOriginDefImageName) forState:UIControlStateNormal];
        [_originalPhotoButton setImage:bundleImageNamed(imagePickerVc.photoOriginSelImageName) forState:UIControlStateSelected];
        [_originalPhotoButton setImage:bundleImageNamed(imagePickerVc.photoOriginDefImageName) forState:UIControlStateDisabled];
        
        _originalPhotoLabel = [[UILabel alloc] init];
        _originalPhotoLabel.frame = CGRectMake(fullImageWidth + 46, 0, 80, kBottomToolBarHeight);
        _originalPhotoLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
        _originalPhotoLabel.font = toolbarTitleFont;
        _originalPhotoLabel.textColor = toolbarTitleColorNormal;
        
        [_originalPhotoButton addSubview:_originalPhotoLabel];
    }
    
    
    CGSize doneSize = [[imagePickerVc.doneBtnTitleStr stringByAppendingFormat:@"(%ld)", (long)imagePickerVc.maxImagesCount] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:toolbarTitleFont} context:nil].size;
    doneSize.height = MIN(MAX(doneSize.height, height), 30);
    doneSize.width += 10;
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(self.view.width - doneSize.width - 12, (kBottomToolBarHeight-doneSize.height)/2, doneSize.width, doneSize.height);
    _doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    _doneButton.titleLabel.font = toolbarTitleFont;
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:imagePickerVc.doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton setTitle:imagePickerVc.doneBtnTitleStr forState:UIControlStateDisabled];
    [_doneButton setTitleColor:toolbarTitleColorNormal forState:UIControlStateNormal];
    [_doneButton setTitleColor:toolbarTitleColorDisabled forState:UIControlStateDisabled];
    _doneButton.layer.cornerRadius = CGRectGetHeight(_doneButton.frame)*0.2;
    _doneButton.layer.masksToBounds = YES;
    _doneButton.enabled = imagePickerVc.selectedModels.count;
    _doneButton.backgroundColor = _doneButton.enabled ? imagePickerVc.oKButtonTitleColorNormal : imagePickerVc.oKButtonTitleColorDisabled;
    
    UIView *divide = [[UIView alloc] init];
    divide.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.1f];
    divide.frame = CGRectMake(0, 0, self.view.width, 1);
    divide.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    [bottomSubToolBar addSubview:_editButton];
    [bottomSubToolBar addSubview:_previewButton];
    [bottomSubToolBar addSubview:_originalPhotoButton];
    [bottomSubToolBar addSubview:_doneButton];
    [bottomSubToolBar addSubview:divide];
    [self.view addSubview:bottomToolBar];
    _bottomToolBar = bottomToolBar;
    
    [self refreshBottomToolBarStatus];
}

#pragma mark - Click Event
//- (void)editButtonClick {
//    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
//    NSArray *models = [imagePickerVc.selectedModels copy];
//    LFPhotoPreviewController *photoPreviewVc = [[LFPhotoPreviewController alloc] initWithModels:_models index:[_models indexOfObject:models.firstObject] excludeVideo:NO];
//    LFPhotoEditingController *photoEditingVC = [[LFPhotoEditingController alloc] init];
//    
//    /** 抽取第一个对象 */
//    LFAsset *model = models.firstObject;
//    /** 获取缓存编辑对象 */
//    LFPhotoEdit *photoEdit = [[LFPhotoEditManager manager] photoEditForAsset:model];
//    if (photoEdit) {
//        photoEditingVC.photoEdit = photoEdit;
//    } else if (model.previewImage) { /** 读取自定义图片 */
//        photoEditingVC.editImage = model.previewImage;
//    } else {
//        /** 获取对应的图片 */
//        [[LFAssetManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
//            photoEditingVC.editImage = photo;
//        }];
//    }
//    [self pushPhotoPrevireViewController:photoPreviewVc photoEditingViewController:photoEditingVC];
//}

- (void)previewButtonClick {
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    NSArray *models = [imagePickerVc.selectedModels copy];
    LFPhotoPreviewController *photoPreviewVc = [[LFPhotoPreviewController alloc] initWithModels:models index:0];
    photoPreviewVc.alwaysShowPreviewBar = YES;
    [self pushPhotoPrevireViewController:photoPreviewVc];
}

- (void)originalPhotoButtonClick {
    
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    
    _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    imagePickerVc.isSelectOriginalPhoto = _originalPhotoButton.isSelected;;
    if (_originalPhotoButton.selected) {
        [self getSelectedPhotoBytes];
        [self checkSelectedPhotoBytes];
    } else {
        _originalPhotoLabel.text = nil;
    }
    
}

- (void)doneButtonClick {
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    
    // 判断是否满足最小必选张数的限制
    if (imagePickerVc.maxImagesCount != imagePickerVc.maxVideosCount && imagePickerVc.selectedModels.firstObject.type == LFAssetMediaTypeVideo) {
        
        if (imagePickerVc.minVideosCount && imagePickerVc.selectedModels.count < imagePickerVc.minVideosCount) {
            NSString *title = [NSString stringWithFormat:[NSBundle lf_localizedStringForKey:@"_minSelectVideoTipText"], imagePickerVc.minVideosCount];
            [imagePickerVc showAlertWithTitle:title];
            return;
        }
        
    } else {
        if (imagePickerVc.minImagesCount && imagePickerVc.selectedModels.count < imagePickerVc.minImagesCount) {
            NSString *title = [NSString stringWithFormat:[NSBundle lf_localizedStringForKey:@"_minSelectPhotoTipText"], imagePickerVc.minImagesCount];
            [imagePickerVc showAlertWithTitle:title];
            return;
        }
    }
    
    if (self.doneButtonClickBlock) {
        self.doneButtonClickBlock();
    } else {
        if (imagePickerVc.selectedModels.count == 1) {
            [imagePickerVc showProgressHUD];
        } else {
            [imagePickerVc showNeedProgressHUD];
        }
        NSMutableArray *resultArray = [NSMutableArray array];
        
        __weak typeof(self) weakSelf = self;
        
        dispatch_globalQueue_async_safe(^{
            
            if (imagePickerVc.selectedModels.count) {
                
                for (NSInteger i = 0; i < imagePickerVc.selectedModels.count; i++) { [resultArray addObject:@0];}
                
                dispatch_group_t _group = dispatch_group_create();
                int limitQueueCount = 1;
                __block int queueCount = 0;
                __block CGFloat process = 0.f;

                void (^resultComplete)(LFResultObject *, NSInteger) = ^(LFResultObject *result, NSInteger index) {
                    if (result) {
                        [resultArray replaceObjectAtIndex:index withObject:result];
                    } else {
                        LFAsset *model = [imagePickerVc.selectedModels objectAtIndex:index];
                        LFResultObject *object = [LFResultObject errorResultObject:model.asset];
                        [resultArray replaceObjectAtIndex:index withObject:object];
                    }
                    dispatch_main_async_safe(^{
                        process += 1.f;
                        [imagePickerVc setProcess:process/resultArray.count];
                    });
                    dispatch_group_leave(_group);
                    queueCount--;
                };
                for (NSInteger i = 0; i < imagePickerVc.selectedModels.count; i++) {
                    LFAsset *model = imagePickerVc.selectedModels[i];
                    dispatch_group_enter(_group);
                    queueCount++;
                    if (model.type == LFAssetMediaTypePhoto) {
#ifdef LF_MEDIAEDIT
                        LFPhotoEdit *photoEdit = [[LFPhotoEditManager manager] photoEditForAsset:model];
                        if (photoEdit) {
                            [[LFPhotoEditManager manager] getPhotoWithAsset:model
                                                                 isOriginal:imagePickerVc.isSelectOriginalPhoto
                                                               compressSize:imagePickerVc.imageCompressSize
                                                      thumbnailCompressSize:imagePickerVc.thumbnailCompressSize
                                                                 completion:^(LFResultImage *resultImage) {
                                                                     
                                                                     if (imagePickerVc.autoSavePhotoAlbum) {
                                                                         /** 编辑图片保存到相册 */
                                                                         [[LFAssetManager manager] saveImageToCustomPhotosAlbumWithTitle:nil imageDatas:@[resultImage.originalData] complete:nil];
                                                                     }
                                                                     resultComplete(resultImage, i);
                                                                 }];
                        } else {
#endif
                            if (imagePickerVc.allowPickingLivePhoto && model.subType == LFAssetSubMediaTypeLivePhoto && model.closeLivePhoto == NO) {
                                [[LFAssetManager manager] getLivePhotoWithAsset:model.asset
                                                                     isOriginal:imagePickerVc.isSelectOriginalPhoto
                                                                     completion:^(LFResultImage *resultImage) {
                                                                         
                                                                         resultComplete(resultImage, i);
                                                                     }];
                            } else {
                                [[LFAssetManager manager] getPhotoWithAsset:model.asset
                                                                 isOriginal:imagePickerVc.isSelectOriginalPhoto
                                                                 pickingGif:imagePickerVc.allowPickingGif
                                                               compressSize:imagePickerVc.imageCompressSize
                                                      thumbnailCompressSize:imagePickerVc.thumbnailCompressSize
                                                                 completion:^(LFResultImage *resultImage) {
                                                                     
                                                                     resultComplete(resultImage, i);
                                                                 }];
                            }
#ifdef LF_MEDIAEDIT
                        }
#endif
                    } else if (model.type == LFAssetMediaTypeVideo) {
#ifdef LF_MEDIAEDIT
                        LFVideoEdit *videoEdit = [[LFVideoEditManager manager] videoEditForAsset:model];
                        if (videoEdit) {
                            [[LFVideoEditManager manager] getVideoWithAsset:model presetName:imagePickerVc.videoCompressPresetName completion:^(LFResultVideo *resultVideo) {
                                if (imagePickerVc.autoSavePhotoAlbum) {
                                    /** 编辑视频保存到相册 */
                                    [[LFAssetManager manager] saveVideoToCustomPhotosAlbumWithTitle:nil videoURLs:@[resultVideo.url] complete:nil];
                                }
                                resultComplete(resultVideo, i);
                            }];
                        } else {
#endif
                            [[LFAssetManager manager] getVideoResultWithAsset:model.asset presetName:imagePickerVc.videoCompressPresetName cache:imagePickerVc.autoVideoCache completion:^(LFResultVideo *resultVideo) {
                                resultComplete(resultVideo, i);
                            }];
#ifdef LF_MEDIAEDIT
                        }
#endif
                    }
                    if (queueCount == limitQueueCount) {
                        dispatch_group_wait(_group, DISPATCH_TIME_FOREVER);
                    }
                }
                dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [imagePickerVc hideProgressHUD];
                        if (imagePickerVc.autoDismiss) {
                            [imagePickerVc dismissViewControllerAnimated:YES completion:^{
                                [weakSelf callDelegateMethodWithResults:resultArray];
                            }];
                        } else {
                            [weakSelf callDelegateMethodWithResults:resultArray];
                        }
                    });
                });
            } else {
                dispatch_main_async_safe(^{
                    [imagePickerVc hideProgressHUD];
                    if (imagePickerVc.autoDismiss) {
                        [imagePickerVc dismissViewControllerAnimated:YES completion:^{
                            [weakSelf callDelegateMethodWithResults:resultArray];
                        }];
                    } else {
                        [weakSelf callDelegateMethodWithResults:resultArray];
                    }
                });
            }
            
        });
    }
    
    
}

- (void)callDelegateMethodWithResults:(NSArray <LFResultObject *>*)results {
    
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    id <LFImagePickerControllerDelegate> pickerDelegate = (id <LFImagePickerControllerDelegate>)imagePickerVc.pickerDelegate;
    
    
    if (imagePickerVc.didFinishPickingResultHandle) {
        imagePickerVc.didFinishPickingResultHandle(results);
    } else if ([pickerDelegate respondsToSelector:@selector(lf_imagePickerController:didFinishPickingResult:)]) {
        [pickerDelegate lf_imagePickerController:imagePickerVc didFinishPickingResult:results];
    }
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_showTakePhotoBtn) {
        return _models.count + 1;
    }
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // the cell lead to take a picture / 去拍照的cell
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    if (((imagePickerVc.sortAscendingByCreateDate && indexPath.row >= _models.count) || (!imagePickerVc.sortAscendingByCreateDate && indexPath.row == 0)) && _showTakePhotoBtn) {
        LFAssetCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LFAssetCameraCell" forIndexPath:indexPath];
        cell.posterImage = bundleImageNamed(imagePickerVc.takePictureImageName);
        
        return cell;
    }
    // the cell dipaly photo or video / 展示照片或视频的cell
    LFAssetCell *cell = nil;
    
    NSInteger index = indexPath.row - 1;
    if (imagePickerVc.sortAscendingByCreateDate || !_showTakePhotoBtn) {
        index = indexPath.row;
    }
    LFAsset *model = _models[index];
    
    if (model.type == LFAssetMediaTypePhoto) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LFAssetPhotoCell" forIndexPath:indexPath];
    } else if (model.type == LFAssetMediaTypeVideo) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LFAssetVideoCell" forIndexPath:indexPath];
    }
    
    if (@available(iOS 9.0, *)){
        /** 给cell注册 3DTouch的peek（预览）和pop功能 */
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            //给cell注册3DTouch的peek（预览）和pop功能
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }

    
    [self configCell:cell model:model reloadModel:YES];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(imagePickerVc) weakImagePickerVc = imagePickerVc;
    cell.didSelectPhotoBlock = ^(BOOL isSelected, LFAsset *cellModel, LFAssetCell *weakCell) {
        // 1. cancel select / 取消选择
        if (!isSelected) {
            [weakImagePickerVc.selectedModels removeObject:cellModel];
            
            [weakSelf refreshBottomToolBarStatus];
            
            if (weakImagePickerVc.maxImagesCount != weakImagePickerVc.maxVideosCount) {
                
                BOOL refreshWithoutSelf = NO;
                if (cellModel.type == LFAssetMediaTypePhoto) {
                    if (weakImagePickerVc.selectedModels.count == weakImagePickerVc.maxImagesCount-1) {
                        refreshWithoutSelf = YES;
                    }
                } else if (cellModel.type == LFAssetMediaTypeVideo) {
                    if (weakImagePickerVc.selectedModels.count == weakImagePickerVc.maxVideosCount-1) {
                        refreshWithoutSelf = YES;
                    }
                }
                
                if (refreshWithoutSelf) {
                    /** 刷新除自己所有的cell */
                    [weakSelf refreshAllCellWithoutCell:weakCell];
                } else if (weakImagePickerVc.selectedModels.count == 0) {
                    if (cellModel.type == LFAssetMediaTypePhoto) {
                        [weakSelf refreshVideoCell];
                    } else {
                        [weakSelf refreshImageCell];
                    }
                } else {
                    [weakSelf refreshSelectedCell];
                }
            } else {
                if (weakImagePickerVc.selectedModels.count == weakImagePickerVc.maxImagesCount-1) {
                    /** 取消选择为最大数量-1时，显示其他可选 */
                    [weakSelf refreshAllCellWithoutCell:weakCell];
                } else if (weakImagePickerVc.selectedModels.count == 0 && weakImagePickerVc.maxImagesCount != weakImagePickerVc.maxVideosCount) {
                    
                    if (cellModel.type == LFAssetMediaTypePhoto) {
                        [weakSelf refreshVideoCell];
                    } else {
                        [weakSelf refreshImageCell];
                    }
                } else {
                    [weakSelf refreshSelectedCell];
                }
            }
            
            [weakCell selectPhoto:NO index:0 animated:NO];
            
        } else {
            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            
            void (^selectedItem)() = ^{
                /** 检测是否超过视频最大时长 */
                if (cellModel.type == LFAssetMediaTypeVideo) {
#ifdef LF_MEDIAEDIT
                    LFVideoEdit *videoEdit = [[LFVideoEditManager manager] videoEditForAsset:cellModel];
                    NSTimeInterval duration = videoEdit.editPreviewImage ? videoEdit.duration : cellModel.duration;
#else
                    NSTimeInterval duration = cellModel.duration;
#endif
                    if (duration > weakImagePickerVc.maxVideoDuration) {
                        if (weakImagePickerVc.maxVideoDuration < 60) {
                            [weakImagePickerVc showAlertWithTitle:[NSString stringWithFormat:[NSBundle lf_localizedStringForKey:@"_maxSelectVideoTipText_second"], (int)weakImagePickerVc.maxVideoDuration]];
                        } else {
                            [weakImagePickerVc showAlertWithTitle:[NSString stringWithFormat:[NSBundle lf_localizedStringForKey:@"_maxSelectVideoTipText_minute"], (int)weakImagePickerVc.maxVideoDuration/60]];
                        }
                        return;
                    }
                }
                [weakImagePickerVc.selectedModels addObject:cellModel];
                [weakSelf refreshBottomToolBarStatus];
                
                if (weakImagePickerVc.maxImagesCount != weakImagePickerVc.maxVideosCount) {
                    
                    BOOL refreshNoSelected = NO;
                    if (weakImagePickerVc.selectedModels.firstObject.type == LFAssetMediaTypePhoto) {
                        if (weakImagePickerVc.selectedModels.count == weakImagePickerVc.maxImagesCount) {
                            [weakSelf refreshNoSelectedCell];
                            refreshNoSelected = YES;
                        }
                    } else {
                        if (weakImagePickerVc.selectedModels.count == weakImagePickerVc.maxVideosCount) {
                            [weakSelf refreshNoSelectedCell];
                            refreshNoSelected = YES;
                        }
                    }
                    
                    /** refreshNoSelected后没有必要再次刷新 */
                    if (weakImagePickerVc.selectedModels.count == 1 && !refreshNoSelected) {
                        if (weakImagePickerVc.selectedModels.firstObject.type == LFAssetMediaTypePhoto) {
                            [weakSelf refreshVideoCell];
                        } else {
                            [weakSelf refreshImageCell];
                        }
                    }
                    
                } else if (weakImagePickerVc.selectedModels.count == weakImagePickerVc.maxImagesCount) {
                    /** 选择到最大数量，禁止其他的可选显示 */
                    [weakSelf refreshNoSelectedCell];
                }
                
                [weakCell selectPhoto:YES index:weakImagePickerVc.selectedModels.count animated:YES];
            };
            
            if (weakImagePickerVc.maxImagesCount != weakImagePickerVc.maxVideosCount && cellModel.type == LFAssetMediaTypeVideo) {
                if (weakImagePickerVc.selectedModels.count < weakImagePickerVc.maxVideosCount) {
                    selectedItem();
                } else {
                    NSString *title = [NSString stringWithFormat:[NSBundle lf_localizedStringForKey:@"_maxSelectVideoTipText"], weakImagePickerVc.maxVideosCount];
                    [weakImagePickerVc showAlertWithTitle:title];
                }
                
            } else {
                if (weakImagePickerVc.selectedModels.count < weakImagePickerVc.maxImagesCount) {
                    selectedItem();
                } else {
                    NSString *title = [NSString stringWithFormat:[NSBundle lf_localizedStringForKey:@"_maxSelectPhotoTipText"], weakImagePickerVc.maxImagesCount];
                    [weakImagePickerVc showAlertWithTitle:title];
                }
            }
            
        }
    };
    return cell;
}

- (void)configCell:(LFAssetCell *)cell model:(LFAsset *)model reloadModel:(BOOL)reloadModel
{
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    
    cell.photoDefImageName = imagePickerVc.photoDefImageName;
    cell.photoSelImageName = imagePickerVc.photoNumberIconImageName;
    cell.displayGif = imagePickerVc.allowPickingGif;
    cell.displayLivePhoto = imagePickerVc.allowPickingLivePhoto;
    cell.displayPhotoName = imagePickerVc.displayImageFilename;
    cell.onlySelected = !imagePickerVc.allowPreview;
    /** 优先级低属性，当最大数量为1时只能点击 */
    if (imagePickerVc.maxImagesCount != imagePickerVc.maxVideosCount && model.type == LFAssetMediaTypeVideo) {
        cell.onlyClick = imagePickerVc.maxVideosCount == 1;
    } else {
        cell.onlyClick = imagePickerVc.maxImagesCount == 1;
    }
    /** 最大数量时，非选择部分显示不可选 */
    if (imagePickerVc.maxImagesCount != imagePickerVc.maxVideosCount) {
        /** 不能混合选择的情况 */
        if (imagePickerVc.selectedModels.count) {
            if (imagePickerVc.selectedModels.firstObject.type == LFAssetMediaTypePhoto) {
                cell.noSelected = (imagePickerVc.selectedModels.count == imagePickerVc.maxImagesCount && ![imagePickerVc.selectedModels containsObject:model]);
            } else if (imagePickerVc.selectedModels.firstObject.type == LFAssetMediaTypeVideo){
                cell.noSelected = (imagePickerVc.selectedModels.count == imagePickerVc.maxVideosCount && ![imagePickerVc.selectedModels containsObject:model]);
            }
            if (model.type != imagePickerVc.selectedModels.firstObject.type) {
                cell.noSelected = YES;
            }
        } else {
            cell.noSelected = NO;
        }
    } else {
        cell.noSelected = (imagePickerVc.selectedModels.count == imagePickerVc.maxImagesCount && ![imagePickerVc.selectedModels containsObject:model]);
    }
    
    if (reloadModel) {
        cell.model = model;
    }
    
    [cell selectPhoto:[imagePickerVc.selectedModels containsObject:model]
                index:[imagePickerVc.selectedModels indexOfObject:model]+1
             animated:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // take a photo / 去拍照
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    if (((imagePickerVc.sortAscendingByCreateDate && indexPath.row >= _models.count) || (!imagePickerVc.sortAscendingByCreateDate && indexPath.row == 0)) && _showTakePhotoBtn)  {
        [self takePhoto];
        return;
    }
    // preview phote or video / 预览照片或视频
    NSInteger index = indexPath.row;
    if (!imagePickerVc.sortAscendingByCreateDate && _showTakePhotoBtn) {
        index = indexPath.row - 1;
    }
    LFPhotoPreviewController *photoPreviewVc = [[LFPhotoPreviewController alloc] initWithModels:[_models copy] index:index];
    [self pushPhotoPrevireViewController:photoPreviewVc];
}

#pragma mark - 拍照图片后执行代理
#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    [imagePickerVc showProgressHUDText:nil isTop:YES];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera && [mediaType isEqualToString:@"public.image"]){
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        [[LFAssetManager manager] saveImageToCustomPhotosAlbumWithTitle:nil images:@[chosenImage] complete:^(NSArray<id> *assets, NSError *error) {
            
            if (assets && !error) {
                [[LFAssetManager manager] getPhotoWithAsset:assets.lastObject
                                                 isOriginal:YES
                                                 pickingGif:NO
                                               compressSize:imagePickerVc.imageCompressSize
                                      thumbnailCompressSize:imagePickerVc.thumbnailCompressSize
                                                 completion:^(LFResultImage *resultImage) {
                                                     
                                                     [imagePickerVc hideProgressHUD];
                                                     [picker.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
                                                         [self callDelegateMethodWithResults:@[resultImage]];
                                                     }];
                                                 }];
            }else if (error) {
                [imagePickerVc hideProgressHUD];
                [imagePickerVc showAlertWithTitle:[NSBundle lf_localizedStringForKey:@"_cameraTakePhotoError"] message:error.localizedDescription complete:^{
                    [picker dismissViewControllerAnimated:YES completion:nil];
                }];
            }
        }];
    } else {
        [imagePickerVc hideProgressHUD];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerPreviewingDelegate
/** peek(预览) */
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    
    LFAssetCell *cell = (LFAssetCell* )[previewingContext sourceView];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath) {
        // preview phote or video / 预览照片或视频
        NSInteger index = indexPath.row;
        if (!imagePickerVc.sortAscendingByCreateDate && _showTakePhotoBtn) {
            index = indexPath.row - 1;
        }
        LFPhotoPreviewController *photoPreviewVc = [[LFPhotoPreviewController alloc] initWithModels:[_models copy] index:index];
        [photoPreviewVc beginPreviewing:imagePickerVc];
        
        PHAsset *phAsset = cell.model.asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat pixelWidth = [UIScreen mainScreen].bounds.size.width * 2.0f;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        CGSize imageSize = CGSizeMake(pixelWidth, pixelHeight);
        
        CGSize contentSize = [UIImage lf_scaleImageSizeBySize:imageSize targetSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height) isBoth:NO];
        photoPreviewVc.preferredContentSize = CGSizeMake(contentSize.width, contentSize.height);
        return photoPreviewVc;
    }
    return nil;
}

/** pop（按用点力进入） */
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    LFPhotoPreviewController *photoPreviewVc = (LFPhotoPreviewController *)viewControllerToCommit;
    [self pushPhotoPrevireViewController:photoPreviewVc];
    [photoPreviewVc endPreviewing];
}


#pragma mark - Private Method

- (void)takePhoto {
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        // 无权限 做一个友好的提示
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        NSString *message = [NSString stringWithFormat:[NSBundle lf_localizedStringForKey:@"_cameraLibraryAuthorityTipText"],appName];
        [imagePickerVc showAlertWithTitle:nil cancelTitle:[NSBundle lf_localizedStringForKey:@"_cameraLibraryAuthorityCancelTitle"] message:message complete:^{
            if (@available(iOS 8.0, *)){
                if (@available(iOS 10.0, *)){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            } else {
                NSString *message = [NSBundle lf_localizedStringForKey:@"_PrivacyAuthorityJumpTipText"];
                [imagePickerVc showAlertWithTitle:nil message:message complete:^{
                }];
            }
        }];
        
    } else { // 调用相机
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(lf_imagePickerControllerTakePhoto:)]) {
                [imagePickerVc.pickerDelegate lf_imagePickerControllerTakePhoto:imagePickerVc];
            } else if (imagePickerVc.imagePickerControllerTakePhoto) {
                imagePickerVc.imagePickerControllerTakePhoto();
            } else {
                /** 调用内置相机模块 */
                UIImagePickerControllerSourceType srcType = UIImagePickerControllerSourceTypeCamera;
                UIImagePickerController *mediaPickerController = [[UIImagePickerController alloc] init];
                mediaPickerController.sourceType = srcType;
                mediaPickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                mediaPickerController.delegate = self;
                mediaPickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                
                /** warning：Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates. */
                mediaPickerController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:mediaPickerController animated:YES completion:NULL];
            }
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)refreshSelectedCell
{
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    NSMutableArray <NSIndexPath *>*indexPaths = [NSMutableArray array];
    if (imagePickerVc.selectedModels.count) {
        [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(LFAssetCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([cell isKindOfClass:[LFAssetCell class]] && [imagePickerVc.selectedModels containsObject:cell.model]) {
                NSInteger index = [_models indexOfObject:cell.model];
                if (self->_showTakePhotoBtn && !imagePickerVc.sortAscendingByCreateDate) {
                    index += 1;
                }
                [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
            }
        }];
        if (indexPaths.count) {
            [self.collectionView reloadItemsAtIndexPaths:indexPaths];
        }
    }
}

- (void)refreshNoSelectedCell
{
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    __weak typeof(self) weakSelf = self;
    NSMutableArray <NSIndexPath *>*indexPaths = [NSMutableArray array];
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(LFAssetCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cell isKindOfClass:[LFAssetCell class]] && ![imagePickerVc.selectedModels containsObject:cell.model]) {
            NSInteger index = [weakSelf.models indexOfObject:cell.model];
            if (self->_showTakePhotoBtn && !imagePickerVc.sortAscendingByCreateDate) {
                index += 1;
            }
            [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
    }];
    if (indexPaths.count) {
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }
}

- (void)refreshAllCellWithoutCell:(LFAssetCell *)myCell
{
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    __weak typeof(self) weakSelf = self;
    NSMutableArray <NSIndexPath *>*indexPaths = [NSMutableArray array];
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(LFAssetCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cell isKindOfClass:[LFAssetCell class]] && ![cell isEqual:myCell]) {
            NSInteger index = [weakSelf.models indexOfObject:cell.model];
            if (self->_showTakePhotoBtn && !imagePickerVc.sortAscendingByCreateDate) {
                index += 1;
            }
            [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
    }];
    if (indexPaths.count) {
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }
}

- (void)refreshImageCell
{
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    __weak typeof(self) weakSelf = self;
    NSMutableArray <NSIndexPath *>*indexPaths = [NSMutableArray array];
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(LFAssetCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cell isKindOfClass:[LFAssetCell class]] && cell.model.type == LFAssetMediaTypePhoto) {
            NSInteger index = [weakSelf.models indexOfObject:cell.model];
            if (self->_showTakePhotoBtn && !imagePickerVc.sortAscendingByCreateDate) {
                index += 1;
            }
            [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
    }];
    if (indexPaths.count) {
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }
}
- (void)refreshVideoCell
{
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    __weak typeof(self) weakSelf = self;
    NSMutableArray <NSIndexPath *>*indexPaths = [NSMutableArray array];
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(LFAssetCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cell isKindOfClass:[LFAssetCell class]] && cell.model.type == LFAssetMediaTypeVideo) {
            NSInteger index = [weakSelf.models indexOfObject:cell.model];
            if (self->_showTakePhotoBtn && !imagePickerVc.sortAscendingByCreateDate) {
                index += 1;
            }
            [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
    }];
    if (indexPaths.count) {
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }
}

- (void)refreshBottomToolBarStatus {
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    
    _editButton.enabled = imagePickerVc.selectedModels.count == 1;
    _previewButton.enabled = imagePickerVc.selectedModels.count > 0;
//    _originalPhotoButton.enabled = imagePickerVc.selectedModels.count > 0;
    _doneButton.enabled = imagePickerVc.selectedModels.count;
    _doneButton.backgroundColor = _doneButton.enabled ? imagePickerVc.oKButtonTitleColorNormal : imagePickerVc.oKButtonTitleColorDisabled;
    
    if (imagePickerVc.selectedModels.count) {
        [_doneButton setTitle:[NSString stringWithFormat:@"%@(%zd)", imagePickerVc.doneBtnTitleStr ,imagePickerVc.selectedModels.count] forState:UIControlStateNormal];
    } else {
        [_doneButton setTitle:imagePickerVc.doneBtnTitleStr forState:UIControlStateNormal];
    }
    
    _originalPhotoButton.selected = imagePickerVc.isSelectOriginalPhoto;
    _originalPhotoLabel.hidden = !(_originalPhotoButton.selected && imagePickerVc.selectedModels.count > 0);
    if (!_originalPhotoLabel.hidden) {
        [self getSelectedPhotoBytes];
        [self checkSelectedPhotoBytes];
    }
}

- (void)pushPhotoPrevireViewController:(LFPhotoPreviewController *)photoPreviewVc {
    
    __weak typeof(self) weakSelf = self;
    [photoPreviewVc setBackButtonClickBlock:^{
        [weakSelf.collectionView reloadData];
        [weakSelf refreshBottomToolBarStatus];
    }];
    [photoPreviewVc setDoneButtonClickBlock:^{
        [weakSelf doneButtonClick];
    }];
    
    [self.navigationController pushViewController:photoPreviewVc animated:YES];
}

//- (void)pushPhotoPrevireViewController:(LFPhotoPreviewController *)photoPreviewVc photoEditingViewController:(LFPhotoEditingController *)photoEditingVC {
//
//    /** 关联代理 */
//    photoEditingVC.delegate = (id)photoPreviewVc;
//
//    __weak typeof(self) weakSelf = self;
//    [photoPreviewVc setBackButtonClickBlock:^{
//        [weakSelf.collectionView reloadData];
//        [weakSelf refreshBottomToolBarStatus];
//    }];
//    [photoPreviewVc setDoneButtonClickBlock:^{
//        [weakSelf doneButtonClick];
//    }];
//
//    if (photoEditingVC) {
//        NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
//        [viewControllers addObject:photoPreviewVc];
//        [viewControllers addObject:photoEditingVC];
//        [self.navigationController setViewControllers:viewControllers animated:YES];
//    } else {
//        [self.navigationController pushViewController:photoPreviewVc animated:YES];
//    }
//}

- (void)checkSelectedPhotoBytes {
    __weak typeof(self) weakSelf = self;
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    __weak typeof(imagePickerVc) weakImagePickerVc = imagePickerVc;
    
    NSMutableArray *newSelectedModes = [NSMutableArray arrayWithCapacity:5];
    for (LFAsset *asset in imagePickerVc.selectedModels) {
        if (asset.type == LFAssetMediaTypePhoto) {
#ifdef LF_MEDIAEDIT
            /** 忽略图片被编辑的情况 */
            if (![[LFPhotoEditManager manager] photoEditForAsset:asset]) {
#endif
                [newSelectedModes addObject:asset];
#ifdef LF_MEDIAEDIT
            }
#endif
        }
    }
    
    [[LFAssetManager manager] checkPhotosBytesMaxSize:newSelectedModes maxBytes:imagePickerVc.maxPhotoBytes completion:^(BOOL isPass) {
        if (!isPass) {
            /** 重新修改原图选项 */
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf->_originalPhotoButton.selected) {
                [strongSelf originalPhotoButtonClick];
            }
            [weakImagePickerVc showAlertWithTitle:[NSBundle lf_localizedStringForKey:@"_selectPhotoSizeLimitTipText"]];
        }
    }];
}

- (void)getSelectedPhotoBytes {
    if (/* DISABLES CODE */ (1)==0) {
        LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
        [[LFAssetManager manager] getPhotosBytesWithArray:imagePickerVc.selectedModels completion:^(NSString *totalBytesStr, NSInteger totalBytes) {
            _originalPhotoLabel.text = [NSString stringWithFormat:@"(%@)",totalBytesStr];
        }];
    }
}

- (void)scrollCollectionViewToBottom {
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    if (_shouldScrollToBottom && _models.count > 0 && imagePickerVc.sortAscendingByCreateDate) {
        NSInteger item = _models.count - 1;
        if (_showTakePhotoBtn) {
            item += 1;
        }
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        _shouldScrollToBottom = NO;
    }
}

- (void)checkDefaultSelectedModels {
    
    LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
    if (imagePickerVc.selectedAssets.count) {
        [imagePickerVc.selectedModels removeAllObjects];
        for (id object in imagePickerVc.selectedAssets) {
            LFAsset *asset = nil;
            if ([object isKindOfClass:[PHAsset class]] || [object isKindOfClass:[ALAsset class]]) {
                asset = [[LFAsset alloc] initWithAsset:object];
            }
            else if ([object conformsToProtocol:@protocol(LFAssetImageProtocol)]) {
                asset = [[LFAsset alloc] initWithObject:object];
            }
            else if ([object conformsToProtocol:@protocol(LFAssetPhotoProtocol)]) {
                asset = [[LFAsset alloc] initWithObject:object];
            }
            if (asset) {
                NSUInteger index = [self.models indexOfObject:asset];
                if (index != NSNotFound) {
                    if (imagePickerVc.selectedModels.count && imagePickerVc.maxImagesCount != imagePickerVc.maxVideosCount) {
                        if (asset.type == imagePickerVc.selectedModels.firstObject.type) {
                            [imagePickerVc.selectedModels addObject:self.models[index]];
                        }
                    } else {
                        [imagePickerVc.selectedModels addObject:self.models[index]];
                    }
                }
                if (imagePickerVc.selectedModels.firstObject.type == LFAssetMediaTypePhoto) {
                    if (imagePickerVc.selectedModels.count >= imagePickerVc.maxImagesCount) {
                        break;
                    }
                } else if (imagePickerVc.selectedModels.firstObject.type == LFAssetMediaTypeVideo) {
                    if (imagePickerVc.selectedModels.count >= imagePickerVc.maxVideosCount) {
                        break;
                    }
                }
            }
        }
    }
    /** 只执行一次 */
    imagePickerVc.selectedAssets = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - PHPhotoLibraryChangeObserver
//相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInfo {
    
    
    // Photos may call this method on a background queue;
    // switch to the main queue to update the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        LFImagePickerController *imagePickerVc = (LFImagePickerController *)self.navigationController;
        // Check for changes to the displayed album itself
        // (its existence and metadata, not its member assets).
        PHObjectChangeDetails *albumChanges = [changeInfo changeDetailsForObject:self.model.album];
        if (albumChanges) {
            // Fetch the new album and update the UI accordingly.
            [self.model changedAlbum:[albumChanges objectAfterChanges]];
            self.navigationItem.title = _model.name;
            if (albumChanges.objectWasDeleted) {
                
                void (^showAlertView)() = ^{
                    [imagePickerVc showAlertWithTitle:nil message:[NSBundle lf_localizedStringForKey:@"_LFPhotoPickerController_photoAlbunDeletedError"] complete:^{
                        if (imagePickerVc.viewControllers.count > 1) {
                            [imagePickerVc popToRootViewControllerAnimated:YES];
                        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                            if ([imagePickerVc respondsToSelector:@selector(cancelButtonClick)]) {
                                [imagePickerVc performSelector:@selector(cancelButtonClick)];
                            }
#pragma clang diagnostic pop
                        }
                    }];
                };
                
                if (self.presentedViewController) {
                    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
                        showAlertView();
                    }];
                } else {
                    showAlertView();
                }
                return ;
            }
        }
        
        // Check for changes to the list of assets (insertions, deletions, moves, or updates).
        PHFetchResultChangeDetails *collectionChanges = [changeInfo changeDetailsForFetchResult:self.model.result];
        if (collectionChanges) {
            // Get the new fetch result for future change tracking.
            [self.model changedResult:collectionChanges.fetchResultAfterChanges];
            
            if (collectionChanges.hasIncrementalChanges)  {
                // Tell the collection view to animate insertions/deletions/moves
                // and to refresh any cells that have changed content.
                
                BOOL hasData1 = self.models.count;
                
                BOOL ascending = imagePickerVc.sortAscendingByCreateDate;
                if (@available(iOS 8.0, *)){
                    if (!imagePickerVc.sortAscendingByCreateDate) {
                        ascending = !imagePickerVc.sortAscendingByCreateDate;
                    }
                }
                [[LFAssetManager manager] getAssetsFromFetchResult:self.model.result allowPickingVideo:imagePickerVc.allowPickingVideo allowPickingImage:imagePickerVc.allowPickingImage fetchLimit:0 ascending:ascending completion:^(NSArray<LFAsset *> *models) {
                    self.model.models = models;
                    self.models = [NSMutableArray arrayWithArray:models];
                }];
                
                BOOL hasData2 = self.models.count;
                
                /** 更新已选数组 */
                if (imagePickerVc.selectedModels.count && collectionChanges.removedObjects.count) {
                    for (id object in collectionChanges.removedObjects) {
                        LFAsset *asset = nil;
                        if ([object isKindOfClass:[PHAsset class]] || [object isKindOfClass:[ALAsset class]]) {
                            asset = [[LFAsset alloc] initWithAsset:object];
                        }
                        if (asset) {
                            [imagePickerVc.selectedModels removeObject:asset];
                        }
                    }
                }
                
                if (hasData1 != hasData2) {
                    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    _shouldScrollToBottom = YES;
                    [self initSubviews];
                } else {
                    [self.collectionView reloadData];
                }
                
                
                if (collectionChanges.removedObjects.count) {
                    /** 刷新后返回当前UI */
                    if (self.presentedViewController) {
                        [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
                            if (imagePickerVc.viewControllers.lastObject != self) {
                                [imagePickerVc popToViewController:self animated:NO];
                            }
                        }];
                    } else {
                        if (imagePickerVc.viewControllers.lastObject != self) {
                            [imagePickerVc popToViewController:self animated:NO];
                        }
                    }
                }
            } else {
                // Detailed change information is not available;
                // repopulate the UI from the current fetch result.
            }
        }
    });
}

@end
