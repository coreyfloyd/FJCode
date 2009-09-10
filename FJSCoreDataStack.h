//
//  FJSCoreDataStack.h
//  FJSCode
//
//  Created by Corey Floyd on 8/12/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+Extensions.h"
#import "NSManagedObject+FJSExtensions.h"

//TODO: create optional file url for NSMangedObjectModel;

@interface FJSCoreDataStack : NSObject {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    NSString *fileName;
    
    
}

//set sqlite db name, no file extension
//default is "storage"
@property(nonatomic,retain)NSString *fileName;


@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

- (NSError*)save;


@end
