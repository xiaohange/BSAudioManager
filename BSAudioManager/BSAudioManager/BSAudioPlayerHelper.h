//
//  BSAudioPlayerHelper.h
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSAudioProgressData.h"
#import "BSAudioPlayModelManager.h"
#import "BSMusicModel.h"
#import "BSAudioPlayerAgent.h"
#import "BSAudioPlayerObserver.h"
@protocol BSAudioPlayerHelperDelegate;
@protocol BSAudioPlayerHelperProtocol;


@interface BSAudioPlayerHelper : NSObject <BSAudioPlayerHelperProtocol>

@property (nonatomic, weak) id delegate;
@property (nonatomic, readonly) id audioPlayTag;
@property (nonatomic, strong)  NSIndexPath *indexPath;
@property (nonatomic, readonly, strong) BSAudioProgressData *playProgressData;
@property (nonatomic, readwrite,strong) BSAudioPlayModelManager *playModelManager;
@property (nonatomic, assign) BOOL playModelEnable;


#pragma mark -
+ (instancetype)audioPlayerHelper;

#pragma mark -
+ (void)remoteControlReceivedWithEvent:(UIEvent *)event;

#pragma mark -
- (void)cloneProgressDataWithPlayerHelper:(BSAudioPlayerHelper *)playerHelper;
#pragma mark -

- (void)playWithRingItem:(BSMusicModel *)ringItem;
- (void)playWithRingItem:(BSMusicModel *)ringItem audioPlayTag:(id)audioPlayTag;
- (void)playWithRingAudioItemList:(NSArray *)audioItemList;
- (void)playWithRingAudioItemList:(NSArray *)audioItemList startPlayTag:(id)startPlayTag startPlayIndex:(NSInteger)startPlayIndex;
- (void)playNextAudioItem;
- (void)playPreviousAudioItem;
- (void)playOrPause;
- (void)resume;
- (void)stop;
- (void)shiftToTime:(NSTimeInterval)theTime;
- (BSAudioPlayerStatus)audioPlayStatus;
- (BOOL)isCurrentAudioPlayerHelper;

- (BOOL)isInPlayProcess;

#pragma mark -

+ (BSAudioProgressData *)currentAudioProgressData;
+ (BSAudioPlayerStatus)audioPlayStatus;
+ (BSAudioPlayerHelper *)currentPlayerHelper;
//+ (void)setAudioCacheDirectory:(NSString *)directory;

@end

@protocol BSAudioPlayerHelperDelegate <NSObject>

- (void)audioPlayerHelper:(BSAudioPlayerHelper *)playerHelper updatePlayStatusWithData:(BSAudioProgressData *)progressData;
- (void)audioPlayerHelper:(BSAudioPlayerHelper *)playerHelper updateProgressWithData:(BSAudioProgressData *)progressData;

@optional
- (void)audioPlayerHelper:(BSAudioPlayerHelper *)playerHelper didOccurError:(NSError *)error;
- (void)audioPlayerHelperDidChangeToNewPlayItem:(BSAudioPlayerHelper *)playerHelper withLastPlayTag:(id)playTag;
- (void)audioPlayerHelper:(BSAudioPlayerHelper *)playerHelper didPlayNextPlayItemAndUpdatePlayTag:(id *)newPlayTag nextPlayItemIndex:(NSInteger)nextPlayIndex lastPlayTag:(id)lastPlayTag;
- (void)audioPlayerHelperDidSwitchDelegate:(BSAudioPlayerHelper *)playerHelper;


@end
