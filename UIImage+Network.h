//
//  UIImage+Network.h
//  Carousel
//
//  Created by Corey Floyd on 12/31/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* imagePathForURL(NSURL* url);

@interface UIImage(NetworkCache)

//This is the crux of the category
//fetches image
//If flag is set, will check cache and save image to cache after fetched
//If it misses the cache, the method immediately returns nil and begins the async network fetch
//subscribe to the notification, object will be the image URL
+ (UIImage*)fetchImageWithURL:(NSURL*)url useCache:(BOOL)flag;

//So you want to check the cache without triggering a network fetch?
+ (UIImage*)cachedImageWithURL:(NSURL*)url;

//So you want to to use the network cache but you have unwittingly fetched an image without using this category
+ (void)cacheImage:(UIImage*)image withURL:(NSURL*)url;

//Same functionality but as an instance method
- (void)cacheWithURL:(NSURL*)url;


//fetch/delete an image from disk based on the url
+ (UIImage*)imageFromDiskWithURL:(NSURL*)url;
+ (void)deleteImageFromDiskWithURL:(NSURL*)url;

//empty cache, did you use too much memory?
+ (void)emptyNetworkCache;

@end

@interface UIImage(Network)

//These methods do not use the cache
+ (void)fetchImageWithURLString:(NSString*)path;
+ (void)fetchImageWithURL:(NSURL*)url;
+ (UIImage*)synchronousfetchAtURL:(NSURL*)url;

@end

//subscribe to be notified of fetched images
extern NSString* const ImageFetchedFromURLNotification;

//key for image in userInfo
extern NSString* const FJSImageKey;

//Check this key in the userInfo dictionary to see if the image failed
extern NSString* const FJSImageFetchFailedKey;
