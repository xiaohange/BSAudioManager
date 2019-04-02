//
//  BSAudioPlayerDefines.h
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#ifndef BSAudioPlayerDefines_h
#define BSAudioPlayerDefines_h

typedef NS_ENUM(NSUInteger, BSAudioPlayerStatus) {
    BSAudioPlayerIdle,
    BSAudioPlayerLaunch,
    BSAudioPlayerPlaying,
    BSAudioPlayerPaused,
    BSAudioPlayerBuffering,
    BSAudioPlayerFinished,
    BSAudioPlayerUserStop,
    BSAudioPlayerError,
};

typedef NS_ENUM(NSUInteger, BSAudioPlayerErrorCode) {
    BSAudioPlayerNoError,
    BSAudioPlayerNetWorkError,
    BSAudioPlayerTimeout,
    BSAudioPlayerDecodeError,
    BSAudioPlayerUnknownError,
};

typedef NS_ENUM(NSUInteger, BSAudioPlayModelType) {
    BSAudioPlayModelUnknowType,
    BSAudioPlayModelOrderedType,
    BSAudioPlayModelCircleType,
};


#endif
