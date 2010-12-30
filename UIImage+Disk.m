//
//  UIImage+Disk.m
//  Carousel
//
//  Created by Corey Floyd on 12/31/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "UIImage+Disk.h"
#import "NSOperationQueue+Shared.h"


NSString* const FJSImageNotFoundKey = @"FJSimageNotFound";
NSString* const FJSImageKey = @"FJSImage";

NSString* const ImageWriteNotification = @"FJSimageWriteNotification";
NSString* const FJSImageWriteFailedKey = @"FJSimageWriteFailed";

NSString* const ImageFetchedAtPathNotification = @"FJSimageFetchedFromDisk";

static NSString* folderName = @"images";
//static NSString* fetching = @"imageInCue";


NSString* imageDirectoryPath()
{
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths objectAtIndex:0]; 
	filePath = [filePath stringByAppendingPathComponent:folderName]; 
    
    return filePath;
}

NSString* filePathWithName(NSString* name)
{
	return [imageDirectoryPath() stringByAppendingPathComponent:name];	
}

BOOL createImagesDirectory()
{
	
	BOOL isDirectory;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:imageDirectoryPath() isDirectory:&isDirectory]) {
        
        if(!isDirectory){
            [[NSFileManager defaultManager] removeItemAtPath:imageDirectoryPath() error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:imageDirectoryPath() withIntermediateDirectories:NO attributes:nil error:nil];

        }
    }
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:imageDirectoryPath()]){
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDirectoryPath() withIntermediateDirectories:NO attributes:nil error:nil];
        
    } 
    
	return [[NSFileManager defaultManager] fileExistsAtPath:imageDirectoryPath()];
}



@implementation UIImage(File)


+ (UIImage*)imageFromImageDirectoryNamed:(NSString*)fileName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *directory = [paths objectAtIndex:0];
    NSString *fullPath = [directory stringByAppendingPathComponent:@"Images"];      
    fullPath = [directory stringByAppendingPathComponent:fileName];
	UIImage *res = [UIImage imageWithContentsOfFile:fullPath];
    
	return res;
}

+ (UIImage*)imageFromImageCacheDirectoryNamed:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *directory = [paths objectAtIndex:0];
    NSString *fullPath = [directory stringByAppendingPathComponent:@"Images"];      
    fullPath = [directory stringByAppendingPathComponent:fileName];
    UIImage *res = [UIImage imageWithContentsOfFile:fullPath];
    
	return res;
    
}

- (BOOL)writeToImageDirectoryWithName:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *directory = [paths objectAtIndex:0];
	NSString *fullPath = [directory stringByAppendingPathComponent:@"Images"];      
    fullPath = [directory stringByAppendingPathComponent:fileName];

    return [self writeToPath:fullPath];
}

- (BOOL)writeToImageCacheDirectoryWithName:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *directory = [paths objectAtIndex:0];
    NSString *fullPath = [directory stringByAppendingPathComponent:@"Images"];      
    fullPath = [directory stringByAppendingPathComponent:fileName];
    
    return [self writeToPath:fullPath];

}

- (BOOL)writeToFileWithImageName:(NSString*)fileName asynchronous:(BOOL)flag{
	if(!createImagesDirectory())
		return NO;
	
	
	if(flag){
		
		return [self writeToPath:filePathWithName(fileName)];
		
	}else{
		
		NSInvocationOperation* cacheOperation = [[[NSInvocationOperation alloc] initWithTarget:self 
																					  selector:@selector(writeToPath:) 
																						object:filePathWithName(fileName)] autorelease];
		
		[[NSOperationQueue sharedOperationQueue] addOperation:cacheOperation];
		
		
	}
	
	return NO;
	
	
	
}
- (BOOL)writeToFile:(NSString*)path asynchronous:(BOOL)flag{
	
	if(flag){
		
		return [self writeToPath:path];
		
	}else{
		
		NSInvocationOperation* cacheOperation = [[[NSInvocationOperation alloc] initWithTarget:self 
																					  selector:@selector(writeToPath:) 
																						object:path] autorelease];
		
		[[NSOperationQueue sharedOperationQueue] addOperation:cacheOperation];
		
		
	}
	
	return NO;
}

- (BOOL)writeToPath:(NSString*)path{
	
	NSData* imageData = UIImagePNGRepresentation(self); 
	
	[UIImage deleteImageAtPath:path];
	
	BOOL success = [imageData writeToFile:path atomically:YES];
	
	NSDictionary* userInfo = nil;
	
	if(success)
		userInfo = [NSDictionary dictionaryWithObject:path forKey:FJSImageWriteFailedKey];
	
	
	NSNotification* note = [NSNotification notificationWithName:ImageWriteNotification 
														 object:path 
													   userInfo:userInfo];
	
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) 
														   withObject:note 
														waitUntilDone:NO];
	
	
	return success; 
}



+ (BOOL)deleteImageAtPath:(NSString*)path{
	
	NSError* error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
	
	if(error!=nil)
		return NO;

	return YES;
}




@end





#pragma mark -
#pragma mark Hash

/*
 - (NSString*)imageHash{
 
 
 unsigned char result[16];
 NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(self)];
 CC_MD5(imageData, [imageData length], result);
 NSString *ih = [NSString stringWithFormat:
 @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
 result[0], result[1], result[2], result[3], 
 result[4], result[5], result[6], result[7],
 result[8], result[9], result[10], result[11],
 result[12], result[13], result[14], result[15]
 ];
 
 return ih;
 
 //TODO: make better
 return [NSString stringWithInt:[self hash]];
 
 
 }
*/



