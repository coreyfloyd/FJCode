//
//  NSArray+Extensions.h
//  FJSCode
//
//  Created by Corey Floyd on 12/20/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  NSMutableArray(Stack)

-(void) push:(id)item;
-(id) pop;

@end

@interface  NSMutableArray(Queue)

-(void) enqueue:(id)item;
-(id) dequeue;

@end
