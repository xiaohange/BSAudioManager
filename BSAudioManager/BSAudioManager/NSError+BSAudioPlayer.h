//
//  NSError+BSAudioPlayer.h
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (BSAudioPlayer)


+ (NSError *)bsPlayTimeoutError;
+ (NSError *)bsPlayNetworkError;
+ (NSError *)bsAudioDecodeError;
+ (NSError *)bsUnknowError;

@end
