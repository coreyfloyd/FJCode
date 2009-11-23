//
//  FJSTextViewCellController.m
//  FJSCode
//
//  Created by Corey Floyd on 11/10/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "FJSTextViewCellController.h"
#import	"IFControlTableViewCell.h"



@implementation FJSTextViewCellController

@synthesize message;



- (void) dealloc
{
    self.message = nil;
    [label release];
	[key release];
	[model release];
    [super dealloc];
}


- (id)initWithLabel:(NSString *)newLabel atKey:(NSString *)newKey inModel:(id<IFCellModel>)newModel invocation:(NSInvocation*)invocation{
    
    self = [super init];
	if (self != nil)
	{
		label = [newLabel retain];
		key = [newKey retain];
		model = [newModel retain];
        self.message = invocation;
        
    }
	return self;
    
}


//
// tableView:cellForRowAtIndexPath:
//
// Returns the cell for a given indexPath.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"TextViewCell";
	
    IFControlTableViewCell *newCell = (IFControlTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (newCell == nil)
	{
        newCell = [[[IFControlTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        
    }
	
    newCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
	newCell.textLabel.text = label;
	newCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    newCell.detailTextLabel.text = [model objectForKey:key];

		
    return newCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [message invoke];
}


@end
