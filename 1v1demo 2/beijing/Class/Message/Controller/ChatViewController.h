
#import <UIKit/UIKit.h>
#import "TUIChatController.h"

@class TUIMessageCellData;
@interface ChatViewController : UIViewController
@property (nonatomic, strong) TUIConversationCellData *conversationData;

@property (nonatomic, assign) NSInteger otherUserId;


@end
