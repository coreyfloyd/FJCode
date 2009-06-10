//
//  FJSMultiSelectTableViewController.h
//  HSS
//
//  Created by Corey Floyd on 5/8/09.
//  Copyright 2009 Advanced Medical Data Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJSTableViewController.h"

@class FJSMultiSelectTableViewCellController;


@interface FJSMultiSelectTableViewController : FJSTableViewController {
    
    UIToolbar *actionToolbar;
	UIBarButtonItem *actionButton;
    NSString *actionButtonTitle;
    
}

@property(nonatomic,retain)NSString *actionButtonTitle;

//overide to perform an action on the selected items
//default does nothing
- (void)performActionWithSelectedCellControllersAtIndexes:(NSArray*)indexes;

- (void)edit:(id)sender;
- (void)cancel:(id)sender;
- (void)showActionToolbar:(BOOL)show;
- (void)updateSelectionCount;
- (void)action:(id)sender;

@end
