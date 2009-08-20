//
//  IFGenericTableViewController.h
//  Thunderbird
//
//	Created by Craig Hockenberry on 1/29/09.
//	Copyright 2009 The Iconfactory. All rights reserved.
//
//  Based on work created by Matt Gallagher on 27/12/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//	For more information: http://cocoawithlove.com/2008/12/heterogeneous-cells-in.html
//

#import <UIKit/UIKit.h>
#import"FJSGenericTableViewDataSource.h"

@interface FJSGenericTableViewController : UITableViewController
{
	NSArray *tableGroups;

	NSArray *tableHeaders;
	NSArray *tableFooters;

	NSObject<FJSGenericTableViewDataSource> *model;
}
@property (nonatomic, retain)NSObject<FJSGenericTableViewDataSource> *model;

- (void)updateAndReload;

@end
