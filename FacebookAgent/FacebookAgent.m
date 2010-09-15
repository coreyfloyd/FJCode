//
//  FacebookAgent.m
//  Pagination
//
//  Created by Shaikh Sonny Aman on 1/6/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import "FacebookAgent.h"

/**
 * For shared use
 */
static FacebookAgent* sharedAgent = nil;

/**
 * Private methods
 */
@interface FacebookAgent()
-(void)postFeed;
-(void)uploadImage;
@end

@implementation FacebookAgent

@synthesize isLoggedIn;
@synthesize shouldFetchUserInfoAfterLogin;
@synthesize delegate;
@synthesize userPrompt;
@synthesize targetUserId;
@synthesize attachment;
@synthesize newStatus;
@synthesize uploadImageData;
@synthesize uploadImageCaption;
@synthesize uploadImageAlbum;
@synthesize shouldResumeSession;
@synthesize userID;
@synthesize permissionStatus;
@synthesize userInfo;

/*
- (id)init{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FacebookAgent Intialization error!" 
													message:@"Please don't use init or new method to initialze. Only use this method:- (id)initWithApiKey:(NSString*)key ApiSecret:(NSString*) secret ApiProxy:(NSString*)proxy;"
												   delegate:nil 
										  cancelButtonTitle:@"Close" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	return nil;
}
 */
- (id)initWithApiKey:(NSString*)key ApiSecret:(NSString*)secret ApiProxy:(NSString*)proxy{
	if( (self = [super init]) ){
		[self initializeWithApiKey:key ApiSecret:secret ApiProxy:proxy];
		return self;
	}
	return nil;
}

-(void)initializeWithApiKey:(NSString*)key ApiSecret:(NSString*)secret ApiProxy:(NSString*)proxy{
	// Initialize
	shouldFetchUserInfoAfterLogin  = YES;
	shouldResumeSession = YES;
	pendingAction = FacebookAgentActionNone;
	currentAction = FacebookAgentActionNone;
	
	FBApiKey = [key retain];
	FBApiSecret = [secret retain];
	FBApiProxy = [proxy retain];
	
	isLoggedIn = NO;
	updateStatusPending = NO;
	
	if (FBApiProxy) {
		_session = [[FBSession sessionForApplication:FBApiKey getSessionProxy:FBApiProxy
											delegate:self] retain];
	} else {
		_session = [[FBSession sessionForApplication:FBApiKey secret:FBApiSecret delegate:self] retain];
	}

}

- (BOOL)isLoggedIn{
    
    if(isLoggedIn)
        return isLoggedIn;

    if(shouldResumeSession){ // try to resume first
		if(! [_session resume] ){
			if(_session.isConnected){
				// Alert already logged in?
                
                isLoggedIn = YES;
                
			}else{
				isLoggedIn = NO;
			}
		}
	}else {
		if(_session.isConnected){
            
            isLoggedIn = YES;
            
			// Alert already logged in?
		}else{
            
            isLoggedIn = NO;
		}
	}
    
    return isLoggedIn;
}

- (void)dealloc{
	[FBApiKey release];
	[FBApiSecret release];
	[FBApiProxy release];
	[_session release];
	
	[attachment release];
	[userPrompt release];
	[targetUserId release];
	
	[newStatus release];
	
	[uploadImageData release];
	[uploadImageCaption release];
	[uploadImageAlbum release];
	self.userInfo = nil;
	self.permissionStatus = nil;
	//[sharedAgent release];sharedAgent = nil;
	
	[super dealloc];
}



- (void) login{
	currentAction = FacebookAgentActionLogin;
	
	if(shouldResumeSession){ // try to resume first
		if(! [_session resume] ){
			if(_session.isConnected){
				// Alert already logged in?
			}else{
				FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:_session] autorelease];
				[dialog show];
			}
		}
	}else {
		if(_session.isConnected){
			// Alert already logged in?
		}else{
			FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:_session] autorelease];
			[dialog show];
		}
	}
}
-(void) logout{
	if(_session.isConnected){
		[_session logout];
	}else{
		//alert already logged out?
	}
}
- (void) askPermission{
	if(!isLoggedIn){
		pendingAction = FacebookAgentActionAskPermission;
		[self login];
		return;
	}
	
	// this line is orginally update by "Me" from comments on http://amanpages.com/iphone-app-development-core-sdk-cocoa/facebookagent-update-now-upload-a-photo-and-then-change-status-in-a-single-call-using-facebook-connect-for-iphone/
	FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] initWithSession:_session] autorelease];
	dialog.delegate = self;
	dialog.permission = @"status_update";
	[dialog show];
}

