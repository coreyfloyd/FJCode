//
//  NSManagedObjectContext+CoreDataStack.h
//  PhillyBeerWeek
//
//  Created by Corey Floyd on 4/18/10.
//  Copyright 2010 Flying Jalapeño Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//#define MULTIPLE_STORE_SUPPORT


@interface NSManagedObjectContext (CDStack)

/*
 To use:
 Delete all the CD ivars, properties and methods in the app delegate.
 Add the following property and method to the app delegate:
 
 @property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
 
 - (NSManagedObjectContext *) managedObjectContext {
 return [NSManagedObjectContext defaultManagedObjectContext];
 }
 */

//standard CD stack
+ (NSManagedObjectContext *)defaultManagedObjectContext;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (NSManagedObjectModel *)managedObjectModel;

//disposable context
+ (NSManagedObjectContext *)scratchpadManagedObjectContext;

//context not attached to store, cannot be persisted
+ (NSManagedObjectContext *)inmemoryManagedObjectContext;
+ (NSPersistentStoreCoordinator *)inMemoryStoreCoordinator;


+ (NSString *)applicationDocumentsDirectory;

//urls of stores
+ (NSURL *)primaryStore;

#ifdef MULTIPLE_STORE_SUPPORT

+ (NSURL *)personalStore;

#endif

//Deletes store at URL
+ (void)deleteStore:(NSURL *)url;

//Deletes store at url and replaces it with store of same name from application bundle, or if not found, an empty store
+ (void)resetStore:(NSURL *)url;


@end

