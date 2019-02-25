//
//  VE_NormalContentPlayView.m
//  VOAEveryday
//
//  Created by devfalme on 2019/1/1.
//  Copyright © 2019 devfalme. All rights reserved.
//

#import "VE_NormalContentPlayView.h"
#import "CCAudioPlayer.h"
@interface VE_NormalContentPlayView ()
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) CCAudioPlayer *audioPlayer;
@property (nonatomic, retain) NSString *url;
@end
@implementation VE_NormalContentPlayView
+ (instancetype)url:(NSString *)url {
    VE_NormalContentPlayView *playView = [self loadFromNib];
    playView.url = url;
    return playView;
}

- (IBAction)playAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.audioPlayer) {
        if (self.audioPlayer.isPlaying) {
            [self.audioPlayer pause];
        }else{//继续bo fang
            [self.audioPlayer seekToTime:self.audioPlayer.progress];
            [self.audioPlayer play];
        }
    }else{
        NSLog(NSLocalizedString(@"音频地址:%@", nil),self.url);
        self.audioPlayer = [CCAudioPlayer audioPlayerWithContentsOfURL:[NSURL URLWithString:self.url]];
        self.timeLabel.text = @"Loading..";
        [self.audioPlayer trackPlayerProgress:^(NSTimeInterval progress) {
            self.slider.value = progress/self.audioPlayer.duration;
            self.timeLabel.text= [self getTheTextLabelTextFrom:progress AndDurion:self.audioPlayer.duration];
        } playerState:^(CCAudioPlayerState playerState) {
            NSLog(NSLocalizedString(@"播放状态%ld\n", nil),(long)playerState);
        }];
        [self.audioPlayer play];
    }
}

- (NSString *)getTheTextLabelTextFrom:(NSTimeInterval )progress AndDurion:(NSTimeInterval )duration {
    NSString *str = [NSString stringWithFormat:@"%@/%@",[self timeFormatted:progress],[self timeFormatted:duration]];
    
    return str;
    
}
- (NSString *)timeFormatted:(NSTimeInterval)totalSeconds {
    int time = (int)totalSeconds;
    int seconds = time%60;
    int minutes = (time / 60) % 60;
    int hours = time / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    
}

- (IBAction)sender:(UISlider *)sender {
    //跳到相应的播放时间
    [_audioPlayer seekToTime:sender.value/sender.maximumValue*_audioPlayer.duration];
}
- (void)pause {
    [_audioPlayer pause];
}
@end
