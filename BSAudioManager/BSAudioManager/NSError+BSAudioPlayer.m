//
//  NSError+BSAudioPlayer.h
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "NSError+BSAudioPlayer.h"
#import "BSAudioPlayerDefines.h"

static  NSString * const SNAudioPlayerErrorDomain = @"com.david.audioPlayerErrorDomain";

@implementation NSError (BSAudioPlayer)

+ (NSError *)bsPlayTimeoutError
{
    return [NSError errorWithDomain:SNAudioPlayerErrorDomain code:BSAudioPlayerTimeout userInfo:nil];
}

+ (NSError *)bsPlayNetworkError
{
    return [NSError errorWithDomain:SNAudioPlayerErrorDomain code:BSAudioPlayerNetWorkError userInfo:nil];
}

+ (NSError *)bsAudioDecodeError
{
    return [NSError errorWithDomain:SNAudioPlayerErrorDomain code:BSAudioPlayerDecodeError userInfo:nil];
}

+ (NSError *)bsUnknowError
{
    return [NSError errorWithDomain:SNAudioPlayerErrorDomain code:BSAudioPlayerUnknownError userInfo:nil];
}

@end
