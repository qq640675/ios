//
//  FUDemoManager.m
//  FUDemo
//
//  Created by 项林平 on 2021/6/17.
//

#import "FUDemoManager.h"

#import "FUBeautySkinView.h"
#import "FUBeautyShapeView.h"
#import "FUBeautyFilterView.h"
#import "FUStickerView.h"
#import "FUMakeupView.h"
#import "FUBodyView.h"

#import "FUSegmentBar.h"
#import "FUAlertManager.h"

@interface FUDemoManager ()<FUSegmentBarDelegate>

/// 底部功能选择栏
@property (nonatomic, strong) FUSegmentBar *bottomBar;
/// 美肤功能视图
@property (nonatomic, strong) FUBeautySkinView *skinView;
/// 美型功能视图
@property (nonatomic, strong) FUBeautyShapeView *shapeView;
/// 滤镜功能视图
@property (nonatomic, strong) FUBeautyFilterView *filterView;
/// 贴纸功能视图
@property (nonatomic, strong) FUStickerView *stickerView;
/// 美妆功能视图
@property (nonatomic, strong) FUMakeupView *makeupView;
/// 美体功能视图
@property (nonatomic, strong) FUBodyView *bodyView;

@property (nonatomic, strong) UIView *showingView;

/// 效果开关
@property (nonatomic, strong) UISwitch *renderSwitch;
/// 提示标签
@property (nonatomic, strong) UILabel *trackTipLabel;

@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, assign) CGFloat demoOriginY;

@property (nonatomic, assign) BOOL shouldRender;
@property (nonatomic, assign) BOOL supportBeauty;

@end

@implementation FUDemoManager

static FUDemoManager *demoManager = nil;
static dispatch_once_t onceToken;

+ (instancetype)shared {
    dispatch_once(&onceToken, ^{
        demoManager = [[FUDemoManager alloc] init];
    });
    return demoManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shouldRender = YES;
    }
    return self;
}

