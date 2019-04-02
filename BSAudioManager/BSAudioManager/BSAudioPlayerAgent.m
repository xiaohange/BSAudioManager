//
//  BSAudioPlayerAgent.m
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "BSAudioPlayerAgent.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "DOUAudioEventLoop.h"
#import "JQNetworkListener.h"
#import <JQTipView/JQTipViewHeader.h>
#import <JQTipViewHeader.h>

#define kDefaultStatusKey       @"status"
#define kDefaultDurationKey     @"duration"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

static BSAudioPlayerAgent *__audioPlayerAgent = nil;

@interface BSAudioPlayerAgent()
@property (nonatomic, assign) BOOL isFirstShow4G;
@end

@implementation BSAudioPlayerAgent

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __audioPlayerAgent = [[BSAudioPlayerAgent alloc] init];
    });
    return __audioPlayerAgent;
}

- (id)init
{
    if (self = [super init]) {
        [self registerNotificationCenter];
        [self setupAudioSession];
    }
    return self;
}

- (void)dealloc
{
    [self resignNotificationCenter];
}

#pragma mark -

- (void)removeAudioStreamerObserver
{
    [_audioPlayer removeObserver:self forKeyPath:kDefaultStatusKey context:kStatusKVOKey];
}

- (void)_updateStatus:(NSNumber *)statusNum
{
    BSAudioPlayerStatus status = [statusNum integerValue];
    self.status = status;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        BSAudioPlayerStatus status = [_audioPlayer status];
        [self performSelector:@selector(_updateStatus:)
                     onThread:[NSThread mainThread]
                   withObject:[NSNumber numberWithInt:status]
                waitUntilDone:NO];
    }
}

- (void)onInterruptOccur:(NSNotification *)notify
{
    NSDictionary *userInfo = [notify userInfo];
    if ([notify.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        AVAudioSessionInterruptionType interType = [[userInfo objectForKey:AVAudioSessionInterruptionTypeKey] integerValue];
        if (interType == AVAudioSessionInterruptionTypeBegan) {
            [self stop];
            [[DOUAudioEventLoop sharedEventLoop] interruptBegin];
        } else if(interType == AVAudioSessionInterruptionTypeEnded) {
            [[DOUAudioEventLoop sharedEventLoop] interruptEnd];
            
            AVAudioSessionInterruptionOptions option = [[userInfo objectForKey:AVAudioSessionInterruptionOptionKey] integerValue];
            if (option == AVAudioSessionInterruptionOptionShouldResume) {
            }
        }
    }
}

- (void)setupAudioSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:NULL];
    [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(onInterruptOccur:) name:AVAudioSessionInterruptionNotification object:nil];
}

#pragma mark -

- (void)registerNotificationCenter
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(onApplicationEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [center addObserver:self selector:@selector(onApplicationEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)resignNotificationCenter
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)resetBackgroundTaskIdentify
{
    _backgroundPlayTaskIdentify = UIBackgroundTaskInvalid;
}

- (BOOL)isInBackgroundStatus
{
    return [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground;
}

- (void)startBackgroundTask
{
    if (_backgroundPlayTaskIdentify != UIBackgroundTaskInvalid) {
        [self endBackgroundTask];
    }
    _backgroundPlayTaskIdentify = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundTask];
    }];
}

- (void)endBackgroundTask
{
    if (_backgroundPlayTaskIdentify != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:_backgroundPlayTaskIdentify];
        [self resetBackgroundTaskIdentify];
    }
}

