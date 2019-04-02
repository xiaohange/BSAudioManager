//
//  ViewController.m
//  DouAudioStreamDemo
//
//  Created by DuoLa on 2019/3/30.
//  Copyright © 2019 DuoLa. All rights reserved.
//

#import "ViewController.h"
#import "BSAudioManager.h"

@interface ViewController ()<BSAudioPlayerHelperDelegate>
{
    BSAudioPlayerHelper *_audioPlayerHelper;
}
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initChildViews];
}

- (void)initChildViews
{
    _audioPlayerHelper = [BSAudioPlayerHelper audioPlayerHelper];
    _audioPlayerHelper.delegate = self;
}

-(IBAction)clickPlay:(id)sender
{
    if(_audioPlayerHelper.audioPlayStatus == BSAudioPlayerPlaying){
        [_audioPlayerHelper stop];
        [self.playButton setTitle:@"播放" forState:(UIControlStateNormal)];
    } else {
        
        BSMusicModel *musicModel = [[BSMusicModel alloc] init];
        musicModel.name = @"这是测试歌曲";
        musicModel.author = @"测试作者";
        musicModel.play_url = @"http://www.ytmp3.cn/down/53159.mp3";
        [_audioPlayerHelper playWithRingItem:musicModel audioPlayTag:@"100"];
        [self.playButton setTitle:@"停止" forState:(UIControlStateNormal)];
    }
}

#pragma mark - BSAudioPlayerHelperDelegate

- (void)audioPlayerHelper:(BSAudioPlayerHelper *)playerHelper updatePlayStatusWithData:(BSAudioProgressData *)progressData
{
    
}

- (void)audioPlayerHelper:(BSAudioPlayerHelper *)playerHelper updateProgressWithData:(BSAudioProgressData *)progressData
{
    
}

@end
