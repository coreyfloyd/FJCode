//
//  FJSCoreDataTableViewController.m
//  FJSCode
//
//  Created by Corey Floyd on 8/19/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSCoreDataTableViewController.h"


@interface FJSCoreDataTableViewController()

@property(nonatomic,retain)NSMutableArray *cellControllers;


- (id<FJSCoreDataCellController>)cellControllerForIndexPath:(NSIndexPath*)indexPath;

@end



@implementation FJSCoreDataTableViewController

@synthesize cellControllers;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize showSectionIndexes;



- (void)dealloc {
    /*
     [[NSNotificationCenter defaultCenter] removeObserver:self 
     name:NSManagedObjectContextDidSaveNotification 
     object:self.managedObjectContext];
     */
    self.managedObjectContext = nil;
    self.cellControllers = nil;
    [fetchedResultsController release];
    fetchedResultsController = nil;
    
    
    [super dealloc];
}

- (void)viewDidUnload {
    self.tableView = nil;
    
    /*
     [[NSNotificationCenter defaultCenter] removeObserver:self 
     name:NSManagedObjectContextDidSaveNotification 
     object:self.managedObjectContext];
     */
    [super viewDidUnload];
    
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated{
    
    fetchedResultsController.delegate = nil;
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     
     [[NSNotificationCenter defaultCenter] addObserver:self 
     selector:@selector(handleSaveNotification:) 
     name:NSManagedObjectContextDidSaveNotification 
     object:self.managedObjectContext];
     
     */
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    fetchedResultsController.delegate = self;
    
    
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




#pragma mark -
#pragma mark UITableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(fetchedResultsController==nil)
        return 0;
    
    NSInteger count = [[fetchedResultsController sections] count];
   
    /*
	if (count == 0) {
		count = 1;
	}
	*/
    return count;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(fetchedResultsController==nil)
        return 0;
    
    NSInteger numberOfRows = 0;
	
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}


- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section { 
    
    if(fetchedResultsController==nil)
        return nil;
    
    NSString *title = nil;
    
    if(section < [[fetchedResultsController sections] count]){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        title =  [NSString stringWithFormat:NSLocalizedString(@"%@", @"%@"), [sectionInfo name]];
    }else {
        title = nil;
    }
    
    
    
    return title;
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<FJSCoreDataCellController> cellController = [self cellControllerForIndexPath:indexPath];
    return [cellController tableView:tableView cellForRowAtIndexPath:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<FJSCoreDataCellController> cellController = [self cellControllerForIndexPath:indexPath];
    if([cellController respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        [cellController tableView:tableView didSelectRowAtIndexPath:indexPath];
    
}



#pragma mark -
#pragma mark sectionIndexTitlesForTableView

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)table {
    if(fetchedResultsController==nil)
        return nil;
    if(showSectionIndexes==NO)
       return nil;
    
    // return list of section titles to display in section index view (e.g. "ABCD...Z#")

    return [fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)table sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if(fetchedResultsController==nil)
        return 0;
    if(showSectionIndexes==NO)
        return 0;
    
    // tell table which section corresponds to section title/index (e.g. "B",1))
    return [fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}



#pragma mark -
#pragma mark Editing


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(fetchedResultsController==nil)
        return;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}   
}


#pragma mark -
#pragma mark FJSCoreDataCellController

- (id<FJSCoreDataCellController>)cellControllerForIndexPath:(NSIndexPath*)indexPath{
    
    if(self.cellControllers==nil)
        self.cellControllers = [NSMutableArray array];
    
    id<FJSCoreDataCellController> cellController = nil;
    
    for(id<FJSCoreDataCellController> eachCellController in self.cellControllers){
        
        if([eachCellController.cellIndexPath compare:indexPath] == NSOrderedSame){
            cellController = eachCellController;
            break;
        }
        
    }
    
    if(cellController == nil){
        cellController = [[self newCellControllerforIndexPath:indexPath] autorelease];
        cellController.cellIndexPath = indexPath;
        [self.cellControllers addObject:cellController];
        
    }
    
    cellController.fetchedResultsController = self.fetchedResultsController;
    
    return cellController;
}

- (id<FJSCoreDataCellController>)newCellControllerforIndexPath:(NSIndexPath*)indexPath{
    
    return nil;
    
}


#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate
/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
            [(id<FJSCoreDataCellController>)[self cellControllerForIndexPath:indexPath] refreshCell];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			// Reloading the section inserts a new row and ensures that titles are updated appropriately.
			[tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}





#pragma mark -
#pragma mark NSFetchedResultsController


//Uncomment to handle merging multiple contexts, also uncomment notification methods in viewDidLoad, etc...
/*
 - (void)handleSaveNotification:(NSNotification *)aNotification {
 
 [managedObjectContext mergeChangesFromContextDidSaveNotification:aNotification];
 [self fetch];
 }
 */

- (void)updateTableforCurrentState{
    self.cellControllers = nil;
    [self configureFetchedResultsController];
    self.fetchedResultsController.delegate = self;
    [self fetchAndReloadTable];
}

- (void)fetchAndReloadTable{
    NSError *error = nil;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    NSAssert2(success, @"Unhandled error performing fetch at SongsViewController.m, line %d: %@", __LINE__, [error localizedDescription]);
    [self.tableView reloadData];
}

- (void)configureFetchedResultsController{
    
    if(self.managedObjectContext==nil)
        return;
    
    self.fetchedResultsController = nil;
    
    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) {
        
        //example code on how to create fetchedResultsController
        
        /*
         // Create the fetch request for the entity.
         NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
         // Edit the entity name as appropriate.
         NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:managedObjectContext];
         [fetchRequest setEntity:entity];
         
         // Edit the sort key as appropriate.
         NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
         NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
         
         [fetchRequest setSortDescriptors:sortDescriptors];
         
         // Edit the section name key path and cache name if appropriate.
         // nil for section name key path means "no sections".
         NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
         aFetchedResultsController.delegate = self;
         self.fetchedResultsController = aFetchedResultsController;
         
         [aFetchedResultsController release];
         [fetchRequest release];
         [sortDescriptor release];
         [sortDescriptors release];
         
         */
    }
	
    
}

@end
