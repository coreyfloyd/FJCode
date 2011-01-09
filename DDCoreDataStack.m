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

#import "DDCoreDataStack.h"
#import "DDCoreDataException.h"

NSString* const kDefaultStoreName = @"storedata";

NSString* const kStoreExtension = @"sqlite";

NSString* defaultStoreLocation(){
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

}



@implementation DDCoreDataStack

@synthesize model = _model;
@synthesize coordinator = _coordinator;
@synthesize mainStore = _mainStore;
@synthesize mainContext = _mainContext;


- (void)dealloc
{
    [self destroyFullStack];
    [super dealloc];
}

- (NSURL*)mainStoreURL{
    
    return [[self mainStore] URL];
    
}

- (BOOL)createFullStackWithDefaultSettings{
    
    return [self createFullStackWithSQLiteStoreWithName:kDefaultStoreName];
}

- (BOOL)createFullStackWithSQLiteStoreWithName:(NSString*)name{
    
    NSString* fileName = [name stringByAppendingPathExtension:kStoreExtension];
    NSString* path = [defaultStoreLocation() stringByAppendingPathComponent:fileName];
    
    NSURL* url = [NSURL fileURLWithPath:path];
    
    return [self createFullStackWithStoreType:NSSQLiteStoreType URL:url error:nil];
}

- (BOOL)createFullStackWithSQLiteStoreWithName:(NSString*)name copyStoreFromURLIfNeccesary:(NSURL*)storeURL{
    
    NSString* storePathExtension = [storeURL pathExtension];
    
	if(![storePathExtension isEqualToString:@"sqlite"])
        return NO;
    
    NSString* fileName = [name stringByAppendingPathExtension:kStoreExtension];
    NSString* path = [defaultStoreLocation() stringByAppendingPathComponent:fileName];
    NSURL* url = [NSURL fileURLWithPath:path];

    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        
        NSError* error;
        [[NSFileManager defaultManager] copyItemAtURL:storeURL 
                                                toURL:url
                                                 error:&error];
        
        if(error != nil)
            return NO;
    }
    
    
    return [self createFullStackWithSQLiteStoreWithName:name];
    
}


- (BOOL)createFullStackByCopyingStoreAtURL:(NSURL*)storeURL{
    
    NSString* storePathExtension = [storeURL pathExtension];
    
	if(![storePathExtension isEqualToString:@"sqlite"])
        return NO;
    
    NSString* fileName = [kDefaultStoreName stringByAppendingPathExtension:kStoreExtension];
    NSString* path = [defaultStoreLocation() stringByAppendingPathComponent:fileName];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    NSError* error;
    [[NSFileManager defaultManager] copyItemAtURL:storeURL 
                                            toURL:url
                                            error:&error];
    
    if(error != nil)
        return NO;
    
    return [self createFullStackWithDefaultSettings];
    
}

       

- (BOOL)createFullStackWithInMemoryStore{
        
    return [self createFullStackWithStoreType:NSInMemoryStoreType URL:nil error:nil];
    
}


- (BOOL)createFullStackWithStoreType:(NSString *)storeType
                                 URL:(NSURL *)url
                               error:(NSError **)error;
{
    return [self createFullStackFromModelsInBundles:nil
                                          storeType:storeType
                                                URL:url
                                              error:error];
}

- (BOOL)createFullStackFromModelsInBundles:(NSArray *)bundles
                                 storeType:(NSString *)storeType
                                       URL:(NSURL *)url
                                     error:(NSError **)error;
{
    [self createMergedModelFromBundles:bundles];
    [self createCoordinator];
    if (![self addMainStoreWithType:storeType
                      configuration:nil
                                URL:url
                            options:nil
                              error:error])
    {
        [self destroyCoordinator];
        [self destroyModel];
        return NO;
    }
    
    [self createMainContext];
    return YES;
}

- (void)createFullStackWithStoreType:(NSString *)storeType
                                 URL:(NSURL *)url;
{
    [self createFullStackFromModelsInBundles:nil
                                   storeType:storeType
                                         URL:url];
}

