//
//  TwitterEngineController.h
//  socialpass
//
//  Created by Corey Floyd on 6/26/10.
//  Copyright 2010 Flying Jalapeño Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGTwitterEngineDelegate.h"
#import "SynthesizeSingleton.h"

@class MGTwitterEngine;

@protocol TwitterEngineControllerDelegate;

@interface TwitterEngineController : NSObject <MGTwitterEngineDelegate>{

    MGTwitterEngine* twitterEngine;

    NSString* username;
    NSString* password;
    
    NSString* XAuthFetchID;
    
    id<TwitterEngineControllerDelegate> delegate;
}
@property (nonatomic, assign) id<TwitterEngineControllerDelegate> delegate;
@property (nonatomic, readonly) BOOL loggedIn;

+ (TwitterEngineController*)sharedTwitterEngineController;

- (BOOL)loginWithUserName:(NSString*)name password:(NSString*)pwd;

- (BOOL)getFollowers;
- (BOOL)getFollowing;

@end


@protocol TwitterEngineControllerDelegate <NSObject>

@optional
- (void)twitterEngineController:(TwitterEngineController*)controller didLogin:(BOOL)login error:(NSError*)error;  
- (void)twitterEngineController:(TwitterEngineController*)controller didFetchFollowers:(NSArray*)followers error:(NSError*)error;  
- (void)twitterEngineController:(TwitterEngineController*)controller didFetchFollowing:(NSArray*)following error:(NSError*)error;  



@end

