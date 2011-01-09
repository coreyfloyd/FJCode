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


//application documents directory
NSString* defaultStoreLocation();

extern NSString* const kDefaultStoreName; //storedata
extern NSString* const kStoreExtension; //sqlite

@interface DDCoreDataStack : NSObject
{
    NSManagedObjectModel * _model;
    NSPersistentStoreCoordinator * _coordinator;
    NSPersistentStore * _mainStore;
    NSManagedObjectContext * _mainContext;
}

@property (readonly, retain) NSManagedObjectModel * model;
@property (readonly, retain) NSPersistentStoreCoordinator * coordinator;
@property (readonly, retain) NSPersistentStore * mainStore;
@property (readonly, retain) NSManagedObjectContext * mainContext;
@property (readonly, readonly) NSURL * mainStoreURL;


- (NSManagedObjectContext *)scratchpadContext; //autoreleased


//convienence methods, most common way to create stores

//default name, location, merging from bundles
- (BOOL)createFullStackWithDefaultSettings;

//specify a name of the store
- (BOOL)createFullStackWithSQLiteStoreWithName:(NSString*)name; //no extension

//same, but copies the store from this URL if the store doesn't exist. Use this if you have a default store that ships with the app
- (BOOL)createFullStackWithSQLiteStoreWithName:(NSString*)name copyStoreFromURLIfNeccesary:(NSURL*)storeURL; //must have .sqlite extension

//copy, will not overwrite existing store
- (BOOL)createFullStackByCopyingStoreAtURL:(NSURL*)storeURL;

//in memory store merging from bundles
- (BOOL)createFullStackWithInMemoryStore;



//full stack

- (BOOL)createFullStackWithStoreType:(NSString *)storeType
                                 URL:(NSURL *)url
                               error:(NSError **)error;

- (BOOL)createFullStackFromModelsInBundles:(NSArray *)bundles
                                 storeType:(NSString *)storeType
                                       URL:(NSURL *)url
                                     error:(NSError **)error;

- (void)createFullStackWithStoreType:(NSString *)storeType
                                 URL:(NSURL *)url;

- (void)createFullStackFromModelsInBundles:(NSArray *)bundles
                                 storeType:(NSString *)storeType
                                       URL:(NSURL *)url;

- (void)destroyFullStack;

- (void)destroyFullStackAndDeleteStoreFromDisk:(BOOL)flag;



//So you want to do it all yourself?

//(1) model

- (void)createMergedModelFromMainBundle;

- (void)createMergedModelFromBundles:(NSArray *)bundles;

- (void)destroyModel;




//(2) coordinator

- (void)createCoordinator; //model must exist!!

- (void)destroyCoordinator;


//(3) store

- (void)addMainStoreWithType:(NSString *)storeType
               configuration:(NSString *)configuration
                         URL:(NSURL *)url
                     options:(NSDictionary *)options; //coordinator must exist!!

- (BOOL)addMainStoreWithType:(NSString *)storeType
               configuration:(NSString *)configuration
                         URL:(NSURL *)url
                     options:(NSDictionary *)options
                       error:(NSError **)error; //coordinator must exist!!

- (void)removeMainStore; //does not remove from disk

- (void)removeMainStoreDeleteFromDisk:(BOOL)flag;

- (void)deleteMainStoreFromDisk;

//(4) context

- (void)createMainContext;

- (NSManagedObjectContext*)newContext;

- (void)destroyMainContext;

@end
