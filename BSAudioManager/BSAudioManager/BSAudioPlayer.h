//
//  BSAudioPlayer.h
//  MusicRing
//  对豆瓣播放器的二次封装
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSAudioItem.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioStreamer+Options.h"
#import "BSAudioPlayerDefines.h"

typedef void (^SNAudioPlayerProgressBlock) (void);
typedef void (^SNAudioPlayerGetDurationBlock) (NSTimeInterval duration);

@interface BSAudioPlayer : NSObject
{
@private
    DOUAudioStreamer *_audioStreamer;

    NSTimer *_playerTimer;
    NSTimer *_timeoutCheckTimer;
    
    dispatch_source_t  _newPlayerTimer;
    dispatch_source_t  _newTimeoutCheckTimer;
}

@property (nonatomic,readwrite,assign) BSAudioPlayerStatus status;
@property (nonatomic,readwrite,strong) BSAudioItem *audioItem;
          ;
@property (nonatomic,readwrite,strong) NSError *error;
@property (nonatomic,readwrite,copy) SNAudioPlayerProgressBlock progressUpdateBlock;
@property (nonatomic,readwrite,copy) SNAudioPlayerGetDurationBlock getDurationBlock;

- (instancetype)initWithItem:(BSAudioItem *)item;
+ (instancetype)audioPlayerWithItem:(BSAudioItem *)item;

- (void)setProgressBlock:(SNAudioPlayerProgressBlock)progressBlock ;
- (void)setGetDurationBlock:(SNAudioPlayerGetDurationBlock)getDurationBlock;

- (void)play;
- (void)resume;
- (void)pause;
- (void)stop;
- (void)shiftToTime:(NSTimeInterval)theTime;

- (NSTimeInterval)duration;
- (NSTimeInterval)currentTime;

@end