+ (void)setupFUSDK:(NSString *)authpackarr {
    NSString *inputString = @"";
    
    if (authpackarr != nil)
    {
        inputString = authpackarr;
    }
    
    if (inputString == nil ||
        [inputString isEqualToString:@""])
    {
        inputString = @"-101,-29,28,-110,-108,-65,10,-6,-92,-32,-82,-99,41,18,47,26,-69,-82,-118,-69,-63,-126,-120,115,-1,59,40,-23,0,85,115,23,-16,121,-49,-109,51,70,48,-73,-43,-32,-3,120,72,127,91,90,112,-69,-56,-82,-26,47,113,-68,-126,11,-119,-102,-108,41,99,59,-8,-43,65,31,39,-93,-24,38,-127,-73,45,-25,45,-65,91,49,-12,-96,-115,116,-43,-90,127,-29,-44,10,-52,-102,-127,-2,-114,-65,-33,-104,69,36,96,-48,-32,95,-48,3,104,68,7,100,87,15,-70,93,-102,-80,-89,-112,97,-52,-110,24,78,-72,55,94,106,6,122,-101,104,-125,-19,-101,43,65,-55,7,84,-106,26,66,-60,-125,-128,-69,44,115,17,118,-43,107,-47,76,28,-30,-78,43,24,48,18,-48,77,65,-40,78,59,91,-49,4,-52,78,9,-58,59,-47,-92,-70,37,-118,-123,-109,-74,11,-20,80,-49,-48,-1,118,-55,-61,78,-22,-73,-123,18,98,91,-118,14,54,-119,-93,96,84,98,6,42,110,-21,-23,121,-1,-21,56,53,-33,38,59,-128,94,-80,-84,-33,-73,108,58,41,25,43,-92,-13,99,25,6,40,-51,106,45,1,-105,17,-6,39,40,-102,81,31,-99,111,-101,66,-10,82,-119,33,-61,67,-82,10,105,-105,68,-72,-100,-110,-9,65,-90,-100,70,-80,2,-74,-122,113,-83,-53,-96,97,86,-26,54,-11,67,65,54,81,-127,83,48,58,49,-113,-10,-54,39,-53,-113,-88,29,49,78,22,-102,-11,-117,49,109,-37,-36,-44,47,104,52,6,19,123,-89,102,-109,-45,-1,105,91,43,-36,-70,-49,99,75,98,-30,73,-16,-28,-7,83,-121,-95,-46,-123,98,49,113,9,121,125,50,108,-119,114,86,52,-50,58,-78,90,-83,-6,98,-16,-79,102,-69,65,27,-56,33,59,75,-80,-97,84,110,-70,-41,-116,-84,-21,-75,6,80,-70,-38,8,-28,-24,41,9,-82,-16,34,-89,-110,-126,17,30,-10,-120,-52,92,-69,99,119,39,107,32,-49,-4,-25,49,117,-66,54,89,-121,22,52,63,44,-75,-62,110,24,57,-62,109,-39,55,-87,55,75,62,30,82,47,-102,-52,-18,-94,61,18,71,-53,11,50,94,116,51,-66,99,-102,89,120,-110,-117,23,-23,-34,49,120,99,-46,96,-1,-85,-86,-32,-44,-98,-6,12,-82,-78,46,-40,-19,-31,-86,-117,-18,10,-29,92,66,40,-110,37,-89,-105,101,-98,104,5,-118,-41,19,-42,-52,120,41,-64,-67,-50,-83,120,11,117,-28,-124,29,10,-4,-34,-11,45,-35,18,93,31,118,-6,-88,-82,54,43,124,-50,104,65,-45,-13,47,29,97,-57,68,-97,17,-29,-36,-116,77,40,0,105,101,22,74,-127,-36,115,42,-126,-108,39,34,38,13,88,26,-105,-66,-45,-55,40,-5,-71,-13,38,34,-125,-24,-19,29,-9,38,125,-24,53,121,43,126,120,49,5,-51,-44,-26,-62,-112,12,8,114,-91,102,-28,-35,-44,105,106,-14,-67,91,112,122,47,84,-50,43,-29,-42,-25,25,119,-91,112,125,-119,-84,43,-23,-107,-12,-88,82,121,-92,-88,-61,-23,18,105,98,69,-101,-52,77,-89,-27,-119,-88,19,83,3,-102,112,4,1,-107,-46,-8,119,123,35,73,-120,125,-25,3,28,-118,81,120,24,-92,-93,35,-21,98,41,-33,52,121,-54,41,6,93,-42,3,126,-43,-117,25,29,-73,-43,76,118,104,84,64,20,-20,-28,9,-35,-51,118,64,-23,-26,-86,106,8,84,7,52,-58,-47,-112,-14,-1,90,111,-48,-102,-111,-30,-25,-25,-3,77,-8,35,-87,-19,-106,-47,2,-69,-107,22,80,-84,2,115,53,48,61,-26,59,-90,-74,-73,-72,-20,-64,80,78,-91,25,-89,-45,91,112,19,121,87,0,-112,41,44,52,-77,-123,61,15,60,-109,9,-113,99,69,1,-117,-40,35,-75,-104,112,-25,-46,-83,42,15,-7,97,19,-11,-14,70,113,-41,64,-125,-59,126,-36,-41,-89,125,-96,13,42,122,68,87,5,81,-105,-119,-13,-3,27,-65,114,-13,11,28,-48,96,111,68,-97,106,19,26,-45,123,43,0,15,-36,92,126,-126,-22,9,-71,-88,-124,123,91,-49,68,33,76,4,16,-94,-69,-11,59,-81,-89,-53,-79,41,1,-48,11,-106,-41,-114,-12,-90,-11,114,-12,-48,-92,116,97,57,-53,53,-97,-11,-92,22,-76,38,57,-101,-84,81,-97,27,8,-65,63,-117,-23,119,-54,-68,44,48,65,-109,-46,20,27,-94,-115,127,-87,-3,89,121,124,17,12,-92,121,-72,68,-25,-91,-60,36,-69,-69,71,83,23,79,-64,85,-80,-36,-120,-2,73,-79,110,-44,-55,66,-94,19,-78,75,62,-72,86,-5,48,114,-102,105,-36,-126,-99,36,-109,-2,-26,90,-68,-91,-52,-102,-87,-92,99,51,-103,-9,-7,77,19,50,121,-37,-13,75,59,-87,93,-103,44,-101,120,83,-41,-79,60,-123,-53,110,-128,114,-89,-20,64,5,-71,-30,100,-7,16,-30,-1,-51,-128,118,57,73,92,5,35,110,-96,50,100,24,121,115,30,19,48,34,126,89,61,-16,75,126,-14,84,-114,-50,55,-109,-46,-37,-124,-59,-59,-31,-83,-4,109,-45,-63,-104,-79,-84,-114,82,27,102,-127,-63,48,-44,-90,-28,66,69,-92,75,58,-94,-120,108,-103,113,-84,-11,21,86,-126,-111,102,25,-84,-103,123,9,-69,45,117,29,-125,30,-18,126,42,-72,110,-102,-101,-49,-48,-23,-115,-64,29,-115,11,-124,113,99,-114,24,-12,85,10,-106,-94,-18,-56,-42,126,-45,2,23,-15,-60,21,-81,-30,-71,6,-75,-36,118,-65,38,122,-60,111,-106,112,-50,125,126,81,-66,-26,95,-18,-61,106,54,-92,-86,-96,-27,-63,10,112,87,-40,-7,-63,31,-22,0,18,-16,121,58,-106,-109,-32,-127,99,64,83,-117,26,1,58,41,83,95,-40,3,-92,-123,-114,-8,46,-122,90,1,-2,99,34,48,99,121,-74,-126,-63,-60,-103,-23,-89,116,34,74,37,90,76,52,45,-125,-87,114,40,99,-85,22,83,-119,-126,-67,-101,-63,-20,-35,-24,90,9";
    }
    
    NSArray *components = [inputString componentsSeparatedByString:@","];
    
    char g_auth_package[components.count];
    
    int i = -1;
    for (NSString *component in components) {
        
        i += 1;
        g_auth_package[i] = [component intValue];
    }
    
    [FURenderKit setLogLevel:FU_LOG_LEVEL_INFO];
    FUSetupConfig *setupConfig = [[FUSetupConfig alloc] init];
    setupConfig.authPack = FUAuthPackMake(g_auth_package, sizeof(g_auth_package));
    // 初始化 FURenderKit
    [FURenderKit setupWithSetupConfig:setupConfig];
    
    // 加载人脸 AI 模型
    NSString *faceAIPath = [[NSBundle mainBundle] pathForResource:@"ai_face_processor" ofType:@"bundle"];
    [FUAIKit loadAIModeWithAIType:FUAITYPE_FACEPROCESSOR dataPath:faceAIPath];
    
    // 加载身体 AI 模型
    NSString *bodyAIPath = [[NSBundle mainBundle] pathForResource:@"ai_human_processor" ofType:@"bundle"];
    [FUAIKit loadAIModeWithAIType:FUAITYPE_HUMAN_PROCESSOR dataPath:bodyAIPath];
    
    [FUAIKit shareKit].maxTrackFaces = 4;
    
    // 设置人脸算法质量
    [FUAIKit shareKit].faceProcessorFaceLandmarkQuality = [FURenderKit devicePerformanceLevel] >= FUDevicePerformanceLevelHigh ? FUFaceProcessorFaceLandmarkQualityHigh : FUFaceProcessorFaceLandmarkQualityMedium;
    
    // 设置小脸检测是否打开
    [FUAIKit shareKit].faceProcessorDetectSmallFace = [FURenderKit devicePerformanceLevel] >= FUDevicePerformanceLevelHigh;
    
    // 性能测试初始化
    [[FUTestRecorder shareRecorder] setupRecord];
    
    // 美颜默认加载
//    [self loadDefaultBeauty];
    
    // TODO - 加载保存的美颜设定
    [self setFUManager];
    
    
    [FUDemoManager shared].supportBeauty = YES;
}

