//
//  CrackedGlassSoundEffect.h
//  Phoney Crack
//
//  Created by Marcus Kratz on 3/24/09.
//  Copyright 2009 Marcus Kratz Electrical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@interface SoundEffect : NSObject {
    SystemSoundID _soundID;
}

+ (id)soundEffectWithContentsOfFile:(NSString *)aPath;
- (id)initWithContentsOfFile:(NSString *)path;
- (void)play;

@end
