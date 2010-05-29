//
//  FJSNetworkImageView.m
//  Carousel
//
//  Created by Corey Floyd on 12/28/09.
//  Copyright 2009 Flying Jalapeño Software. All rights reserved.
//

#import "FJSNetworkImageView.h"
#import "UIImage+Network.h"
#import "UIView-Extensions.h"
#import "UIImage+Disk.h"

@implementation FJSNetworkImageView

@synthesize imageView;
@synthesize activityIndicator;


- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self]; 
	self.imageView = nil;
	self.activityIndicator = nil;
	
    [super dealloc];
}

- (id)initWithImageURL:(NSURL*)url frame:(CGRect)aFrame useCache:(BOOL)flag{
    if (self = [super initWithFrame:aFrame]) {
		
		self.backgroundColor = [UIColor lightGrayColor];
		self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activityIndicator.frame = rectContractedByValue(self.bounds,(self.bounds.size.width-activityIndicator.frame.size.width)/2) ;
		[self addSubview:activityIndicator];

		
		
		self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:imageView];
		
		[self loadImageAtURL:url useCache:flag];
		
		
    }
    return self;
}


- (void)loadImageAtURL:(NSURL*)url useCache:(BOOL)flag{
	if(url == nil)
		return;
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(iconFetchedFromURLWithNotification:) 
												 name:ImageFetchedFromURLNotification 
											   object:[url absoluteString]];
	
	
	if(flag){
		
		//self.imageView.image = [UIImage fetchImageWithURL:url checkCache:YES];
		
		self.imageView.image = [UIImage cachedImageWithURL:url];
		
		if(self.imageView.image==nil){
			
			FJSLog(@"Missed Network Cache for File Path: %@ \n -----------", [url absoluteString]);	
			
			self.imageView.image = [UIImage imageFromDiskWithURL:url];
			
			if(self.imageView.image == nil){
				
				[UIImage fetchImageWithURL:url useCache:YES];
			}
						
		}else{
			
			FJSLog(@"Hit Network Cache for File Path: %@ \n -----------", [url absoluteString]);	
			
		}
		
	}
	else{
		
		[UIImage fetchImageWithURL:url];
	} 

	if(self.imageView.image == nil)
		[activityIndicator startAnimating];
	else{
		[[NSNotificationCenter defaultCenter] removeObserver:self 
														name:ImageFetchedFromURLNotification 
													  object:[url absoluteString]];
		self.imageView.backgroundColor = [UIColor whiteColor];
		[activityIndicator stopAnimating];
	} 
	

		
}

- (void)iconFetchedFromURLWithNotification:(NSNotification*)note{
	
	[activityIndicator stopAnimating];

	NSString* urlString = [note object];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:ImageFetchedFromURLNotification 
												  object:urlString];
	
	UIImage* image = [[note userInfo] objectForKey:FJSImageKey];
	
	if(image != nil){
		
		self.imageView.image = image;	
		self.imageView.backgroundColor = [UIColor whiteColor];

	}else{
		
		NSLog(@"wtf no image! url:", urlString);
		
		if([[note userInfo] objectForKey:FJSImageFetchFailedKey] == nil){
			
			NSLog(@"image failed to fetch");

		}
		
		//TODO: display no image graphic?
	} 
		
}




@end
