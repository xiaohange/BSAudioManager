//
//  BSAudioPlayerHelper.m
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "BSAudioPlayerHelper.h"
#import "JQNetworkListener.h"
#import <JQTipView/JQTipViewHeader.h>
#import "BSAudioPlayerObserver.h"

#define AutoPlayErrorCountLimit 4

@interface BSAudioPlayerHelper ()
{
    NSInteger _autoPlayErrorCount;
}

@end

@implementation BSAudioPlayerHelper

#pragma mark -
- (BOOL)isSupportSortPlay
{
    return YES;
}

- (void)inscreaseAutoPlayErrorCount
{
    _autoPlayErrorCount ++;
}

- (void)resetAutoPlayErrorCount
{
    _autoPlayErrorCount = 0;
}

- (BOOL)isAutoPlayErrorLimit
{
    return _autoPlayErrorCount >= AutoPlayErrorCountLimit;
}

#pragma mark -

+ (instancetype)audioPlayerHelper
{
    return [[[self class] alloc] init];
}

- (id)init
{
    if (self = [super init]) {
        _playProgressData = [[BSAudioProgressData alloc] init];
        _playModelManager = [[BSAudioPlayModelManager alloc] init];
    }
    return self;
}

- (void)cloneProgressDataWithPlayerHelper:(BSAudioPlayerHelper *)playerHelper
{
    _playProgressData = [[playerHelper playProgressData] copy];
}

- (void)audioPlayerHelperDidLaunch
{
    _playProgressData.status = BSAudioPlayerLaunch;
    [_delegate audioPlayerHelper:self updatePlayStatusWithData:_playProgressData];
}

- (void)audioPlayerHelperInPlaying
{
    _playProgressData.status = BSAudioPlayerPlaying;
    [_delegate audioPlayerHelper:self updatePlayStatusWithData:_playProgressData];
}

- (void)audioPlayerHelperInBuffering
{
    _playProgressData.status = BSAudioPlayerBuffering;
    [_delegate audioPlayerHelper:self updatePlayStatusWithData:_playProgressData];
}

- (void)audioPlayerHelperInPause
{
    _playProgressData.status = BSAudioPlayerPaused;
    [_delegate audioPlayerHelper:self updatePlayStatusWithData:_playProgressData];
}

- (void)audioPlayerHelperFinish
{
    _playProgressData.status = BSAudioPlayerFinished;
    [_delegate audioPlayerHelper:self updatePlayStatusWithData:_playProgressData];
    [self playNextAudioItemAuto];
}

- (void)audioPlayerHelperUserStop
{
    _playProgressData.status = BSAudioPlayerFinished;
    [_delegate audioPlayerHelper:self updatePlayStatusWithData:_playProgressData];
}

- (void)audioPlayerHelperOccurError:(NSError *)error
{
    _playProgressData.status = BSAudioPlayerError;
    [_delegate audioPlayerHelper:self updatePlayStatusWithData:_playProgressData];
    if ([_delegate respondsToSelector:@selector(audioPlayerHelper:didOccurError:)]) {
        [_delegate audioPlayerHelper:self didOccurError:error];
    }
    switch (error.code) {
        case BSAudioPlayerNetWorkError:
        case BSAudioPlayerTimeout:
            [JQTipView showWithTip:NSLocalizedString(@"网络不给力，请您检查网络设置或稍后再试", @"网络不给力，请您检查网络设置或稍后再试")];
            break;
        case BSAudioPlayerDecodeError:
            [JQTipView showWithTip:NSLocalizedString(@"播放文件格式不支持", @"播放文件格式不支持")];
            break;
        case BSAudioPlayerUnknownError:
            [JQTipView showWithTip:NSLocalizedString(@"播放发生未知错误", @"播放发生未知错误")];
            break;
        default:
            break;
    }
    if ([[JQNetworkListener shareInstance] isNetConnect]) {
        if ([self isAutoPlayErrorLimit]) {
            return;
        }
        [self inscreaseAutoPlayErrorCount];
        [self playNextAudioItemAuto];
    }
}

- (void)audioPlayerHelperUpdateWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    _playProgressData.duration = duration;
    if (fabs(duration) > 1e-6) {
        [self resetAutoPlayErrorCount];
    }
    _playProgressData.currentTime = currentTime;
    [_delegate audioPlayerHelper:self updateProgressWithData:_playProgressData];
}

- (void)audioPlayerHelperChange
{
    _playProgressData.status = BSAudioPlayerIdle;
    [_delegate audioPlayerHelper:self updatePlayStatusWithData:_playProgressData];
}

#pragma mark -

- (void)playNextAudioItemAuto
{
    if (_playModelManager.enable && [self isSupportSortPlay]) {
        if ([[_playModelManager currentPlayModel] hasNextPlayItem]) {
            BSMusicModel *ringItem = [_playModelManager.currentPlayModel getNextPlayItem];
            BSAudioItem *audioItem = [BSAudioItem audioItemWithOriginAudioDataItem:ringItem];
            if ([[audioItem audioFileURL] isFileURL] || [[JQNetworkListener shareInstance] isWifiNetWork]) {
                [_playModelManager changeToNextPlayAudioItem];
                [self _playNewAudioItem];
            }
        } else {
            // do nothing
        }
    }
}

- (void)_playNewAudioItem
{
    id tag = nil;
    if ([_delegate respondsToSelector:@selector(audioPlayerHelper:didPlayNextPlayItemAndUpdatePlayTag:nextPlayItemIndex:lastPlayTag:)]) {
        [_delegate audioPlayerHelper:self didPlayNextPlayItemAndUpdatePlayTag:&tag nextPlayItemIndex:[_playModelManager currentPlayIndex] lastPlayTag:_audioPlayTag];
    }
    BSMusicModel *ringItem = [_playModelManager currentPlayAudioItem];
    [self _playWithOriginRingItem:ringItem audioPlayTag:tag];
}

#pragma mark -

- (BSAudioPlayerHelper *)getCurrentPlayerHelper
{
    return [BSAudioPlayerObserver defaultAudioPlayerObserver].currentAudioPlayerHelper;
}

- (void)playWithRingItem:(BSMusicModel *)ringItem
{
    _playModelManager.enable = NO;
    [self playWithRingItem:ringItem audioPlayTag:nil];
}

- (void)playWithRingItem:(BSMusicModel *)ringItem audioPlayTag:(id)audioPlayTag
{
    [self resetAutoPlayErrorCount];
    [self _playWithOriginRingItem:ringItem audioPlayTag:audioPlayTag];
}

- (void)_playWithOriginRingItem:(BSMusicModel *)audioItem audioPlayTag:(id)audioPlayTag
{
    if ([_delegate respondsToSelector:@selector(audioPlayerHelperDidChangeToNewPlayItem:withLastPlayTag:)]) {
        [_delegate audioPlayerHelperDidChangeToNewPlayItem:self withLastPlayTag:_audioPlayTag];
    }
    _audioPlayTag = audioPlayTag;
    if ([self getCurrentPlayerHelper] != self) {
        [BSAudioPlayerObserver defaultAudioPlayerObserver].currentAudioPlayerHelper = self;
    }
    [[BSAudioPlayerAgent sharedInstance] playWithAudioItem:[BSAudioItem audioItemWithOriginAudioDataItem:audioItem]];
}

- (void)playWithRingAudioItemList:(NSArray *)audioItemList
{
    [self playWithRingAudioItemList:audioItemList startPlayTag:nil startPlayIndex:0];
}

