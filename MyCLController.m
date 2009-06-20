#import "MyCLController.h"

@implementation MyCLController

@synthesize locationManager;
@synthesize delegate;

-(void)stopUpdating{
    
    [self.locationManager setDelegate:nil];
    NSLog(@"set location delegate to nil");
    [self.locationManager stopUpdatingLocation];
    NSLog(@"stop updates");
    //[self setLocationManager:nil];
   // NSLog(@"set location delegate to nil");


/*
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Running on Simulator");
#else    
    [self.locationManager setDelegate:nil];
    NSLog(@"Running on Device");
    [self setLocationManager:nil];
#endif
*/    
    
    
}
-(void)startUpdating{
    
    if(self.locationManager==nil){
        
        CLLocationManager *localManager = [[CLLocationManager alloc] init];
        self.locationManager = localManager;
        [localManager release];    
        NSLog(@"manager created");

    }
    
    [[self locationManager] setDelegate:self];
    NSLog(@"delegate set");

    [self.locationManager startUpdatingLocation];
    NSLog(@"manager updateing");

}


- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	[self.delegate locationUpdate:newLocation];
}


- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	[self.delegate locationError:error];
}

- (void)dealloc {
    [self.locationManager setDelegate:nil];
	self.locationManager = nil;
    [super dealloc];
}

@end