- (void)addDemoViewToView:(UIView *)view originY:(CGFloat)originY {
    NSAssert(view, @"目标控制器不能为空");
    self.targetView = view;
    self.demoOriginY = originY;
    
    [view addSubview:self.bottomBar];
    [view addSubview:self.skinView];
    [view addSubview:self.shapeView];
    [view addSubview:self.filterView];
    [view addSubview:self.stickerView];
    [view addSubview:self.makeupView];
    [view addSubview:self.bodyView];
    
    [view addSubview:self.trackTipLabel];
    [view addSubview:self.renderSwitch];
}

- (void)checkAITrackedResult {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.showingView == self.bodyView) {
            self.trackTipLabel.hidden = [FUAIKit aiHumanProcessorNums] > 0;
            self.trackTipLabel.text = FULocalizedString(@"未检测到人体");
        } else {
            self.trackTipLabel.hidden = [FUAIKit aiFaceProcessorNums] > 0;
            self.trackTipLabel.text = FULocalizedString(@"未检测到人脸");
        }
    });
}

#pragma mark - Private methods

/// 显示功能视图
/// @param functionView 功能视图
- (void)showFunctionView:(UIView *)functionView {
    if (!functionView) {
        return;
    }
    functionView.hidden = NO;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        functionView.transform = CGAffineTransformMakeScale(1, 1);
        functionView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}


