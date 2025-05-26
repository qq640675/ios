//
//  YLAudioPlay.m
//  wavDemo
//
//  Created by zhou last on 2018/7/27.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import "YLAudioPlay.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YLUserDefault.h"

@interface YLAudioPlay ()
{
    dispatch_source_t timer;
}

@property (nonatomic ,strong) AVAudioPlayer *audioPlay;
@property (nonatomic ,strong) AVAudioPlayer *backAudioPlay;
@property (nonatomic ,strong) CADisplayLink *displayLink;

@property (nonatomic, strong) AVAudioPlayer *noVoiceAudioPlayer;


@end

@implementation YLAudioPlay

#pragma mark ---- 实例
+ (id)shareInstance
{
    static YLAudioPlay *audioPlay = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!audioPlay) {
            audioPlay = [YLAudioPlay new];
        }
    });
    
    return audioPlay;
}


- (void)callPlay
{
    BOOL    bAudioInputAvailable = FALSE;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    bAudioInputAvailable    = [audioSession isInputAvailable];
    
    if (bAudioInputAvailable)
    {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"m4r"];
        
        NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
        //初始化播放器对象
        self.audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
        //设置声音的大小
        self.audioPlay.volume = 1;//范围为（0到1）；
        //设置循环次数，如果为负数，就是无限循环
        self.audioPlay.numberOfLoops =-1;
        //设置播放进度
        self.audioPlay.currentTime = 0;
        //准备播放
        [self.audioPlay prepareToPlay];
        [self.audioPlay play];
    }
}

- (void)callMSGPlay {
    //如果正在聊天就不播放消息提示音
    if ([YLUserDefault userDefault].connectOnLine) {
        return;
    }
    
    BOOL    bAudioInputAvailable = FALSE;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    bAudioInputAvailable = [audioSession isInputAvailable];
    
    if (bAudioInputAvailable)
    {
        NSString *soundPath = [[NSBundle mainBundle]pathForResource:@"msg" ofType:@"wav"];
        
        NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
        //初始化播放器对象
        self.backAudioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
        //设置声音的大小
        self.backAudioPlay.volume = 1;//范围为（0到1）；
        //设置循环次数，如果为负数，就是无限循环
        self.backAudioPlay.numberOfLoops =0;
        //设置播放进度
        self.backAudioPlay.currentTime = 0;
        //准备播放
        [self.backAudioPlay prepareToPlay];
        [self.backAudioPlay play];
    }
}

- (void)callMSGEndPlay
{
    BOOL    bAudioInputAvailable = FALSE;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    bAudioInputAvailable    = [audioSession isInputAvailable];
    
    if (bAudioInputAvailable)
    {
        [self.backAudioPlay stop];
        self.backAudioPlay.currentTime = 0;//将播放的进度设置为初始状态
        
        [self backAudioPlay];
    }
}



- (void)callEndPlay
{
    BOOL    bAudioInputAvailable = FALSE;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    bAudioInputAvailable    = [audioSession isInputAvailable];
    
    if (bAudioInputAvailable)
    {
        [self.audioPlay stop];
        self.audioPlay.currentTime = 0;//将播放的进度设置为初始状态
        
        [self cancelPlay];
    }
}

- (void)callEndNoSoundsPaly {
    BOOL    bAudioInputAvailable = FALSE;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    bAudioInputAvailable    = [audioSession isInputAvailable];
    
    if (bAudioInputAvailable)
    {
        [self.audioPlay stop];
        self.audioPlay.currentTime = 0;//将播放的进度设置为初始状态
    }
}

- (void)anchorMatchingCallPlay {
    BOOL    bAudioInputAvailable = FALSE;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    bAudioInputAvailable    = [audioSession isInputAvailable];
    
    if (bAudioInputAvailable)
    {
        [self.audioPlay stop];
        self.audioPlay.currentTime = 0;//将播放的进度设置为初始状态
        
        [self matchingPlay];
    }
}

- (void)matchingPlay {
    NSString *soundPath = [[NSBundle mainBundle]pathForResource:@"matching" ofType:@"wav"];
    
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    //初始化播放器对象
    self.audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
    //设置声音的大小
    self.audioPlay.volume = 0.8;//范围为（0到1）；
    //设置循环次数，如果为负数，就是无限循环
    self.audioPlay.numberOfLoops = 0;
    //设置播放进度
    self.audioPlay.currentTime = 0;
    //准备播放
    [self.audioPlay prepareToPlay];
    [self.audioPlay play];
}

- (int)playTime
{
    return self.audioPlay.currentTime;
}


- (void)cancelPlay
{
    NSString *soundPath = [[NSBundle mainBundle]pathForResource:@"cancel" ofType:@"wav"];

    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    //初始化播放器对象
    self.audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
    //设置声音的大小
    self.audioPlay.volume = 0.8;//范围为（0到1）；
    //设置循环次数，如果为负数，就是无限循环
    self.audioPlay.numberOfLoops = 0;
    //设置播放进度
    self.audioPlay.currentTime = 0;
    //准备播放
    [self.audioPlay prepareToPlay];
    [self.audioPlay play];
}


#pragma mark ---- 开始震动
- (void)startAlertSound
{
//    NSLog(@"start button action");
//    //如果你想震动的提示播放音乐的话就在下面填入你的音乐文件
//    self.displayLink = [CADisplayLink displayLinkWithTarget:self
//                            selector:@selector(handleDisplayLink:)];
//    interval = 5;
//    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
//                           forMode:NSDefaultRunLoopMode];
    
    dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
    
    // 创建一个 timer 类型定时器 （ DISPATCH_SOURCE_TYPE_TIMER）
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //设置定时器的各种属性（何时开始，间隔多久执行）
    // GCD 的时间参数一般为纳秒 （1 秒 = 10 的 9 次方 纳秒）
    // 指定定时器开始的时间和间隔的时间
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC, 0);
    
    // 任务回调
    dispatch_source_set_event_handler(timer, ^{
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    });
    
    // 开始定时器任务（定时器默认开始是暂停的，需要复位开启）
    dispatch_resume(timer);
}

#pragma mark ---- 结束震动
-(void)stopDisplayLink{
    
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}


//播放无声音乐
- (void)startPlayNoVoiceMP3 {
    [self.noVoiceAudioPlayer stop];
    BOOL bAudioInputAvailable = FALSE;

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    // 设置会话类型（声音与其他声音共存）
    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    // 激活会话
    [audioSession setActive:YES error:nil];

    bAudioInputAvailable = [audioSession isInputAvailable];

    if (bAudioInputAvailable)
    {
        NSString *soundPath = [[NSBundle mainBundle]pathForResource:@"0000" ofType:@"mp3"];

        NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
        //初始化播放器对象
        self.noVoiceAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
        //设置声音的大小
//        self.noVoiceAudioPlayer.volume = 0.8;//范围为（0到1）；
        //设置循环次数，如果为负数，就是无限循环
        self.noVoiceAudioPlayer.numberOfLoops =-1;
        //设置播放进度
        self.noVoiceAudioPlayer.currentTime = 0;
        //准备播放
        [self.noVoiceAudioPlayer prepareToPlay];
        [self.noVoiceAudioPlayer play];
    }
}

- (void)stopPlayNoVoiceMP3 {
    [self.noVoiceAudioPlayer stop];
    self.noVoiceAudioPlayer = nil;
}


@end
