//
//  FJSLinkCellController.m
//  GenericTableViews
//
//  Created by Corey Floyd on 7/25/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSLinkCellController.h"


@implementation FJSLinkCellController

@synthesize nibFileName;

- (void) dealloc
{
    self.nibFileName = nil;
    [super dealloc];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewController *tableViewController = (UITableViewController *)tableView.dataSource;
    UIViewController *linkTableViewController; 
    
    if(nibFileName==nil)
        linkTableViewController = (UIViewController *)[[[controllerClass alloc] initWithStyle:UITableViewStyleGrouped] autorelease];

    else
        linkTableViewController = (UIViewController *)[[[controllerClass alloc] initWithNibName:nibFileName bundle:[NSBundle mainBundle]] autorelease];

	[tableViewController.navigationController pushViewController:linkTableViewController animated:YES];
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
