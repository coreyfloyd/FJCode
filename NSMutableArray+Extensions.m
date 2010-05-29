//
//  NSArray+Extensions.m
//  FJSCode
//
//  Created by Corey Floyd on 12/20/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "NSMutableArray+Extensions.h"


@implementation  NSMutableArray(primatives)

- (void)addInt:(int)integer{
	
	[self addObject:[NSNumber numberWithInt:integer]];
}

@end


@implementation  NSMutableArray(Stack)


-(void) push:(id) item {
	[self addObject:item]; // where list is the actual array in your stack
}

-(id) pop {
	id r = [[self lastObject] retain];
	[self removeLastObject];
	return [r autorelease];
}

@end

@implementation  NSMutableArray(Queue)

-(void) enqueue:(id) item {
	[self insertObject:item atIndex:0];
}

-(id) dequeue {
	id r = [[self lastObject] retain];
	[self removeLastObject];
	return [r autorelease];
}
@end
