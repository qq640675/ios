//
//  PersonCenterListModel.h
//  beijing
//
//  Created by yiliaogao on 2019/3/1.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "SLBaseListModel.h"

typedef enum
{
    SwitchTypeVideo = 1,//视频
    SwitchTypeVoice, //语音
    SwitchTypeChat,//私聊
}SwitchType;

NS_ASSUME_NONNULL_BEGIN

@interface PersonCenterListModel : SLBaseListModel

@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *iconName;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL      isSwitch;
@property (nonatomic, assign) BOOL      isSwitchSelected;

@property (nonatomic, assign) SwitchType switchType;

@end

NS_ASSUME_NONNULL_END
