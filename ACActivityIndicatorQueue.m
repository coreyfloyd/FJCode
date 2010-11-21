//  --------------------------------------------
//  The MIT License
//  
//  Copyright 2009 Appcorn AB.
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//  --------------------------------------------
//
//  ACActivityIndicatorQueue.m
//
//  Created by Martin Alléus on 2009-04-19.
//  Copyright 2009 Appcorn AB.
//

#import "ACActivityIndicatorQueue.h"


@implementation ACActivityIndicatorQueue


# pragma mark --- Singelton Methods ---

static ACActivityIndicatorQueue *activityIndicatorQueue = nil;

+ (ACActivityIndicatorQueue *)sharedInstance {
	if(activityIndicatorQueue == nil) {
		activityIndicatorQueue = [[self alloc] init];
	}
	return activityIndicatorQueue;
}

- (id)copyWithZone:(NSZone *)zone {
    return activityIndicatorQueue;
}

- (id)retain {
    return activityIndicatorQueue;
}

- (unsigned)retainCount {
    return UINT_MAX; 
}

- (id)autorelease {
    return activityIndicatorQueue;
}

- (void)release {
	// Do nothing
}


# pragma mark --- Initialization ---

- (id)init {
	[super init];
	
	application = [UIApplication sharedApplication];
	indicatorQueue = 0;
	
	return self;
}


# pragma mark --- Static convinience-methods ---

+ (void)startActivity {
	ACActivityIndicatorQueue *instace = [ACActivityIndicatorQueue sharedInstance];
	[instace addToIndicatorQueue];
}

+ (void)endActivity {
	ACActivityIndicatorQueue *instace = [ACActivityIndicatorQueue sharedInstance];
	[instace removeFromIndicatorQueue];
}


# pragma mark --- Custom Methods ---

- (void)addToIndicatorQueue {
	if(indicatorQueue == 0) {
		// First addition to the queue, show the activity indicator
		application.networkActivityIndicatorVisible = YES;
	}
	
	indicatorQueue++;
}

- (void)removeFromIndicatorQueue {
	indicatorQueue--;
	
	if(indicatorQueue <= 0) {
		// Last removal from the queue, hide the activity indicator
		application.networkActivityIndicatorVisible = NO;
	}
}

@end
