//
//  NetworkController.h
//  HSS
//
//  Created by Corey Floyd on 4/30/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <Foundation/Foundation.h>

//TODO: test, no longer niling out response after completeion (seemed unnecesary)
//specifically if i do a test anywhere like : if([downloader data] == nil)


@protocol FJSDownloaderDelegate <NSObject>

@optional
-(void)didReceiveResponse:(NSData*)aResponse withError:(NSError*)error;

@end


@interface FJSDownloader : NSObject {
	NSMutableData *responseData;
    
    BOOL isFetching;
    
    id<FJSDownloaderDelegate> delegate;

}
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,assign)BOOL isFetching;
@property(nonatomic,assign)id<FJSDownloaderDelegate> delegate;

//URL string will be encoded using UTF8 encoding
- (void)sendRequestwithURL:(NSString*)aURL;

@end
