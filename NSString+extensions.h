//
//  NSString+extensions.h
//  CMN2
//
//  Created by Corey Floyd on 4/27/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <Foundation/Foundation.h>


/* 
 * Short hand NSLocalizedString, doesn't need 2 parameters
 */
#define LocalizedString(s) NSLocalizedString(s,s)

/*
 * LocalizedString with an additionl parameter for formatting
 */
#define LocalizedStringWithFormat(s,...) [NSString stringWithFormat:NSLocalizedString(s,s),##__VA_ARGS__]

enum {
	NSTruncateStringPositionStart=0,
	NSTruncateStringPositionMiddle,
	NSTruncateStringPositionEnd
}; typedef int NSTruncateStringPosition;




@interface NSString (comparison) 

- (NSComparisonResult)localizedCaseInsensitiveArticleStrippingCompare:(NSString*)aString;

@end



@interface NSString (parsing) 

-(NSArray *)csvRows;

@end

@interface NSString (exstensions) 


- (BOOL)doesContainString:(NSString *)aString;
/*
 * Checks to see if the string contains the given string, case insenstive
 */
- (BOOL)containsString:(NSString*)string;

/*
 * Checks to see if the string contains the given string while allowing you to define the compare options
 */
- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options;


- (NSRange)fullRange;
- (NSString*)stringByDeletingLastCharacter;
- (NSString*)stringByRemovingArticlePrefixes;

//also tests if string is a single space
- (BOOL)isEmpty;

- (NSString*)md5;

/*
 * Truncate string to length
 */
- (NSString*)stringByTruncatingToLength:(int)length;
- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom;
- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom withEllipsisString:(NSString*)ellipsis;





@end

@interface NSString (NumberStuff) 

+ (NSString*)stringWithInt:(int)anInteger;
+ (NSString*)stringWithFloat:(float)aFloat decimalPlaces:(int)decimalPlaces;


- (BOOL)holdsFloatingPointValue;
- (BOOL)holdsFloatingPointValueForLocale:(NSLocale *)locale;
- (BOOL)holdsIntegerValue;

/*
 * Returns the long value of the string
 */
- (long)longValue;
- (long long)longLongValue;


@end