- (void) setStatus:(NSString*)status{
	self.newStatus = status;
	
	if(!isLoggedIn){
		pendingAction = FacebookAgentActionSetStatus;
		[self login];
		return;
	}
	
	updateStatusPending = YES;
	[self askPermission];
}
- (void) uploadPhoto:(NSString*)imageurl{
	NSURL    *url  = [NSURL URLWithString:imageurl];
	NSData   *data = [NSData dataWithContentsOfURL:url];
	UIImage  *img  = [[UIImage alloc] initWithData:data];
	
	self.uploadImageData = (NSData*)img;
	self.uploadImageCaption = nil;
	self.uploadImageAlbum = nil;
	
	[self uploadPhotoAsData:uploadImageData withCaption:uploadImageCaption toAlbum:uploadImageAlbum];
}

- (void) uploadPhotoAtURL:(NSString*)imageurl withCaption:(NSString*)captionOrNil toAlbum:(NSString*)aidOrNil{
	NSURL    *url  = [NSURL URLWithString:imageurl];
	NSData   *data = [NSData dataWithContentsOfURL:url];
	//UIImage  *img  = [[UIImage alloc] initWithData:data];
	
	self.uploadImageData = data;
	self.uploadImageCaption = captionOrNil;
	self.uploadImageAlbum = aidOrNil;
	
	[self uploadPhotoAsData:uploadImageData withCaption:uploadImageCaption toAlbum:uploadImageAlbum];
}
- (void) uploadPhotoAsData:(NSData*)imagedata withCaption:(NSString*)captionOrNil toAlbum:(NSString*)aidOrNil{
	if(!uploadImageData){
		self.uploadImageData = imagedata;
	}
	
	if(!uploadImageCaption){
		self.uploadImageCaption = captionOrNil;
	}
	if(!uploadImageAlbum){
		self.uploadImageAlbum = aidOrNil;
	}
	
	
	if(!isLoggedIn){
		pendingAction = FacebookAgentActionUploadPhoto;
		[self login];
		return;
	}
	
	if(uploadImageAlbum){
		uploadPhotoPending = YES;
		[self askUploadPhotoToAlbumPermission];
		return;
	}
	[self uploadImage];
}

- (void) uploadPhoto:(NSString*)imageurl withStatus:(NSString*)status{
	self.newStatus = status;
	[self uploadPhoto:imageurl];
}
- (void) uploadPhotoAtURL:(NSString*)imageurl withStatus:(NSString*)status caption:(NSString*)captionOrNil toAlbum:(NSString*)aidOrNil{
	self.newStatus = status;
	[self uploadPhotoAtURL:imageurl withCaption:captionOrNil toAlbum:aidOrNil];
}
- (void) uploadPhotoAsData:(NSData*)imagedata withStatus:(NSString*)status caption:(NSString*)captionOrNil toAlbum:(NSString*)aidOrNil{
	self.newStatus = status;
	[self uploadPhotoAsData:imagedata withCaption:captionOrNil toAlbum:aidOrNil];
}

-(void)uploadImage{
	NSMutableDictionary *params = nil;
	if(uploadImageCaption){
		params = [NSMutableDictionary dictionaryWithObjectsAndKeys:uploadImageCaption,@"caption",nil];
		if(uploadImageAlbum){
			[params setValue:uploadImageAlbum forKey:@"aid"];
		}
	}else {
		if(uploadImageAlbum){
			[params setValue:uploadImageAlbum forKey:@"aid"];
		}
	}
	
	[[FBRequest requestWithDelegate:self] call:@"facebook.photos.upload" params:params dataParam:uploadImageData];
}

