//
//  NetworkController.m
//  HSS
//
//  Created by Corey Floyd on 4/30/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "FJSDownloader.h"


@implementation FJSDownloader

@synthesize responseData;
@synthesize isFetching;
@synthesize delegate;


- (void)sendRequestwithURL:(NSString*)aURL{
    
    [self setResponseData:nil];
    
    if(isFetching)
        return;
    
    self.isFetching = YES;
    
    [self setResponseData:nil];
    
    NSURL *url = [NSURL URLWithString:aURL];
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
    self.isFetching = NO;
    
    if([delegate respondsToSelector:@selector(didReceiveResponse:withError:)])
        [delegate didReceiveResponse:responseData withError:error];


}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
   // NSLog(@"DONE. Received Bytes: %d", [responseData length]);

    self.isFetching=NO;
    
    if([delegate respondsToSelector:@selector(didReceiveResponse:withError:)])
        [delegate didReceiveResponse:responseData withError:nil];
        
}

- (void)dealloc{

    [responseData release];
    [super dealloc];
    
}




@end
