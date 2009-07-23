//
//  SoundEffect.m
//  Phoney Crack
//
//  Created by Marcus Kratz on 3/24/09.
//  Copyright 2009 Marcus Kratz Electrical. All rights reserved.
//

#import "SoundEffect.h"


@implementation SoundEffect
+ (id)soundEffectWithContentsOfFile:(NSString *)aPath {
    if (aPath) {
        return [[[SoundEffect alloc] initWithContentsOfFile:aPath] autorelease];
    }
    return nil;
}

- (id)initWithContentsOfFile:(NSString *)path {
    self = [super init];
    
    if (self != nil) {
        NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
        
        if (aFileURL != nil)  {
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, &aSoundID);
            
            if (error == kAudioServicesNoError) { // success
                _soundID = aSoundID;
            } else {
                NSLog(@"Error %d loading sound at path: %@", error, path);
                [self release], self = nil;
            }
        } else {
            NSLog(@"NSURL is nil for path: %@", path);
            [self release], self = nil;
        }
    }
    return self;
}

-(void)dealloc {
    AudioServicesDisposeSystemSoundID(_soundID);
    [super dealloc];
}

-(void)play {
    AudioServicesPlaySystemSound(_soundID);
}

@end
