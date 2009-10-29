//
//  FJSCoreDataTableViewController.h
//  FJSCode
//
//  Created by Corey Floyd on 8/19/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//


//Animations for deletions and additions are handled automatically.
//To support editing, simply add the editing button to the tool bar.

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "FJSCoreDataCellController.h"

@interface FJSCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>{

    NSMutableArray *cellControllers;
    NSFetchedResultsController* fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    BOOL showSectionIndexes;
}
// Set the context or errors will ensue...
@property(nonatomic,retain)NSManagedObjectContext *managedObjectContext;

// set and/or configure this instance within the configureFetchedResultsController method
@property(nonatomic,retain)NSFetchedResultsController *fetchedResultsController;

// Set to show section enable or disable section indexes, default is NO;
@property(nonatomic,assign)BOOL showSectionIndexes;


// You MUST overide this method to return a newly configured "empty" Cell Controller
// It will be populated with with the proper model data before being displayed on screen.
// must create a new UItableViewCell instance for the cellForRowAtIndexPath:
// default returns nil
- (id<FJSCoreDataCellController>)newCellControllerforIndexPath:(NSIndexPath*)indexPath;


// You MUST overide this method to configure the fetchedResultsController dependent upon state
// assign the fetchedResultsController property to your configured controller
- (void)configureFetchedResultsController;


// call to update the table
// configures fetchedResultsController by calling configureFetchedResultsController
// kills current cellControllers, fetches data, reloads tableview
// sets fetchedController delegate to self
- (void)updateTableforCurrentState;

// DOES NOT configure fetchedResultsController
// fetches data, reloads tableview 
// DOES NOT set fetchedController delegate to self
- (void)fetchAndReloadTable;


// Implement to support rearranging the table view.
// unset and reset fetchresultscontroller delegate to avoid automatic animations if you perform fetches
// - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

// Implement to support conditional rearranging of the table view.
// - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath; 

// Implement to support conditional editing of the table view.
// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

@end

