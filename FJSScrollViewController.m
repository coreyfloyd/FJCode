//
//  ImageSelectScrollViewController.m
//  Skinny Jeans
//
//  Created by Corey Floyd on 4/9/09.
//  Copyright 2009 AMDS. All rights reserved.
//

#import "FJSScrollViewController.h"
#import "FJSViewController.h"
#import "UIView-Extensions.h"
#import "FJSSelectableScrollView.h"

@interface FJSScrollViewController()

- (void)populateControllerData;
- (void)setViewFrames;


@end


@implementation FJSScrollViewController

static CGFloat kScrollObjHeight	= 416;
static CGFloat kScrollObjWidth	= 320;


@synthesize highlightedViewController;
@synthesize viewControllers;
@synthesize data;
@synthesize currentPage;
@synthesize lastPage;
@synthesize scrollView;
@synthesize pageSize;

#pragma mark -
#pragma mark selection and highlight 

- (void)highlightCurrentPage{
	
	//ImageViewController *controller = [[ImageViewController alloc] initWithImage:[highlightImages objectAtIndex:currentPage]];
	//CGRect myFrame = [[[self.imageViewControllers objectAtIndex:currentPage] imageView] frame];
	//[[controller imageView] setFrame:myFrame];
	
	//[self setHighlightImageViewController:controller];
	//[multiImageView addSubview:highlightImageViewController.imageView];
	//[controller release];
	
	[self.view setBackgroundColor:[UIColor yellowColor]];
    
	
}

- (void)dehighlightCurrentPage{
    
	[[self view] setBackgroundColor:[UIColor lightGrayColor]];
}


- (void)selectCurrentPage{
    
	[self.view changeColor:[UIColor lightGrayColor] withDelay:0.75 duration:0.25];
	[[[viewControllers objectAtIndex:currentPage] view] setAlpha:0.0];
	[[[viewControllers objectAtIndex:currentPage] view] fadeInWithDelay:3.0 duration:.75];
	
	//[highlightImageViewController.imageView removeFromSuperview];
	//[self setHighlightImageViewController:nil];
}



#pragma mark -
#pragma mark page controller management

- (void)createViewControllers{
    
    NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
    self.viewControllers = emptyArray;
    [emptyArray release];
    
}


- (void)populateControllerData{
        
    
    for(FJSViewController *controller in viewControllers){
        
        int index = [viewControllers indexOfObject:controller];
        
        [controller setData:[data objectAtIndex:index]];
    }
}

- (void)createScrollView{
    
    CGSize size;
    if(CGSizeEqualToSize(CGSizeZero, pageSize))
        size = CGSizeMake(kScrollObjWidth, kScrollObjHeight);
    else
        size = pageSize;
    
    if(!scrollView){
        
        UIScrollView *aScrollView = [[UIScrollView alloc] init];
        self.scrollView = aScrollView;
        
        CGPoint origin = CGPointMake(0,0);
        CGRect myFrame;
        myFrame.size = size;
        myFrame.origin = origin;
        
        scrollView.frame = myFrame;
        
        scrollView.scrollEnabled = YES;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = YES;
        scrollView.delaysContentTouches = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:scrollView];
    }
    
    [scrollView setContentSize:CGSizeMake(([viewControllers count] * size.width), size.height)];

}

- (void)setViewFrames{
    
    
    for(FJSViewController *controller in viewControllers){
        
        int index = [viewControllers indexOfObject:controller];
        
		CGRect frame = self.view.frame;
        
        CGSize size;
        if(CGSizeEqualToSize(CGSizeZero, pageSize))
            size = CGSizeMake(kScrollObjWidth, kScrollObjHeight);
        else
            size = pageSize;
        
        frame.origin.x = size.width * index;
        frame.origin.y = 0;
		frame.size.width= size.width;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
        
    }
}
        

#pragma mark -
#pragma mark UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
        
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender{
    
    CGSize size;
    if(CGSizeEqualToSize(CGSizeZero, pageSize))
        size = CGSizeMake(kScrollObjWidth, kScrollObjHeight);
    else
        size = pageSize;
    
    
    self.lastPage = currentPage;
    
    CGPoint pageOrigin = [self.scrollView contentOffset];
    
    currentPage = pageOrigin.x/size.width;
        
}
 

#pragma mark -
#pragma mark FJSScrollViewController


#pragma mark -
#pragma mark UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize size;
    if(CGSizeEqualToSize(CGSizeZero, pageSize))
        size = CGSizeMake(kScrollObjWidth, kScrollObjHeight);
    else
        size = pageSize;
    
    
    [self.view setFrame:CGRectMake(0, 0, size.width, size.height)];
    [self createViewControllers];
    [self createScrollView];
    [self setViewFrames];


	        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark -
#pragma mark NSObject

- (id)init{
    
    if(self = [super init]){
        
        [self addObserver:self forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"viewControllers" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    
    return self;
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if([keyPath isEqualToString:@"data"]) {
                
        [self populateControllerData];
        
    } else if([keyPath isEqualToString:@"viewControllers"]){
        
        [self setViewFrames];
        
    }
}





- (void)dealloc {
    
    
    [scrollView release];    
	[viewControllers release];
	viewControllers = nil;
	[data release];
	data = nil;	
    [highlightedViewController release];
	highlightedViewController = nil;
	
	
	[super dealloc];
}




@end
