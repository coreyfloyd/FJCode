//
//  NSManagedObject+FJSExtensions.h
//  FJSCode
//
//  Created by Corey Floyd on 8/12/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NSManagedObject(IsNew)
/*!
 @method isNew 
 @abstract   Returns YES if this managed object is new and has not yet been saved yet into the persistent store.
 */
-(BOOL)isNew;
@end

