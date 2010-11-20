

#import "FJFlipViewController.h"

@interface FJFlipViewCoontroller()

- (void)_addFront;
- (void)_removeFront;
- (void)_removeBack;
- (void)_addBack;

@end

@implementation FJFlipViewCoontroller

@synthesize frontController;
@synthesize backController;
@synthesize switchBar;
@synthesize viewSwitch;
@synthesize backingView;



- (void)dealloc {
    
    [backingView release];
    backingView = nil;
    [viewSwitch release];
    viewSwitch = nil;
    [frontController release];
    frontController = nil;
    [backController release];
    backController = nil;
    [switchBar release];
    switchBar = nil;
    
    [super dealloc];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    [self showFrontAnimated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    if([self.frontController.view superview] != nil){
        [self.frontController updateTable];
    }else{
        [self.backController reload];
    }
}

- (void)showFront{
    
    [self showFrontAnimated:YES];
}

- (void)showFrontAnimated:(BOOL)animated{
    
    self.viewSwitch.selectedSegmentIndex = 0;
    	
    if(animated){
        
        [UIView beginAnimations:@"Front" context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.backingView cache:YES];
        
    }    
    
    [self _removeBack];
    [self _addFront];
    
    if(animated){
        
        [UIView commitAnimations];
    }
    
    [self.frontController updateTable];
           
}

- (void)_addFront{
    
    [self.backingView addSubview:self.frontController.view];
    
}

- (void)_removeFront{
    
    [self.frontController.view removeFromSuperview];
    
}


- (void)showBack{
    
    [self showBackAnimated:YES];
       
}

- (void)showBackAnimated:(BOOL)animated{
    
    self.viewSwitch.selectedSegmentIndex = 1;
   
    if(animated){
        
        [UIView beginAnimations:@"Back" context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.backingView cache:YES];

    }
    
    [self _removeFront];
    [self _addBack];
    
    if(animated){
        
        [UIView commitAnimations];
    }
    
    [self.backController reload];
}

- (void)_addBack{
    
    [self.backingView addSubview:self.backController.view];

}

- (void)_removeBack{
    
    [self.backController.view removeFromSuperview];
}


- (IBAction)toggleViews:(id)sender{
    
    UISegmentedControl* c = (UISegmentedControl*)sender;
    
    if(c.selectedSegmentIndex == 0){
        
        [self showFront];

    }else{
        
        [self showBack];
    }
}


- (void)openDetailViewWithObject:(id )anObject animated:(BOOL)flag{
    
    //nonop
}    
    

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.switchBar = nil;
    self.viewSwitch = nil;
    self.backingView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
