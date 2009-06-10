//
//  FJSTableViewControler.h
//  HSS
//
//  Created by Corey Floyd on 5/8/09.
//  Copyright 2009 Advanced Medical Data Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJSTableViewCellController;

@protocol FJSTableViewController

- (FJSTableViewCellController*)newCellController;

@end





@interface FJSTableViewController : UITableViewController {
    
    NSArray *cellDataAndControllerPairsBySection;
    NSString *tableViewCellControllerNIB;

}
@property(nonatomic,retain)NSArray *cellDataAndControllerPairsBySection;
@property(nonatomic,retain)NSString *tableViewCellControllerNIB;


- (NSMutableArray *)arrayOfdictionarysWithArrayOfDataArrays:(NSArray*)data Keys:(NSArray*)keys;
- (void)updateVisableCells;
- (NSIndexPath *)indexPathForCellController:(id)cellController;


- (void)constructData;
//override this method to subclass and return an instance of you FJSTVCC subclass 
- (FJSTableViewCellController*)newCellControllerFromNIB;
- (FJSTableViewCellController*)newCellController;


@end
