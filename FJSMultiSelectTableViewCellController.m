//
//  FJSMultiSelectTableViewCellController.m
//  HSS
//
//  Created by Corey Floyd on 5/8/09.
//  Copyright 2009 Advanced Medical Data Solutions. All rights reserved.
//

#import "FJSMultiSelectTableViewCellController.h"


@implementation FJSMultiSelectTableViewCellController

static NSInteger indicatorTag = 54321;
static NSInteger editingHorizontalOffset = 35;

@synthesize selected;
@synthesize customEditingViewEnabled;

- (void)setUpCell{
        
    UIImageView *indicator = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NotSelected.png"]] autorelease];
    
    const NSInteger IMAGE_SIZE = 30;
    const NSInteger SIDE_PADDING = 5;
    
    indicator.tag = indicatorTag;
    CGRect frame = CGRectMake(-editingHorizontalOffset + SIDE_PADDING, (0.5 * 75) - (0.5 * IMAGE_SIZE), IMAGE_SIZE, IMAGE_SIZE);
    
    indicator.frame = frame;
    [cell.contentView addSubview:indicator];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[[UIView alloc] init] autorelease];
    
}


- (void)refreshCell{
    
    UIImageView *indicator = (UIImageView *)[cell.contentView viewWithTag:indicatorTag];
    
    if (selected) {
        indicator.image = [UIImage imageNamed:@"IsSelected.png"];
        cell.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else {
        indicator.image = [UIImage imageNamed:@"NotSelected.png"];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
		
	}
}

- (void)cellTouched{
    
    selected = !selected;
    
    [self refreshCell];
}

- (void)dealloc{
    
    
    [super dealloc];
}



@end
