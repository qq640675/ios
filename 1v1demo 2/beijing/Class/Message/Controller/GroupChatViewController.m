//
//  GroupChatViewController.m
//  beijing
//
//  Created by 黎 涛 on 2021/6/2.
//  Copyright © 2021 zhou last. All rights reserved.
//

#import "GroupChatViewController.h"
#import "TUIKit.h"
#import "MMLayout/UIView+MMLayout.h"
#import "THelper.h"
#import "TUITextMessageCell.h"
#import "TUIImageMessageCell.h"
#import "TUIFaceCell.h"
#import "TUIFaceView.h"
#import "UIView+MMLayout.h"

#import "SLHelper.h"
#import "BaseView.h"
#import "YLPushManager.h"
#import "LFImagePickerController.h"
#import "NewMessageAlertView.h"
#import "MessageImageCell.h"
#import "BigImageViewController.h"
#import "UIButton+LXMImagePosition.h"

@interface GroupChatViewController ()<TUIChatControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, LFImagePickerControllerDelegate, TFaceViewDelegate>
{
    UIView *itemView;
    UITextField *textField;
}
@property (nonatomic, strong) TUIChatController *chat;
@property (nonatomic, strong) TIMConversation *conv;
@property (nonatomic, strong) TUIFaceView *emojiView;

@end

@implementation GroupChatViewController

#pragma mark - vc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XZRGB(0xf5f5f5);
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self setChatVC];
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self checkImState];
    
    //上报已读
    [_conv setReadMessage:nil succ:nil fail:nil];
    
    [[NewMessageAlertView shareView] stopAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUnReadMsgNoti" object:nil];
}

#pragma mark - not
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat bottomHeight = SafeAreaBottomHeight - 49;
    CGFloat transformY = endFrame.origin.y - itemView.height + bottomHeight;
    if (beginFrame.size.height>0 && (beginFrame.origin.y-endFrame.origin.y>0)) {
        //执行动画
        [UIView animateWithDuration:duration animations:^{
            self->itemView.y = transformY-SafeAreaTopHeight;
            self.chat.messageController.tableView.height = transformY-SafeAreaTopHeight;
        }];
        
        [self.chat.messageController scrollToBottom:NO];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification{
    [self hideEmojiView];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transformY = endFrame.origin.y - itemView.height;
    [UIView animateWithDuration:duration animations:^{
        self->itemView.y = transformY-SafeAreaTopHeight;;
        self.chat.messageController.tableView.height = transformY-SafeAreaTopHeight;
    }];

    [self.chat.messageController scrollToBottom:NO];
}

#pragma mark - func
- (void)checkImState {
    //检测IM登录状态
    if ([[TIMManager sharedInstance] getLoginStatus] != 1) {
        [SLHelper TIMLoginSuccess:^{
            
        } fail:^{
            
        }];
    }
}

- (void)chatItemButtonClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    [self.view endEditing:YES];
    [self hideEmojiView];
    if (sender.tag < 6666+6) {
        NSString *title = sender.titleLabel.text;
        if ([title isEqualToString:@"图片"]) {
            [self choosePicWithCameraWithType:0]; //单张图片选择
        } else if ([title isEqualToString:@"拍摄"]) {
            [self choosePicWithCameraWithType:1];
        }
    } else if (sender.tag == 6888) {
        // 表情
        [self chatEmoji];
    }
}

#pragma mark - 发送文字
- (void)sendTextMessage {
    if (textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"内容不能为空"];
        return;
    }

    TUITextMessageCellData *data = [[TUITextMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
    data.content = textField.text;
    [self.chat sendMessage:data];
    self->textField.text = nil;
}

#pragma mark - 发送emoji
- (void)chatEmoji {
    textField.hidden = NO;
    self.emojiView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self->itemView.y -= 180;
        self.emojiView.y = CGRectGetMinY(self->itemView.frame)+125;
        self.chat.messageController.tableView.height -= 180;
        [self.chat.messageController scrollToBottom:NO];
    }];
}

