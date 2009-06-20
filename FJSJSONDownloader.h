//
//  FJSJSONDownloader.h
//  FJSCode
//
//  Created by Corey Floyd on 6/9/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FJSJSONDownloaderDelegate

-(void)didReceiveResponse:(id)anObject withError:(NSError*)error;

@end




@interface FJSJSONDownloader : NSObject {
    NSMutableData *responseData;
    NSString *responseString;
        
    id<FJSJSONDownloaderDelegate> delegate;

    
}
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)NSString *responseString;
@property(nonatomic,assign)id<FJSJSONDownloaderDelegate> delegate;

- (void)sendRequestwithURL:(NSString*)aURL;


@end
