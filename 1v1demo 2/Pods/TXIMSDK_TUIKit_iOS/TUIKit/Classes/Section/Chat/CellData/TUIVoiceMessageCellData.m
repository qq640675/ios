//
//  TUIVoiceMessageCellData.m
//  TXIMSDK_TUIKit_iOS
//
//  Created by annidyfeng on 2019/5/21.
//

#import "TUIVoiceMessageCellData.h"
#import "THeader.h"
#import "TUIKit.h"
#import "THelper.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import <ImSDK/ImSDK.h>
@import AVFoundation;

@interface TUIVoiceMessageCellData ()<AVAudioPlayerDelegate>
@property AVAudioPlayer *audioPlayer;
@property NSString *wavPath;
@end

@implementation TUIVoiceMessageCellData

- (instancetype)initWithDirection:(TMsgDirection)direction
{
    self = [super initWithDirection:direction];
    if (self) {
        if (direction == MsgDirectionIncoming) {
            self.cellLayout = [TIncommingVoiceCellLayout new];
            _voiceImage = [UIImage imageNamed:@"chat_voice_play_2"];
            _voiceAnimationImages = @[[UIImage imageNamed:@"chat_voice_play_0"],
            [UIImage imageNamed:@"chat_voice_play_1"],
                                              [UIImage imageNamed:@"chat_voice_play_2"]];
            _voiceTop = [[self class] incommingVoiceTop];
        } else {
            self.cellLayout = [TOutgoingVoiceCellLayout new];

            _voiceImage = [UIImage imageNamed:@"chat_voice_play_me_2"];
            _voiceAnimationImages = @[[UIImage imageNamed:@"chat_voice_play_me_0"],
            [UIImage imageNamed:@"chat_voice_play_me_1"],
                                              [UIImage imageNamed:@"chat_voice_play_me_2"]];
            _voiceTop = [[self class] outgoingVoiceTop];
        }
    }

    return self;
}

- (NSString *)getVoicePath:(BOOL *)isExist
{
    NSString *path = nil;
    BOOL isDir = false;
    *isExist = NO;
    if(self.direction == MsgDirectionOutgoing) {
        //上传方本地是否有效
        path = [NSString stringWithFormat:@"%@%@", TUIKit_Voice_Path, _path.lastPathComponent];
        if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]){
            if(!isDir){
                *isExist = YES;
            }
        }
    }

    if(!*isExist) {
        //查看本地是否存在
        path = [NSString stringWithFormat:@"%@%@.amr", TUIKit_Voice_Path, _uuid];
        if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]){
            if(!isDir){
                *isExist = YES;
            }
        }
    }
    return path;
}

- (TIMSoundElem *)getIMSoundElem
{
    TIMMessage *imMsg = self.innerMessage;
    for (int i = 0; i < imMsg.elemCount; ++i) {
        TIMElem *imElem = [imMsg getElem:i];
        if([imElem isKindOfClass:[TIMSoundElem class]]){
            TIMSoundElem *imSoundElem = (TIMSoundElem *)imElem;
            return imSoundElem;
        }
    }
    return nil;
}

- (CGSize)contentSize
{
    CGFloat bubbleWidth = TVoiceMessageCell_Back_Width_Min + self.duration / TVoiceMessageCell_Max_Duration * Screen_Width;
    if(bubbleWidth > TVoiceMessageCell_Back_Width_Max){
        bubbleWidth = TVoiceMessageCell_Back_Width_Max;
    }

    CGFloat bubbleHeight = TVoiceMessageCell_Duration_Size.height;
    bubbleHeight = 48;
//    if (self.direction == MsgDirectionIncoming) {
//        bubbleWidth = MAX(bubbleWidth, [TUIBubbleMessageCellData incommingBubble].size.width);
//        bubbleHeight = [TUIBubbleMessageCellData incommingBubble].size.height;
//    } else {
//        bubbleWidth = MAX(bubbleWidth, [TUIBubbleMessageCellData outgoingBubble].size.width);
//        bubbleHeight = [TUIBubbleMessageCellData outgoingBubble].size.height;
//    }
    return CGSizeMake(bubbleWidth+TVoiceMessageCell_Duration_Size.width, bubbleHeight);
//    CGFloat width = bubbleWidth + TVoiceMessageCell_Duration_Size.width;
//    return CGSizeMake(width, TVoiceMessageCell_Duration_Size.height);
}

- (void)playVoiceMessage
{
    if (self.isPlaying) {
        return;
    }
    self.isPlaying = YES;
    
    if(self.innerMessage.customInt == 0)
        self.innerMessage.customInt = 1;
    
    if (self.voicePath) {
        [self playVoiceWithUrlString:self.voicePath];
        NSString *localIdent = [[NSUserDefaults standardUserDefaults] objectForKey:@"MESSAGE_LOCAL_IDENT"];
        if (localIdent.length == 0 || localIdent == nil || [localIdent containsString:@"null"]) {
            localIdent = @"";
        }
        NSString *setIdent = [NSString stringWithFormat:@"%@,%@", localIdent, self.ident];
        [[NSUserDefaults standardUserDefaults] setObject:setIdent forKey:@"MESSAGE_LOCAL_IDENT"];
        return;
    }

    BOOL isExist = NO;
    NSString *path = [self getVoicePath:&isExist];
    if(isExist) {
        [self playInternal:path];
    } else {
        if(self.isDownloading) {
            return;
        }
        //网络下载
        TIMSoundElem *imSound = [self getIMSoundElem];
        self.isDownloading = YES;
        @weakify(self)
        [imSound getSound:path succ:^{
            @strongify(self)
            self.isDownloading = NO;
            [self playInternal:path];;
        } fail:^(int code, NSString *msg) {
            @strongify(self)
            self.isDownloading= NO;
            [self stopVoiceMessage];
        }];
    }
}

- (void)playVoiceWithUrlString:(NSString *)urlString {
    if (!self.isPlaying)
    return;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (void)playInternal:(NSString *)path
{
    if (!self.isPlaying)
        return;
    //play current
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.audioPlayer.delegate = self;
    bool result = [self.audioPlayer play];
    if (!result) {
        self.wavPath = [[path stringByDeletingPathExtension] stringByAppendingString:@".wav"];
        [THelper convertAmr:path toWav:self.wavPath];
        NSURL *url = [NSURL fileURLWithPath:self.wavPath];
        [self.audioPlayer stop];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
    }
}

- (void)stopVoiceMessage
{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    self.isPlaying = NO;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    self.isPlaying = NO;
    [[NSFileManager defaultManager] removeItemAtPath:self.wavPath error:nil];
}

static CGFloat s_incommingVoiceTop = 12;

+ (void)setIncommingVoiceTop:(CGFloat)incommingVoiceTop
{
    s_incommingVoiceTop = incommingVoiceTop;
}

+ (CGFloat)incommingVoiceTop
{
    return s_incommingVoiceTop;
}

static CGFloat s_outgoingVoiceTop = 12;

+ (void)setOutgoingVoiceTop:(CGFloat)outgoingVoiceTop
{
    s_outgoingVoiceTop = outgoingVoiceTop;
}

+ (CGFloat)outgoingVoiceTop
{
    return s_outgoingVoiceTop;
}

@end
