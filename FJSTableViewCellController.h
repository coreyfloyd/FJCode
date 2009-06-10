//
//  FJSTableViewCellController.h
//  HSS
//
//  Created by Corey Floyd on 5/8/09.
//  Copyright 2009 Advanced Medical Data Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FJSTableViewCellController

- (void)setData:(NSDictionary*)someData;
- (void)setCell:(UITableViewCell*)aCell;


@end



@interface FJSTableViewCellController : NSObject {
    
    UITableViewCell *cell;
    NSDictionary *data;
    NSDictionary *cellContentViews;

}
@property(nonatomic,retain)IBOutlet UITableViewCell *cell;
@property(nonatomic,retain)NSDictionary *data;
@property(nonatomic,retain)NSDictionary *cellContentViews;


//override these to perform setup, reattach outlets from a Controller 
//not loaded from a NIB and to update the contents of a cell if need be

- (void)setUpCell;
- (void)attachOutletsToCell;
- (void)refreshCell;


@end
