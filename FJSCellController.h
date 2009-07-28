//
//  IFCellController.h
//  Thunderbird
//
//  Created by Matt Gallagher on 27/12/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//

#import "FJSCellDataSource.h"

@protocol FJSCellControllerDelegate <NSObject>

@optional
-(void)cellController:(id)aCellController didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
-(void)cellController:(id)aCellController didSelectObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath;
 

@end


@protocol FJSCellController

@property(nonatomic,retain)NSDictionary *model;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@optional
//re-attach any subviews of the content view of a requed cell to the ivars of the controller
//typically this is done through the use of tags
- (void)attachOutletsToCell;



@optional

//set to recieve notifications of selections
@property(nonatomic,assign)id<FJSCellControllerDelegate> delegate;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
