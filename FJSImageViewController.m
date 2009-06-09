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



- (void)resizeToImageDimensions{
    
    CGSize imageSize = self.image.size;
    CGRect viewFrame = self.view.frame;
    viewFrame.size = imageSize;
    [self.view setFrame:viewFrame];
    
}

- (void)createImageView{
    
    UIImageView *localImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.view = localImage;
    [localImage release];
    
}

- (void)setData:(NSDictionary *)aData
{
    if (data != aData) {
        [aData retain];
        [data release];
        data = aData;
        
        self.image = [data objectForKey:@"image"];
    }
}

- (void)setImageWithImageNamed:(NSString *)anImageName{
        
    self.image = [UIImage imageNamed:anImageName];
}

- (void)setImage:(UIImage *)anImage{
    
    if (image != anImage) {
        [anImage retain];
        [image release];
        image = anImage;
        
        [(UIImageView*)self.view setImage:image];

    }
}

- (id)initWithImage:(UIImage *)anImage frame:(CGRect)frame {
    
    if(self = [self initWithImage:anImage]){
        
        [self.view setFrame:frame];
    }
    
    return self;
}

- (id)initWithImageNamed:(NSString *)anImageName {
	    
	if(self = [self initWithImage:[UIImage imageNamed:anImageName]]){
        
        
    }
    return self;
}


- (id)initWithImage:(UIImage *)anImage {
	
	if(self = [self init]){
		self.image = anImage;
        [(UIImageView*)self.view setImage:image];
    }
    return self;
}


- (id)init{
	
	if(self = [super init]){
    
        [self createImageView];
        
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