- (void) askUploadPhotoToAlbumPermission{
	if(!isLoggedIn){
		pendingAction = FacebookAgentActionUploadPhotoAskPermission;
		[self login];
		return;
	}
	FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.permission = @"photo_upload";
	[dialog show];
}
- (void) getAlbumList{
	// TBD
}



-(void)postFeed{
	if(!userPrompt){
		self.userPrompt = @"What's on your mind?";
	}
	
	if(isLoggedIn){
		FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
		dialog.delegate = self;
		dialog.attachment = attachment;
		dialog.userMessagePrompt = userPrompt;
		if(targetUserId){
			dialog.targetId = targetUserId;
		}
		[dialog show];
	}else {
		pendingAction = FacebookAgentActionPublishFeed;
		[self login];
	}

}
- (void) postFeedWithName:(NSString*)name 
				 captionText:(NSString*)caption 
					imageurl:(NSString*)url 
					 linkurl:(NSString*)href
		   userMessagePrompt:(NSString*)prompt 
			  actionLabel:(NSString*)label
			   actionText:(NSString*)text 
			   actionLink:(NSString*)link
					targetId:(NSString*)target{
	
	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	href = [href stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* att;
	if( label && text){
		if(link){ // text as action link
			att = [NSString stringWithFormat:@"{\"name\":\"%@\",\"caption\":\"%@\",\"description\":\"%@\",\"media\":[{\"type\":\"image\",\"src\":\"%@\",\"href\":\"%@\"}]," "\"properties\":{\"%@\":{\"text\":\"%@\",\"href\":\"%@\"}}}",name,caption,@"",url,href,label,text,link];
		}else { // only text but how?
			//att = [NSString stringWithFormat:@"{\"name\":\"%@\",\"caption\":\"%@\",\"description\":\"%@\",\"media\":[{\"type\":\"image\",\"src\":\"%@\",\"href\":\"%@\"}]," "\"properties\":\"%@\":\"text\"}",name,caption,@"",url,href,label,text];
			return;
		}


	}else {
		att = [NSString stringWithFormat:@"{\"name\":\"%@\",\"caption\":\"%@\",\"description\":\"%@\",\"media\":[{\"type\":\"image\",\"src\":\"%@\",\"href\":\"%@\"}]}",name,caption,@"",url,href];
	}

	
	self.attachment = att;
	self.userPrompt = prompt;
	self.targetUserId = target;
	[self postFeed];
	
}

- (void) publishFeed:(NSString*)attachement{
	
	self.attachment = attachement;
	[self postFeed];
}


- (void) publishFeed:(NSString*)attachement 
   userMessagePrompt:(NSString*)prompt{
	
	self.attachment = attachement;
	self.userPrompt = prompt;
	[self postFeed];
}


- (void) publishFeed:(NSString*)attachement 
   userMessagePrompt:(NSString*)prompt
			targetId:(NSString*)target{
	
	self.attachment = attachement;
	self.userPrompt = prompt;
	self.targetUserId = target;
	[self postFeed];
}


- (void) publishFeedWithName:(NSString*)name 
				 captionText:(NSString*)caption 
					   imageurl:(NSString*)url 
						linkurl:(NSString*)href
			  userMessagePrompt:(NSString*)prompt{
	
	[self postFeedWithName:name 
			   captionText:caption 
				  imageurl:url 
				   linkurl:href 
		 userMessagePrompt:prompt
			   actionLabel:nil
				actionText:nil 
				actionLink:nil
				  targetId:nil];
}


- (void) publishFeedWithName:(NSString*)name 
				 captionText:(NSString*)caption 
					   imageurl:(NSString*)url 
						linkurl:(NSString*)href
			  userMessagePrompt:(NSString*)prompt
					targetId:(NSString*)target{
	
	[self postFeedWithName:name 
			   captionText:caption 
				  imageurl:url 
				   linkurl:href 
		 userMessagePrompt:prompt 
			   actionLabel:nil
				actionText:nil 
				actionLink:nil
				  targetId:target];
}

- (void) publishFeedWithName:(NSString*)name 
				 captionText:(NSString*)caption 
					imageurl:(NSString*)url 
					 linkurl:(NSString*)href
		   userMessagePrompt:(NSString*)prompt 
				 actionLabel:(NSString*)label
				  actionText:(NSString*)text 
				  actionLink:(NSString*)link{
	[self postFeedWithName:name 
			   captionText:caption 
				  imageurl:url 
				   linkurl:href 
		 userMessagePrompt:prompt 
			   actionLabel:label
				actionText:text 
				actionLink:link
				  targetId:nil];
}

- (void) publishFeedWithName:(NSString*)name 
				 captionText:(NSString*)caption 
					imageurl:(NSString*)url 
					 linkurl:(NSString*)href
		   userMessagePrompt:(NSString*)prompt 
				 actionLabel:(NSString*)label
				  actionText:(NSString*)text 
				  actionLink:(NSString*)link
					targetId:(NSString*)target{
	[self postFeedWithName:name 
			   captionText:caption 
				  imageurl:url 
				   linkurl:href 
		 userMessagePrompt:prompt
			   actionLabel:label
				actionText:text 
				actionLink:link
				  targetId:target];
}

#pragma mark FBSessionDelegate
- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	currentAction = FacebookAgentActionNone;
	isLoggedIn = YES;
	self.userID = uid;
	
	[delegate facebookAgent:self loginStatus:YES];
	
	if(shouldFetchUserInfoAfterLogin){
		NSString* fql = [NSString stringWithFormat:
						 @"select uid,name,pic_square,pic_small,locale from user where uid = %lld", session.uid];	
		NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
		[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
		fqlType = FacebookAgentFQLTypeFetchUserInfo;
	}
	
	if(pendingAction != FacebookAgentActionNone){
		switch (pendingAction) {
			case FacebookAgentActionPublishFeed:{
				pendingAction = FacebookAgentActionNone;
				[self postFeed];
				break;
			}
			case FacebookAgentActionAskPermission:{
				pendingAction = FacebookAgentActionNone;
				[self askPermission];
				break;
			}
			case FacebookAgentActionSetStatus:{
				pendingAction = FacebookAgentActionNone;
				[self setStatus:self.newStatus];
				break;
			}
			case FacebookAgentActionUploadPhoto:{
				pendingAction = FacebookAgentActionNone;
				[self uploadImage];
				break;
			}
			case FacebookAgentActionUploadPhotoAskPermission:{
				pendingAction = FacebookAgentActionNone;
				[self askUploadPhotoToAlbumPermission];
				break;
			}
			default:
				break;
		}
	}
}
- (void)sessionDidNotLogin:(FBSession*)session {
	currentAction = FacebookAgentActionNone;
	isLoggedIn = NO;
	[delegate facebookAgent:self loginStatus:NO];
}

- (void)sessionDidLogout:(FBSession*)session {
	currentAction = FacebookAgentActionNone;
	isLoggedIn = NO;
	[delegate facebookAgent:self loginStatus:NO];
}

#pragma mark FBRequestDelegate
- (void)request:(FBRequest*)request didLoad:(id)result {
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* resultData = result;
		switch (fqlType) {
			case FacebookAgentFQLTypeFetchUserInfo:{
				NSDictionary* user = [resultData objectAtIndex:0];
				// Calling the delegate callback
				self.userInfo = user;
                if([delegate respondsToSelector:@selector(facebookAgent:didLoadInfo:)])
                    [delegate facebookAgent:self didLoadInfo:user];
				break;
				}
			case FacebookAgentFQLTypeFetchFriendList:
				// Calling the delegate callback
                if([delegate respondsToSelector:@selector(facebookAgent:didLoadFriendList:onlyAppUsers:)])
                    [delegate facebookAgent:self didLoadFriendList:resultData onlyAppUsers:NO];
				break;
			case FacebookAgentFQLTypeFetchAppFriendList:
				// Calling the delegate callback
                if([delegate respondsToSelector:@selector(facebookAgent:didLoadFriendList:onlyAppUsers:)])
                    [delegate facebookAgent:self didLoadFriendList:resultData onlyAppUsers:YES];
				break;
			case FacebookAgentFQLTypeFetchPermissions:
				self.permissionStatus = [resultData objectAtIndex:0];
                if([delegate respondsToSelector:@selector(facebookAgent:didLoadPermissions:)])
                    [delegate facebookAgent:self didLoadPermissions:[resultData objectAtIndex:0]];
				break;
			case FacebookAgentFQLTypeGeneral:
                if([delegate respondsToSelector:@selector(facebookAgent:didLoadFQL:)])
                    [delegate facebookAgent:self didLoadFQL:resultData];
				break;

			default:
				break;
		}
		
		//fqlType = FacebookAgentFQLTypeNone;
		
		
	} else if ([request.method isEqualToString:@"facebook.users.setStatus"]) {
		newStatus = nil;
		NSString* success = result;
		if ([success isEqualToString:@"1"]) {
			
			// Calling the delegate callback
            if([delegate respondsToSelector:@selector(facebookAgent:statusChanged:)])
                [delegate facebookAgent:self statusChanged:YES];
			
		} else {
            if([delegate respondsToSelector:@selector(facebookAgent:statusChanged:)])
                [delegate facebookAgent:self statusChanged:NO];
		}
	} else if ([request.method isEqualToString:@"facebook.photos.upload"]) {
		NSDictionary* photoInfo = result;
		NSString* pid = [photoInfo objectForKey:@"pid"];
		
		self.uploadImageData = nil;
		self.uploadImageCaption = nil;
		self.uploadImageAlbum = nil;
        if([delegate respondsToSelector:@selector(facebookAgent:photoUploaded:)])
            [delegate facebookAgent:self photoUploaded:pid];
		
		if(newStatus){
			[self setStatus:newStatus];
		}
	}
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
	newStatus = nil;
	NSString* msg = [NSString stringWithFormat:@"Error(%d) %@", error.code,
				   error.localizedDescription];
	
    if([delegate respondsToSelector:@selector(facebookAgent:requestFaild:)])
        [delegate facebookAgent:self requestFaild:msg];
}


