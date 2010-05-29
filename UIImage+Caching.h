//
//  UIImage+Caching.h
//  Carousel
//
//  Created by Corey Floyd on 12/16/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage(Caching)

//pulls from disk and optionally caches image using file path as key
//will check cache first, and returned cached image
+ (UIImage*)imageWithContentsOfFile:(NSString*)path cache:(BOOL)flag;


@end










