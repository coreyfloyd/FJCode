//
//  NSString+extensions.h
//  CMN2
//
//  Created by Corey Floyd on 4/27/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (parsing) 

-(NSArray *)csvRows;

@end

@interface NSString (exstensions) 


- (BOOL)doesContainString:(NSString *)aString;
- (NSRange)fullRange;
- (NSString*)stringByDeletingLastCharacter;

//also tests if string is a single space
- (BOOL)isEmpty;


@end

@interface NSString (NumberStuff) 

+ (NSString*)stringWithInt:(int)anInteger;
+ (NSString*)stringWithFloat:(float)aFloat decimalPlaces:(int)decimalPlaces;


- (BOOL)holdsFloatingPointValue;
- (BOOL)holdsFloatingPointValueForLocale:(NSLocale *)locale;
- (BOOL)holdsIntegerValue;

@end
