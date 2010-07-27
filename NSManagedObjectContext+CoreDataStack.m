//
//  NSManagedObjectContext+CoreDataStack.m
//  PhillyBeerWeek
//
//  Created by Corey Floyd on 4/18/10.
//  Copyright 2010 Flying Jalapeño Software. All rights reserved.
//

#import "NSManagedObjectContext+CoreDataStack.h"




#pragma mark -
#pragma mark Core Data stack

static NSManagedObjectModel* managedObjectModel = nil;
static NSPersistentStoreCoordinator* persistentStoreCoordinator = nil;
static NSManagedObjectContext* managedObjectContext = nil;

static NSString* const kStoreName = @"storedata.sqlite";
static NSString* const kModelConfigurationName = @"primaryModel";

#ifdef MULTIPLE_STORE_SUPPORT

static NSString* const kPersonalStoreName = @"personalstoredata.sqlite";
static NSString* const kPersonalModelConfigurationName = @"personalModel";

#endif

@implementation NSManagedObjectContext (CDStack)


+ (NSURL *)primaryStore{
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:kStoreName];
	
	return [NSURL fileURLWithPath:storePath];
	
}

#ifdef MULTIPLE_STORE_SUPPORT

+ (NSURL *)personalStore{
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:kPersonalStoreName];
	
	return [NSURL fileURLWithPath:storePath];
	
}

#endif

+ (void)deleteStore:(NSURL *)url{
	
	[[NSFileManager defaultManager] removeItemAtPath:[url path] error:nil];
	
}
+ (void)resetStore:(NSURL *)url{
	
	NSString* filename = [[url path] lastPathComponent];
	
	NSString* extension = [filename pathExtension];
	
	filename = [filename stringByDeletingPathExtension];
	
	if([extension isEqualToString:@"sqlite"]){
		
		NSString* freshStore = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
		
		if(freshStore == nil)
			return;
		
		[NSManagedObjectContext deleteStore:url];
		
		debugLog(@"Replacing Store with database located at: %@", freshStore);
		
		[[NSFileManager defaultManager] copyItemAtPath:freshStore 
												toPath:[url path]
												 error:nil];
	}
}


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
+ (NSManagedObjectContext *)defaultManagedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

+ (NSManagedObjectContext *)scratchpadManagedObjectContext{
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	NSManagedObjectContext* newContext = nil;
    if (coordinator != nil) {
        newContext = [[[NSManagedObjectContext alloc] init] autorelease];
        [newContext setPersistentStoreCoordinator: coordinator];
    }
	
	NSError* error = nil;
	if( ![newContext save:&error]){
		debugLog(@"core data save error:", [error description]);
		return nil;
	} else {
		return newContext;
	}
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
+ (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSManagedObjectContext primaryStore];
	
	/*
	 if(![[NSFileManager defaultManager] fileExistsAtPath:[storeUrl path]])
	 [self resetStore:storeUrl];
	 */
	
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:kModelConfigurationName URL:storeUrl options:nil error:&error]) {
		
		//We had an issue, we will delete the store and try again
		[self deleteStore:storeUrl];
		
		if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:kModelConfigurationName URL:storeUrl options:nil error:&error]) {
			debugLog(@"Unresolved error %@, %@", error, [error userInfo]);
			//Man we are really f*cked
			abort();
		}
    }
    
#ifdef MULTIPLE_STORE_SUPPORT
    
	NSURL *personalStoreUrl = [NSManagedObjectContext personalStore];
	
	
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:kPersonalModelConfigurationName URL:personalStoreUrl options:nil error:&error]) {
		
		//We had an issue, we will delete the store and try again
		[self deleteStore:personalStoreUrl];
		
		if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:kPersonalModelConfigurationName URL:personalStoreUrl options:nil error:&error]) {
			debugLog(@"Unresolved error %@, %@", error, [error userInfo]);
			//Man we are really f*cked
			abort();
		}
    }
    
#endif
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
+ (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}




@end