- (void)hideEmojiView {
    if (_emojiView.hidden == NO) {
        [UIView animateWithDuration:0.25 animations:^{
            self->itemView.y = APP_Frame_Height-SafeAreaTopHeight-self->itemView.height;
            self.emojiView.y = APP_Frame_Height;
            self.chat.messageController.tableView.height = APP_Frame_Height-SafeAreaTopHeight-self->itemView.height;
            [self.chat.messageController scrollToBottom:NO];
        }];
        _emojiView.hidden = YES;
    }
}

#pragma mark - 发送图片
- (void)choosePicWithCameraWithType:(int)type {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    if (type == 0) {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    pickerController.delegate = self;
    pickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    UIImageOrientation imageOrientation = resultImage.imageOrientation;
    if(imageOrientation != UIImageOrientationUp)
    {
        CGFloat aspectRatio = MIN ( 1920 / resultImage.size.width, 1920 / resultImage.size.height );
        CGFloat aspectWidth = resultImage.size.width * aspectRatio;
        CGFloat aspectHeight = resultImage.size.height * aspectRatio;

        UIGraphicsBeginImageContext(CGSizeMake(aspectWidth, aspectHeight));
        [resultImage drawInRect:CGRectMake(0, 0, aspectWidth, aspectHeight)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    NSString *path = [TUIKit_Image_Path stringByAppendingString:[THelper genImageName:nil]];
    [self sendPictureMessageWithImage:resultImage path:path];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)choosePicWithLibrary {
    LFImagePickerController *imagePicker = [[LFImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePicker.allowPickingVideo = NO;
    imagePicker.allowTakePicture = NO;
    imagePicker.supportAutorotate = NO;
    imagePicker.allowPickingGif = YES; /** 支持GIF */
    imagePicker.allowPickingLivePhoto = NO; /** 支持Live Photo */
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
        imagePicker.syncAlbum = YES; /** 实时同步相册 */
    }
    imagePicker.doneBtnTitleStr = @"确定"; //最终确定按钮名称
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)lf_imagePickerController:(LFImagePickerController *)picker didFinishPickingResult:(NSArray<LFResultObject *> *)results {
    for (int i = 0; i < results.count; i++) {
        LFResultObject *result = results[i];
        if ([result isKindOfClass:[LFResultImage class]]) {
            LFResultImage *resultImage = (LFResultImage *)result;
            UIImage *image = resultImage.originalImage;
            UIImageOrientation imageOrientation = image.imageOrientation;
            if(imageOrientation != UIImageOrientationUp)
            {
                CGFloat aspectRatio = MIN ( 1920 / image.size.width, 1920 / image.size.height );
                CGFloat aspectWidth = image.size.width * aspectRatio;
                CGFloat aspectHeight = image.size.height * aspectRatio;

                UIGraphicsBeginImageContext(CGSizeMake(aspectWidth, aspectHeight));
                [image drawInRect:CGRectMake(0, 0, aspectWidth, aspectHeight)];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }

            NSString *path = [NSString stringWithFormat:@"%@_%d", [TUIKit_Image_Path stringByAppendingString:[THelper genImageName:nil]], i];
            [self sendPictureMessageWithImage:image path:path];
        }
    }
}

- (void)sendPictureMessageWithImage:(UIImage *)image path:(NSString *)path{
    NSData *data = UIImageJPEGRepresentation(image, 0.75);
    
    [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    
    TUIImageMessageCellData *cellData = [[TUIImageMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
    cellData.path = path;
    cellData.length = data.length;
    [self.chat sendMessage:cellData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.chat.messageController scrollToBottom:YES];
    });
}

#pragma mark - chat vc
- (void)setChatVC {
    _conv = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:self.group];
    _chat = [[TUIChatController alloc] initWithConversation:_conv];
    _chat.delegate = self;
    _chat.messageController.tableView.backgroundColor = XZRGB(0xf5f5f5);
    [self addChildViewController:_chat];
    [self.view addSubview:_chat.view];
    
    self.navigationItem.title = [_conv getGroupName];
    
    // 设置气泡 和文本颜色
    TUITextMessageCellData.outgoingTextColor = XZRGB(0xae4ffd);
    TUITextMessageCellData.incommingTextColor = XZRGB(0x333333);
    TUIBubbleMessageCellData.outgoingBubble = [UIImage imageNamed:@"message_bubble_me"];
    TUIBubbleMessageCellData.incommingBubble = [UIImage imageNamed:@"message_bubble"];
    
    [TUIKit sharedInstance].config.defaultAvatarImage = [UIImage imageNamed:@"default"];//设置默认头像
    [TUIKit sharedInstance].config.avatarType = TAvatarTypeRounded; // 设置头像为圆形
    
    // 自定义inputbBar
    [self reSetInputBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewDidTouched)];
    [self.chat.messageController.tableView addGestureRecognizer:tap];
    _chat.messageController.tableView.y = 0;
}

- (void)tableViewDidTouched {
    [self.view endEditing:YES];
    [self hideEmojiView];
}

#pragma mark - input bar
- (void)reSetInputBar {
    // 移除自身的inputbar  需自定义UI
    [_chat.inputController.view removeFromSuperview];
    
    CGFloat itemHeight = SafeAreaBottomHeight-49+125;
    itemView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-itemHeight-SafeAreaTopHeight, App_Frame_Width, itemHeight)];
    itemView.backgroundColor = XZRGB(0xf5f5f5);
    [self.view addSubview:itemView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, itemView.width, 70)];
    bgView.backgroundColor = XZRGB(0xf5f5f5);
    [itemView addSubview:bgView];
    
    NSArray *iconArr = @[@"chat_item_pic", @"chat_item_camera"];
    NSArray *titleArr = @[@"图片", @"拍摄"];
    CGFloat width = App_Frame_Width/iconArr.count;
    for (int i = 0; i < iconArr.count; i ++) {
        UIButton *itemBtn = [UIManager initWithButton:CGRectMake(width*i, 0, width, 70) text:titleArr[i] font:14 textColor:XZRGB(0x333333) normalImg:iconArr[i] highImg:nil selectedImg:nil];
        [itemBtn setImagePosition:2 spacing:2];
        itemBtn.tag = 6666+i;
        [itemBtn addTarget:self action:@selector(chatItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:itemBtn];
    }

    textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, App_Frame_Width-60, 35)];
    textField.delegate = self;
    textField.backgroundColor = UIColor.whiteColor;
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 4;
    textField.font = [UIFont systemFontOfSize:16];
    [textField setReturnKeyType:UIReturnKeySend];
    [itemView addSubview:textField];
    
    UIButton *emojiBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-45, 10, 40, 35) text:@"" font:1 textColor:nil normalImg:@"newmessage_btn_emoji" highImg:nil selectedImg:nil];
    emojiBtn.tag = 6888;
    [emojiBtn addTarget:self action:@selector(chatItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:emojiBtn];
    
    [self emojiView];
    _chat.messageController.tableView.height = self.view.height - itemView.height;
//    APP_Frame_Height-SafeAreaTopHeight-itemView.height-coinLabelHeight;
}