/// 隐藏功能视图
/// @param functionView 功能视图
/// @param animated 是否需要动画（切换功能时先隐藏当前显示的视图不需要动画，直接隐藏时需要动画）
- (void)hideFunctionView:(UIView *)functionView animated:(BOOL)animated {
    if (!functionView) {
        return;
    }
    if (animated) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            functionView.transform = CGAffineTransformMakeScale(1, 0.001);
            functionView.alpha = 0;
        } completion:^(BOOL finished) {
            functionView.hidden = YES;
        }];
    } else {
        functionView.transform = CGAffineTransformMakeScale(1, 0.001);
        functionView.alpha = 0;
        functionView.hidden = YES;
    }
}

#pragma mark - Event response
- (void)renderSwitchAction:(UISwitch *)sender {
    self.shouldRender = sender.isOn;
}

#pragma mark - FUSegmentBarDelegate

- (void)segmentBar:(FUSegmentBar *)segmentBar didSelectItemAtIndex:(NSUInteger)index {
    [FUAIKit shareKit].maxTrackFaces = index == FUModuleTypeBody ? 1 : 4;
    UIView *needShowView = nil;
    switch (index) {
        case FUModuleTypeBeautySkin:{
            needShowView = self.skinView;
        }
            break;
        case FUModuleTypeBeautyShape:{
            needShowView = self.shapeView;
        }
            break;
        case FUModuleTypeBeautyFilter:{
            needShowView = self.filterView;
        }
            break;
        case FUModuleTypeSticker:{
            needShowView = self.stickerView;
        }
            break;
        case FUModuleTypeMakeup:{
            needShowView = self.makeupView;
        }
            break;
        case FUModuleTypeBody:{
            if (![FURenderKit shareRenderKit].bodyBeauty) {
                // 加载默认美体
                [FUDemoManager loadDefaultBody];
            }
            needShowView = self.bodyView;
        }
            break;
    }
    if (needShowView && needShowView.hidden) {
        if (self.showingView) {
            // 先隐藏当前功能视图
            [self hideFunctionView:self.showingView animated:NO];
        }
        [self showFunctionView:needShowView];
        self.renderSwitch.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(needShowView.frame));
        self.renderSwitch.hidden = NO;
        self.showingView = needShowView;
    }
}

#pragma mark - Getters
- (FUSegmentBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[FUSegmentBar alloc] initWithFrame:CGRectMake(0, self.demoOriginY, CGRectGetWidth(self.targetView.bounds), 49) titles:@[FULocalizedString(@"美肤"), FULocalizedString(@"美型"), FULocalizedString(@"滤镜"), FULocalizedString(@"贴纸"),  FULocalizedString(@"美妆"), FULocalizedString(@"美体")] configuration:[FUSegmentBarConfigurations new]];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
}

