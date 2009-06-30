//
//  ImageDownloader.h
//  imageDLTest
//
//  Created by Corey Floyd on 6/8/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FJSImageDownloaderDelegate

-(void)didReceiveImage:(UIImage*)anImage withError:(NSError*)error;

@end



@interface FJSImageDownloader : NSObject {
    
	NSMutableData *responseData;
    UIImage *image;
    NSString *baseURL;
    NSString *cacheDirectoryPath;
    NSString *cacheFileName;
    BOOL cacheImages;
    BOOL loadFromCache;
    
    id<FJSImageDownloaderDelegate> delegate;

}
//accessable data 
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)UIImage *image;

//optional. will be concatinated with URL in fetch method
@property(nonatomic,retain)NSString *baseURL;

//where to store/load images
@property(nonatomic,retain)NSString *cacheDirectoryPath;

//name for file
@property(nonatomic,retain)NSString *cacheFileName;

//Use these to control caching behavior Default:YES
@property(nonatomic,assign)BOOL cacheImages;
@property(nonatomic,assign)BOOL loadFromCache;


@property(nonatomic,assign)id<FJSImageDownloaderDelegate> delegate;

//if no base url, uses entire url
- (void)fetchImageWithURL:(NSString*)aURL;

@end
