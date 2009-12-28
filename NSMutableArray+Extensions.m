//
//  NSArray+Extensions.m
//  FJSCode
//
//  Created by Corey Floyd on 12/20/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "NSMutableArray+Extensions.h"


@implementation  NSMutableArray(Stack)


-(void) push:(id) item {
	[list addObject:item] // where list is the actual array in your stack
	count++;
}

-(id) pop {
	id r = [list lastObject];
	[list removeLastObject];
	count--;
	return r;
}

@implementation  NSMutableArray(Queue)

-(void) enqueue:(id) item {
	[list insertObject:item atIndex:0];
	count++;
}

-(id) dequeue {
	id r = [list lastObject];
	[list removeLastObject];
	count--;
	return r;
}
@end
