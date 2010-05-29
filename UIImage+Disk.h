//
//  UIImage+Disk.h
//  Carousel
//
//  Created by Corey Floyd on 12/31/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import <UIKit/UIKit.h>

//returns the path: ~/Documents/images/
NSString* imageDirectoryPath();

//returns the path: ~/Documents/images/"name"
NSString* filePathWithName(NSString* name);


//these methods will overwrite existing files with aplumb!
@interface UIImage(File)

//Write to ~/Documents/images
- (BOOL)writeToFileWithImageName:(NSString*)fileName asynchronous:(BOOL)flag;

//Write to an arbitrary path with async option (uses global operation queue)
- (BOOL)writeToFile:(NSString*)path asynchronous:(BOOL)flag;

//Write to arbitrary path
- (BOOL)writeToPath:(NSString*)path;

//Delete an item at an arbitrary path
+ (BOOL)deleteImageAtPath:(NSString*)path;


@end

//subscribe to be notified of files async written to disk
extern NSString* const ImageWriteNotification;

//Check this key in the userInfo dictionary to see if the image failed
extern NSString* const FJSImageWriteFailedKey;






