//
//  ShareManager.h
//  beijing
//
//  Created by yiliaogao on 2019/3/29.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>


@interface ShareManager : NSObject

+ (id)shareInstance;

- (void)shareWithTitle:(NSString *)title content:(NSString *)content image:(id)image url:(NSString *)url;

@end