#pragma mark FBDialogDelegate
- (void)dialogDidSucceed:(FBDialog*)dialog{
	if(updateStatusPending){
		updateStatusPending = NO;
		NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
								self.newStatus, @"status",
								@"true", @"status_includes_verb",
								nil];
		[[FBRequest requestWithDelegate:self] call:@"facebook.users.setStatus" params:params];
		self.newStatus = nil;
		return;
	}
	
	if(uploadPhotoPending){
		uploadPhotoPending = NO;
		[self uploadImage];
	}
	
	if(pendingAction == FacebookAgentActionGrantPermission){
		pendingAction = FacebookAgentActionNone;
        if([delegate respondsToSelector:@selector(facebookAgent:permissionGranted:)])
            [self.delegate facebookAgent:self permissionGranted:grantingPermission];
	}
}

- (void)dialogDidCancel:(FBDialog*)dialog{
	if(currentAction == FacebookAgentActionLogin){
        [self.delegate facebookAgent:self loginStatus:NO];
		currentAction = FacebookAgentActionNone;
	}
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error{
	[delegate facebookAgent:self 
					 dialog:dialog 
		   didFailWithError:error];
}

- (void)getMyFriendList:(BOOL)onlyAppUsers{
	
	NSString* fql;
	if(onlyAppUsers){
		fqlType = FacebookAgentFQLTypeFetchAppFriendList;
		fql = 	[NSString stringWithFormat:
					 @"SELECT uid,name,pic_square,locale,online_presence FROM user WHERE \
					 is_app_user = 1 \
					 AND uid IN ( \
					 SELECT uid2 FROM friend WHERE uid1 = %lld \
					 )", _session.uid];
	}else {
		fqlType = FacebookAgentFQLTypeFetchFriendList;
		fql = 	[NSString stringWithFormat:
				 @"SELECT uid,name,pic_square,locale,online_presence FROM user WHERE \
				 uid IN ( \
				 SELECT uid2 FROM friend WHERE uid1 = %lld \
				 )", _session.uid];
	}

	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
	
}
- (void)runFQL:(NSString*)fql{
	fqlType = FacebookAgentFQLTypeGeneral;
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
}
- (void)getPermissions{
	fqlType = FacebookAgentFQLTypeFetchPermissions;
	NSString* fql = [NSString stringWithFormat:@"select status_update \
					 ,photo_upload \
					 ,sms \
					 ,offline_access\
					 ,email\
					 ,create_event\
					 ,rsvp_event\
					 ,publish_stream\
					,read_stream\
					 ,share_item\
					 ,create_note\
					 ,bookmarked\
					 ,tab_added \
					  from permissions where uid = %lld"
					 ,_session.uid];
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
	
}

- (void)grantPermission:(FacebookAgentPermission)type{
	pendingAction = FacebookAgentActionGrantPermission;
	grantingPermission = type;
	
	FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] initWithSession:_session] autorelease];
	dialog.delegate = self;
	NSString* strPermission = @"offline_access";
	switch (type) {
		case FacebookAgentPermissionStatusUpdate:
			strPermission = @"status_update";
			break;
		case FacebookAgentPermissionPhotoUpload:
			strPermission = @"photo_upload";
			break;
		case FacebookAgentPermissionSMS:
			strPermission = @"sms";
			break;
		case FacebookAgentPermissionOfflineAccess:
			strPermission = @"offline_access";
			break;
		case FacebookAgentPermissionEmail:
			strPermission = @"email";
			break;
		case FacebookAgentPermissionCreateEvent:
			strPermission = @"create_event";
			break;
		case FacebookAgentPermissionRSVPEvent:
			strPermission = @"rsvp_event";
			break;
		case FacebookAgentPermissionPublishStream:
			strPermission = @"publish_stream";
			break;
		case FacebookAgentPermissionReadStream:
			strPermission = @"read_stream";
			break;
		case FacebookAgentPermissionShareItem:
			strPermission = @"share_item";
			break;
		case FacebookAgentPermissionCreateNote:
			strPermission = @"create_note";
			break;
		case FacebookAgentPermissionBookmarked:
			strPermission = @"bookmarked";
			break;
		case FacebookAgentPermissionTabAdded:
			strPermission = @"tab_added";
			break;
		default:
			strPermission = @"offline_access";
			break;
	}
	dialog.permission = strPermission;
	[dialog show];
}