- (void)createFullStackFromModelsInBundles:(NSArray *)bundles
                                 storeType:(NSString *)storeType
                                       URL:(NSURL *)url;
{
    [self createMergedModelFromBundles:bundles];
    [self createCoordinator];
    [self addMainStoreWithType:storeType
                 configuration:nil
                           URL:url
                       options:nil];
    [self createMainContext];
}

- (void)destroyFullStack;
{
    [self destroyMainContext];
    [self removeMainStore];
    [self destroyCoordinator];
    [self destroyModel];
}

- (void)destroyFullStackAndDeleteStoreFromDisk:(BOOL)flag{
    
    [self destroyMainContext];
    [self removeMainStoreDeleteFromDisk:flag];
    [self destroyCoordinator];
    [self destroyModel];
    
}

- (void)createMergedModelFromMainBundle;
{
    [self createMergedModelFromBundles:nil];
}

- (void)createMergedModelFromBundles:(NSArray *)bundles;
{
    NSAssert(_model == nil, @"Model is already created");
    _model = [[NSManagedObjectModel mergedModelFromBundles:bundles] retain];
    NSAssert(_model != nil, @"Created model is nil");
}

- (void)destroyModel
{
    [_model release];
    _model = nil;
}

- (void)createCoordinator;
{
    NSAssert(_coordinator == nil, @"Coordinator is already created");
    NSAssert(_model != nil, @"Model should not be nil");
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    NSAssert(_coordinator != nil, @"Created coordinator is nil");
}

- (void)destroyCoordinator
{
    [_coordinator release];
    _coordinator = nil;
}

- (void)addMainStoreWithType:(NSString *)storeType
               configuration:(NSString *)configuration
                         URL:(NSURL *)url
                     options:(NSDictionary *)options;
{
    NSError * error = nil;
    if (![self addMainStoreWithType:storeType
                      configuration:configuration
                                URL:url
                            options:options
                              error:&error])
    {
        @throw [DDCoreDataException exceptionWithReason:@"Could not addPersistent store"
                                                  error:error];
    }
}

- (BOOL)addMainStoreWithType:(NSString *)storeType
               configuration:(NSString *)configuration
                         URL:(NSURL *)url
                     options:(NSDictionary *)options
                       error:(NSError **)error;
{
    NSAssert(_mainStore == nil, @"Main store is already created");
    NSAssert(_coordinator != nil, @"Coordinator should not be nil");
    _mainStore = [_coordinator addPersistentStoreWithType:storeType
                                            configuration:configuration
                                                      URL:url
                                                  options:options
                                                    error:error];
    [_mainStore retain];
    if (_mainStore == nil)
        return NO;
    else
        return YES;
}

- (void)removeMainStore
{
    if (_mainStore != nil)
    {
        [_coordinator removePersistentStore:_mainStore error:nil];
        [_mainStore release];
        _mainStore = nil;
    }
}

- (void)removeMainStoreDeleteFromDisk:(BOOL)flag{

    [self deleteMainStoreFromDisk];
   
    if (_mainStore != nil)
    {
        [_coordinator removePersistentStore:_mainStore error:nil];
        [_mainStore release];
        _mainStore = nil;
    }
    
}

- (void)createMainContext;
{
    NSAssert(_mainContext == nil, @"Main context is already created");
    _mainContext = [self newContext];
}

- (NSManagedObjectContext*)newContext{
    
    NSAssert(_coordinator != nil, @"Coordinator should not be nil");
    NSManagedObjectContext * context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:_coordinator];
    return context;
    
}


- (void)destroyMainContext
{
    [_mainContext release];
    _mainContext = nil;
}


- (NSManagedObjectContext *)scratchpadContext{
	
    NSAssert(_coordinator != nil, @"Coordinator should not be nil");
    NSManagedObjectContext * context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:_coordinator];
    return [context autorelease];
    
}

- (void)deleteMainStoreFromDisk{
    
    [[NSFileManager defaultManager] removeItemAtPath:[[self mainStoreURL] path] error:nil];
    
}




@end
