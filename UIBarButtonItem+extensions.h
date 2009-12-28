//
//  UIBarButtonItem+extensions.h
//  BuyingGuide
//
//  Created by Corey Floyd on 11/16/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIBarButtonItem(extensions)

+ (UIBarButtonItem*)flexibleSpaceItem;
+ (UIBarButtonItem*)fixedSpaceItemOfSize:(float)size;
+ (UIBarButtonItem*)itemWithView:(UIView*)aView;
+ (UIBarButtonItem*)itemWithImage:(UIImage*)anImage style:(UIBarButtonItemStyle)aStyle target:(id)aTarget action:(SEL)anAction;
+ (UIBarButtonItem*)itemWithTitle:(NSString*)aTitle style:(UIBarButtonItemStyle)aStyle target:(id)aTarget action:(SEL)anAction;
+ (UIBarButtonItem*)systemItem:(UIBarButtonSystemItem)systemItem target:(id)aTarget action:(SEL)anAction;
+ (NSArray*)centeredToolButtonsItems:(NSArray*)toolBarItems;

@end
