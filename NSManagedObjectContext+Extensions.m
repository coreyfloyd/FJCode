//
//  NSManagedObjectContext+Extensions.m
//  FJSCode
//
//  Created by Corey Floyd on 8/12/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "NSManagedObjectContext+Extensions.h"


#pragma mark -
#pragma mark Core Data stack

static NSManagedObjectModel* managedObjectModel = nil;
static NSPersistentStoreCoordinator* persistentStoreCoordinator = nil;
static NSManagedObjectContext* managedObjectContext = nil;



@implementation NSManagedObjectContext (CDStack)


+ (void)deleteStore{
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"storedata.sqlite"];
	[[NSFileManager defaultManager] removeItemAtPath:storePath error:nil];
	
}


+ (void)resetCoreDataStore{
	
	NSString* db = [[NSBundle mainBundle] pathForResource:@"storedata" ofType:@"sqlite"];
	
	NSString* appDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSString* path = [appDirectory stringByAppendingPathComponent:@"storedata.sqlite"]; 
	
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	[[NSFileManager defaultManager] copyItemAtPath:db 
											toPath:path
											 error:nil];
}


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
+ (NSManagedObjectContext *) defaultManagedObjectContext {
	
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
        newContext = [[NSManagedObjectContext alloc] init];
        [newContext setPersistentStoreCoordinator: coordinator];
    }
    return [newContext autorelease];
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
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"storedata.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		
		[self deleteStore];
		
		if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
    }    
	
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


@implementation NSManagedObjectContext (insert)
-(NSManagedObject *) insertNewEntityWithName:(NSString *)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
}
@end



@implementation NSManagedObjectContext (Entities)


//Containing strings
- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key contains:(NSString *)value{
    return [self entityWithName:entityName whereKey:key contains:value] != nil;
	
    
}

- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key contains:(NSString *)value{
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@",key , value];
    
    [request setPredicate:predicate];
    
    return [[self executeFetchRequest:request error:NULL] firstObject];
    
}

- (NSArray*)entitiesWithName:(NSString *)entityName whereKey:(NSString *)key contains:(NSString *)value{
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@",key , value];
    
    [request setPredicate:predicate];
    
    return [self executeFetchRequest:request error:NULL];
}

#pragma mark -
#pragma mark Case Insensitive Optional

- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value caseInsensitive:(BOOL)flag{
    
	if(flag)
		return [self entityWithNameExists:entityName whereKey:key caseInsensitiveLike:value];
	else 
		return [self entityWithNameExists:entityName whereKey:key like:value];
	
}

- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value caseInsensitive:(BOOL)flag{
	
	if(flag)
		return [self entityWithName:entityName whereKey:key caseInsensitiveLike:value];
	else 
		return [self entityWithName:entityName whereKey:key like:value];
	
    
    }

#pragma mark -
#pragma mark Case Insensitive Always

- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key caseInsensitiveLike:(NSString *)value{
	
    return [self entityWithName:entityName whereKey:key caseInsensitiveLike:value] != nil;
}

- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key caseInsensitiveLike:(NSString *)value
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like[c] %@",key , value];
    [request setPredicate:predicate];
    
    return [[self executeFetchRequest:request error:NULL] firstObject];
}


#pragma mark -
#pragma mark Equality

- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key equalToObject:(id )value{
	
	return [self entityWithName:entityName whereKey:key equalToObject:value] != nil;
	
}
- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key equalToObject:(id )value
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    [request setPredicate:predicate];
    
    return [[self executeFetchRequest:request error:NULL] firstObject];
}


- (id)retrieveOrCreateEntityWithName:(NSString *)entityName whereKey:(NSString *)key equalToObject:(id )value
{
    id obj = [self entityWithName:entityName whereKey:key equalToObject:value];
    if (!obj) {
        obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
        [obj setValue:value forKey:key];
    }
    return obj;
}


#pragma mark -

- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value
{
    return [self entityWithName:entityName whereKey:key like:value] != nil;
}

- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@",key , value];
    [request setPredicate:predicate];
    
    return [[self executeFetchRequest:request error:NULL] firstObject];
}

- (id)retrieveOrCreateEntityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value
{
    id obj = [self entityWithName:entityName whereKey:key like:value];
    if (!obj) {
        obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
        [obj setValue:value forKey:key];
    }
    return obj;
}


- (id)createEntity:(NSString *)entityName withUniqueValueForKey:(NSString *)key defaultValue:(NSString *)def
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                            inManagedObjectContext:self];
    NSString *baseName      = def;
    NSString *suggestedName = baseName;
    int counter             = 1;
    
    //find a unique name for the New Collection
    BOOL go = YES;
    while (go) {
        NSFetchRequest *request  = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"%K like %@",key,suggestedName]];
        int count = [self countForFetchRequest:request error:NULL];
        if (count != 0) {
            suggestedName = [NSString stringWithFormat:@"%@ %i",baseName,counter];
            counter++;
        } else
            go = NO;
    }
    [object setValue:suggestedName forKey:key];
    return object;
}

- (int)numberOfEntitiesWithName:(NSString *)entityName
{
    NSFetchRequest *request  = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    return [self countForFetchRequest:request error:NULL];
}

- (NSArray *)entitiesWithName:(NSString *)entityName
{
    NSFetchRequest *request  = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
        
    return[self executeFetchRequest:request error:NULL];
}

- (int)numberOfEntitiesWithName:(NSString *)entityName where:(NSString *)key like:(NSString *)value
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@",key , value];
    [request setPredicate:predicate];
    
    return [self countForFetchRequest:request error:NULL];
}

- (NSArray *)entitiesWithName:(NSString *)entityName where:(NSString *)key like:(NSString *)value
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@",key , value];
    [request setPredicate:predicate];
    
    return [self executeFetchRequest:request error:NULL];
}


@end



@implementation NSArray (CDArrayExtensions)

- (id)firstObject
{
	if ([self count] > 0)
		return [self objectAtIndex:0];
	
	return nil;
}

@end




