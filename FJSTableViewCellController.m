//
//  FJSTableViewCellController.m
//  HSS
//
//  Created by Corey Floyd on 5/8/09.
//  Copyright 2009 Advanced Medical Data Solutions. All rights reserved.
//

#import "FJSTableViewCellController.h"

@implementation FJSTableViewCellController

@synthesize cell;
@synthesize data;
@synthesize cellContentViews;


- (void)setUpCell{
        
}

- (void)attachOutletsToCell{
    
    
}

- (void)refreshCell{
    
}


- (id)init {
    self=[super init];
    if(nil != self) {
        
        //You will have a different cell after you connect to a nib, don't do cell init here
        //
        // observing makes it so we don't have to implement the set method
        // subclass must implement:
        // observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
        // to update cell UI if not simply updating labels or if formating is needed
        
        [self addObserver:self forKeyPath:@"data" 
                  options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change
                       context:(void *)context {
    if([keyPath isEqualToString:@"data"]) {
        
        for(NSString *key in cellContentViews){
            
            [[cellContentViews objectForKey:key] setText:[data objectForKey:key]];
            
        }
        
    [cell.contentView setNeedsDisplay];
    }
}



- (void)dealloc {
    
    
    [self removeObserver:self forKeyPath:@"data"];
    [cellContentViews release];
    [data release];
    [cell release];    
    [super dealloc];
}


@end
