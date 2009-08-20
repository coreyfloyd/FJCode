//
//  NSManagedObjectContext+Extensions.h
//  FJSCode
//
//  Created by Corey Floyd on 8/12/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/*
 Almost all methods here have comparable syntax.
 It's all something like '...entitiyWithName: whereKey: like:',
 which works just the way it says
 */


@interface NSManagedObjectContext (CDManagedObjectContextExtensions)

//returns YES if there exists an entity with 'entityName' which has a 'key' with a certain 'value', NO otherwise
- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value;

//creates and returns an entity with 'entityName' with 'key' set to 'value'
- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value;

//tries to retrieve an entity with certain characteristics and if it fails, it creates one
- (id)retrieveOrCreateEntityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value;

//creates an entity with an unique value for key, derived from the default value.
//for example, if there already exists and entity "Person" with "name"="Foo", it will create an entity with "name"="Foo 1" etc
- (id)createEntity:(NSString *)entityName withUniqueValueForKey:(NSString *)key defaultValue:(NSString *)def;

//returns the number of entities with a certain name
- (int)numberOfEntitiesWithName:(NSString *)entityName;

//returns the number of entities of 'entityName' where 'key' has a certain 'value'
- (int)numberOfEntitiesWithName:(NSString *)entityName where:(NSString *)key like:(NSString *)value;

//returns all entities with a certain name
- (NSArray *)entitiesWithName:(NSString *)entityName;

//returns all entities of 'entityName' where 'key' has a certain 'value'
- (NSArray *)entitiesWithName:(NSString *)entityName where:(NSString *)key like:(NSString *)value;

@end


/*
 This very short little category allows me to insert new objects into a context by simply doing this:
 
 [context insertNewEntityWityName:[entity name]];
 */


@interface NSManagedObjectContext(insert)
-(NSManagedObject *) insertNewEntityWithName:(NSString *)name;
@end

