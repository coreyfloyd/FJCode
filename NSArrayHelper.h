//
//  NSArrayHelper.h
//  CocoaHelpers
//
//  Created by Shaun Harrison on 10/28/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSArray (Helper)

/*
 * Checks to see if the array is empty
 */
@property(nonatomic,readonly,getter=isEmpty) BOOL empty;

- (NSUInteger)lastIndex; //returns NSNotFound for empty array

@end



@interface NSArray (UtilityExtensions)
- (id) firstObject;
- (NSArray *) uniqueMembers;
- (NSArray *) unionWithArray: (NSArray *) array;
- (NSArray *) intersectionWithArray: (NSArray *) array;


// Note also see: makeObjectsPeformSelector: withObject:. Map collects the results a la mapcar in Lisp
//- (NSArray *) map: (SEL) selector;
//- (NSArray *) map: (SEL) selector withObject: (id)object;
//- (NSArray *) map: (SEL) selector withObject: (id)object1 withObject: (id)object2;

@end


@interface  NSMutableArray(primatives)

- (void)addInt:(int)integer;

@end

@interface  NSMutableArray(Stack)

-(void) push:(id)item;
-(id) pop;

@end

@interface  NSMutableArray(Queue)

-(void) enqueue:(id)item;
-(id) dequeue;

@end


@interface NSMutableArray (UtilityExtensions)

- (NSMutableArray *) removeFirstObject;
- (NSMutableArray *) reverse;
- (NSMutableArray *) scramble;

@property (readonly, getter=reverse) NSMutableArray *reversed;

@end

@interface NSArray (StringExtensions)

- (NSArray *) arrayBySortingStrings;
@property (readonly, getter=arrayBySortingStrings) NSArray *sortedStrings;
@property (readonly) NSString *stringValue;

@end