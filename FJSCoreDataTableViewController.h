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


//You MUST overide the getter to configure the fetchedResultsController dependent upon state
//be sure to set fetchedResultsController.delegate = self if you require add/remove support
@property(nonatomic,retain, readonly)NSFetchedResultsController *fetchedResultsController;


//You MUST overide this method to return a newly configured "empty" Cell Controller
//It will be populated with with the proper model data before being displayed on screen.
//default returns nil
- (id<FJSCoreDataCellController>)newCellControllerforIndexPath:(NSIndexPath*)indexPath;

//will update table depedent upon current state
- (void)refresh;

@end
