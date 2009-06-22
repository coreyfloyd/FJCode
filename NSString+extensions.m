//
//  NSString+extensions.m
//  CMN2
//
//  Created by Corey Floyd on 4/27/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "NSString+extensions.h"


@implementation NSString (exstensions) 


+ (NSString*)stringWithInt:(int)anInteger{
    
    return [NSString stringWithFormat:@"%i", anInteger];
    
}

+ (NSString*)stringWithFloat:(float)aFloat decimalPlaces:(int)decimalPlaces{
    
    NSMutableString *formatString = [NSMutableString stringWithString:@"%."];
    [formatString appendString:[NSString stringWithInt:decimalPlaces]];
    [formatString appendString:@"f"];
    return [NSString stringWithFormat:formatString, aFloat];

}


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

- (NSString*)stringByDeletingLastCharacter{
    
    if([self length]==0)
        return self;
    
    return [NSString stringWithString:[self substringToIndex:([self length]-1)]];
    
    
}


@end
