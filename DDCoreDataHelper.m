/*
 * Copyright (c) 2007-2008 Dave Dribin
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "DDCoreDataHelper.h"
#import "DDCoreDataProvider.h"

@implementation DDCoreDataHelper

+ (DDCoreDataHelper *) helperWithProvider: (DDCoreDataProvider *) provider;
{
    return [[[self alloc] initWithProvider: provider] autorelease];
}

- (id) initWithProvider: (DDCoreDataProvider *) provider;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _provider = provider;
    
    return self;
}

- (NSArray *) executeFetchRequest: (NSFetchRequest *) request;
{
    NSError * error = nil;
    NSManagedObjectContext * context = [_provider managedObjectContext];
    NSArray * results = [context executeFetchRequest: request error: &error];
    if (results == nil)
    {
        [_provider handleCoreDataError: error];
        return nil;
    }
    
    return results;
}

- (id) executeUniqueFetchRequest: (NSFetchRequest *) request;
{
    NSArray * results = [self executeFetchRequest: request];
    if ([results count] > 1)
    {
        NSError * error = [NSError errorWithDomain: NSCocoaErrorDomain
                                              code: 0
                                          userInfo: nil];
        [_provider handleCoreDataError: error];
        return nil;
    }
    
    if ([results count] == 0)
        return nil;
    else
        return [results objectAtIndex: 0];
}

- (BOOL) save;
{
    NSManagedObjectContext * context = [_provider managedObjectContext];
    NSError * error = nil;
    BOOL result = [context save: &error];
    if (!result)
        [_provider handleCoreDataError: error];
    return result;
}

@end
