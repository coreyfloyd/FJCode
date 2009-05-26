//
//  ImageViewController.m
//  Skinny Jeans
//
//  Created by Corey Floyd on 3/15/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "FJSImageViewController.h"


@implementation FJSImageViewController

@synthesize image;

- (void)setImage:(UIImage *)anImage
{
    if (image != anImage) {
        [anImage retain];
        [image release];
        image = anImage;
        
		UIImageView *localImage = [[UIImageView alloc] initWithImage:image];
		[localImage setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
		self.view = localImage;
		[localImage release];
            
    }
}



- (id)initWithImage:(NSString *)url {
	
	if(self = [super init]){
	
		image = [UIImage imageNamed:url];
		UIImageView *localImage = [[UIImageView alloc] initWithImage:image];
		[localImage setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
		self.view = localImage;
		[localImage release];
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [image release];
    image = nil;
	[super dealloc];

}

@end
