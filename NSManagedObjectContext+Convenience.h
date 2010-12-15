#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>




@interface NSArray (CDArrayExtensions)

- (id)firstObject;

@end


@interface NSManagedObjectContext (DictionaryExtensions)

- (NSMutableDictionary*) mutableDictionaryForEntityWithName:(NSString*)entityName keyedBy:(NSString*)keyName;

@end


@interface NSManagedObjectContext(insert)
/*
 This very short little category allows me to insert new objects into a context by simply doing this:
 [context insertNewEntityWityName:[entity name]];
 */
-(NSManagedObject *) insertNewEntityWithName:(NSString *)name;
@end



@interface NSManagedObjectContext (Entities)

/*
 Almost all methods here have comparable syntax.
 It's all something like '...entitiyWithName: whereKey: like:',
 which works just the way it says
 */



//returns the number of entities with a certain name
- (int)numberOfEntitiesWithName:(NSString *)entityName;

//returns the number of entities of 'entityName' where 'key' has a certain 'value'
- (int)numberOfEntitiesWithName:(NSString *)entityName where:(NSString *)key like:(NSString *)value;




//returns all entities with a certain name
- (NSArray *)entitiesWithName:(NSString *)entityName;

- (NSArray *)entitiesWithName:(NSString *)entityName predicate:(NSPredicate*)predicate;



//returns all entities of 'entityName' where 'key' has a certain 'value'
- (NSArray *)entitiesWithName:(NSString *)entityName where:(NSString *)key like:(NSString *)value;

//returns all entities of 'entityName' where 'key' contains string (case insensitive)
- (NSArray *)entitiesWithName:(NSString *)entityName whereKey:(NSString *)key contains:(NSString *)value;

// returns all entities of 'entityName' where 'key' is one of a collection of values (collection must be an array, set, or dictionary (in which case the values are used))
- (NSArray*)entitiesWithName: (NSString*)entityName whereKey: (NSString*)key isIn: (id)collection;



//returns YES if there exists an entity with 'entityName' which has a 'key' with a certain 'value', NO otherwise
- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value;

//Containing strings (case insensitive)
- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key contains:(NSString *)value;

//Case Insensitive optional
- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value caseInsensitive:(BOOL)flag;

//exact object matches 
- (BOOL)entityWithNameExists:(NSString *)entityName whereKey:(NSString *)key equalToObject:(id )value;




//returns an entity with 'entityName' with 'key' set to 'value'
- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value;

//Containing strings (case insensitive)
- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key contains:(NSString *)value;

//Case Insensitive optional
- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value caseInsensitive:(BOOL)flag;

//exact matches (not strings)
- (id)entityWithName:(NSString *)entityName whereKey:(NSString *)key equalToObject:(id )value;




//creates an entity with an unique value for key, derived from the default value.
//for example, if there already exists and entity "Person" with "name"="Foo", it will create an entity with "name"="Foo 1" etc
- (id)createEntity:(NSString *)entityName withUniqueValueForKey:(NSString *)key defaultValue:(NSString *)def;




//tries to retrieve an entity with certain characteristics and if it fails, it creates one
- (id)retrieveOrCreateEntityWithName:(NSString *)entityName whereKey:(NSString *)key like:(NSString *)value;

//exact object matches 
- (id)retrieveOrCreateEntityWithName:(NSString *)entityName whereKey:(NSString *)key equalToObject:(id )value;



- (NSArray*)objectsWithObjectIDs:(NSArray*)originalObjectIDs;

- (NSArray*)objectsWithObjectsFromOtherContext:(NSArray*)originalObjects;



@end




