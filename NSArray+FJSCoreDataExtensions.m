//
//  CDArrayExtensions.m
//  CoreDataKit
//
//  Created by Pieter Omvlee on 8/7/08.
//  Copyright 2008 Bohemian Coding. All rights reserved.
//

#import "NSArray+FJSCoreDataExtensions.h"


@implementation NSArray (CDArrayExtensions)

- (id)firstObject
{
  if ([self count] > 0)
    return [self objectAtIndex:0];
  
  return nil;
}

@end
