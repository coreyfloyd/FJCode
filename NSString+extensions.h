//
//  NSString+extensions.h
//  CMN2
//
//  Created by Corey Floyd on 4/27/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (exstensions) 

+ (NSString*)stringWithInt:(int)anInteger;
+ (NSString*)stringWithFloat:(float)aFloat decimalPlaces:(int)decimalPlaces;


- (BOOL)doesContainString:(NSString *)aString;
- (NSRange)fullRange;
- (NSString*)stringByDeletingLastCharacter;
- (BOOL)isEmpty;


@end
