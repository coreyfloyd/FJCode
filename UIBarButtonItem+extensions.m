//
//  UIBarButtonItem+extensions.m
//  BuyingGuide
//
//  Created by Corey Floyd on 11/16/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "UIBarButtonItem+extensions.h"


@implementation UIBarButtonItem(extensions)

+ (UIBarButtonItem*)flexibleSpaceItem{
    
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                          target:nil 
                                                          action:nil] autorelease];
    
    
}

+ (UIBarButtonItem*)fixedSpaceItemOfSize:(float)size{
    
    
    UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil 
                                                                           action:nil] autorelease];
    item.width = size;
    
    return item;
    
    
}


+ (UIBarButtonItem*)itemWithView:(UIView*)aView{
    
    return [[[UIBarButtonItem alloc] initWithCustomView:aView] autorelease];
    
}

+ (UIBarButtonItem*)itemWithImage:(UIImage*)anImage style:(UIBarButtonItemStyle)aStyle target:(id)aTarget action:(SEL)anAction{
    
    UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithTitle:@"" style:aStyle target:aTarget action:anAction] autorelease];
    item.image = anImage;
    return item;
    
}

+ (UIBarButtonItem*)itemWithTitle:(NSString*)aTitle style:(UIBarButtonItemStyle)aStyle target:(id)aTarget action:(SEL)anAction {
    
    return [[[UIBarButtonItem alloc] initWithTitle:aTitle style:aStyle target:aTarget action:anAction] autorelease];

}

+ (UIBarButtonItem*)systemItem:(UIBarButtonSystemItem)systemItem target:(id)aTarget action:(SEL)anAction{
    
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:aTarget action:anAction] autorelease];
    
}

+ (NSArray*)centeredToolButtonsItems:(NSArray*)toolBarItems{
    
    NSMutableArray* items = [NSMutableArray array];
    [items addObject:[UIBarButtonItem flexibleSpaceItem]];
    [items addObjectsFromArray:toolBarItems];
    [items addObject:[UIBarButtonItem flexibleSpaceItem]];
    
    return items;
}

@end
