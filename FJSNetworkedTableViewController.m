//
//  FJSNetworkedTableViewController.m
//  FJSCode
//
//  Created by Corey Floyd on 5/27/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSNetworkedTableViewController.h"


@implementation FJSNetworkedTableViewController


- (void)didReceiveNewData:(id<FJSCellDataSource>)newData{
    
    [self updateAndReload];
    
}

- (void)noNewDataAvailable{
    
    //Data is up to date, possibly notify user?
    
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
