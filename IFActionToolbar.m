//
//  IFActionToolbar.m
//  Thunderbird
//
//  Created by Craig Hockenberry on 2/16/09.
//  Copyright 2009 The Iconfactory. All rights reserved.
//

#import "IFActionToolbar.h"

#if TARGET_OS_IPHONE
	#import <objc/runtime.h>
	#import <objc/message.h>
#else
	#import <objc/objc-runtime.h>
#endif

@implementation IFActionToolbarActionItem

@synthesize target;
@synthesize action;
@synthesize title;

- (id)initWithTitle:(NSString *)newTitle target:(id)newTarget action:(SEL)newAction
{
	if (self = [super init])
	{
		self.title = newTitle;
		
		self.target = newTarget;
		self.action = newAction;
	}
	return self;
}

- (void)dealloc
{
	self.title = nil;
	
    [super dealloc];
}

@end


@implementation IFActionToolbar

@synthesize actionToolbarDelegate;

- (void)setup
{
	_actions = [[NSMutableDictionary alloc] init];

	[self update];
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self setup];
	}
	return self;
}

- (void)awakeFromNib
{
	[self setup];

	[super awakeFromNib];
}

- (void)dealloc
{
	[_actions release];
	_actions = nil;
	
	[super dealloc];
}

- (void)attachActionItems:(NSArray *)actionItems toItem:(UIBarButtonItem *)item
{
	NSUInteger index = [self.items indexOfObject:item];
	if (index != NSNotFound)
	{
		// NOTE: the item can't be used as a key since it does not adopt the NSCopying protocol, so use its hash
		[_actions setObject:actionItems forKey:[NSNumber numberWithInt:[item hash]]];
		
		[item setTarget:self];
		[item setAction:@selector(showActionSheet:)];
	}
}

- (void)update
{
	for (UIBarButtonItem *item in self.items)
	{
		objc_msgSend(actionToolbarDelegate, @selector(enableActionToolbarItem:), item);
	
		if ([actionToolbarDelegate respondsToSelector:@selector(enableActionToolbarItem:)])
		{
			// Thank you, Greg Parker: http://www.cocoabuilder.com/archive/message/cocoa/2006/2/12/156604
			BOOL result = ((BOOL (*)(id, SEL, id))objc_msgSend)(actionToolbarDelegate, @selector(enableActionToolbarItem:), item);
			[item setEnabled:result];
		}
		
		UIImage *image = nil;
		if ([actionToolbarDelegate respondsToSelector:@selector(actionToolbarItemImage:)])
		{
			image = [actionToolbarDelegate performSelector:@selector(actionToolbarItemImage:) withObject:item];
			if (image)
			{
				[item setImage:image];
			}
		}
	}
}

#pragma mark Actions

- (void)showActionSheet:(id)sender
{
	NSUInteger index = [self.items indexOfObject:sender];
	if (index != NSNotFound)
	{
		NSArray *actionItems = [_actions objectForKey:[NSNumber numberWithInt:[sender hash]]];
		
		NSMutableArray *buttonTitles = [NSMutableArray arrayWithCapacity:5];

		NSUInteger cancelButtonIndex = NSNotFound;
		NSUInteger destructiveButtonIndex = NSNotFound;
		
		NSUInteger buttonIndex = 0;
		for (IFActionToolbarActionItem *actionItem in actionItems)
		{
			if ([actionToolbarDelegate respondsToSelector:@selector(showActionToolbarActionItem:)])
			{
				// thank you Greg Parker
				BOOL result = ((BOOL (*)(id, SEL, id))objc_msgSend)(actionToolbarDelegate, @selector(showActionToolbarActionItem:), actionItem);
				if (result)
				{
					[buttonTitles addObject:[actionItem title]];

					if ([actionToolbarDelegate respondsToSelector:@selector(isCancelActionToolbarActionItem:)])
					{
						BOOL result = ((BOOL (*)(id, SEL, id))objc_msgSend)(actionToolbarDelegate, @selector(isCancelActionToolbarActionItem:), actionItem);
						if (result)
						{
							cancelButtonIndex = buttonIndex;
						}
					}
					
					if ([actionToolbarDelegate respondsToSelector:@selector(isDestructiveActionToolbarActionItem:)])
					{
						BOOL result = ((BOOL (*)(id, SEL, id))objc_msgSend)(actionToolbarDelegate, @selector(isDestructiveActionToolbarActionItem:), actionItem);
						if (result)
						{
							destructiveButtonIndex = buttonIndex;
						}
					}
					
					buttonIndex += 1;
				}
			}
		}

		NSString *title = nil;
		if ([actionToolbarDelegate respondsToSelector:@selector(actionToolbarItemTitle:)])
		{
			title = [actionToolbarDelegate performSelector:@selector(actionToolbarItemTitle:) withObject:sender];
		}
		
		UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
		[actionSheet setDelegate:self];
		[actionSheet setTag:index]; // save the index of the UIBarButtonItem that owns the action sheet

		if (title)
		{
			[actionSheet setTitle:title];
		}
		for (NSString *buttonTitle in buttonTitles)
		{
			[actionSheet addButtonWithTitle:buttonTitle];
		}
		if (cancelButtonIndex != NSNotFound)
		{
			[actionSheet setCancelButtonIndex:cancelButtonIndex];
		}
		if (destructiveButtonIndex != NSNotFound)
		{
			[actionSheet setDestructiveButtonIndex:destructiveButtonIndex];
		}
		
		// NOTE: this doesn't work correctly if the toolbar is not at the bottom of the application frame:
		//   [actionSheet showFromToolbar:self];
		// but this does:
		[actionSheet showInView:[self window]];
		[actionSheet release];
	}
}

#pragma mark UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSInteger index = [actionSheet tag]; // retrieve the index of the UIBarButtonItem that owns the action sheet
	
	// NOTE: It seems like a bit of a hack to determine the correct target and action using the title
	// of the button, but it's all we've got. Should work fine since the title won't change between the time it's shown
	// and this delegate method is called (even if it's localized.)
	NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	
	if (index >= 0 && index < [self.items count])
	{
		UIBarButtonItem *item = [self.items objectAtIndex:index];
		if (item)
		{
			NSArray *actionItems = [_actions objectForKey:[NSNumber numberWithInt:[item hash]]];
		
			for (IFActionToolbarActionItem *actionItem in actionItems)
			{
				if ([[actionItem title] isEqualToString:buttonTitle])
				{
					if ([actionItem target] && [actionItem action])
					{
						[[actionItem target] performSelector:[actionItem action] withObject:self];
					}
				}
			}
		}
	}
}

@end
