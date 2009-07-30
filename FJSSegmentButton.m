//
//  FJSSegmentButton.m
//  FJSCode
//
//  Created by Corey Floyd on 7/29/09.
//  Copyright 2009 Flying Jalapeno Software. All rights reserved.
//

#import "FJSSegmentButton.h"


@implementation FJSSegmentButton

@synthesize glossyBackground;
@synthesize tintColor;
@synthesize title;
@synthesize font;
@synthesize fontSize;
@synthesize fontColor;


- (void)dealloc {
    
    self.glossyBackground = nil;
    self.tintColor = nil;
    self.title = nil;
    self.font = nil;
    self.fontColor = nil;
    
    [super dealloc];
}


- (void)drawText{
    if(title==nil)
        return;
    if(font==nil)
        self.font = [UIFont boldSystemFontOfSize:12];
    if(fontSize==0)
        self.fontSize = 12;
    if(fontColor==nil)
        self.fontColor = [UIColor whiteColor];
   
    
    // Text bounds
	UIFont*		theFont	= [self.font fontWithSize:self.fontSize];
	CGSize		size	= [title sizeWithFont:font];
    
	// Rendering context
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	// Set colors
	CGContextSetFillColorWithColor(context, [fontColor CGColor]);
	CGContextSetStrokeColorWithColor(context, [fontColor CGColor]);
    
	// Render
	[title drawInRect:CGRectMake(0, 0, size.width, size.height) withFont:theFont];
    
    // Create image and release context
	UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    
    [glossyBackground setImage:image forSegmentAtIndex:0];
    
    
} 


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    
    if([keyPath isEqualToString:@"font"]){
        
        [self drawText];
        
    }else if([keyPath isEqualToString:@"fontSize"]){
        
        [self drawText];
        
    }else if([keyPath isEqualToString:@"fontColor"]){
        
        [self drawText];
        
    }else if([keyPath isEqualToString:@"title"]){
        
        [self drawText];
        
    }else if([keyPath isEqualToString:@"frame"]){
        
        [glossyBackground setFrame:self.frame];
        
    }else if([keyPath isEqualToString:@"tintColor"]){
        
        [glossyBackground setTintColor:tintColor];
        
    }else{
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)addTarget:(id)target action:(SEL)action{
    
    [glossyBackground addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    
}



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // Segmented control
        self.glossyBackground = [[[UISegmentedControl alloc] initWithFrame:self.bounds] autorelease];
        [glossyBackground insertSegmentWithTitle:@" " atIndex:0 animated:NO];
        glossyBackground.segmentedControlStyle = UISegmentedControlStyleBar;
        glossyBackground.momentary = YES;
        [self addSubview:glossyBackground];
        
        [self addObserver:self forKeyPath:@"font" options:0 context:@"fontChanged"];
        [self addObserver:self forKeyPath:@"fontColor" options:0 context:@"fontColorChanged"];
        [self addObserver:self forKeyPath:@"tintColor" options:0 context:@"tintCOlorChanged"];
        [self addObserver:self forKeyPath:@"title" options:0 context:@"textChanged"];
        [self addObserver:self forKeyPath:@"fontSize" options:0 context:@"fontSizeChanged"];
        [self addObserver:self forKeyPath:@"frame" options:0 context:@"frameChnaged"];
        
        
    }
    return self;
}

@end
