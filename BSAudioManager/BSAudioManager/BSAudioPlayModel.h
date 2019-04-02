//
//  BSAudioPlayModel.h
//  MusicRing
//  音频播放模式
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSAudioPlayList.h"
#import "BSAudioPlayerDefines.h"

@protocol BSAudioPlayModel <NSObject>

- (void)changeToNextPlayAudioItem;
- (void)changeToPreviousPlayAudioItem;

@end

@interface BSAudioPlayModel : NSObject <BSAudioPlayModel>
{

}

@property (nonatomic, readwrite, strong) BSAudioPlayList *audioPlayList;
@property (nonatomic, readonly) NSInteger currentPlayIndex;
@property (nonatomic, readonly) id currentPlayAudioItem;
@property (nonatomic, readonly) BSAudioPlayModelType modelType;

+ (instancetype)audioPlayModelWithType:(BSAudioPlayModelType)modelType;
+ (instancetype)audioPlayModelWithType:(BSAudioPlayModelType)modelType audioPlayList:(BSAudioPlayList *)playList;

#pragma mark -
- (BOOL)hasNextPlayItem;
- (BOOL)hasPreviousPlayItem;
- (id)getNextPlayItem;
- (id)getPreviousPlayItem;

@end
