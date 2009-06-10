//
//  FJSMultiSelectTableViewCell.m
//  HSS
//
//  Created by Corey Floyd on 5/8/09.
//  Copyright 2009 Advanced Medical Data Solutions. All rights reserved.
//

#import "FJSMultiSelectTableViewCell.h"
#import "FJSMultiSelectTableViewCellController.h"


@implementation FJSMultiSelectTableViewCell

static NSInteger editingHorizontalOffset = 35;

@synthesize customEditingViewEnabled;


//
// setEditing:animated:
//
// Refreshed the layout when editing is enabled/disabled.
//
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    
    customEditingViewEnabled = [(FJSMultiSelectTableViewCellController*)[self superview] customEditingViewEnabled];
    
    if(customEditingViewEnabled)
        [self setNeedsLayout];
    else
        [super setEditing:editing animated:animated];
}

//
// layoutSubviews
//
// When editing, displace everything rightwards to allow space for the
// selection indicator.
//
- (void)layoutSubviews
{
    
    if(customEditingViewEnabled){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        [super layoutSubviews];
        
        if (((UITableView *)self.superview).isEditing)
        {
            CGRect contentFrame = self.contentView.frame;
            contentFrame.origin.x = editingHorizontalOffset;
            self.contentView.frame = contentFrame;
        }
        else
        {
            CGRect contentFrame = self.contentView.frame;
            contentFrame.origin.x = 0;
            self.contentView.frame = contentFrame;
        }
        
        [UIView commitAnimations];
    } else{
        
        [super layoutSubviews];
    }

	
}


@end
