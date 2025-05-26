//
//  HelpCenterListModel.h
//  beijing
//
//  Created by yiliaogao on 2019/3/2.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpCenterListModel : SLBaseListModel

@property (nonatomic, copy) NSString    *t_title;
@property (nonatomic, copy) NSString    *t_content;

@property (nonatomic, assign) BOOL       isOpen;

@end

NS_ASSUME_NONNULL_END
