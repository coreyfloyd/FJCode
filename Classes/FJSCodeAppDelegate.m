//
//  FJSCodeAppDelegate.m
//  FJSCode
//
//  Created by Corey Floyd on 5/21/09.
//  Copyright Flying Jalapeno Software 2009. All rights reserved.
//

#import "FJSCodeAppDelegate.h"

@implementation FJSCodeAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
