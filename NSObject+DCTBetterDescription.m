//
//  NSObject+DCTBetterDescription.m
//  DCTBetterDescription
//
//  Created by Daniel Tull on 25.09.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import "NSObject+DCTBetterDescription.h"

@implementation NSObject (DCTBetterDescription)

- (NSString *)dct_betterDescriptionWithProperties:(NSArray *)properties {
	
	NSMutableString *betterDescription = [[[NSMutableString alloc] init] autorelease];
	
	for (NSString *propertyName in properties) {
		
		if ([properties indexOfObject:propertyName] != 0)
			[betterDescription appendString:@"; "];
		
		[betterDescription appendFormat:@"%@ = %@", propertyName, [self valueForKey:propertyName]];
	}
	
	return [self dct_betterDescriptionWithString:betterDescription];
}

- (NSString *)dct_betterDescriptionWithString:(NSString *)string {
	return [NSString stringWithFormat:@"<%@: %p; %@>", [[self class] description], self, string];
}

@end
