//
//  NSManagedObjectContext+Extensions.m
//  FJSCode
//
//  Created by Corey Floyd on 8/12/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "NSManagedObjectContext+Extensions.h"


#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

@implementation NSManagedObjectContext (BuyingGuide)

- (void)resetCoreDataStore{
	
	NSString* db = [[NSBundle mainBundle] pathForResource:@"storedata" ofType:@"sqlite"];

	NSString* appDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSString* path = [appDirectory stringByAppendingPathComponent:@"storedata.sqlite"]; 
	
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	[[NSFileManager defaultManager] copyItemAtPath:db 
											toPath:path
											 error:nil];
}


- (void)displayCcoreDataError{
	
	NSDictionary* info = [[NSBundle mainBundle] infoDictionary];
	NSString* text = [info objectForKey:@"CoreDataCrashMessage"];
    UIAlertView* message = [[UIAlertView alloc] initWithTitle:@"Uh Oh"
                                                      message:text 
                                                     delegate:self 
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil];
    [message show];
	
}



@end

#endif

@implementation NSManagedObjectContext (CDManagedObjectContextExtensions)


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

#pragma mark -
#pragma mark Case Insensitive Optional

- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value caseInsensitive:(BOOL)flag{
    
    return [self entityWithName:entityName whereKey:key like:value caseInsensitive:flag] != nil;
    
}

- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value caseInsensitive:(BOOL)flag{
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate;
    
    if(flag)
        predicate = [NSPredicate predicateWithFormat:@"%K like[c] %@",key , value];
    else
        predicate = [NSPredicate predicateWithFormat:@"%K like %@",key , value];
    
    [request setPredicate:predicate];
    
    return [[self executeFetchRequest:request error:NULL] firstObject];
}

- (id)retrieveOrCreateEntityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value caseInsensitive:(BOOL)flag{
 
    id obj = [self entityWithName:entityName whereKey:key like:value caseInsensitive:flag];
    if (!obj) {
        obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
        [obj setValue:value forKey:key];
    }
    return obj;
    
   
}


#pragma mark -
#pragma mark Case Insensitive Always

- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key caseInsensitiveLike:(NSString *)value
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like[c] %@",key , value];
    [request setPredicate:predicate];
    
    return [[self executeFetchRequest:request error:NULL] firstObject];
}

- (id)retrieveOrCreateEntityWithName:(NSString *)entityName whereKey:(NSString *)key caseInsensitiveLike:(NSString *)value
{
    id obj = [self entityWithName:entityName whereKey:key caseInsensitiveLike:value];
    if (!obj) {
        obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
        [obj setValue:value forKey:key];
    }
    return obj;
}


#pragma mark -
#pragma mark Equality

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
#pragma mark Like (Original)

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

@implementation NSManagedObjectContext (insert)
-(NSManagedObject *) insertNewEntityWithName:(NSString *)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self];
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


