//
//  BSAudioPlayModelManager.h
//  MusicRing
//  音频播放模式管理器
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSAudioPlayerDefines.h"
#import "BSAudioPlayList.h"
#import "BSAudioPlayModel.h"

@interface BSAudioPlayModelManager : NSObject <BSAudioPlayModel>
{
@private
    NSMutableDictionary *_playModelDictionary;
}

@property (nonatomic, strong)   BSAudioPlayList *audioPlayList;
@property (nonatomic, readonly) NSInteger currentPlayIndex;
@property (nonatomic, readonly) id currentPlayAudioItem;
@property (nonatomic, assign)   BSAudioPlayModelType currentModelType;
@property (nonatomic, readonly) BSAudioPlayModel *currentPlayModel;

@property (nonatomic, assign)   BOOL enable;


@end
