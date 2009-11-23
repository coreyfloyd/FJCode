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


+ (UIBarButtonItem*)itemWithView:(UIView*)aView{
    
    
    return [[[UIBarButtonItem alloc] initWithCustomView:aView] autorelease];
    
}

@end
