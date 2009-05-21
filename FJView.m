//
//  FJView.m
//  Skinny Jeans
//
//  Created by Corey Floyd on 3/14/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "FJView.h"


@implementation FJView

@synthesize viewController;


- (void)dealloc {
	[viewController release];
	viewController = nil;
    [super dealloc];
}


@end
