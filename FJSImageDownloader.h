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
    
    id<FJSImageDownloaderDelegate> delegate;

}
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)UIImage *image;
@property(nonatomic,retain)NSString *baseURL;
@property(nonatomic,retain)NSString *cacheDirectoryPath;
@property(nonatomic,retain)NSString *cacheFileName;
@property(nonatomic,assign)BOOL cacheImages;

@property(nonatomic,assign)id<FJSImageDownloaderDelegate> delegate;

//if no base url, uses entire url
- (void)fetchImageWithURL:(NSString*)aURL;

@end
