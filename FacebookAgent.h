//
//  FacebookAgent.h
//  Pagination
//
//  Created by Shaikh Sonny Aman on 1/6/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect/FBConnect.h"

@class FacebookAgent;

typedef  enum {
	FacebookAgentActionNone = 0,
	FacebookAgentActionPublishFeed,
	FacebookAgentActionSetStatus,
	FacebookAgentActionAskPermission,
	FacebookAgentActionUploadPhoto,
	FacebookAgentActionUploadPhotoAskPermission,
}FacebookAgentAction;

/**
 * Implement this protocol to use FacebokAgent
 */
@protocol FacebookAgentDelegate <NSObject>

@optional

/**
 * Must define this method if setStatus is called
 *
 * This method is called when user status is changed either successfully or not
 */
- (void) facebookAgent:(FacebookAgent*)agent statusChanged:(BOOL) success;

/**
 * Must define this method if shouldFetchUsernameAfterLogin is set YES
 *
 * This method is called after the agent fetched facebook profile name
 */
- (void) facebookAgent:(FacebookAgent*)agent didLoadName:(NSString*) name;

/**
 * Must define this method if uploadPhoto is called
 *
 * This method is called after photo is uploaded
 */
- (void) facebookAgent:(FacebookAgent*)agent photoUploaded:(NSString*) pid;

/**
 * Must impement this method if any of the above method is defined
 *
 * This method is called if the agent fails to perform any of the above three actions
 */
- (void) facebookAgent:(FacebookAgent*)agent requestFaild:(NSString*) message;


/**
 * 
 * This method is called if the agent successfully obtains permission
 */

- (void) facebookAgent:(FacebookAgent*)agent permissiondialog:(FBPermissionDialog*)dialog succededForPermission:(NSString*)permission;


@required

/**
 * This method is called if after login or logout
 */
- (void) facebookAgent:(FacebookAgent*)agent loginStatus:(BOOL) loggedIn;



/**
 * This method is called on dialog errors
 */
- (void) facebookAgent:(FacebookAgent*)agent dialog:(FBDialog*)dialog didFailWithError:(NSError*)error;

@end

/**
 * FacebookAgent is a simple class to help integrate facebook connect into your app.
 * 
 * We often need to use facebook share in our apps which requires some repeatative
 * work such as update copy the facebook connect source, update,project settings, 
 * write delegate methods etc.
 *
 * This class will minimize those hastle. Just add this folder, you don't need to
 * update any project settings!
 *
 * TODO How to use:
 */
@interface FacebookAgent : NSObject<FBDialogDelegate, FBSessionDelegate, FBRequestDelegate> {
	
	/**
	 * Delegate
	 */
	id <FacebookAgentDelegate> delegate;
	
	/**
	 * Facebook application api key
	 */
	NSString* FBApiKey;
	
	/**
	 * Facebook application api secret 
	 */
	NSString* FBApiSecret;
	
	/**
	 * Facebook application proxy, optional
	 */
	NSString* FBApiProxy;
	
	/**
	 * Facebook session
	 */
	FBSession* _session;
	
	/**
	 * Flag indicating session login status
	 */
	BOOL isLoggedIn;
	
	/**
	 * Flag indicating if fb username should be fetched after log in
	 */
	BOOL shouldFetchUsernameAfterLogin;
	
	
	/**
	 * Variables related to feed posting
	 */
	NSString* attachment;
	NSString* userPrompt;
	NSString* targetUserId;
	
	/**
	 * Stores the action type. This is used if the user is not logged in.
	 * Then agent first logs in and calls the last action
	 */
	FacebookAgentAction pendingAction;
	NSString* newStatus;
	
	// needed for uploading image
	NSData* uploadImageData;
	NSString* uploadImageCaption;
	NSString* uploadImageAlbum;
	
	/**
	 * Flag indicating if permission is asked for update status
	 */
	BOOL updateStatusPending;
	
	/**
	 * Flag indicating if permission is asked for upload photo to an album
	 */
	BOOL uploadPhotoPending;
	
	/**
	 * Try to resume the session first before login?
	 */
	BOOL shouldResumeSession;
}

/**
 * Login to facebook
 */

- (void) login;


/**
 * Logout from facebook
 */
-(void) logout;

/**
 * You must initize using this method.
 */
