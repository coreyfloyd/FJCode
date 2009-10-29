//
//  NSObject+AssociatedObjects.h
//
//  Created by Andy Matuschak on 8/27/09.
//  Public domain because I love you.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>


@interface NSObject (AMAssociatedObjects)
- (void)associateValue:(id)value withKey:(void *)key; // Retains value.
- (id)associatedValueForKey:(void *)key;
@end
