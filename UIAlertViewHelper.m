//
//  UIAlertViewHelper.m
//  CocoaHelpers
//
//  Created by Shaun Harrison on 10/16/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import "UIAlertViewHelper.h"
#import "NSString+extensions.h"

void UIAlertViewQuick(NSString* title, NSString* message, NSString* dismissButtonTitle) {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:LocalizedString(title) 
													message:LocalizedString(message) 
												   delegate:nil 
										  cancelButtonTitle:LocalizedString(dismissButtonTitle) 
										  otherButtonTitles:nil
						  ];
	[alert show];
	[alert autorelease];
}


@implementation UIAlertView (Helper)

+ (id)presentAlertViewWithTitle:(NSString*)aTitle message:(NSString*)aMessage delegate:(id)object{
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:aTitle
													message:aMessage
												   delegate:object 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	return [alert autorelease];
	
}

+ (id)presentNoInternetAlertWithDelegate:(id)object{
	

	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Could not Connect"
													  message:@"Network Unavailable. Please ensure your Wifi or 3G is turned on and try again."
													 delegate:object 
											cancelButtonTitle:@"OK" 
											otherButtonTitles:nil];
	[alert show];
	return [alert autorelease];
	
	
}

+ (id)presentIncorrectPasswordAlertWithDelegate:(id)object{
	

	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Could not authenticate"
													message:@"Please check your username and password and try again."
												   delegate:object 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	return [alert autorelease];
	
}


+ (id)presentDialogForMissingField:(NSString*)fieldName{
    
    NSString* t = [NSString stringWithFormat:@"Missing %@", fieldName];
    NSString* m = [NSString stringWithFormat:@"Please enter a %@", [fieldName lowercaseString]];
    
    return [UIAlertView presentAlertViewWithTitle:t message:m delegate:nil];
    
}


+ (id)presentDialogForWifiUnreachabilityWithDelegate:(id)object{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Wifi Unreachable"
													message:@"Wifi is required to watch movies in this application. If you are watching a movie, please reconnect to Wifi to continue watching. Playback will automatically pause in 5 minutes"
												   delegate:object 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	return [alert autorelease];
    
    
}

+ (id)presentDialogForWifiRecheckWithDelegate:(id)object{
    
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Wifi Unreachable"
													message:@"Playback has been paused. Please reconnect to Wifi to restart the movie."
												   delegate:object 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	return [alert autorelease];
    
    
    
}

@end