#pragma mark - chat vc delegate
- (void)chatController:(TUIChatController *)chatController onSelectMoreCell:(TUIInputMoreCell *)cell {
    
}

- (TUIMessageCellData *)chatController:(TUIChatController *)controller onNewMessage:(TIMMessage *)msg {
    if (msg && msg.elemCount > 0) {
        TIMElem *elem = [msg getElem:0];
        //判断是否为自定义元素。
        if([elem isKindOfClass:[TIMCustomElem class]]) {
            
            TIMCustomElem *customElem = (TIMCustomElem *)elem;
        
            NSString *receiver = msg.sender;
            
            NSString *jsonStr = [[NSString alloc] initWithData:customElem.data encoding:NSUTF8StringEncoding];
            // 这里是服务端的虚拟主播发送过来的自定义消息 不知什么原因带有{}包含的字符串发过来 客户端接收到的data为空，就用字符serverSend&&代替{, 然后解析时如果以字符serverSend&&开头则替换为{再进行转dic。
            if ([jsonStr hasPrefix:@"serverSend&&"]) {
                jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"serverSend&&" withString:@"{"];
            }
            NSDictionary *dic = [SLHelper dictionaryWithJsonString:jsonStr];
            NSString *type = dic[@"type"];
            
            if ([type isEqualToString:@"picture"]) {
                // 服务端发送的图片消息  以自定义消息发送
                MessageImageData *cellData = [[MessageImageData alloc] initWithDirection:msg.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
                cellData.imageUrl = dic[@"fileUrl"];
                if (msg.isSelf == YES) {
                    cellData.headImage = [YLUserDefault userDefault].headImage;
                } else {
                    [msg getSenderProfile:^(TIMUserProfile *profile) {
                        cellData.avaterImageUrl = profile.faceURL;
                    }];
                    cellData.identifier = receiver;
                }
                cellData.innerMessage = msg;
                return cellData;
            }
        }
    }
    return nil;
}

