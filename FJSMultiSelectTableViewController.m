//
//  FJSMultiSelectTableViewController.m
//  HSS
//
//  Created by Corey Floyd on 5/8/09.
//  Copyright 2009 Advanced Medical Data Solutions. All rights reserved.
//

#import "FJSMultiSelectTableViewController.h"
#import "FJSMultiSelectTableViewCellController.h"



@implementation FJSMultiSelectTableViewController

static NSString *cellControllerKey = @"cellController";
static NSString *cellDataKey = @"cellData";

@synthesize actionButtonTitle;

- (void)edit:(id)sender
{
	[self showActionToolbar:YES];
	
	UIBarButtonItem *cancelButton =
    [[[UIBarButtonItem alloc]
      initWithTitle:@"Cancel"
      style:UIBarButtonItemStyleDone
      target:self
      action:@selector(cancel:)]
     autorelease];
	[self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
	[self updateSelectionCount];
	
	[self.tableView setEditing:YES animated:YES];
}

//
// cancel:
//
// Remove the editing
//
- (void)cancel:(id)sender{
	[self showActionToolbar:NO];
    
	UIBarButtonItem *editButton =
    [[[UIBarButtonItem alloc]
      initWithTitle:@"Edit"
      style:UIBarButtonItemStylePlain
      target:self
      action:@selector(edit:)]
     autorelease];
	[self.navigationItem setRightBarButtonItem:editButton animated:NO];
    
    for(NSArray *section in cellDataAndControllerPairsBySection){
        
        for(NSDictionary *dataControllerPair in section){
            
            FJSMultiSelectTableViewCellController *cellController = [dataControllerPair objectForKey:cellControllerKey];
            if(cellController.selected){
                [cellController cellTouched];
        
            }
        }
    }
    
	[self.tableView setEditing:NO animated:YES];
}

- (void)showActionToolbar:(BOOL)show{
	CGRect toolbarFrame = actionToolbar.frame;
	CGRect tableViewFrame = self.tableView.frame;
	if (show)
	{
		toolbarFrame.origin.y = actionToolbar.superview.frame.size.height - toolbarFrame.size.height;
		tableViewFrame.size.height -= toolbarFrame.size.height;
	}
	else
	{
		toolbarFrame.origin.y = actionToolbar.superview.frame.size.height;
		tableViewFrame.size.height += toolbarFrame.size.height;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
	actionToolbar.frame = toolbarFrame;
	self.tableView.frame = tableViewFrame;
	
	[UIView commitAnimations];
}

- (void)updateSelectionCount{
	NSInteger count = 0;
	
    
    for(NSArray *section in cellDataAndControllerPairsBySection){
        
        for(NSDictionary *dataControllerPair in section){
            
            FJSMultiSelectTableViewCellController *cellController = [dataControllerPair objectForKey:cellControllerKey];
            if ([cellController selected]){
                count++;
            }
        }
    }
        
	actionButton.title = [NSString stringWithFormat:@"%@ (%ld)", actionButtonTitle, count];
	actionButton.enabled = (count != 0);
}

- (void)action:(id)sender{

    NSMutableArray *selectedControllerIndexes = [NSMutableArray array];

    for(NSArray *section in cellDataAndControllerPairsBySection){
        
        for(NSDictionary *dataControllerPair in section){
            
            FJSMultiSelectTableViewCellController *cellController = [dataControllerPair objectForKey:cellControllerKey];
            if(cellController.selected){
                [cellController cellTouched];
                [selectedControllerIndexes addObject:[self indexPathForCellController:cellController]];
            }
        }
    }
    
    [self performActionWithSelectedCellControllersAtIndexes:selectedControllerIndexes];
    [self updateSelectionCount];
}

- (void)performActionWithSelectedCellControllersAtIndexes:(NSArray*)indexes{
    
    //implement to perform an action on selected cells
    
    
}

#pragma mark -
#pragma mark FJSTableViewController

- (FJSTableViewCellController*)newCellControllerFromNIB{
    
    FJSMultiSelectTableViewCellController *cellController = [[FJSMultiSelectTableViewCellController alloc] init];
    [[NSBundle mainBundle] loadNibNamed:tableViewCellControllerNIB owner:cellController options:nil];
    
    return cellController;
    
}

- (FJSTableViewCellController*)newCellController{
    
    FJSMultiSelectTableViewCellController *cellController = [[FJSMultiSelectTableViewCellController alloc] init];
    
    return cellController;
    
}

#pragma mark -
#pragma mark UITableViewController


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    [self updateSelectionCount];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //if (tableView.isEditing){
        
        //UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        FJSMultiSelectTableViewCellController *cellController 
                            = (FJSMultiSelectTableViewCellController*)[[[cellDataAndControllerPairsBySection objectAtIndex:indexPath.section] 
                                                                                  objectAtIndex:indexPath.row] 
                                                                                  objectForKey:cellControllerKey];
        [cellController cellTouched];
        [self updateSelectionCount];
    //}
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleNone;
}


#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
		
	[self.tableView setAllowsSelectionDuringEditing:YES];
    
	//
	// Set the state for not editing.
	//
	//[self cancel:self];
}

//Action Tool Bar now in xib
/*
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
	actionButton = 
    [[[UIBarButtonItem alloc]
      initWithTitle:actionButtonTitle
      style:UIBarButtonItemStyleBordered
      target:self
      action:@selector(action:)]
     autorelease];
	[actionToolbar setItems:[NSArray arrayWithObject:actionButton]];
    
    
}

//
// viewDidAppear:
//
// Add the actionToolbar when this view appears
//

- (void)viewDidAppear:(BOOL)animated{
	[self.view.superview addSubview:actionToolbar];
    
}


- (void)viewWillDisappear:(BOOL)animated{
	[actionToolbar removeFromSuperview];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}



- (void)dealloc {
    
    [actionButtonTitle release];
    [actionToolbar release];
    [super dealloc];
}


@end

