//
//  FacebookAgent.m
//  Pagination
//
//  Created by Shaikh Sonny Aman on 1/6/10.
//  Copyright 2010 SHAIKH SONNY AMAN :) . All rights reserved.
//

#import "FacebookAgent.h"

/**
 * Private methods
 */
@interface FacebookAgent()
-(void)postFeed;
-(void)uploadImage;
@end

@implementation FacebookAgent

@synthesize isLoggedIn;
@synthesize shouldFetchUsernameAfterLogin;
@synthesize delegate;
@synthesize userPrompt;
@synthesize targetUserId;
@synthesize attachment;
@synthesize newStatus;
@synthesize uploadImageData;
@synthesize uploadImageCaption;
@synthesize uploadImageAlbum;
@synthesize shouldResumeSession;
//@synthesize session = _session;



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
- (id)initWithApiKey:(NSString*)key ApiSecret:(NSString*)secret ApiProxy:(NSString*)proxy{
	if( (self = [super init]) ){
		
		// Initialize
		pendingAction = FacebookAgentActionNone;
		
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
		
		return self;
	}
	return nil;
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
	
	[super dealloc];
}

- (NSString*)sessionKey{
	
	return [_session sessionKey];
}

- (NSString*)sessionSecret{
	
	return [_session sessionSecret];
}


- (void) login{
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
- (void) askStatusUpdatePermission{
	if(!isLoggedIn){
		pendingAction = FacebookAgentActionAskPermission;
		[self login];
		return;
	}
	FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
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
	[self askStatusUpdatePermission];
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
	NSDictionary *params;
	if(uploadImageCaption){
		params = [NSDictionary dictionaryWithObjectsAndKeys:uploadImageCaption,@"caption",nil];
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


- (void)getFriends{    
    
    NSString* fql = [NSString stringWithFormat:@"SELECT name,uid FROM user WHERE uid IN ( SELECT uid2 FROM friend WHERE uid1=%lld )", _session.uid];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
    
    [[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];

}

#pragma mark FBSessionDelegate
- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	isLoggedIn = YES;
	
	[delegate facebookAgent:self loginStatus:YES];
	
	if(shouldFetchUsernameAfterLogin){
		NSString* fql = [NSString stringWithFormat:
						 @"select uid,name from user where uid == %lld", session.uid];	
		NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
		[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
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
				[self askStatusUpdatePermission];
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
	isLoggedIn = NO;
	[delegate facebookAgent:self loginStatus:NO];
}

- (void)sessionDidLogout:(FBSession*)session {
	isLoggedIn = NO;
	[delegate facebookAgent:self loginStatus:NO];
}

#pragma mark FBRequestDelegate
- (void)request:(FBRequest*)request didLoad:(id)result {
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
		
		// Calling the delegate callback
		[delegate facebookAgent:self didLoadName:name];
		
	} else if ([request.method isEqualToString:@"facebook.users.setStatus"]) {
		newStatus = nil;
		NSString* success = result;
		if ([success isEqualToString:@"1"]) {
			
			// Calling the delegate callback
			[delegate facebookAgent:self statusChanged:YES];
			
		} else {
			[delegate facebookAgent:self statusChanged:NO];
		}
	} else if ([request.method isEqualToString:@"facebook.photos.upload"]) {
		NSDictionary* photoInfo = result;
		NSString* pid = [photoInfo objectForKey:@"pid"];
		
		self.uploadImageData = nil;
		self.uploadImageCaption = nil;
		self.uploadImageAlbum = nil;
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
	
	[delegate facebookAgent:self requestFaild:msg];
}


#pragma mark FBDialogDelegate
- (void)dialogDidSucceed:(FBDialog*)dialog{
	if(updateStatusPending){
		
		if([dialog isKindOfClass:[FBPermissionDialog class]]){
			
			if([delegate respondsToSelector:@selector(facebookAgent:permissiondialog:succededForPermission:)])
				[delegate facebookAgent:self permissiondialog:(FBPermissionDialog*)dialog succededForPermission:[(FBPermissionDialog*)dialog permission]];
		}
		
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
}

- (void)dialogDidCancel:(FBDialog*)dialog{
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error{
	[delegate facebookAgent:self 
					 dialog:dialog 
		   didFailWithError:error];
}


@end
