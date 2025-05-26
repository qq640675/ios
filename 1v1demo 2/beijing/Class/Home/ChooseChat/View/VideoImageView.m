//
//  VideoImageView.m
//  beijing
//
//  Created by 黎 涛 on 2019/10/10.
//  Copyright © 2019 zhou last. All rights reserved.
//

#import "VideoImageView.h"

@implementation VideoImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
//        self.backgroundColor = XZRGB(0xebebeb);
        self.userInteractionEnabled = YES;
        [self setButton];
    }
    return self;
}

- (void)setButton {
    UIButton *deleteBtn = [UIManager initWithButton:CGRectMake(self.width-30, 0, 30, 30) text:@"" font:1 textColor:nil normalImg:@"chat_delete_btn" highImg:nil selectedImg:nil];
    [deleteBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
}

- (void)setDefaultUrl:(NSString *)defaultUrl {
    AVPlayerItem *avplayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:defaultUrl]];
    if (!_avplayer) {
        _avplayer = [AVPlayer playerWithPlayerItem:avplayerItem];
        _avplayer.volume = 0;
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_avplayer];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = CGRectMake(0, 0, self.width, self.height);
        [self.layer insertSublayer:layer atIndex:0];
    } else {
        [_avplayer replaceCurrentItemWithPlayerItem:avplayerItem];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rePlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avplayer.currentItem];
    [_avplayer play];
}

- (void)play {
    [_avplayer play];
}

- (void)pause {
    [_avplayer pause];
}

- (void)rePlay:(NSNotification *)notification {
    AVPlayerItem *item = [notification object];
    [item seekToTime:kCMTimeZero];
    [self.avplayer play];


}

- (void)buttonClick {
    if (self.deleteButtonClick) {
        self.deleteButtonClick();
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
