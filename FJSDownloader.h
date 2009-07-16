//
//  NetworkController.h
//  HSS
//
//  Created by Corey Floyd on 4/30/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FJSDownloaderDelegate

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

- (void)sendRequestwithURL:(NSString*)aURL;

@end
