//
//  BSCircleAudioPlayModel.m
//  MusicRing
//  
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "BSCircleAudioPlayModel.h"

@implementation BSCircleAudioPlayModel

- (NSInteger)getNextPlayIndex
{
    NSInteger newIndex = -1;
    if (self.audioPlayList.currentPlayIndex >= self.audioPlayList.playAudioItemCount - 1) {
        newIndex = 0;
    } else {
        newIndex = self.audioPlayList.currentPlayIndex + 1;
    }
    return newIndex;
}

- (NSInteger)getPreviousPlayIndex
{
    NSInteger newIndex = -1;
    if (self.audioPlayList.currentPlayIndex <= 0) {
        newIndex = self.audioPlayList.playAudioItemCount - 1;
    } else {
        newIndex = self.audioPlayList.currentPlayIndex - 1;
    }
    return newIndex;
}

- (void)changeToNextPlayAudioItem
{
    [self.audioPlayList setCurrentPlayIndex:[self getNextPlayIndex]];
}

- (void)changeToPreviousPlayAudioItem
{
    [self.audioPlayList setCurrentPlayIndex:[self getPreviousPlayIndex]];
}

- (id)currentPlayAudioItem
{
    return [super currentPlayAudioItem];
}

- (BOOL)hasNextPlayItem
{
    if ([self.audioPlayList playAudioItemCount] == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)hasPreviousPlayItem
{
    if ([self.audioPlayList playAudioItemCount] == 0) {
        return NO;
    }
    return YES;
}

- (id)getNextPlayItem
{
    if (![self hasNextPlayItem]) {
        return nil;
    }
    return [self.audioPlayList getAudioItemAtIndex:[self getNextPlayIndex]];
}

- (id)getPreviousPlayItem
{
    if (![self hasPreviousPlayItem]) {
        return nil;
    }
    return [self.audioPlayList getAudioItemAtIndex:[self getPreviousPlayIndex]];
}


@end