- (TUIMessageCell *)chatController:(TUIChatController *)controller onShowMessageData:(TUIMessageCellData *)data {
    if ([data isKindOfClass:[MessageImageData class]]) {
        // 自定义  图片
        MessageImageCell *imagCell = [[MessageImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
        [imagCell fillWithData:(MessageImageData *)data];
        return imagCell;
    }

    return nil;
}

- (void)chatController:(TUIChatController *)controller onSelectMessageContent:(TUIMessageCell *)cell {
    [self.view endEditing:YES];
    [self hideEmojiView];
    
    if ([cell isKindOfClass:[MessageImageCell class]]) {
        // 图片点击
        MessageImageCell *imageCell = (MessageImageCell *)cell;
        BigImageViewController *imageVC = [[BigImageViewController alloc] init];
        imageVC.bigImage = imageCell.contentImageView.image;
        [self.navigationController pushViewController:imageVC animated:YES];
    }
}

- (void)chatController:(TUIChatController *)controller onSelectMessageAvatar:(TUIMessageCell *)cell {
    // 点击头像
    NSString *receiver = cell.messageData.identifier;
    NSLog(@"__receiver:%@    cell.messageData.identifier:%@", receiver, cell.messageData.identifier);
    NSString *myIdcard = [NSString stringWithFormat:@"%d", [YLUserDefault userDefault].t_id+10000];
    if (![myIdcard isEqualToString:receiver]) {
        NSInteger userId = [receiver intValue]-10000;
        [YLPushManager pushAnchorDetail:userId];
    }
}

#pragma mark - TUIFaceView Delegate
- (void)faceView:(TUIFaceView *)faceView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TFaceGroup *group = [TUIKit sharedInstance].config.faceGroups[indexPath.section];
    TFaceCellData *face = group.faces[indexPath.row];
    [textField setText:[textField.text stringByAppendingString:face.name]];
    
}

- (void)faceViewDidBackDelete:(TUIFaceView *)faceView {
    if (textField.text.length != 0) {
        UITextPosition *position = [textField endOfDocument];
        textField.selectedTextRange = [textField textRangeFromPosition:position toPosition:position];
        [textField deleteBackward];
    }
}

- (void)faceViewDidSendMsg:(TUIFaceView *)faceView {
    if (textField.text.length > 0) {
        [self sendTextMessage];
    }
}

#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        return NO;
    }
    [self sendTextMessage];
    return YES;
}


#pragma mark - lazy loading
- (TUIFaceView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[TUIFaceView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height, App_Frame_Width, 180)];
        _emojiView.delegate = self;
        _emojiView.hidden = YES;
        [_emojiView setData:[NSMutableArray arrayWithArray:[TUIKit sharedInstance].config.faceGroups]];
        [self.view addSubview:_emojiView];
        
        UIButton *sendBtn = [UIManager initWithButton:CGRectMake(App_Frame_Width-70, 140, 70, 40) text:@"发送" font:15 textColor:UIColor.whiteColor normalImg:nil highImg:nil selectedImg:nil];
        sendBtn.backgroundColor = UIColor.grayColor;
        [sendBtn addTarget:self action:@selector(sendTextMessage) forControlEvents:UIControlEventTouchUpInside];
        [_emojiView addSubview:sendBtn];
    }
    return _emojiView;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
