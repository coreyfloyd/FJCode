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
    
    NSString *baseURL;
    NSString *cacheDirectoryPath;
    BOOL cacheImages;
    
    id<FJSImageDownloaderDelegate> delegate;

}
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)NSString *baseURL;
@property(nonatomic,retain)NSString *cacheDirectoryPath;
@property(nonatomic,assign)BOOL cacheImages;

@property(nonatomic,assign)id<FJSImageDownloaderDelegate> delegate;


//used as file name so put any '/' in base url
//if no base url, uses entire url, but won't cache image
- (void)fetchImageWithURL:(NSString*)aURL;

@end
