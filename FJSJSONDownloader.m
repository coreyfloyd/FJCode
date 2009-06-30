//
//  FJSJSONDownloader.m
//  FJSCode
//
//  Created by Corey Floyd on 6/9/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSJSONDownloader.h"
#import "JSON.h"

@implementation FJSJSONDownloader

@synthesize responseData;
@synthesize responseString;
@synthesize delegate;

- (void)sendRequestwithURL:(NSString*)aURL{
    
    [self setResponseData:nil];
    
    NSString *encodedURL = [aURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];        
    NSURL *url = [NSURL URLWithString:encodedURL];
    NSLog([url description]);
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest setHTTPMethod:@"GET"];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection ){
		self.responseData = [NSMutableData data];
        
    }else{
		NSLog(@"theConnection is NULL");
	}
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSString *failureMessage = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    NSLog(failureMessage);
    [delegate didReceiveResponse:nil withError:error];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // NSLog(@"DONE. Received Bytes: %d", [responseData length]);
    self.responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    
    NSError *error;
    SBJSON *json = [[SBJSON new] autorelease];
    id data = [json objectWithString:responseString error:&error];
            
    [delegate didReceiveResponse:data withError:error];
    
    [self setResponseData:nil];
    [self setResponseString:nil];
    
       
}

- (void)dealloc{
    
    [responseString release];
    [responseData release];
    [super dealloc];
    
}




@end
