//
//  DynamicReleaseListModel.h
//  beijing
//
//  Created by yiliaogao on 2018/12/26.
//  Copyright © 2018 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

typedef NS_ENUM(NSUInteger, ReleaseListType) {
    ReleaseListType_Location = 0,
    ReleaseListType_Look_All = 1,
    ReleaseListType_Look_Fav = 2
};

NS_ASSUME_NONNULL_BEGIN

@interface DynamicReleaseListModel : SLBaseListModel

@property (nonatomic, copy) NSString    *listTitle;
@property (nonatomic, copy) NSString    *listImageName;
@property (nonatomic, copy) NSString    *listSelectedImageName;
@property (nonatomic, copy) NSString    *listDesc;
@property (nonatomic, assign) BOOL       isSelected;
@property (nonatomic, assign) ReleaseListType   listType;

@end

NS_ASSUME_NONNULL_END
