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

//replaces deprecated methods below
- (BOOL)containsCharacters; //tests if length is > 0, does not count whitespace
- (BOOL)containsCharactersIncludeWhiteSpace:(BOOL)flag; //whitespace optional

- (NSString*)nilIfZeroLength; //doesNotCountWhiteSpace

//DEPRECATED, same as above
- (BOOL)isNotEmpty; //__OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_3_0)
- (BOOL)isEmpty; //__OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_3_0)

+ (NSString*)GUIDString;
- (NSString*)md5;

/*
 * Truncate string to length
 */
- (NSString*)stringByTruncatingToLength:(int)length;
- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom;
- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom withEllipsisString:(NSString*)ellipsis;


- (NSString*)stringByTrimmingWhiteSpace;


- (NSString*) stringByPreparingForURL;


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

+ (NSString *) commasForNumber: (long long) num;


@end



typedef enum {
	StringValidationTypeEmail = 0,
	StringValidationTypePhone,
    StringValidationTypeZip
} StringValidationType;

@interface NSString (Validation)


+ (NSPredicate *)predicateForWhiteSpace;
+ (NSPredicate *)predicateForEmail;
+ (NSPredicate *)predicateForPhone;
+ (NSPredicate *)predicateForZip;

- (BOOL)isValid:(int)type acceptWhiteSpace:(BOOL)acceptWhiteSpace;

@end



@interface NSMutableString (charManipulation)

- (void)removeLastCharacter;


@end

