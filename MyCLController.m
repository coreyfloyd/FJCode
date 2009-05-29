#import "MyCLController.h"

@implementation MyCLController

@synthesize locationManager;
@synthesize delegate;

- (id) init {
	self = [super init];
	if (self != nil) {
		CLLocationManager *localManager = [[CLLocationManager alloc] init];
		localManager.delegate = self; // send loc updates to myself
        
        
        self.locationManager = localManager;
        [localManager release];
        
	}
	return self;
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
    locationManager.delegate=nil;
	[locationManager release];
    [super dealloc];
}

@end
