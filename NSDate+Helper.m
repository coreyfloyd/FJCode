//
//  NSDate+Helper.m
//  Codebook
//
//  Created by Billy Gray on 2/26/09.
//  Copyright 2009 Zetetic LLC. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

- (NSInteger)daysAgo {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
											   fromDate:self
												 toDate:[NSDate date]
												options:0];
	return [components day];
}

- (NSString *)stringDaysAgo {
	NSInteger daysAgo = [self daysAgo];
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

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
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
	
	// comparing against midnight
	if ([date compare:midnight] == NSOrderedDescending) {
		[displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
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
	}
    //TODO:    [displayFormatter autorelease];
	// use display formatter to return formatted date string
	return [displayFormatter stringFromDate:date];
}


+ (NSString *)stringForDisplayForFutureDates:(NSDate *)date{
    /* 
     * if the date is in today, display 12-hour time with meridian,
     * if it is within the last 7 days, display weekday name (Friday)
     * if within the calendar year, display as Jan 23
     * else display as Nov 11, 2008
     */
    
    NSString *readableDate = nil;
	NSDate *today = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
                                                     fromDate:today];
    
    //today
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    
	NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
	
    //tomorrow
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:+1];
    NSDate *tomorrow = [calendar dateByAddingComponents:componentsToAdd toDate:today options:0];
    [componentsToAdd release];
    componentsToAdd = nil;
    
    // compare to midnight today and midnight tomorrow
    if ([date compare:midnight] == NSOrderedDescending) {
        
        if([date compare:tomorrow] ==NSOrderedAscending){
            
            readableDate = [NSString stringWithString:@"Today"];
        }
        
	} else {
        //check to see if after today
        if([date compare:tomorrow] ==NSOrderedDescending){
            
            // check if date is within next 7 days
            componentsToAdd = [[NSDateComponents alloc] init];
            [componentsToAdd setDay:+7];
            NSDate *nextWeek = [calendar dateByAddingComponents:componentsToAdd toDate:today options:0];
            [componentsToAdd release];
            
            if ([date compare:nextWeek] == NSOrderedAscending) {
                [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
                readableDate = [displayFormatter stringFromDate:date];
            }
        }
    }
    
    //any other date (past date or more than 7 days in the future
    if(readableDate==nil){
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
    }
    
    //TODO:    [displayFormatter autorelease];
	// use display formatter to return formatted date string
	return readableDate;
    
}

@end
