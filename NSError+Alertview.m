//
//  NSError+Alertview.m
//  FJSCode
//
//  Created by Corey Floyd on 12/20/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "NSError+Alertview.h"
#import "UIAlertViewHelper.h"

@implementation NSError(AlertView)

- (void)presentAlertViewWithDelegate:(id)delegate{
	
	//TODO: do I need to check the error domain? 
	if([self code] == -1009)
		[UIAlertView presentNoInternetAlertWithDelegate:delegate];
	else if([self code] == 401)
		[UIAlertView presentIncorrectPasswordAlertWithDelegate:delegate];
	else 
		[UIAlertView presentAlertViewWithTitle:@"Error"
									   message:[self localizedDescription] 
									  delegate:delegate];}

@end