- (BOOL)hasPermission:(FacebookAgentPermission)type{
	
	if(!self.permissionStatus)return NO;
	
	NSString* strPermission = @"offline_access";
	switch (type) {
		case FacebookAgentPermissionStatusUpdate:
			strPermission = @"status_update";
			break;
		case FacebookAgentPermissionPhotoUpload:
			strPermission = @"photo_upload";
			break;
		case FacebookAgentPermissionSMS:
			strPermission = @"sms";
			break;
		case FacebookAgentPermissionOfflineAccess:
			strPermission = @"offline_access";
			break;
		case FacebookAgentPermissionEmail:
			strPermission = @"email";
			break;
		case FacebookAgentPermissionCreateEvent:
			strPermission = @"create_event";
			break;
		case FacebookAgentPermissionRSVPEvent:
			strPermission = @"rsvp_event";
			break;
		case FacebookAgentPermissionPublishStream:
			strPermission = @"publish_stream";
			break;
		case FacebookAgentPermissionReadStream:
			strPermission = @"read_stream";
			break;
		case FacebookAgentPermissionShareItem:
			strPermission = @"share_item";
			break;
		case FacebookAgentPermissionCreateNote:
			strPermission = @"create_note";
			break;
		case FacebookAgentPermissionBookmarked:
			strPermission = @"bookmarked";
			break;
		case FacebookAgentPermissionTabAdded:
			strPermission = @"tab_added";
			break;
		default:
			strPermission = @"offline_access";
			break;
	}
	return [[self.permissionStatus valueForKey:strPermission] boolValue];
	
}
+(FacebookAgent*)sharedAgent{
	if(!sharedAgent){
		sharedAgent = [[FacebookAgent alloc] init];
	}
	return sharedAgent;
}
- (NSString*)getUserName{
	return [userInfo valueForKey:@"name"];
	
}
- (NSString*)getUserProfileSquareImage{
	return [userInfo valueForKey:@"pic_square"];
}
- (NSString*)getUserProfileImage{
	return [userInfo valueForKey:@"pic_big"];
}
@end
