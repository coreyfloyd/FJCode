//
//  ImageDownloader.m
//  imageDLTest
//
//  Created by Corey Floyd on 6/8/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSImageDownloader.h"


@interface FJSImageDownloader()

- (void)writeData;
- (void)loadData;
- (NSString *)filePath;

@end





@implementation FJSImageDownloader


@synthesize responseData;
@synthesize image;
@synthesize delegate;
@synthesize baseURL;
@synthesize cacheDirectoryPath;
@synthesize cacheFileName;
@synthesize cacheImages;
@synthesize loadFromCache;


- (void)writeData{
    
    if(cacheFileName==nil)
        return;
    if(cacheDirectoryPath==nil)
        return;
    if(cacheImages==NO)
        return;
    
    
	if (![[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {        
        
        NSData *imageData = UIImagePNGRepresentation(self.image);
        
        NSError *writeError= nil;
       
        BOOL didWrite =  [imageData writeToFile:[self filePath] options:NSAtomicWrite error:&writeError];
        
        if(writeError){
            NSLog([writeError localizedDescription]);
            
            NSDictionary *info = [writeError userInfo];
            
            
            for(NSString *aKey in info){

                NSLog(aKey);

                [[[info objectForKey:aKey] class] description];
                
                if([[info objectForKey:aKey] isKindOfClass:[NSString class]])
                    NSLog([info objectForKey:aKey]);
            }
            
        }
        
        
        if(didWrite)
            NSLog(@"image saved");
        else
            NSLog(@"image not saved");

        
    }
}

- (void)loadData{
    
    if(cacheFileName==nil)
        return;
    if(cacheDirectoryPath==nil)
        return;
    if(loadFromCache==NO)
        return;
    
        

	if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {
        
        self.responseData = [NSData dataWithContentsOfFile:[self filePath]];
        if(responseData!=nil){
            
            self.image = [UIImage imageWithData:self.responseData];
            if(self.image != nil)
                NSLog(@"image loaded from cache");
            
            
            [delegate didReceiveImage:self.image withError:nil];
            
        }
    } 
}

- (NSString *)filePath{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString *cacheDirectory = [paths objectAtIndex:0]; 
	NSString *filename = [cacheDirectory stringByAppendingPathComponent:cacheDirectoryPath]; 
    
    BOOL isDirectory;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDirectory]) {
        
        if(!isDirectory){
            [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:filename attributes:nil];
        }
    }
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:filename])
        [[NSFileManager defaultManager] createDirectoryAtPath:filename attributes:nil];
    
    filename = [filename stringByAppendingPathComponent:cacheFileName]; 
    filename = [filename stringByDeletingPathExtension];
    NSLog(filename);
    
	return filename;
	
}


- (void)fetchImageWithURL:(NSString*)aURL{
    
    self.image=nil;
    [self setResponseData:nil];
    
    [self loadData];
    
    if(self.image==nil){
        
        
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
    
    self.image = [UIImage imageWithData:responseData];

    [self writeData];
    
    [delegate didReceiveImage:image withError:nil];

}
- (id) init{
    self = [super init];
    if (self != nil) {
        self.loadFromCache = YES;
        self.cacheImages = YES;
    }
    return self;
}


- (void)dealloc{
    
    
    self.image = nil;    
    self.cacheFileName = nil;    
    self.baseURL = nil;
    self.cacheDirectoryPath = nil;
    [responseData release];
    [super dealloc];
    
}

@end
