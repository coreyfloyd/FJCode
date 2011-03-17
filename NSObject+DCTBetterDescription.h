//
//  NSObject+DCTBetterDescription.h
//  DCTBetterDescription
//
//  Created by Daniel Tull on 25.09.2010.
//  Copyright (c) 2010 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DCTBetterDescription)
- (NSString *)dct_betterDescriptionWithString:(NSString *)string;
- (NSString *)dct_betterDescriptionWithProperties:(NSArray *)properties;
@end
