//
//  UIImage+Caching.m
//  Carousel
//
//  Created by Corey Floyd on 12/16/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "UIImage+Caching.h"
#import "NSObject+AssociatedObjects.h"


@interface UIImage(PrivateCaching)

//Cache image with an arbitrary key
+ (UIImage*)cachedImageForKey:(NSString*)key;

//return image for arbitrary key
//set key to nil to clear image from cache
+ (void)cacheImage:(UIImage*)image withKey:(NSString*)key;

//Convienence instance method for caching
- (void)cacheWithKey:(NSString*)key;

@end

@implementation UIImage(PrivateCaching)

+ (void)didReceiveMemoryWarning{
	
	[self breakAllAssociations];
	//TODO: figure out a better way to clean the cache. Perhaps remove images not accessed for a certain time period.
}

+ (void)load{
	
	if ( self == [UIImage class] ) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(didReceiveMemoryWarning) 
													 name:UIApplicationDidReceiveMemoryWarningNotification 
												   object:nil];    
	}
}

+ (UIImage*)cachedImageForKey:(NSString*)key{
	return [self associatedValueForKey:key];
}

+ (void)cacheImage:(UIImage*)image withKey:(NSString*)key{
	if(key == nil)
		return;
	
	[image cacheWithKey:key];
}

- (void)cacheWithKey:(NSString*)key{
	[UIImage associateValue:self withKey:key];	
}


@end

@implementation UIImage(Caching)


+ (UIImage*)imageWithContentsOfFile:(NSString*)path cache:(BOOL)flag{
	
	UIImage* image = nil;
	
	if(flag)
		image = [UIImage cachedImageForKey:path];
	
	if(image == nil){
		
		image = [UIImage imageWithContentsOfFile:path];
		
		if(flag)
			[UIImage cacheImage:image withKey:path];
		
	}
	
	return image;
}
		 

@end










