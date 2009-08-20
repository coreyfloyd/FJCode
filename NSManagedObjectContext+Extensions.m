//
//  NSManagedObjectContext+Extensions.m
//  FJSCode
//
//  Created by Corey Floyd on 8/12/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "NSManagedObjectContext+Extensions.h"
#import "NSArray+FJSCoreDataExtensions.h"


@implementation NSManagedObjectContext (CDManagedObjectContextExtensions)

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
    
    return [[self executeFetchRequest:request error:NULL] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
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

