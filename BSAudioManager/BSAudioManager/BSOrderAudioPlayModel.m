//
//  BSOrderAudioPlayModel.m
//  MusicRing
//  
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "BSOrderAudioPlayModel.h"

@implementation BSOrderAudioPlayModel

- (void)changeToNextPlayAudioItem
{
    if (self.audioPlayList.currentPlayIndex >= self.audioPlayList.playAudioItemCount - 1) {
        return;
    }
    [self.audioPlayList setCurrentPlayIndex:self.audioPlayList.currentPlayIndex + 1];
}

- (void)changeToPreviousPlayAudioItem
{
    if (self.audioPlayList.currentPlayIndex <= 0) {
        return;
    }
    [self.audioPlayList setCurrentPlayIndex:self.audioPlayList.currentPlayIndex - 1];
}

- (id)currentPlayAudioItem
{
    return [super currentPlayAudioItem];
}

- (BOOL)hasNextPlayItem
{
    if (self.audioPlayList.playAudioItemCount == 0 || self.audioPlayList.currentPlayIndex >= self.audioPlayList.playAudioItemCount - 1) {
        return NO;
    }
    return YES;
}

- (BOOL)hasPreviousPlayItem
{
    if (self.audioPlayList.playAudioItemCount == 0 || self.audioPlayList.currentPlayIndex <= 0) {
        return NO;
    }
    return YES;
}

- (id)getNextPlayItem
{
    if (![self hasNextPlayItem]) {
        return nil;
    }
    return [self.audioPlayList getAudioItemAtIndex:self.audioPlayList.currentPlayIndex + 1];
}

- (id)getPreviousPlayItem
{
    if (![self hasPreviousPlayItem]) {
        return nil;
    }
    return [self.audioPlayList getAudioItemAtIndex:self.audioPlayList.currentPlayIndex - 1];
}

@end
