//
//  YLPrivateChatViewController.m
//  yiliao
//
//  Created by zhou last on 2018/7/31.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLPrivateChatViewController.h"
#import "DefineConstants.h"

@interface YLPrivateChatViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    float         keyboardHeight;
}

//聊天界面
@property (strong, nonatomic) UITableView       *chatTableView;
//语音
@property (weak, nonatomic) IBOutlet UIButton *audioOrTextButton;
//按住录音按钮
@property (weak, nonatomic) IBOutlet UIButton *startAudioButton;
//文本输入框
@property (weak, nonatomic) IBOutlet UITextView *inputTextField;
//笑脸
@property (weak, nonatomic) IBOutlet UIButton *faceButton;
//更多
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

//下面语音笑脸等背景
@property (weak, nonatomic) IBOutlet UIView *audioTextFaceBgView;
//线
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


@end

@implementation YLPrivateChatViewController

- (instancetype)init
{
    if (self == [super init])
    {
        [self chatTableView];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardDidShowNotification object:nil];

}




#pragma mark ---- tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ICMessageHelper *helper = msgArray[indexPath.row];
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testChatCell"];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testChatCell"];
    }
    
    cell.textLabel.text = @"a;lgjlajglajlgjag";
//    cell.backgroundColor    = IColor(230, 230, 230);
//    ICMessageHelper *helper = msgArray[indexPath.row];
//    helper.indexRow         = indexPath.row;
//    helper.messageArray     = msgArray;
//
//    [cell modelHeader:helper block:^(int index) {
//        [self browseImageNotification:index];
//    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    [self hideKeyBoard];
}

- (void)showKeyBoard:(NSNotification *)noti
{
//    _emotionView.hidden = NO;
    CGFloat curkeyBoardHeight = [[[noti userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[noti userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[noti userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height <= end.size.height){
        keyboardHeight = curkeyBoardHeight;
        
        self->_bottomConstraint.constant = - self->keyboardHeight;
        self->_chatTableView.frame = CGRectMake(0, 64, App_Frame_Width, APP_Frame_Height - 81 - self->keyboardHeight - 64);
    }
}

#pragma mark ---- 事件处理 语音或文本按钮切换
- (IBAction)audioOrTextButtonBeClicked:(id)sender {
    UIButton *audioTextBtn = (UIButton *)sender;
    if ([IChatBackGImage(audioTextBtn) isEqual:IChatUImage(@"ToolViewKeyboard")])
    {
        IChatSetBackGImage(_audioOrTextButton, @"ToolViewVoice");
        //        IChatSetBackSelectedGImage(_audioOrTextButton, @"ToolViewInputVoiceHL");
        
        [_inputTextField becomeFirstResponder];
        IChatSetBackGImage(_faceButton, @"news_expression");

        
        _lineView.hidden = NO;
        [_inputTextField setHidden:NO];
        [_startAudioButton setHidden:YES];
        self->_bottomConstraint.constant = - keyboardHeight;
        self->_chatTableView.frame = CGRectMake(0, 64, App_Frame_Width, APP_Frame_Height - 81 - keyboardHeight - 64);
    }else{
        IChatSetBackGImage(_audioOrTextButton, @"ToolViewKeyboard");
        //        IChatSetBackSelectedGImage(_audioOrTextButton, @"ToolViewKeyboardHL");
        
//        _emotionView.hidden = YES;
        
        [_inputTextField resignFirstResponder];
        [_inputTextField setHidden:YES];
        _lineView.hidden = YES;
        [_startAudioButton setHidden:NO];
        self->_bottomConstraint.constant = - 0;
        self->_chatTableView.frame = CGRectMake(0, 64, App_Frame_Width, APP_Frame_Height - 81 - 64);
        IChatSetBackGImage(_faceButton, @"ToolViewEmotion");
    }
    
    [self scrollTableToFoot:YES];
}

#pragma mark ---- 滚动到底
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [_chatTableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [_chatTableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [_chatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}

#pr

#pragma mark ---- 笑脸

- (IBAction)faceButtonBeClicked:(id)sender {
    UIButton *faceBtn = (UIButton *)sender;
//    _moreView.hidden = YES;
    if ([IChatBackGImage(faceBtn) isEqual:IChatUImage(@"ToolViewKeyboard")])
    {
        NSLog(@"+++++++++++999999992222299999111");
        IChatSetBackGImage(_faceButton, @"news_expression");
        [_inputTextField becomeFirstResponder];
        
//        _emotionView.hidden = YES;
        _lineView.hidden = NO;
        [UIView animateWithDuration:.5 animations:^{
            self->_bottomConstraint.constant = self->keyboardHeight;
            self->_chatTableView.frame = CGRectMake(0, 64, App_Frame_Width, APP_Frame_Height - 81 - self->keyboardHeight - 64);
        }];
    }else{
        NSLog(@"______999999992222299999111");
        IChatSetBackGImage(_faceButton, @"ToolViewKeyboard");
        //        IChatSetBackSelectedGImage(_faceButton, @"ToolViewKeyboardHL");
        
//        _emotionView.hidden = NO;
        _lineView.hidden = NO;
        
        [_inputTextField setHidden:NO];
        [_startAudioButton setHidden:YES];
        [_inputTextField resignFirstResponder];
        IChatSetBackGImage(_audioOrTextButton, @"ToolViewVoice");
        
        [UIView animateWithDuration:.5 animations:^{
            self->_bottomConstraint.constant =  252;
            self->_chatTableView.frame = CGRectMake(0, 64, App_Frame_Width, APP_Frame_Height - 81 - 252 - 64);
        }];
    }
}


#pragma mark ---- 更多或添加
- (IBAction)moreButtonBeClicked:(id)sender {
    _bottomConstraint.constant = - 252;
    [_inputTextField resignFirstResponder];
    self->_chatTableView.frame = CGRectMake(0, 64, App_Frame_Width, APP_Frame_Height - 81 - 252 - 64);
//    _moreView.hidden = NO;
}


- (UITableView *)chatTableView
{
    if (nil == _chatTableView) {
        _chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, App_Frame_Width, APP_Frame_Height - 81 - 64)];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        [_chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _chatTableView.userInteractionEnabled = YES;
        _chatTableView.backgroundColor =IColor(230, 230, 230);
        [self.view addSubview:_chatTableView];
    }
    
    return  _chatTableView;
}

@end
