//
//  IFActionToolbar.h
//  Thunderbird
//
//  Created by Craig Hockenberry on 2/16/09.
//  Copyright 2009 The Iconfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFActionToolbarActionItem : NSObject
{
	id target;
	SEL action;
	NSString *title;
}

@property(nonatomic, assign) id target;
@property(nonatomic, assign) SEL action;
@property(nonatomic, retain) NSString *title;

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end

@protocol IFActionToolbarDelegate

@optional
- (BOOL)enableActionToolbarItem:(UIBarButtonItem *)item; // enable the item in the toolbar
- (UIImage *)actionToolbarItemImage:(UIBarButtonItem *)item; // image for the item in the toolbar (if nil, there is no change)
- (NSString *)actionToolbarItemTitle:(UIBarButtonItem *)item; // the title of the action menu attached to the item in the toolbar
- (BOOL)showActionToolbarActionItem:(IFActionToolbarActionItem *)actionItem; // show the action item in the sheet
- (BOOL)isCancelActionToolbarActionItem:(IFActionToolbarActionItem *)actionItem; // the action item is a cancel button in the sheet
- (BOOL)isDestructiveActionToolbarActionItem:(IFActionToolbarActionItem *)actionItem; // the action item is a destructive button in the sheet

@end

@interface IFActionToolbar : UIToolbar <UIActionSheetDelegate>
{
	NSMutableDictionary *_actions;
	
	id actionToolbarDelegate;
}

/*
	NOTE: The verbose delegate name is used because the name "delegate" is used by UIToolbar. It's not exposed in either
	the headers or in the documentation, but it does appear in Interface Builder.
*/
@property (nonatomic, assign) IBOutlet id actionToolbarDelegate;

- (void)attachActionItems:(NSArray *)actionItems toItem:(UIBarButtonItem *)item;
- (void)update;

@end
