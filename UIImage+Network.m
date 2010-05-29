//
//  UIImage+Network.m
//  Carousel
//
//  Created by Corey Floyd on 12/31/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "UIImage+Network.h"
#import "NSString+extensions.h"
#import "UIImage+Disk.h"
#import "NSOperationQueue+Shared.h"
#import "NSError+UIAlertView.h"
#import "SDNextRunloopProxy.h"


NSString* const ImageFetchedFromURLNotification = @"FJSImageFetchedFromURL";
NSString* const FJSImageFetchFailedKey = @"FJSImageFetchFailed";


static NSMutableDictionary* _sharedDictionary = nil;


NSString* imageNameForURL(NSURL* url){
	//return [NSString stringWithInt:[[url absoluteString] hash]];
	return [[url absoluteString] md5];

}

NSString* imagePathForURL(NSURL* url){
	return filePathWithName(imageNameForURL(url));
}


@implementation UIImage(NetworkCache)


+ (void)associateValue:(id)value withKey:(void *)key
{
	if(_sharedDictionary == nil){
		_sharedDictionary = [[NSMutableDictionary alloc] init];
	}
	[_sharedDictionary setObject:value forKey:key];
}

+ (id)associatedValueForKey:(void *)key
{
	return [_sharedDictionary objectForKey:key];
}

+ (void)breakAllAssociations
{	
	[_sharedDictionary removeAllObjects];
}


+ (UIImage*)cachedImageWithURL:(NSURL*)url{
	
	if(url == nil)
		return nil;
	
	NSString* urlDescription = [url description];
		
	if(urlDescription == nil)
		return nil;
	
	return [self associatedValueForKey:urlDescription];
}

+ (void)cacheImage:(UIImage*)image withURL:(NSURL*)url{
	if(image == nil)
		return;
	if(url == nil)
		return;
	
	NSString* urlDescription = [url description];

	[self associateValue:image withKey:urlDescription];
}

- (void)cacheWithURL:(NSURL*)url{
	[UIImage cacheImage:self withURL:url];
}


+ (UIImage*)fetchImageWithURL:(NSURL *)url useCache:(BOOL)flag{
	if(url == nil)
		return nil;
	
	UIImage* image = nil;
	
	if(flag)
		image = [UIImage cachedImageWithURL:url];
	
	if(image == nil){
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(imageFetchedFromURLWithNotification:) 
													 name:ImageFetchedFromURLNotification 
												   object:[url absoluteString]];
		[UIImage fetchImageWithURL:url];
	}
	
	return image;
}


+ (UIImage*)imageFromDiskWithURL:(NSURL*)url{
	if(url == nil)
		return nil;
	
	UIImage* image = [UIImage imageWithContentsOfFile:imagePathForURL(url)];
	[UIImage cacheImage:image withURL:url];
	return image;
	
}

+ (void)deleteImageFromDiskWithURL:(NSURL*)url{
	if(url == nil)
		return;
	
	[UIImage deleteImageAtPath:imagePathForURL(url)];
}


+ (void)emptyNetworkCache{
	
	[self breakAllAssociations];
	
}

@end

@implementation UIImage(Network)



+ (void)imageFetchedFromURLWithNotification:(NSNotification*)note{
	
	NSString* imageURL = [note object];
	
	if (imageURL == nil)
		return;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ImageFetchedFromURLNotification object:imageURL];
	
	UIImage* image = [[note userInfo] objectForKey:FJSImageKey];
	
	if(image != nil){
		
		NSURL* url = [NSURL URLWithString:imageURL];
		[image cacheWithURL:url];		
		[image writeToPath:imagePathForURL(url)];
		
	}
}


+ (UIImage*)synchronousfetchAtURL:(NSURL*)url{
	
	if(url == nil)
		return nil;
		
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
	
	NSURLResponse* response = nil;
	NSError* error = nil;
    
	NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
	UIImage* image = nil;	
	
	if(error == nil){
		
		if(responseData != nil){
			
			image = [UIImage imageWithData:responseData];	
			
		}
	}
	
	if(image!=nil){
		
		[[image nextRunloopProxy] writeToPath:imagePathForURL(url)];
		
	}
	
	return image;
}



+ (void)fetchImageWithURLString:(NSString*)path{
	
	if(path == nil)
		return;
	
	NSURL* url = [NSURL URLWithString:path];
	[UIImage fetchImageWithURL:url];
}



+ (void)fetchImageWithURL:(NSURL*)url{
	
	if(url == nil)
		return;
	
	NSInvocationOperation* fetchOperation = [[[NSInvocationOperation alloc] initWithTarget:self 
																				  selector:@selector(fetchAtURLOperation:) 
																					object:url] autorelease];
	
	[[NSOperationQueue sharedOperationQueue] addOperation:fetchOperation];
}


+ (void)fetchAtURLOperation:(NSURL*)url{
	
	if(url == nil)
		return;
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
	
	NSURLResponse* response = nil;
	NSError* error = nil;
    
	NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	NSNotification* note = nil;
	
	if(error == nil){
		
		if(responseData!=nil){
			
			UIImage* image = [UIImage imageWithData:responseData];	
			
			if(image!=nil){
				
				note = [NSNotification notificationWithName:ImageFetchedFromURLNotification 
													 object:[url absoluteString]
												   userInfo:[NSDictionary dictionaryWithObject:image forKey:FJSImageKey]];
				
				
				[image writeToPath:imagePathForURL(url)];
				
			}
		}
	}
	
	if(note == nil){
		
		note = [NSNotification notificationWithName:ImageFetchedFromURLNotification 
											 object:[url absoluteString] 
										   userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:FJSImageFetchFailedKey]];
		
		
		
		[error presentInAlertView];
		
		//TODO: parse error and send in userInfo		
		
	}
	
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) 
														   withObject:note 
														waitUntilDone:NO]; 
	
	
	
	[pool drain];
	
}





@end
