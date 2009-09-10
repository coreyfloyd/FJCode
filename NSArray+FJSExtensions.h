//
//  NSArray+FJSExtensions.h
//  FJSCode
//
//  Created by Corey Floyd on 9/2/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (FJS)

/*!
 This method will return an object contained with an array 
 contained within this array. It is intended to allow 
 single-step retrieval of objects in the nested array 
 using an index path
 */
- (id)nestedObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
