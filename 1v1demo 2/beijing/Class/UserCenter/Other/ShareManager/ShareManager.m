//
//  ShareManager.m
//  beijing
//
//  Created by yiliaogao on 2019/3/29.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "ShareManager.h"
#import "BaseView.h"

static ShareManager *shareManager = nil;

@implementation ShareManager

+ (id)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareManager) {
            shareManager = [[ShareManager alloc] init];
        }
    });
    return shareManager;
}

- (void)shareWithTitle:(NSString *)title content:(NSString *)content image:(id)image url:(NSString *)url {
    
    NSString *shareUrl = (NSString *)[SLDefaultsHelper getSLDefaults:@"common_share_url"];
    
    if (title.length == 0 && content.length == 0) {
        shareUrl = nil;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:content
                                     images:image
                                        url:[NSURL URLWithString:shareUrl]
                                      title:title
                                       type:SSDKContentTypeAuto];
    SSUIShareSheetConfiguration *config = [[SSUIShareSheetConfiguration alloc] init];
    
    NSArray *items = @[@(SSDKPlatformTypeQQ),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)];
    
    UIViewController *curController = [SLHelper getCurrentVC];
    [ShareSDK showShareActionSheet:curController.view
                       customItems:items
                       shareParams:shareParams
                sheetConfiguration:config
                    onStateChanged:^(SSDKResponseState state,
                                     SSDKPlatformType platformType,
                                     NSDictionary *userData,
                                     SSDKContentEntity *contentEntity,
                                     NSError *error,
                                     BOOL end) {
                        
                        
                    }];
}

@end
