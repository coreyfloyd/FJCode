//
//  FJSCoreDataCellController.h
//  FJSCode
//
//  Created by Corey Floyd on 8/19/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#ifdef TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol FJSCoreDataCellController <NSObject>

//set in cellForRowAtIndexPath:
@property(nonatomic,assign)UITableViewCell *cell;
@property(nonatomic,retain)NSIndexPath *cellIndexPath;

//will be set by the TableViewController, use to fetch the cells content in refreshCell
@property(nonatomic,assign)NSFetchedResultsController *fetchedResultsController;

//update the conents of the cell
//check to see if all properties are set before performing
- (void)refreshCell;

//initialize cell and call refreshCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end



@interface FJSCoreDataCellController : NSObject {

}

@end

#endif