- (id)initWithApiKey:(NSString*)key ApiSecret:(NSString*) secret ApiProxy:(NSString*)proxy;

/**
 * Use this method to obtain extended permission by the user
 */
- (void) askStatusUpdatePermission;

/**
 * Make your own attachment and publish feed.
 *
 * User prompt will be: What's on your mind?
 */
- (void) publishFeed:(NSString*)attachement;

/**
 * Make your own attachment and publish feed with the user prompt.
 *
 */
- (void) publishFeed:(NSString*)attachement 
   userMessagePrompt:(NSString*)prompt ;

/**
 * Make your own attachment and publish feed with the user prompt to the target user id.
 *
 */
- (void) publishFeed:(NSString*)attachement 
   userMessagePrompt:(NSString*)prompt
			targetId:(NSString*)target;

/**
 * Let the agent make attachement for you. You just pass the information
 *
 */
- (void) publishFeedWithName:(NSString*)name 
			 captionText:(NSString*)caption 
					   imageurl:(NSString*)url 
						linkurl:(NSString*)href
			  userMessagePrompt:(NSString*)prompt;


/**
 * Let the agent make attachement for you. You just pass the information
 *
 * The feed will be targetted to the target user id
 */
- (void) publishFeedWithName:(NSString*)name
				 captionText:(NSString*)caption 
					   imageurl:(NSString*)url 
						linkurl:(NSString*)href
			  userMessagePrompt:(NSString*)prompt
					   targetId:(NSString*)target;

// UPDATE: Support for action link. One action link can be added.
/**
 * Let the agent make attachement for you. You just pass the information
 *
 */
- (void) publishFeedWithName:(NSString*)name 
				 captionText:(NSString*)caption 
					imageurl:(NSString*)url 
					 linkurl:(NSString*)href
		   userMessagePrompt:(NSString*)prompt 
				 actionLabel:(NSString*)label
				  actionText:(NSString*)text 
				  actionLink:(NSString*)link;

/**
 * Let the agent make attachement for you. You just pass the information
 *
 */
- (void) publishFeedWithName:(NSString*)name 
				 captionText:(NSString*)caption 
					imageurl:(NSString*)url 
					 linkurl:(NSString*)href
		   userMessagePrompt:(NSString*)prompt 
				 actionLabel:(NSString*)label
				  actionText:(NSString*)text 
				  actionLink:(NSString*)link
					targetId:(NSString*)target;


- (void) setStatus:(NSString*)status;

/**
 * Upload photo
 */
- (void) uploadPhoto:(NSString*)imageurl;
- (void) uploadPhotoAtURL:(NSString*)imageurl withCaption:(NSString*)captionOrNil toAlbum:(NSString*)aidOrNil;
- (void) uploadPhotoAsData:(NSData*)imagedata withCaption:(NSString*)captionOrNil toAlbum:(NSString*)aidOrNil;

/**
 * Upload photo with status
 */
- (void) uploadPhoto:(NSString*)imageurl withStatus:(NSString*)status;
- (void) uploadPhotoAtURL:(NSString*)imageurl withStatus:(NSString*)status caption:(NSString*)captionOrNil toAlbum:(NSString*)aidOrNil;
- (void) uploadPhotoAsData:(NSData*)imagedata withStatus:(NSString*)status caption:(NSString*)captionOrNil toAlbum:(NSString*)aidOrNil;


/**
 * Ask permission to auto approve uploaded photo and add photo to an album.
 */
- (void) askUploadPhotoToAlbumPermission;
- (void) getAlbumList;


@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, assign) BOOL shouldResumeSession;
@property (nonatomic, assign) BOOL shouldFetchUsernameAfterLogin;
@property (nonatomic,assign) id<FacebookAgentDelegate> delegate;

@property (nonatomic, retain) NSString* attachment;
@property (nonatomic, retain) NSString* targetUserId;
@property (nonatomic, retain) NSString* userPrompt;

@property (nonatomic, retain) NSString* newStatus;
@property (nonatomic, retain) NSData* uploadImageData;
@property (nonatomic, retain) NSString* uploadImageCaption;
@property (nonatomic, retain) NSString* uploadImageAlbum;

//@property(nonatomic,retain)FBSession *session;

@property (nonatomic, readonly) NSString* sessionKey;
@property (nonatomic, readonly) NSString* sessionSecret;

@end
