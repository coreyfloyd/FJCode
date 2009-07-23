//
//  FJSNetworkImageViewController.h
//  FJSCode
//
//  Created by Corey Floyd on 7/15/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJSImageViewController.h"
#import "FJSImageDownloader.h"


@protocol FJSNetworkImageViewControllerDelegate;


@interface FJSNetworkImageViewController : FJSImageViewController <FJSImageDownloaderDelegate> {
    
    FJSImageDownloader *downloader;
    
    NSString *imageURL;
    NSString *cacheDirectory;
    
    BOOL imageLoaded;
    
    id<FJSNetworkImageViewControllerDelegate> delegate;
    
}
@property(nonatomic,retain)FJSImageDownloader *downloader;
@property(nonatomic,retain)NSString *imageURL;
@property(nonatomic,retain)NSString *cacheDirectory;
@property(nonatomic,assign)BOOL imageLoaded;
@property(nonatomic,assign)id<FJSNetworkImageViewControllerDelegate> delegate;


- (void)fetch;
- (void)setupDownloader;


@end



@protocol FJSNetworkImageViewControllerDelegate

- (void)imageController:(FJSNetworkImageViewController*)controller didUpdateImageWithError:(NSError*)error;




@end