//
//  DummyClass.m
//  HSS
//
//  Created by Corey Floyd on 6/5/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "DummyClass.h"


@implementation DummyClass

@synthesize dummyArray;
@synthesize dummyDictionary;


-(void)myDummyMethod{
    
    NSDictionary *localDictionary;
    
    localDictionary =  [self dummyDictionary];
    localDictionary =  [self valueForKey:@"dummyDictionary"];
    
}


-(void)myOtherDummyMethod{
    
    NSDictionary *localDictionary;
    
    [self setDummyDictionary:localDictionary];
    [self setValue:localDictionary forKey:@"dummyDictionary"];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context{
        
    if([keyPath isEqualToString:@"dummyDictionary"]){
        
        //do amazing things
        
    }

}    


- (id)init{
    
    if(self = [super init]){
        
        [self addObserver:self 
               forKeyPath:@"dummyDictionary" 
                  options:0 
                  context:@"dictionaryChanged"];
        
    }
    return self;
}



- (void)dealloc{
    
    [dummyArray release];
    [dummyDictionary release];
    [super dealloc];
}




@end
