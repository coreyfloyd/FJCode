//
//  FJSImageScrollViewCOntroller.m
//  FJSCode
//
//  Created by Corey Floyd on 5/23/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSImageScrollViewController.h"
#import "FJSImageViewController.h"


@implementation FJSImageScrollViewController

- (void)populateControllerData{
    
    for(FJSImageViewController *controller in viewControllers){
        
        int index = [viewControllers indexOfObject:controller];
        
        [controller setImage:[data objectAtIndex:index]];
    }
}


- (void)dealloc {
    [super dealloc];
}


@end
