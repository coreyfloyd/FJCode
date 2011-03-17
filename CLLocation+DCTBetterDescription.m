//
//  CLLocation+DCTBetterDescription.m
//  DCTBetterDescriptions
//
//  Created by Daniel Tull on 25.09.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import "CLLocation+DCTBetterDescription.h"
#import <CoreLocation/CoreLocation.h>
#import "NSObject+DCTBetterDescription.h"

@implementation CLLocation (DCTBetterDescription)

- (NSString *)description {
	CLLocationCoordinate2D coord = self.coordinate;
	return [self dct_betterDescriptionWithString:[NSString stringWithFormat:@"latitude = %f; longitude = %f", coord.latitude, coord.longitude]];
}

@end
