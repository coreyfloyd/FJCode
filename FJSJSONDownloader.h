//
//  FJSJSONDownloader.h
//  FJSCode
//
//  Created by Corey Floyd on 6/9/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FJSDownloader.h"

//TODO: test, now uses jsonkit
//TODO: test, no longer niling out response after completeion (seemed unnecesary)
//specifically if i do a test anywhere like : if([downloader data] == nil)

@protocol FJSJSONDownloaderDelegate <NSObject>

@optional

//Implement this method in your delegate to receive the JSON object
-(void)didReceiveJSONResponse:(id)anObject withError:(NSError*)error;

@end




@interface FJSJSONDownloader : FJSDownloader {
    
    NSString *responseString;
    id JSONObject;
        
}
//JSON in string form
@property(nonatomic,retain)NSString *responseString;

//JSON Object
@property(nonatomic,retain)id JSONObject;



@end
