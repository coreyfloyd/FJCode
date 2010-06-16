//
//  NSError+UIAlertView.m
//  Carousel
//
//  Created by Corey Floyd on 12/29/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "NSError+UIAlertView.h"


@implementation NSError(UIAlertView)

- (void)presentInAlertView{
	
	NSLog(@"%@", [self localizedFailureReason]);
	NSLog(@"%@", [self localizedDescription]);
	
	for(NSString* eachKey in [self userInfo]){
		
		NSLog(@"%@: %@", eachKey, [[self userInfo] objectForKey:eachKey]);
	}
	UIAlertView* message = [[[UIAlertView alloc] initWithTitle:[[self localizedDescription] capitalizedString]
                                                      message:[[[self userInfo] objectForKey:NSUnderlyingErrorKey] localizedDescription]
                                                     delegate:nil 
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil] autorelease];
    [message show];
}


- (void)presentInAlertViewWithDelegate:(id)delegate{
	
	NSLog(@"%@", [self localizedFailureReason]);
	NSLog(@"%@", [self localizedDescription]);
	
	for(NSString* eachKey in [self userInfo]){
		
		NSLog(@"%@: %@", eachKey, [[self userInfo] objectForKey:eachKey]);
	}
	UIAlertView* message = [[[UIAlertView alloc] initWithTitle:[[self localizedDescription] capitalizedString]
													   message:[[[self userInfo] objectForKey:NSUnderlyingErrorKey] localizedDescription]
													  delegate:delegate 
											 cancelButtonTitle:@"OK" 
											 otherButtonTitles:nil] autorelease];
    [message show];
}

@end
