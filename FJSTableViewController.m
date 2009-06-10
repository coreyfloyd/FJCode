//
//  FJSTableViewControler.m
//  HSS
//
//  Created by Corey Floyd on 5/8/09.
//  Copyright 2009 Advanced Medical Data Solutions. All rights reserved.
//

#import "FJSTableViewController.h"
#import "FJSTableViewCellController.h"


@implementation FJSTableViewController

static NSString *cellControllerKey = @"cellController";
static NSString *cellDataKey = @"cellData";

@synthesize cellDataAndControllerPairsBySection;
@synthesize tableViewCellControllerNIB;

#pragma mark -
#pragma mark Data

- (void)constructData{
	self.cellDataAndControllerPairsBySection = [NSArray arrayWithObject:[NSArray array]];
}

//
// clearTableGroups
//
// Releases the table group data (it will be recreated when next needed)
//
- (void)clearData{
    self.cellDataAndControllerPairsBySection = nil;
    
}

//
// updateAndReload
//
// Performs all work needed to refresh the data and the associated display
//
- (void)updateAndReload{
	[self clearData];
	[self constructData];
	[self.tableView reloadData];
}


- (NSMutableArray *)arrayOfdictionarysWithArrayOfDataArrays:(NSArray*)data Keys:(NSArray*)keys{
    
    NSMutableArray *theArray = [[NSMutableArray alloc] init];
    NSDictionary *dataAsDictionary;
    NSMutableDictionary *dataAndCellControllerDictionary;
    
    for(NSArray *item in data){
        
        if([item count]==[keys count]){
            
            dataAsDictionary = [[NSDictionary alloc] initWithObjects:item forKeys:keys];
            dataAndCellControllerDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dataAsDictionary, cellDataKey, nil];
            [theArray addObject:dataAndCellControllerDictionary];
            [dataAsDictionary release];
            [dataAndCellControllerDictionary release];
        }
    }
    
    return [theArray autorelease];
}



- (FJSTableViewCellController*)newCellControllerFromNIB{
    
    FJSTableViewCellController *cellController = [[FJSTableViewCellController alloc] init];
    [[NSBundle mainBundle] loadNibNamed:tableViewCellControllerNIB owner:cellController options:nil];
    
    return cellController;
    
}

- (FJSTableViewCellController*)newCellController{
    
    FJSTableViewCellController *cellController = [[FJSTableViewCellController alloc] init];
    
    return cellController;
    
}

#pragma mark -
#pragma mark UITableViewController



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!cellDataAndControllerPairsBySection){
		[self constructData];
	}
    
    return [cellDataAndControllerPairsBySection count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (!cellDataAndControllerPairsBySection){
		[self constructData];
	}
	
	return [[cellDataAndControllerPairsBySection objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!cellDataAndControllerPairsBySection){
		[self constructData];
	}
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    FJSTableViewCellController *cellController=nil;
    
    if (cell != nil) {
            
        cellController = [[[self.cellDataAndControllerPairsBySection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:cellControllerKey];
        
        if(!cellController){
            cellController = [[self newCellController] autorelease];
            
            [[[cellDataAndControllerPairsBySection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] 
             setObject:cellController forKey:cellControllerKey];
        }
        
         cellController.cell = cell;
        [cellController attachOutletsToCell];
        
    } else{
        
        cellController = [[self newCellControllerFromNIB] autorelease];
        [cellController setUpCell];
        cell = cellController.cell;
        [[[cellDataAndControllerPairsBySection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] setObject:cellController forKey:cellControllerKey];
        
    }
    
    cellController.data = [[[self.cellDataAndControllerPairsBySection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:cellDataKey];
    [cellController refreshCell];

    
    return cell;
    
}


- (NSIndexPath *)indexPathForCellController:(id)cellController{
    
    UITableViewCell *theCell = [cellController cell];
    
    return [self.tableView indexPathForCell:theCell];

}

- (void)updateVisableCells{
    /*
     To display the current time, redisplay the time labels.
     Don't reload the table view's data as this is unnecessarily expensive -- it recalculates the number of cells and the height of each item to determine the total height of the view etc.  The external dimensions of the cells haven't changed, just their contents.
     */
    FJSTableViewCellController *cellController; 
    
    NSArray *visibleCellIndexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visibleCellIndexPaths) {
        
        cellController = [[[cellDataAndControllerPairsBySection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:cellControllerKey];
        [cellController setData:[[[self.cellDataAndControllerPairsBySection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:cellDataKey]];
        
    }
}



#pragma mark -
#pragma mark UIViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@"cellDataAndControllerPairsBySection" options:0 context:@"dataChanged"];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change
                       context:(void *)context {
    if([keyPath isEqualToString:@"cellDataAndControllerPairsBySection"]) {
        
        [self.tableView reloadData];
    }
}


- (void)dealloc {
    
    [cellDataAndControllerPairsBySection release];
    [tableViewCellControllerNIB release];
    [super dealloc];
}


@end

