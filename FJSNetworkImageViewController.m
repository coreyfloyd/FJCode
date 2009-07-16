//
//  FJSNetworkImageViewController.m
//  FJSCode
//
//  Created by Corey Floyd on 7/15/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSNetworkImageViewController.h"
#import "NSString+extensions.h"


@implementation FJSNetworkImageViewController


@synthesize downloader;
@synthesize imageURL;
@synthesize imageLoaded;
@synthesize cacheDirectory;
@synthesize delegate;


- (void)fetch{
    
    if(downloader==nil)
        self.downloader = [[[FJSImageDownloader alloc] init] autorelease];
    
    self.imageLoaded=NO;
    [downloader setDelegate:self];
    [downloader setCacheImages:NO];

    
    if(cacheDirectory!=nil){
        if(![cacheDirectory isEmpty]){
            [downloader setCacheImages:YES];
            [downloader setCacheDirectoryPath:cacheDirectory];
        }
    }
    
    [downloader setCacheFileName:[imageURL lastPathComponent]];
    [downloader fetchImageWithURL:imageURL];
}


-(void)didReceiveImage:(UIImage*)anImage withError:(NSError*)error{
    
    if(error==nil){
        
        if(anImage!=nil){
            self.imageLoaded = YES;
            self.image = anImage;
            [delegate imageController:self didUpdateImageWithError:nil];
                        
        } else {
            //TODO: handle nil image
            self.imageLoaded=NO;
        }
        
    } else{
        //TODO: handle error
        self.imageLoaded=NO;
    }
    
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
    
    [downloader setDelegate:nil];
    self.downloader = nil;
    self.imageURL = nil;
    self.cacheDirectory = nil;
    
    
    [super dealloc];
}


@end