- (void)playWithRingAudioItemList:(NSArray *)audioItemList startPlayTag:(id)startPlayTag startPlayIndex:(NSInteger)startPlayIndex
{
    if (!audioItemList.count) {
        return;
    }
    [self resetAutoPlayErrorCount];
    _playModelManager.audioPlayList = [BSAudioPlayList audioPlayListWithList:audioItemList currentPlayIndex:startPlayIndex];
    BSMusicModel *ringItem = [_playModelManager currentPlayAudioItem];
    [self playWithRingItem:ringItem audioPlayTag:startPlayTag];
}

- (void)playOrPause
{
    if ([self getCurrentPlayerHelper] != self) {
        return;
    }
    if ([self isInPlayProcess]) {
        [[BSAudioPlayerAgent sharedInstance] playOrPause];
    } else {
        [self playCurrentAudioItem];
    }
}

- (void)resume
{
    if ([self getCurrentPlayerHelper] != self) {
        return;
    }
    [[BSAudioPlayerAgent sharedInstance] resume];
}


- (void)stop
{
    if ([self getCurrentPlayerHelper] != self) {
        return;
    }
    [[BSAudioPlayerAgent sharedInstance] stop];
    [[BSAudioPlayerAgent sharedInstance] cleanNowPlayingInfoCenter];
}

- (void)shiftToTime:(NSTimeInterval)theTime
{
    if ([self getCurrentPlayerHelper] != self) {
        return;
    }
    [[BSAudioPlayerAgent sharedInstance] shiftToTime:theTime];
}

- (void)playNextAudioItem
{
    if (!_playModelManager || !_playModelManager.enable) {
        return;
    }
    if ([[_playModelManager currentPlayModel] hasNextPlayItem]) {
        [_playModelManager changeToNextPlayAudioItem];
        [self _playNewAudioItem];
    } else {
      
    }
}

- (void)playPreviousAudioItem
{
    if (!_playModelManager || !_playModelManager.enable) {
        return;
    }
    if ([[_playModelManager currentPlayModel] hasPreviousPlayItem]) {
        [_playModelManager changeToPreviousPlayAudioItem];
        [self _playNewAudioItem];
    } else {
    }
}

- (void)playCurrentAudioItem
{
    BSMusicModel *ringItem = [_playModelManager currentPlayAudioItem];
    if ([self getCurrentPlayerHelper] != self) {
        [BSAudioPlayerObserver defaultAudioPlayerObserver].currentAudioPlayerHelper = self;
    }
    [[BSAudioPlayerAgent sharedInstance] playWithAudioItem:[BSAudioItem audioItemWithOriginAudioDataItem:ringItem]];
}

- (BOOL)isInPlayProcess
{
    BSAudioPlayerStatus status = [self audioPlayStatus];
    return status == BSAudioPlayerBuffering || status == BSAudioPlayerPlaying || status == BSAudioPlayerPaused;
}

#pragma mark -

- (BSAudioPlayerStatus)audioPlayStatus
{
    return _playProgressData.status;
}

- (BOOL)isCurrentAudioPlayerHelper
{
    return [BSAudioPlayerObserver defaultAudioPlayerObserver].currentAudioPlayerHelper == self;
}

+ (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    [[BSAudioPlayerObserver defaultAudioPlayerObserver] remoteControlReceivedWithEvent:event];
}

+ (BSAudioProgressData *)currentAudioProgressData
{
    return [[BSAudioPlayerAgent sharedInstance] currentAudioProgressData];
}

+ (BSAudioPlayerStatus)audioPlayStatus
{
    return [[BSAudioPlayerAgent sharedInstance] status];
}

#pragma mark -

- (BOOL)playModelEnable
{
    return [_playModelManager enable];
}

- (void)setPlayModelEnable:(BOOL)playModelEnable
{
    _playModelManager.enable = playModelEnable;
}

+ (BSAudioPlayerHelper *)currentPlayerHelper
{
    return [[BSAudioPlayerObserver defaultAudioPlayerObserver] currentAudioPlayerHelper];
}

@end
