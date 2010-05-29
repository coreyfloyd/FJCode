//
//  FJSTweetViewController.m
//  BuyingGuide
//
//  Created by Corey Floyd on 1/21/10.
//  Copyright 2010 Flying Jalapeño Software. All rights reserved.
//

#import "FJSTweetViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "NSError+Alertview.h"
#import "LoadingView.h"
#import "SDNextRunloopProxy.h"
#import "SA_OAuthTwitterController.h"

#define kOAuthConsumerKey				@" "	
#define kOAuthConsumerSecret			@" "		

NSString* const FJSTwitterUsernameKey = @"FJSTwitterUsername";
NSString* const FJSTwitterPasswordKey = @"FJSTwitterPassord";


@interface FJSTweetViewController()

@property(nonatomic,retain)SA_OAuthTwitterEngine *twitterEngine;
@property(nonatomic,copy)NSString *prefilledText;

- (void)launchLoginViewForce:(BOOL)flag;

@end


@implementation FJSTweetViewController

@synthesize tweetTextView;
@synthesize charCount;
@synthesize twitterEngine;
@synthesize prefilledText;
@synthesize accountName;


#pragma mark -
#pragma mark NSObject

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.accountName = nil;
	self.prefilledText = nil;
	self.tweetTextView = nil;
	self.charCount = nil;
	self.twitterEngine = nil;
    [super dealloc];
}


- (id)initWithText:(NSString*)someText{
	
	self = [super initWithNibName:@"FJSTweetViewController" bundle:nil];
	if (self != nil) {
		
		self.prefilledText = someText;
		
	}
	return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tweetTextView.font = [UIFont boldSystemFontOfSize:14];
	
	self.twitterEngine = [SA_OAuthTwitterEngine OAuthTwitterEngineWithDelegate:self];

	twitterEngine.consumerKey = kOAuthConsumerKey;
	twitterEngine.consumerSecret = kOAuthConsumerSecret;

}

- (void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	

}

- (void)viewDidAppear:(BOOL)animated{	
			
	[twitterEngine requestRequestToken];	
		
	//this is sloppy, but UIKit dreads popping up 2 modal views in quick succession
	[[self nextRunloopProxy] launchLoginViewForce:NO];
		

}

#pragma mark -
#pragma mark IBActions

- (IBAction)tweet{
	
	int maxChars = 140;
	
	if(self.tweetTextView.text.length > maxChars){
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No more characters"
														 message:[NSString stringWithFormat:@"You have reached the character limit of %d.",maxChars]
														delegate:nil
											   cancelButtonTitle:@"Ok"
											   otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	CGRect rect = self.view.bounds;
	rect.size.height = rect.size.height - 215;
	
	[[LoadingView loadingViewInView:self.view frame:rect] setDelegate:self];
	
	[self.twitterEngine sendUpdate:self.tweetTextView.text];	
}

- (IBAction)cancel{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)loginManually{
	
	[self launchLoginViewForce:YES];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[self tweet];	
	return NO;
}

- (void)textViewDidChange:(UITextView *)textView{
	
	int maxChars = 140;
	int charsLeft = maxChars - [textView.text length];
	
	self.charCount.text = [NSString stringWithFormat:@"%d",charsLeft];
	
}


#pragma mark -
#pragma mark FJSTwitterLoginController

- (void)launchLoginViewForce:(BOOL)force{
	
	if(force){
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		[defaults setObject: nil forKey: @"authData"];
		[defaults setObject: nil forKey:FJSTwitterUsernameKey];
		
		[defaults synchronize];
		
		self.twitterEngine = [SA_OAuthTwitterEngine OAuthTwitterEngineWithDelegate:self];
		
		twitterEngine.consumerKey = kOAuthConsumerKey;
		twitterEngine.consumerSecret = kOAuthConsumerSecret;
		
		[twitterEngine requestRequestToken];	
		
	}
	
	UIViewController *controller = 
	[SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: self.twitterEngine 
																	delegate: self];

	if (controller) 
		[self presentModalViewController: controller animated: YES];
	else {
		self.tweetTextView.text = self.prefilledText;
		[self textViewDidChange:self.tweetTextView];
		
		NSString* username = [self.twitterEngine username];
		[self.accountName setTitle:username forState:UIControlStateNormal];
		
		//get the keyboard up for ui purposes
		[self.tweetTextView becomeFirstResponder];
	}	
}


//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults setObject: username forKey:FJSTwitterUsernameKey];
	
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
	[self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];

}


#pragma mark -
#pragma mark MGTwitterEngineDelegate

- (void)requestSucceeded:(NSString *)connectionIdentifier{
		
	for(UIView* aView in self.view.subviews){
		
		if([aView isKindOfClass:[LoadingView class]])
			[(LoadingView*)aView updateTextAndRemoveView:@"Tweet Sent!"];
	}
}


- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error{
	
	for(UIView* aView in self.view.subviews){
		
		if([aView isKindOfClass:[LoadingView class]])
			[(LoadingView*)aView removeView];
	}
	
	[error presentAlertViewWithDelegate:nil];	
}


#pragma mark LoadingViewDelegate

- (void)loadingViewDidClose:(LoadingView*)loadingView{
	[self dismissModalViewControllerAnimated:YES];
}



@end
