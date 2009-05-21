//
//  NSString+extensions.m
//  CMN2
//
//  Created by Corey Floyd on 4/27/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "NSString+extensions.h"


@implementation NSString (exstensions) 


- (BOOL)doesContainString:(NSString *)aString{
    
    BOOL answer = YES;
    
    NSRange rangeOfSubString = [self rangeOfString:aString];
    
    if(rangeOfSubString.location == NSNotFound)
        answer = NO;
    
    return answer;
    
}

- (NSRange)fullRange{
    
    return (NSMakeRange(0, [self length]));
}


@end
