//
//  NSString+extensions.m
//  CMN2
//
//  Created by Corey Floyd on 4/27/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "NSString+extensions.h"

@implementation NSString (parsing) 

-(NSArray *)csvRows {
    NSMutableArray *rows = [NSMutableArray array];
    
    // Get newline character set
    NSMutableCharacterSet *newlineCharacterSet = (id)[NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    [newlineCharacterSet formIntersectionWithCharacterSet:[[NSCharacterSet whitespaceCharacterSet] invertedSet]];
    
    // Characters that are important to the parser
    NSMutableCharacterSet *importantCharactersSet = (id)[NSMutableCharacterSet characterSetWithCharactersInString:@",\""];
    [importantCharactersSet formUnionWithCharacterSet:newlineCharacterSet];
    
    // Create scanner, and scan string
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    while ( ![scanner isAtEnd] ) {        
        BOOL insideQuotes = NO;
        BOOL finishedRow = NO;
        NSMutableArray *columns = [NSMutableArray arrayWithCapacity:10];
        NSMutableString *currentColumn = [NSMutableString string];
        while ( !finishedRow ) {
            NSString *tempString;
            if ( [scanner scanUpToCharactersFromSet:importantCharactersSet intoString:&tempString] ) {
                [currentColumn appendString:tempString];
            }
            
            if ( [scanner isAtEnd] ) {
                if ( ![currentColumn isEqualToString:@""] ) [columns addObject:currentColumn];
                finishedRow = YES;
            }
            else if ( [scanner scanCharactersFromSet:newlineCharacterSet intoString:&tempString] ) {
                if ( insideQuotes ) {
                    // Add line break to column text
                    [currentColumn appendString:tempString];
                }
                else {
                    // End of row
                    if ( ![currentColumn isEqualToString:@""] ) [columns addObject:currentColumn];
                    finishedRow = YES;
                }
            }
            else if ( [scanner scanString:@"\"" intoString:NULL] ) {
                if ( insideQuotes && [scanner scanString:@"\"" intoString:NULL] ) {
                    // Replace double quotes with a single quote in the column string.
                    [currentColumn appendString:@"\""]; 
                }
                else {
                    // Start or end of a quoted string.
                    insideQuotes = !insideQuotes;
                }
            }
            else if ( [scanner scanString:@"," intoString:NULL] ) {  
                if ( insideQuotes ) {
                    [currentColumn appendString:@","];
                }
                else {
                    // This is a column separating comma
                    [columns addObject:currentColumn];
                    currentColumn = [NSMutableString string];
                    [scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:NULL];
                }
            }
        }
        if ( [columns count] > 0 ) [rows addObject:columns];
    }
    
    return rows;
}

@end


@implementation NSString (exstensions) 



- (BOOL)isEmpty{
    
    BOOL answer = NO;
    
    if([self length]==0)
        answer = YES;
    else if([self isEqualToString:@" "])
        answer = YES;
    
    return answer;
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


@implementation NSString(NumberStuff)


+ (NSString*)stringWithInt:(int)anInteger{
    
    return [NSString stringWithFormat:@"%i", anInteger];
    
}

+ (NSString*)stringWithFloat:(float)aFloat decimalPlaces:(int)decimalPlaces{
    
    NSMutableString *formatString = [NSMutableString stringWithString:@"%."];
    [formatString appendString:[NSString stringWithInt:decimalPlaces]];
    [formatString appendString:@"f"];
    return [NSString stringWithFormat:formatString, aFloat];
    
}



- (BOOL)holdsFloatingPointValue
{
    return [self holdsFloatingPointValueForLocale:[NSLocale currentLocale]];
}
- (BOOL)holdsFloatingPointValueForLocale:(NSLocale *)locale
{
    NSString *currencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    NSString *decimalSeparator = [locale objectForKey:NSLocaleDecimalSeparator];
    NSString *groupingSeparator = [locale objectForKey:NSLocaleGroupingSeparator];
    
    
    // Must be at least one character
    if ([self length] == 0)
        return NO;
    NSString *compare = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Strip out grouping separators
    compare = [compare stringByReplacingOccurrencesOfString:groupingSeparator withString:@""];
    
    // We'll allow a single dollar sign in the mix
    if ([compare hasPrefix:currencySymbol])
    {   
        compare = [compare substringFromIndex:1];
        // could be spaces between dollar sign and first digit
        compare = [compare stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    NSUInteger numberOfSeparators = 0;
    
    NSCharacterSet *validCharacters = [NSCharacterSet decimalDigitCharacterSet];
    for (NSUInteger i = 0; i < [compare length]; i++) 
    {
        unichar oneChar = [compare characterAtIndex:i];
        if (oneChar == [decimalSeparator characterAtIndex:0])
            numberOfSeparators++;
        else if (![validCharacters characterIsMember:oneChar])
            return NO;
    }
    return (numberOfSeparators == 1);
    
}
- (BOOL)holdsIntegerValue
{
    if ([self length] == 0)
        return NO;
    
    NSString *compare = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSCharacterSet *validCharacters = [NSCharacterSet decimalDigitCharacterSet];
    for (NSUInteger i = 0; i < [compare length]; i++) 
    {
        unichar oneChar = [compare characterAtIndex:i];
        if (![validCharacters characterIsMember:oneChar])
            return NO;
    }
    return YES;
}
@end
