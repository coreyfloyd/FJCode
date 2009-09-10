//
//  NSArray+FJSExtensions.m
//  FJSCode
//
//  Created by Corey Floyd on 9/2/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "NSArray+FJSExtensions.h"


@implementation NSArray (FJS)

- (id)nestedObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    NSArray *subArray = [self objectAtIndex:section];
    
    if (![subArray isKindOfClass:[NSArray class]])
        return nil;
    
    if (row >= [subArray count])
        return nil;
    
    return [subArray objectAtIndex:row];
}

@end
