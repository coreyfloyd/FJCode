//
//  NSOperationQueue+Shared.h
//  Carousel
//
//  Created by Corey Floyd on 12/16/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSOperationQueue(SharedQueue)

+(NSOperationQueue*)sharedOperationQueue;
+(void)setSharedOperationQueue:(NSOperationQueue*)operationQueue;

@end
