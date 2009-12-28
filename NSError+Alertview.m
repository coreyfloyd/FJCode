//
//  NSError+Alertview.m
//  FJSCode
//
//  Created by Corey Floyd on 12/20/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "NSError+Alertview.h"

@implementation NSError(AlertView)

- (void)presentAlertViewWithDelegate:(id)delegate{
	
	[UIAlertView presentAlertViewWithTitle:@"Error"
								   message:[self localizedDescription] 
								  delegate:delegate];
	
}

@end
