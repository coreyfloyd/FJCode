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

@synthesize pageController;
@synthesize highlightedViewController;
@synthesize viewControllers;
@synthesize data;
@synthesize currentPage;
@synthesize lastPage;
@synthesize scrollView;


const CGFloat kScrollObjHeight	= 436;
const CGFloat kScrollObjWidth	= 320;
const NSUInteger kNumObjects	= 7;






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

- (void)sizeScrollViewToFitViews{
    
    if(!scrollView){
        
        FJSSelectableScrollView *aScrollView = [[FJSSelectableScrollView alloc] init];
        self.scrollView = aScrollView;
        
        CGPoint origin = CGPointMake(0,0);
        CGSize size = CGSizeMake(kScrollObjWidth, kScrollObjHeight);
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
    
    [scrollView setContentSize:CGSizeMake(([viewControllers count] * kScrollObjWidth), kScrollObjHeight)];
    
}

- (void)setViewFrames{
    
    for(FJSViewController *controller in viewControllers){
        
        int index = [viewControllers indexOfObject:controller];
                
		CGRect frame = self.view.frame;
        frame.origin.x = kScrollObjWidth * index;
        frame.origin.y = 0;
		frame.size.width= kScrollObjWidth;
        controller.view.frame = frame;
        [self.view addSubview:controller.view];
        
    }
}
        

#pragma mark -
#pragma mark UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        
    self.lastPage = currentPage;
    
    CGPoint pageOrigin = [(UIScrollView *)[self view] contentOffset];
    currentPage = pageOrigin.x/kScrollObjWidth;
        
}

#pragma mark -
#pragma mark FJSScrollViewController

- (id)initWithData:(NSArray*)dataArray{
    
    if(self = [self init]){
        
        self.data = dataArray;
        
    }    
    return self;
}



#pragma mark -
#pragma mark UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	        
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
        
        [self.view setFrame:[[UIScreen mainScreen] applicationFrame]];
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
        
        [self sizeScrollViewToFitViews];
        [self setViewFrames];
        
    }
}





- (void)dealloc {
    
    
    [scrollView release];    
    [pageController release];
    pageController = nil;    
	[viewControllers release];
	viewControllers = nil;
	[data release];
	data = nil;	
    [highlightedViewController release];
	highlightedViewController = nil;
	
	
	[super dealloc];
}




@end