- (FUBeautySkinView *)skinView {
    if (!_skinView) {
        _skinView = [[FUBeautySkinView alloc] initWithFrame:CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight)];
        _skinView.layer.anchorPoint = CGPointMake(0.5, 1);
        // 设置了anchorPoint需要重新设置frame
        _skinView.frame = CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight);
        // 默认隐藏
        [self hideFunctionView:_skinView animated:NO];
    }
    return _skinView;
}

- (FUBeautyShapeView *)shapeView {
    if (!_shapeView) {
        _shapeView = [[FUBeautyShapeView alloc] initWithFrame:CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight)];
        _shapeView.layer.anchorPoint = CGPointMake(0.5, 1);
        _shapeView.frame = CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight);
        // 默认隐藏
        [self hideFunctionView:_shapeView animated:NO];
    }
    return _shapeView;
}

- (FUBeautyFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[FUBeautyFilterView alloc] initWithFrame:CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight)];
        _filterView.layer.anchorPoint = CGPointMake(0.5, 1);
        _filterView.frame = CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight);
        // 默认隐藏
        [self hideFunctionView:_filterView animated:NO];
    }
    return _filterView;
}

- (FUStickerView *)stickerView {
    if (!_stickerView) {
        _stickerView = [[FUStickerView alloc] initWithFrame:CGRectMake(0, self.demoOriginY - FUFunctionViewHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight)];
        _stickerView.layer.anchorPoint = CGPointMake(0.5, 1);
        _stickerView.frame = CGRectMake(0, self.demoOriginY - FUFunctionViewHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight);
        // 默认隐藏
        [self hideFunctionView:_stickerView animated:NO];
    }
    return _stickerView;
}

- (FUMakeupView *)makeupView {
    if (!_makeupView) {
        _makeupView = [[FUMakeupView alloc] initWithFrame:CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight)];
        _makeupView.layer.anchorPoint = CGPointMake(0.5, 1);
        _makeupView.frame = CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight);
        // 默认隐藏
        [self hideFunctionView:_makeupView animated:NO];
    }
    return _makeupView;
}

- (FUBodyView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[FUBodyView alloc] initWithFrame:CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight)];
        _bodyView.layer.anchorPoint = CGPointMake(0.5, 1);
        _bodyView.frame = CGRectMake(0, self.demoOriginY - FUFunctionViewHeight - FUFunctionSliderHeight, CGRectGetWidth(self.targetView.bounds), FUFunctionViewHeight + FUFunctionSliderHeight);
        // 默认隐藏
        [self hideFunctionView:_bodyView animated:NO];
    }
    return _bodyView;
}

- (UISwitch *)renderSwitch {
    if (!_renderSwitch) {
        _renderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(self.bottomBar.frame) - 40, 80, 30)];
        [_renderSwitch addTarget:self action:@selector(renderSwitchAction:) forControlEvents:UIControlEventValueChanged];
        _renderSwitch.on = YES;
        _renderSwitch.hidden = YES;
    }
    return _renderSwitch;
}

- (UILabel *)trackTipLabel {
    if (!_trackTipLabel) {
        _trackTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.targetView.frame) - 70, CGRectGetMidY(self.targetView.frame) - 12, 140, 24)];
        _trackTipLabel.textColor = [UIColor whiteColor];
        _trackTipLabel.font = [UIFont systemFontOfSize:17];
        _trackTipLabel.textAlignment = NSTextAlignmentCenter;
        _trackTipLabel.hidden = YES;
    }
    return _trackTipLabel;
}

#pragma mark - Class methods

+ (void)destory {
    [FURenderKit destroy];
    onceToken = 0;
    demoManager = nil;
}

+ (void)resetTrackedResult {
    [FUAIKit resetTrackedResult];
}

