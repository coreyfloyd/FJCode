//
//  FJSNetworkedCellDataSource.m
//  FJSCode
//
//  Created by Corey Floyd on 5/27/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//


#import "FJSNetworkedCellDataSource.h"

@implementation FJSNetworkedCellDataSource

@synthesize data;
@synthesize delegate;
@synthesize timeOfLastUpdate;

#pragma mark -
#pragma mark FJSNetworkedCellDataSource

- (void)updateData{
        
    self.data = nil;
        
}

#pragma mark -
#pragma mark FJSCellDataSource

- (void)setObject:(id)value forKey:(NSString *)key{
    [data setObject:value forKey:key];
    
}
- (id)objectForKey:(NSString *)key{
    return [data objectForKey:key];
}

- (int)count{
    return [data count];
    
}
- (void)removeObjectForKey:(NSString *)key{
    [data removeObjectForKey:key];
}


#pragma mark -
#pragma mark NSObject

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    //NSLog(keyPath);
    
    if([keyPath isEqualToString:@"data"]){
        
        [delegate didReceiveNewData:self];
        
    }
}

- (id)init{
    
    if(self = [super init]){
        
        [self addObserver:self forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    
    return self;
}

- (void)dealloc{
    
    [self removeObserver:self forKeyPath:@"data"];
    [data release];
    [super dealloc];
}


@end
