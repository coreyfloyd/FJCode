//
//  UIFont+DCTBetterDescription.m
//  DCTBetterDescription
//
//  Created by Daniel Tull on 25.09.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import "UIFont+DCTBetterDescription.h"
#import "NSObject+DCTBetterDescription.h"

@implementation UIFont (DCTBetterDescription)

- (NSString *)description {
	return [self dct_betterDescriptionWithProperties:[NSArray arrayWithObjects:@"familyName", @"fontName", @"pointSize", nil]];
}

@end