- (void)onApplicationEnterBackground
{
    [self startBackgroundTask];
    [(id)[UIApplication sharedApplication].delegate becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)onApplicationEnterForeground
{
    [self endBackgroundTask];
}

- (void)configNowPlayingInfoCenter
{
    BSAudioItem *audioItem = [self currentPlayAudioItem];
    NSString *audioName = nil;
    if (![self isStringEmpty:[audioItem audioName]]) {
        audioName = [audioItem audioName];
    }
    NSString *authorName = nil;
    if (![self isStringEmpty:[audioItem authorName]]) {
        authorName = [audioItem authorName];
    }
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        _nowPlayingInfo = [[NSMutableDictionary alloc] init];
        [_nowPlayingInfo setObject:audioName forKey:MPMediaItemPropertyTitle];
        if(authorName)
        {
            [_nowPlayingInfo setObject:authorName forKey:MPMediaItemPropertyArtist];
        }
        else
        {
            [_nowPlayingInfo setObject:@"" forKey:MPMediaItemPropertyArtist];
        }
        
        [_nowPlayingInfo setObject:[NSNumber numberWithDouble:0] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [_nowPlayingInfo setObject:[NSNumber numberWithDouble:0] forKey:MPMediaItemPropertyPlaybackDuration];
        [_nowPlayingInfo setObject:[NSNumber numberWithDouble:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:_nowPlayingInfo];
    }
}

- (BOOL) isStringEmpty:(NSString *)tstr
{
    if(tstr != nil && ![tstr isEqualToString:@""]) {
        return NO;
    } else
    {
        return YES;
    }
}

- (void)onGetDurationBlock:(NSTimeInterval)duration
{
    [_nowPlayingInfo setObject:[NSNumber numberWithDouble:duration] forKey:MPMediaItemPropertyPlaybackDuration];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:_nowPlayingInfo];
}

- (void)onProgressUpdate
{
    if (_progressUpdateBlock) {
        _progressUpdateBlock();
    }
}

#pragma mark -

- (void)playWithAudioItem:(BSAudioItem *)audioItem
{
    if (![audioItem audioFileURL]) {
        return;
    }
    if (![[audioItem audioFileURL] isFileURL] && [[JQNetworkListener shareInstance] isNetConnect] && ![[JQNetworkListener shareInstance] isWifiNetWork] ) {
        if (![[JQNetworkListener shareInstance] isWifiNetWork] && !self.isFirstShow4G) {
            self.isFirstShow4G = YES;
            [JQTipView showWithTip:NSLocalizedString(@"未连接WiFi，在消耗流量播放", @"未连接WiFi，在消耗流量播放")];
        }
    }
    __weak typeof(self) wself = self;
    [self removeAudioStreamerObserver];
    [_audioPlayer stop];
    _audioPlayer = [BSAudioPlayer audioPlayerWithItem:audioItem];
    [_audioPlayer setProgressUpdateBlock:^{
        [wself onProgressUpdate];
    }];
    [_audioPlayer setGetDurationBlock:^(NSTimeInterval duration) {
        [wself onGetDurationBlock:duration];
    }];
    [_audioPlayer addObserver:self forKeyPath:kDefaultStatusKey options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_audioPlayer play];
    [self configNowPlayingInfoCenter];
    if ([self isInBackgroundStatus]) {
        [self startBackgroundTask];
    }
}

- (void)playOrPause
{
    if (_audioPlayer.status == BSAudioPlayerPlaying || _audioPlayer.status ==BSAudioPlayerBuffering) {
        [_audioPlayer pause];
    } else if (_audioPlayer.status == BSAudioPlayerPaused) {
        [_audioPlayer play];
    }
}

- (void)resume
{
    [_audioPlayer resume];
}

- (void)stop
{
    [_audioPlayer stop];
}

- (void)shiftToTime:(NSTimeInterval)theTime
{
    [_audioPlayer shiftToTime:theTime];
}

#pragma mark -

- (BSAudioItem *)currentPlayAudioItem;
{
    return [_audioPlayer audioItem];
}

- (NSTimeInterval)duration
{
    return [_audioPlayer duration];
}

- (NSTimeInterval)currentTime
{
    return [_audioPlayer currentTime];
}

- (NSError *)error
{
    return _audioPlayer.error;
}

- (void)setProgressUpdateBlock:(SNAudioPlayerProgressBlock)block
{
    _progressUpdateBlock = [block copy];
}

- (BSAudioProgressData *)currentAudioProgressData
{
    if (_audioPlayer.status != BSAudioPlayerBuffering && _audioPlayer.status != BSAudioPlayerPlaying) {
        return nil;
    }
    BSAudioProgressData *data = [[BSAudioProgressData alloc] init];
    data.duration = [self duration];
    data.status = _audioPlayer.status;
    data.currentTime = [self currentTime];
    return data;
}

- (void)cleanNowPlayingInfoCenter
{
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
}



@end
