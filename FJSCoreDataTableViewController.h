//
//  FJSCoreDataTableViewController.h
//  FJSCode
//
//  Created by Corey Floyd on 8/19/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "FJSCoreDataCellController.h"

@interface FJSCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>{

    NSMutableArray *cellControllers;
    NSFetchedResultsController* fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}
//Set the context or errors will ensue...
@property(nonatomic,retain)NSManagedObjectContext *managedObjectContext;

@property(nonatomic,retain)NSFetchedResultsController *fetchedResultsController;

//You MUST overide this method to configure the fetchedResultsController dependent upon state
- (void)configureFetchedResultsController;


//You MUST overide this method to return a newly configured "empty" Cell Controller
//It will be populated with with the proper model data before being displayed on screen.
//must create a new UItableViewCell instance for the cellForRowAtIndexPath:
//default returns nil
- (id<FJSCoreDataCellController>)newCellControllerforIndexPath:(NSIndexPath*)indexPath;

//will update table depedent upon current state
- (void)refresh;

@end
