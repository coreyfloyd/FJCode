//
//  ImageDownloader.m
//  imageDLTest
//
//  Created by Corey Floyd on 6/8/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSImageDownloader.h"


@implementation FJSImageDownloader

@synthesize responseData;
@synthesize delegate;
@synthesize baseURL;
@synthesize cacheDirectoryPath;
@synthesize cacheImages;


- (BOOL)imageIsCachedWithName:(NSString*)imageName{
    
    BOOL answer = NO;
    
    //need to make sure it's an image name
    if(baseURL!=nil){
        
        //TODO: check image directory for image
        
        
    }
    
    // TODO: retrieve image
    
    //TODO: return to delegate;
    
    
    return answer;
}

- (void)fetchCachedImageWithURL:(NSString*)imageName{
    
    
}
    



- (void)fetchImageWithURL:(NSString*)aURL{
    
    [self setResponseData:nil];
    
    if(![self imageIsCachedWithName:aURL]){
        
        NSURL *url; 
        
        if(baseURL==nil)
            url = [NSURL URLWithString:aURL];
        else
            url = [NSURL URLWithString:[baseURL stringByAppendingString:aURL]];
        
        
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
    [delegate didReceiveImage:nil withError:error];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"DONE. Received Bytes: %d", [responseData length]);
    
    UIImage *anImage = [UIImage imageWithData:responseData];

    if(cacheImages){
        
        //TODO: save images to directory
        
    }
    
    
    [delegate didReceiveImage:anImage withError:nil];
    
}

- (void)dealloc{
    
    
    self.baseURL = nil;
    self.cacheDirectoryPath = nil;
    [responseData release];
    [super dealloc];
    
}

@end
