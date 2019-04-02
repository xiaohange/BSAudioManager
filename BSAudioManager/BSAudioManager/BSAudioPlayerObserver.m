//
//  BSAudioPlayerObserver.m
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "BSAudioPlayerObserver.h"
#import "BSAudioPlayerAgent.h"
#define kDefaultStatusKey       @"status"
static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;
static BSAudioPlayerObserver *__audioPlayerObserver = nil;

@implementation BSAudioPlayerObserver

#pragma mark -

+ (instancetype)defaultAudioPlayerObserver
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __audioPlayerObserver = [[BSAudioPlayerObserver alloc] init];
    });
    return __audioPlayerObserver;
}

+ (id)alloc
{
    NSAssert(__audioPlayerObserver == nil, @"请使用defaultAudioPlayerObserver获取实例对象！");
    return [super alloc];
}

#pragma mark -

- (id)init
{
    if (self = [super init]) {
        [[BSAudioPlayerAgent sharedInstance] addObserver:self forKeyPath:kDefaultStatusKey options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
        __weak typeof(self) wself = self;
        [[BSAudioPlayerAgent sharedInstance] setProgressUpdateBlock:^{
            [wself onProgressUpdate];
        }]; 
    }
    return self;
}

#pragma mark -

- (void)onProgressUpdate
{
    NSTimeInterval currentTime = [[BSAudioPlayerAgent sharedInstance] currentTime];
    NSTimeInterval duration = [[BSAudioPlayerAgent sharedInstance] duration];
    [_currentAudioPlayerHelper audioPlayerHelperUpdateWithCurrentTime:currentTime duration:duration];
}

- (void)_updateStatus:(NSNumber *)statusNum
{
    BSAudioPlayerStatus status = [statusNum integerValue];
    switch (status) {
        case BSAudioPlayerLaunch:
        {
            [_currentAudioPlayerHelper audioPlayerHelperDidLaunch];
        }
            break;
        case BSAudioPlayerPlaying:
        {
            [_currentAudioPlayerHelper audioPlayerHelperInPlaying];
        }
            break;
        case BSAudioPlayerPaused:
        {
            [_currentAudioPlayerHelper audioPlayerHelperInPause];
        }
            break;
        case BSAudioPlayerBuffering:
        {
            [_currentAudioPlayerHelper audioPlayerHelperInBuffering];
        }
            break;
        case BSAudioPlayerError:
        {
            [_currentAudioPlayerHelper audioPlayerHelperOccurError:[BSAudioPlayerAgent sharedInstance].error];
        }
            break;
        case BSAudioPlayerFinished:
        {
            [_currentAudioPlayerHelper audioPlayerHelperFinish];
        }
            break;
        case BSAudioPlayerIdle:
        {
            [_currentAudioPlayerHelper audioPlayerHelperFinish];
        }
            break;
        case BSAudioPlayerUserStop:
        {
            [_currentAudioPlayerHelper audioPlayerHelperUserStop];
        }
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        BSAudioPlayerStatus status = [[BSAudioPlayerAgent sharedInstance] status];
        [self performSelector:@selector(_updateStatus:)
                     onThread:[NSThread mainThread]
                   withObject:[NSNumber numberWithInt:status]
                waitUntilDone:NO];
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if ([[self currentAudioPlayerHelper] respondsToSelector:@selector(playOrPause)]) {
                    [[self currentAudioPlayerHelper] playOrPause];
                }
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                if ([[self currentAudioPlayerHelper] respondsToSelector:@selector(playPreviousAudioItem)]) {
                    [[self currentAudioPlayerHelper] playPreviousAudioItem];
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                if ([[self currentAudioPlayerHelper] respondsToSelector:@selector(playNextAudioItem)]) {
                    [[self currentAudioPlayerHelper] playNextAudioItem];
                }
                break;
            case UIEventSubtypeRemoteControlPlay:
                if ([[self currentAudioPlayerHelper] respondsToSelector:@selector(playOrPause)]) {
                    [[self currentAudioPlayerHelper] playOrPause];
                }
                break;
            case UIEventSubtypeRemoteControlPause:
                if ([[self currentAudioPlayerHelper] respondsToSelector:@selector(playOrPause)]) {
                    [[self currentAudioPlayerHelper] playOrPause];
                }
                break;
            default:
                break;
        }
    }
}

#pragma mark -

- (void)setCurrentAudioPlayerHelper:(id<BSAudioPlayerHelperProtocol>)currentAudioPlayerHelper
{
    if (_currentAudioPlayerHelper != currentAudioPlayerHelper) {
        [_currentAudioPlayerHelper audioPlayerHelperChange];
    }
    _currentAudioPlayerHelper = currentAudioPlayerHelper;
}


@end
