//
//  FJSJSONDownloader.m
//  FJSCode
//
//  Created by Corey Floyd on 6/9/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSJSONDownloader.h"
#import "JSONKit.h"
//#import "JSON.h"

@implementation FJSJSONDownloader

@synthesize JSONObject;
@synthesize responseString;

- (void)sendRequestwithURL:(NSString*)aURL{

    [self setResponseString:nil];
    [self setJSONObject:nil];
    
    [super sendRequestwithURL:aURL];
        
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    [super connection:connection didFailWithError:error];
    
	NSString *failureMessage = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    NSLog(failureMessage);
    
    if([delegate respondsToSelector:@selector(didReceiveJSONResponse:withError:)])
        [(id <FJSJSONDownloaderDelegate>)delegate didReceiveJSONResponse:nil withError:error];

    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [super connectionDidFinishLoading:connection];
    
    // NSLog(@"DONE. Received Bytes: %d", [responseData length]);
    self.responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    
    NSError *error = nil;
    
    /*
    SBJSON *json = [[SBJSON new] autorelease];
    id data = nil;
    data = [json objectWithString:responseString error:&error];
    */
    
    self.JSONObject = [NSObject objectWithJSON:responseString]; 
    
    //got data but the json conversion went wrong
    if((responseString!=nil) && (JSONObject==nil)){
        error = [NSError errorWithDomain:@"FJSError" code:1 userInfo:nil];
        JSONObject = responseData;
    }
    
    if([delegate respondsToSelector:@selector(didReceiveJSONResponse:withError:)])
        [(id <FJSJSONDownloaderDelegate>)delegate didReceiveJSONResponse:JSONObject withError:error];
    
}

- (void)dealloc{

    self.JSONObject = nil;    
    
    [responseString release];
    [super dealloc];
    
}




@end
