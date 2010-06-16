//
//  NSManagedObjectContext+CoreDataStack.h
//  PhillyBeerWeek
//
//  Created by Corey Floyd on 4/18/10.
//  Copyright 2010 Flying Jalapeño Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



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
+ (NSManagedObjectContext *)defaultManagedObjectContext;
+ (NSManagedObjectContext *)scratchpadManagedObjectContext;
+ (NSManagedObjectModel *)managedObjectModel;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

+ (NSString *)applicationDocumentsDirectory;

//urls of stores
+ (NSURL *)primaryStore;
+ (NSURL *)personalStore;

//Deletes store at URL
+ (void)deleteStore:(NSURL *)url;

//Deletes store at url and replaces it with store of same name from application bundle
+ (void)resetStore:(NSURL *)url;


@end

