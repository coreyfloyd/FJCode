//
//  FJSCellDataSource.m
//  FJSCode
//
//  Created by Corey Floyd on 6/5/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSCellDataSource.h"

@implementation FJSCellDataSource

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

- (NSArray*)allKeys{
    
    return [data allKeys];
    
}

#pragma mark -
#pragma mark NSObject

- (id)initWithData:(NSDictionary*)someData{
    
    if(self = [super init]){
        
        data = [someData retain];
        
    }
    return self;
}

- (void)dealloc{
    
    //[self removeObserver:self forKeyPath:@"data"];
    [data release];
    [super dealloc];
}


@end
