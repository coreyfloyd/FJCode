//
//  NSDate+Helper.m
//  Codebook
//
//  Created by Billy Gray on 2/26/09.
//  Copyright 2009 Zetetic LLC. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */


- (NSUInteger)daysAgo {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
											   fromDate:self
												 toDate:[NSDate date]
												options:0];
	return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	[mdf release];
	
	return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSUInteger)daysInFutureAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	[mdf release];
	
	return (int)[midnight timeIntervalSinceNow] / (60*60*24);
}

- (NSString *)stringDaysAgo {
	return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
	NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
	NSString *text = nil;
	switch (daysAgo) {
		case 0:
			text = @"Today";
			break;
		case 1:
			text = @"Yesterday";
			break;
		default:
			text = [NSString stringWithFormat:@"%d days ago", daysAgo];
	}
	return text;
}

+ (NSString *)dbFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

+ (NSDate *)dateFromString:(NSString *)string {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:[NSDate dbFormatString]];
	NSDate *date = [inputFormatter dateFromString:string];
	[inputFormatter release];
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:date];
	[outputFormatter release];
	return timestamp_str;
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [NSDate stringFromDate:date withFormat:[NSDate dbFormatString]];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
	/* 
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
	
	NSDate *today = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
													 fromDate:today];
	
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	
	NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
	NSString *displayString = nil;
	
	// comparing against midnight
	if ([date compare:midnight] == NSOrderedDescending) {
        if (prefixed) {
            [displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
        } else {
            [displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
        }
	} else {
		// check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
		[componentsToSubtract release];
		if ([date compare:lastweek] == NSOrderedDescending) {
			[displayFormatter setDateFormat:@"EEEE"]; // Tuesday
		} else {
			// check if same calendar year
			NSInteger thisYear = [offsetComponents year];
			
			NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
														   fromDate:date];
			NSInteger thatYear = [dateComponents year];			
			if (thatYear >= thisYear) {
				[displayFormatter setDateFormat:@"MMM d"];
			} else {
				[displayFormatter setDateFormat:@"MMM d, YYYY"];
			}
		}
        if (prefixed) {
            NSString *dateFormat = [displayFormatter dateFormat];
            NSString *prefix = @"'on' ";
            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
        }
	}
	
	// use display formatter to return formatted date string
	displayString = [displayFormatter stringFromDate:date];
	[displayFormatter release];
	return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
    return [self stringForDisplayFromDate:date prefixed:NO];
}



+ (NSString *)stringForDisplayForFutureDates:(NSDate *)date{
    /* 
     * display Today, Yesterday, or Tomorrow
     * if it is within the last 7 days, but after tomorrow, display weekday name (Friday)
     * if within the calendar year, display as Jan 23
     * else display as Nov 11, 2008
     */
    
    
    NSString *readableDate = nil;
    
    
    if([date daysAgoAgainstMidnight]==0)
        readableDate = @"Today";
    else if([date daysAgoAgainstMidnight]==1)
        readableDate = @"Yesterday";
    else if([date daysInFutureAgainstMidnight]==1)
        readableDate = @"Tomorrow";
    else if([date daysInFutureAgainstMidnight] < 8 && 
                [date daysInFutureAgainstMidnight] > 1){
        
        
        NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
        [displayFormatter setDateFormat:@"EEEE"];
        readableDate = [displayFormatter stringFromDate:date];
        [displayFormatter release];

        
    } else{
      
        
        NSDate *today = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                                                         fromDate:today];
        
        NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
        // check if same calendar year
        NSInteger thisYear = [offsetComponents year];
        
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                                                       fromDate:date];
        NSInteger thatYear = [dateComponents year];			
        if (thatYear >= thisYear) {
            [displayFormatter setDateFormat:@"MMM d"];
        } else {
            [displayFormatter setDateFormat:@"MMM d, YYYY"];
        }
        
        readableDate = [displayFormatter stringFromDate:date];    
        [displayFormatter release];

        
   }    

	return readableDate;
    
}

@end



@implementation NSDate (Misc)

+ (NSDate *)dateWithoutTime
{
    return [[NSDate date] dateAsDateWithoutTime];
}

-(NSDate *)dateByAddingDays:(NSInteger)numDays
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:numDays];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    [comps release];
    [gregorian release];
    return date;
}

- (NSDate *)dateAsDateWithoutTime
{
    NSString *formattedString = [self formattedDateString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    NSDate *ret = [formatter dateFromString:formattedString];
    [formatter release];
    return ret;
}

- (int)differenceInDaysTo:(NSDate *)toDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit
                                                fromDate:self
                                                  toDate:toDate
                                                 options:0];
    NSInteger days = [components day];
    [gregorian release];
    return days;
}

- (NSString *)formattedDateString
{
    return [self formattedStringUsingFormat:@"MMM dd, yyyy"];
}

- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *ret = [formatter stringFromDate:self];
    [formatter release];
    return ret;
}


@end