+ (void)updateBeautyBlurEffect {
    if (![FURenderKit shareRenderKit].beauty || ![FURenderKit shareRenderKit].beauty.enable) {
        return;
    }
    if ([FURenderKit devicePerformanceLevel] >= FUDevicePerformanceLevelHigh) {
        // 根据人脸置信度设置不同磨皮效果
        CGFloat score = [FUAIKit fuFaceProcessorGetConfidenceScore:0];
        if (score > 0.95) {
            [FURenderKit shareRenderKit].beauty.blurType = 3;
            [FURenderKit shareRenderKit].beauty.blurUseMask = YES;
        } else {
            [FURenderKit shareRenderKit].beauty.blurType = 2;
            [FURenderKit shareRenderKit].beauty.blurUseMask = NO;
        }
    } else {
        // 设置精细磨皮效果
        [FURenderKit shareRenderKit].beauty.blurType = 2;
        [FURenderKit shareRenderKit].beauty.blurUseMask = NO;
    }
}

/// 加载默认美颜
+ (void)loadDefaultBeauty {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
    FUBeauty *beauty = [[FUBeauty alloc] initWithPath:path name:@"FUBeauty"];
    beauty.heavyBlur = 0;
    // 默认均匀磨皮
    beauty.blurType = 3;
    // 默认精细变形
    beauty.faceShape = 4;
    
    // 高性能设备设置去黑眼圈、去法令纹、大眼、嘴型最新效果
    if ([FURenderKit devicePerformanceLevel] >= FUDevicePerformanceLevelHigh) {
        [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemovePouchStrength];
        [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemoveNasolabialFoldsStrength];
        [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyEyeEnlarging];
        [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyIntensityMouth];
    }
    [FURenderKit shareRenderKit].beauty = beauty;
}

+ (void)saveFUManager {
    FUBeauty *beauty = [FURenderKit shareRenderKit].beauty;
    
    NSMutableDictionary *FUManagerDic = [NSMutableDictionary dictionary];
    [FUManagerDic setObject:[NSNumber numberWithBool:beauty.blurUseMask]  forKey:@"blurUseMask"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%d", beauty.heavyBlur] forKey:@"heavyBlur"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%d", beauty.blurType] forKey:@"blurType"];
    
    
//    (Skin)
    [FUManagerDic setObject:[NSNumber numberWithBool:beauty.enableSkinSegmentation]  forKey:@"enableSkinSegmentation"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%d", beauty.skinDetect] forKey:@"skinDetect"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%d", beauty.nonskinBlurScale] forKey:@"nonskinBlurScale"];
    
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.blurLevel] forKey:@"blurLevel"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.antiAcneSpot] forKey:@"antiAcneSpot"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.colorLevel] forKey:@"colorLevel"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.redLevel] forKey:@"redLevel"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.clarity] forKey:@"clarity"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.sharpen] forKey:@"sharpen"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.faceThreed] forKey:@"faceThreed"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.eyeBright] forKey:@"eyeBright"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.toothWhiten] forKey:@"toothWhiten"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.removePouchStrength] forKey:@"removePouchStrength"];
    
    
//    (Shape)
    [FUManagerDic setObject:[NSString stringWithFormat:@"%d", beauty.faceShape] forKey:@"faceShape"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%d", beauty.changeFrames] forKey:@"changeFrames"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.faceShapeLevel] forKey:@"faceShapeLevel"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.cheekV] forKey:@"cheekV"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.cheekThinning] forKey:@"cheekThinning"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.cheekLong] forKey:@"cheekLong"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.cheekCircle] forKey:@"cheekCircle"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.cheekNarrow] forKey:@"cheekNarrow"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.cheekSmall] forKey:@"cheekSmall"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.cheekShort] forKey:@"cheekShort"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityCheekbones] forKey:@"intensityCheekbones"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityLowerJaw] forKey:@"intensityLowerJaw"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.eyeEnlarging] forKey:@"eyeEnlarging"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityChin] forKey:@"intensityChin"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityForehead] forKey:@"intensityForehead"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityNose] forKey:@"intensityNose"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityMouth] forKey:@"intensityMouth"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityLipThick] forKey:@"intensityLipThick"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityEyeHeight] forKey:@"intensityEyeHeight"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityCanthus] forKey:@"intensityCanthus"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityEyeLid] forKey:@"intensityEyeLid"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityEyeSpace] forKey:@"intensityEyeSpace"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityEyeRotate] forKey:@"intensityEyeRotate"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityLongNose] forKey:@"intensityLongNose"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityPhiltrum] forKey:@"intensityPhiltrum"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensitySmile] forKey:@"intensitySmile"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityEyeCircle] forKey:@"intensityEyeCircle"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityBrowHeight] forKey:@"intensityBrowHeight"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityBrowSpace] forKey:@"intensityBrowSpace"];
    [FUManagerDic setObject:[NSString stringWithFormat:@"%.1f", beauty.intensityBrowThick] forKey:@"intensityBrowThick"];
    
    [[NSUserDefaults standardUserDefaults] setObject:FUManagerDic forKey:@"FUManagerDic"];
}

