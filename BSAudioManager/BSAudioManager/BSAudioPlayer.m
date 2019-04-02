//
//  BSAudioPlayer.m
//  MusicRing
//  对豆瓣播放器的二次封装
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "BSAudioPlayer.h"
#import "NSError+BSAudioPlayer.h"

#define kDefaultStatusKey       @"status"
#define kDefaultDurationKey     @"duration"
static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;
#define PlayerTimeSpace 0.2
#define TimeOutLimitLength      20


@implementation BSAudioPlayer

- (instancetype)initWithItem:(BSAudioItem *)item
{
    if (self = [super init]) {
        [DOUAudioStreamer setOptions:DOUAudioStreamerKeepPersistentVolume];
        _audioItem = item;
    }
    return self;
}

+ (instancetype)audioPlayerWithItem:(BSAudioItem *)item
{
    return [[[self class] alloc] initWithItem:item];
}

- (void)setProgressBlock:(SNAudioPlayerProgressBlock)progressBlock
{
    _progressUpdateBlock = [progressBlock copy];
}

- (void)setGetDurationBlock:(SNAudioPlayerGetDurationBlock)getDurationBlock
{
    _getDurationBlock = [getDurationBlock copy];
}


#pragma mark -

- (void)startPlayerTimer
{
    if(_newPlayerTimer){
        dispatch_cancel(_newPlayerTimer);
    }
    dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
    _newPlayerTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_newPlayerTimer, DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_newPlayerTimer, ^{
        [self onPlayerTimer];
    });
    dispatch_resume(_newPlayerTimer);
    
    /*
     [_playerTimer invalidate];
     _playerTimer = [NSTimer scheduledTimerWithTimeInterval:PlayerTimeSpace target:self selector:@selector(onPlayerTimer) userInfo:nil repeats:YES];
     [[NSRunLoop currentRunLoop] addTimer:_playerTimer forMode:NSRunLoopCommonModes];
     */
    
    
}

- (void)stopPlayerTimer
{
    dispatch_cancel(_newPlayerTimer);
    //_newPlayerTimer = nil;
    /*
     [_playerTimer invalidate];
     _playerTimer = nil;*/
}

- (void)onPlayerTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_progressUpdateBlock) {
            self->_progressUpdateBlock();
        }
    });
    
}

#pragma mark -

- (void)startTimeoutTimer
{
    [_timeoutCheckTimer invalidate];
    _timeoutCheckTimer = [NSTimer scheduledTimerWithTimeInterval:TimeOutLimitLength target:self selector:@selector(onTimeoutTimer) userInfo:nil repeats:NO];
}

- (void)stopTimeoutTimer
{
    [_timeoutCheckTimer invalidate];
    _timeoutCheckTimer = nil;
}

- (void)onTimeoutTimer
{
    self.error = [NSError bsPlayTimeoutError];
    self.status = BSAudioPlayerError;
}


- (void)addAudioStreamerObserver
{
    [_audioStreamer addObserver:self forKeyPath:kDefaultStatusKey options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_audioStreamer addObserver:self forKeyPath:kDefaultDurationKey options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
}

- (void)removeAudioStreamerObserver
{
    [_audioStreamer removeObserver:self forKeyPath:kDefaultStatusKey context:kStatusKVOKey];
    [_audioStreamer removeObserver:self forKeyPath:kDefaultDurationKey context:kDurationKVOKey];
}

- (void)play
{
    [_audioStreamer stop];
    if (!_audioStreamer) {
        _audioStreamer =  [DOUAudioStreamer streamerWithAudioFile:_audioItem];
        [self addAudioStreamerObserver];
    }
    [_audioStreamer play];
    [self startPlayerTimer];
    self.status = BSAudioPlayerLaunch;
}

- (void)resume
{
    [_audioStreamer play];
    [self startPlayerTimer];
    //self.status = BSAudioPlayerLaunch;
}

- (void)pause
{
    [_audioStreamer pause];
    [self stopTimeoutTimer];
    [self stopPlayerTimer];
}

- (void)_cleanPlayCacheFile
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:[_audioItem cachePath] error:nil];
}

- (void)stop
{
    if (_audioStreamer) {
        [self removeAudioStreamerObserver];
        if (![_audioStreamer isRequestFinish]) {
            [self _cleanPlayCacheFile];
        }
        [_audioStreamer stop];
        _audioStreamer = nil;
        [self stopTimeoutTimer];
        [self stopPlayerTimer];
        self.status = BSAudioPlayerUserStop;
    }
}

- (void)shiftToTime:(NSTimeInterval)theTime
{
    [self stopPlayerTimer];
    _audioStreamer.currentTime = theTime;
}

- (NSTimeInterval)duration
{
    return [_audioStreamer duration];
}

- (NSTimeInterval)currentTime
{
    return [_audioStreamer currentTime];
}


- (void)_updateStatus:(NSNumber *)statusNum
{
    DOUAudioStreamerStatus status = [statusNum integerValue];
    switch (status) {
        case DOUAudioStreamerPlaying:
            [self stopTimeoutTimer];
            self.status = BSAudioPlayerPlaying;
            break;
        case DOUAudioStreamerPaused:
            [self stopTimeoutTimer];
            self.status = BSAudioPlayerPaused;
            break;
        case DOUAudioStreamerBuffering:
            [self startTimeoutTimer];
            self.status = BSAudioPlayerBuffering;
            break;
        case DOUAudioStreamerFinished:
            [self stopTimeoutTimer];
            [self stopPlayerTimer];
            self.status = BSAudioPlayerFinished;
            break;
        case DOUAudioStreamerIdle:
            [self stopTimeoutTimer];
            [self stopPlayerTimer];
            self.status = BSAudioPlayerIdle;
            break;
        case DOUAudioStreamerError:
            [self _cleanPlayCacheFile];
            [self stopTimeoutTimer];
            [self stopPlayerTimer];
            if (_audioStreamer.error.code == DOUAudioStreamerNetworkError) {
                self.error = [NSError bsPlayNetworkError];
            } else if (_audioStreamer.error.code == DOUAudioStreamerDecodingError) {
                self.error = [NSError bsAudioDecodeError];
            } else {
                self.error = [NSError bsUnknowError];
            }
            self.status = BSAudioPlayerError;
            break;
        default:
            break;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        DOUAudioStreamerStatus status = [_audioStreamer status];
        [self performSelector:@selector(_updateStatus:)
                     onThread:[NSThread mainThread]
                   withObject:[NSNumber numberWithInt:status]
                waitUntilDone:NO];
    } else if (context == kDurationKVOKey) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_getDurationBlock) {
                _getDurationBlock(_audioStreamer.duration);
            }
        });
    }
}
@end
