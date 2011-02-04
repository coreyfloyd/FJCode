//
//  NSDate+Helper.h
//  Codebook
//
//  Created by Billy Gray on 2/26/09.
//  Copyright 2009 Zetetic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* PrettyDateFromInterval( NSInteger epoch );

NSString* prettyHoursFromInterval(NSTimeInterval seconds); //rounds to half hours, appends "hours" to string
NSString* prettyHoursFromIntervalNumberOnly(NSTimeInterval seconds); //rounds to half hours
NSString* prettyMinutesAndSecondsFromInterval(NSTimeInterval seconds); //mm:ss


@interface NSDate (Helper)

- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;

+ (NSDate *)dateFromString:(NSString *)string; //yyyy-MM-dd HH:mm:ss 
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;

+ (NSString *)dateFormatString; 
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;  //yyyy-MM-dd HH:mm:ss 


@end

@interface NSDate (Misc)

- (NSDate *)dateByAddingDays:(NSInteger)numDays;
- (NSDate *)dateByAddingDays:(NSInteger)numDays hours:(NSInteger)numHours minutes:(NSInteger)numMinutes;
- (NSDate *)dateAsDateWithoutTime;
- (int)differenceInDaysTo:(NSDate *)toDate;
- (NSString *)formattedDateString;
- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat;

+ (NSDate *)dateWithoutTime;

- (NSString*)prettyAge;

- (NSString*)durationInHoursAndMinutesSinceDate:(NSDate*)startDate;

@end


@interface NSDate (MoreHelp)

// Returns an NSDate based on a string with formatting options passed to NSDateFormatter
+ (NSDate*)dateWithString:(NSString*)dateString formatString:(NSString*)dateFormatterString;

// Returns an NSDate with an ISO8610 format, aka ATOM: yyyy-MM-dd'T'HH:mm:ssZZZ 
+ (NSDate*)dateWithISO8601String:(NSString*)str;

// Returns an NSDate with a 'yyyy-MM-dd' string
+ (NSDate*)dateWithDateString:(NSString*)str;

// Returns an NSDate with a 'yyyy-MM-dd HH:mm:ss' string
+ (NSDate*)dateWithDateTimeString:(NSString*)str;

// Returns an NSDate with a 'dd MMM yyyy HH:mm:ss' string
+ (NSDate*)dateWithLongDateTimeString:(NSString*)str;

// Returns an NSDate with an RSS formatted string: 'EEE, d MMM yyyy HH:mm:ss ZZZ' string
+ (NSDate*)dateWithRSSDateString:(NSString*)str;

// Returns an NSDate with an alternative RSS formatted string: 'd MMM yyyy HH:mm:ss ZZZ' string
+ (NSDate*)dateWithAltRSSDateString:(NSString*)str;


// Pass in an string compatible with NSDateFormatter
- (NSString*)formattedDateWithFormatString:(NSString*)dateFormatterString;

// Returns date formatted to: EEE, d MMM 'at' h:mma
- (NSString*)formattedDate;

// Returns date formatted to: NSDateFormatterShortStyle
- (NSString*)formattedTime;

// Returns date formatted to: Weekday if within last 7 days, Yesterday/Tomorrow, or NSDateFormatterShortStyle for everything else
- (NSString*)relativeFormattedDate;

// Returns date formatted to: Weekday if within last 7 days, Yesterday/Today/Tomorrow, or NSDateFormatterShortStyle for everything else
// If date is today, returns no Date, instead returns NSDateFormatterShortStyle for time
- (NSString*)relativeFormattedDateOnly;

// Returns date formatted to: Weekday if within last 7 days, Yesterday/Today/Tomorrow, or NSDateFormatterFullStyle for everything else
// Also returns NSDateFormatterShortStyle for time
- (NSString*)relativeFormattedDateTime;

// Returns date formatted to: Weekday if within last 7 days, Yesterday/Today/Tomorrow, or NSDateFormatterFullStyle for everything else
- (NSString*)relativeLongFormattedDate;

// Returns date formatted for ISO8601/ATOM: yyyy-MM-dd'T'HH:mm:ssZZZ
- (NSString*)iso8601Formatted;

// Checks whether current date is past date
- (BOOL)isPastDate;

// Returns the current date, at midnight
- (NSDate*)midnightDate;

@end