+ (void)setFUManager {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FUManagerDic"] == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
        FUBeauty *beauty = [[FUBeauty alloc] initWithPath:path name:@"FUBeauty"];
        beauty.heavyBlur = 0;
        // 默认均匀磨皮
        beauty.blurType = 3;
        // 默认精细变形
        beauty.faceShape = 4;
        
        // 高性能设备设置去黑眼圈、去法令纹、大眼、嘴型最新效果
        if ([FURenderKit devicePerformanceLevel] >= FUDevicePerformanceLevelHigh) {
            [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemovePouchStrength];
            [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemoveNasolabialFoldsStrength];
            [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyEyeEnlarging];
            [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyIntensityMouth];
        }
        [FURenderKit shareRenderKit].beauty = beauty;
        
        return;
    }
    
//    FUBeauty *beauty = [FURenderKit shareRenderKit].beauty;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification" ofType:@"bundle"];
    FUBeauty *beauty = [[FUBeauty alloc] initWithPath:path name:@"FUBeauty"];
    
    NSDictionary *FUManagerDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"FUManagerDic"];
    beauty.blurUseMask = [FUManagerDic[@"skinDetectEnable"] boolValue];
    beauty.heavyBlur = [FUManagerDic[@"heavyBlur"] intValue];
    beauty.blurType = [FUManagerDic[@"blurType"] intValue];
    
    
//    (Skin)
    
    beauty.enableSkinSegmentation = [FUManagerDic[@"enableSkinSegmentation"] boolValue];
    beauty.skinDetect = [FUManagerDic[@"skinDetect"] intValue];
    beauty.nonskinBlurScale = [FUManagerDic[@"nonskinBlurScale"] intValue];
    
    beauty.blurLevel = [FUManagerDic[@"blurLevel"] doubleValue];
    beauty.antiAcneSpot = [FUManagerDic[@"antiAcneSpot"] doubleValue];
    beauty.colorLevel = [FUManagerDic[@"colorLevel"] doubleValue];
    beauty.redLevel = [FUManagerDic[@"redLevel"] doubleValue];
    beauty.clarity = [FUManagerDic[@"clarity"] doubleValue];
    beauty.sharpen = [FUManagerDic[@"sharpen"] doubleValue];
    beauty.faceThreed = [FUManagerDic[@"faceThreed"] doubleValue];
    beauty.eyeBright = [FUManagerDic[@"eyeBright"] doubleValue];
    beauty.toothWhiten = [FUManagerDic[@"toothWhiten"] doubleValue];
    beauty.removePouchStrength = [FUManagerDic[@"removePouchStrength"] doubleValue];
    beauty.removeNasolabialFoldsStrength = [FUManagerDic[@"removeNasolabialFoldsStrength"] doubleValue];
    
    
