//
//  NSManagedObject+FJSExtensions.m
//  FJSCode
//
//  Created by Corey Floyd on 8/12/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "NSManagedObject+Extensions.h"


@implementation NSManagedObject(IsNew)
-(BOOL)isNew 
{
    NSDictionary *vals = [self committedValuesForKeys:nil];
    return [vals count] == 0;
}
@end

