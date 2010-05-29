//
//  NSOperationQueue+Shared.m
//  Carousel
//
//  Created by Corey Floyd on 12/16/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "NSOperationQueue+Shared.h"


@implementation NSOperationQueue(SharedQueue)

static NSOperationQueue* _sharedOperationQueue = nil;

+(NSOperationQueue*)sharedOperationQueue;
{
	if (_sharedOperationQueue == nil) {
		_sharedOperationQueue = [[NSOperationQueue alloc] init];
		[_sharedOperationQueue setMaxConcurrentOperationCount:1];
	}
	return _sharedOperationQueue;
}

+(void)setSharedOperationQueue:(NSOperationQueue*)operationQueue;
{
	if (operationQueue != _sharedOperationQueue) {
		[_sharedOperationQueue release];
		_sharedOperationQueue = [operationQueue retain];
	}
}

@end