//    (Shape)
    
    beauty.faceShape = [FUManagerDic[@"faceShape"] intValue];
    beauty.changeFrames = [FUManagerDic[@"changeFrames"] intValue];
    
    beauty.faceShapeLevel = [FUManagerDic[@"faceShapeLevel"] doubleValue];
    beauty.cheekV = [FUManagerDic[@"cheekV"] doubleValue];
    beauty.cheekThinning = [FUManagerDic[@"cheekThinning"] doubleValue];
    beauty.cheekLong = [FUManagerDic[@"cheekLong"] doubleValue];
    beauty.cheekCircle = [FUManagerDic[@"cheekCircle"] doubleValue];
    beauty.cheekNarrow = [FUManagerDic[@"cheekNarrow"] doubleValue];
    beauty.cheekSmall = [FUManagerDic[@"cheekSmall"] doubleValue];
    beauty.cheekShort = [FUManagerDic[@"cheekShort"] doubleValue];
    beauty.intensityCheekbones = [FUManagerDic[@"intensityCheekbones"] doubleValue];
    beauty.intensityLowerJaw = [FUManagerDic[@"intensityLowerJaw"] doubleValue];
    beauty.eyeEnlarging = [FUManagerDic[@"eyeEnlarging"] doubleValue];
    beauty.intensityChin = [FUManagerDic[@"intensityChin"] doubleValue];
    beauty.intensityForehead = [FUManagerDic[@"intensityForehead"] doubleValue];
    beauty.intensityNose = [FUManagerDic[@"intensityNose"] doubleValue];
    beauty.intensityMouth = [FUManagerDic[@"intensityMouth"] doubleValue];
    beauty.intensityLipThick = [FUManagerDic[@"intensityLipThick"] doubleValue];
    beauty.intensityEyeHeight = [FUManagerDic[@"intensityEyeHeight"] doubleValue];
    beauty.intensityCanthus = [FUManagerDic[@"intensityCanthus"] doubleValue];
    beauty.intensityEyeLid = [FUManagerDic[@"intensityEyeLid"] doubleValue];
    beauty.intensityEyeSpace = [FUManagerDic[@"intensityEyeSpace"] doubleValue];
    beauty.intensityEyeRotate = [FUManagerDic[@"intensityEyeRotate"] doubleValue];
    beauty.intensityLongNose = [FUManagerDic[@"intensityLongNose"] doubleValue];
    beauty.intensityPhiltrum = [FUManagerDic[@"intensityPhiltrum"] doubleValue];
    beauty.intensitySmile = [FUManagerDic[@"intensitySmile"] doubleValue];
    beauty.intensityEyeCircle = [FUManagerDic[@"intensityEyeCircle"] doubleValue];
    beauty.intensityBrowHeight = [FUManagerDic[@"intensityBrowHeight"] doubleValue];
    beauty.intensityBrowSpace = [FUManagerDic[@"intensityBrowSpace"] doubleValue];
    beauty.intensityBrowThick = [FUManagerDic[@"intensityBrowThick"] doubleValue];
    
    // 高性能设备设置去黑眼圈、去法令纹、大眼、嘴型最新效果
    if ([FURenderKit devicePerformanceLevel] >= FUDevicePerformanceLevelHigh) {
        [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemovePouchStrength];
        [beauty addPropertyMode:FUBeautyPropertyMode2 forKey:FUModeKeyRemoveNasolabialFoldsStrength];
        [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyEyeEnlarging];
        [beauty addPropertyMode:FUBeautyPropertyMode3 forKey:FUModeKeyIntensityMouth];
    }
    
    [FURenderKit shareRenderKit].beauty = beauty;
}

/// 加载默认美体
+ (void)loadDefaultBody {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"body_slim" ofType:@"bundle"];
    FUBodyBeauty *bodyBeauty = [[FUBodyBeauty alloc] initWithPath:filePath name:@"body_slim"];
    [FURenderKit shareRenderKit].bodyBeauty = bodyBeauty;
}

- (BOOL)hideCurrentView
{
    
    if (self.showingView) {
        
        if (self.renderSwitch.hidden == NO)
        {
            self.renderSwitch.hidden = YES;
        }
        
        // 先隐藏当前功能视图
        [self hideFunctionView:self.showingView animated:NO];
        self.showingView = nil;
        
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
