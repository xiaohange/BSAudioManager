//
//  BSAudioPlayerAgent.h
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSAudioPlayer.h"
#import "BSAudioItem.h"
#import "BSAudioProgressData.h"

@interface BSAudioPlayerAgent : NSObject
{
@private
    UIBackgroundTaskIdentifier _backgroundPlayTaskIdentify;
    NSMutableDictionary *_nowPlayingInfo;
}

+ (BSAudioPlayerAgent *)sharedInstance;

@property (nonatomic, readonly, strong)  BSAudioPlayer *audioPlayer;
@property (nonatomic, readwrite,assign)  BSAudioPlayerStatus status;
@property (nonatomic, readwrite,copy)    SNAudioPlayerProgressBlock progressUpdateBlock;
@property (nonatomic, readonly, strong)  NSError *error;

- (void)setProgressUpdateBlock:(SNAudioPlayerProgressBlock)block;

#pragma mark -

- (void)playWithAudioItem:(BSAudioItem *)audioItem;

#pragma mark -
- (void)playOrPause;
- (void)resume;
- (void)stop;

- (void)shiftToTime:(NSTimeInterval)theTime;

#pragma mark -

- (BSAudioItem *)currentPlayAudioItem;
- (NSTimeInterval)duration;
- (NSTimeInterval)currentTime;
- (BSAudioProgressData *)currentAudioProgressData;

#pragma mark -

- (void)configNowPlayingInfoCenter;
- (void)cleanNowPlayingInfoCenter;

@end
