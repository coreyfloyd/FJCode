//
//  FJSCoreDataCellController.h
//  FJSCode
//
//  Created by Corey Floyd on 8/19/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol FJSCoreDataCellController <NSObject>

@property(nonatomic,assign)UITableViewCell *cell;
@property(nonatomic,assign)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,retain)NSIndexPath *cellIndexPath;

- (void)refreshCell;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end




@interface FJSCoreDataCellController : NSObject {

}

@end
