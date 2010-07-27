//
//  MapViewController.m
//  SoleSearch
//
//  Created by Dan on 11/07/09.
//  Copyright 2009 Bawtree Software Contracting. All rights reserved.
//

#import "MapViewController.h"
#import "NSObject+Proxy.h"



void openGoogleMapsForDirectionsToLocation(CLLocation* startLocation, CLLocation* endLocation) {
	
	CLLocationCoordinate2D start = startLocation.coordinate;
	CLLocationCoordinate2D destination = endLocation.coordinate;        
	
	NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
									 start.latitude, start.longitude, destination.latitude, destination.longitude];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];		
}

@interface MapViewController()

- (void)refreshMapAnnotations;
- (void)centerOnAnnotations;
- (void)centerOnAnnotation:(id<MKAnnotation>)annotation;
- (void)centerOnCoordinate:(CLLocationCoordinate2D)coord;




@end


@implementation MapViewController
@synthesize annotations;
@synthesize mapView;
@synthesize currentCcoordinate;
@synthesize delegate;
@synthesize numberOfLocationsToCenterMap;


#pragma mark -
#pragma mark NSObject

- (void)dealloc {

    delegate = nil;
    [self removeObserver:self forKeyPath:@"annotations"];

    if (nil != self.mapView) {
		self.mapView.delegate = nil;	
	}
    [mapView release], mapView = nil;
    [annotations release], annotations = nil;
    
    [super dealloc];
}


- (id)initWithAnnotations:(NSArray*)someAnnotations{
    
    self = [super initWithNibName:@"MapView" bundle:nil];
    if (self != nil) {
        self.annotations = someAnnotations;
        self.numberOfLocationsToCenterMap = 100;
        [self addObserver:self forKeyPath:@"annotations" options:0 context:nil];
        
    }
    return self;
    
    
}


#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	
	if([keyPath isEqualToString:@"annotations"]){
		
		[self refreshMapAnnotations];
		
		return;
		
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


#pragma mark -
#pragma mark UIViewController

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;

    
}
- (void)viewWillAppear:(BOOL)animated{
    
    if([self.annotations count] == 1){
        
        self.title = [((id<MKAnnotation>)[self.annotations objectAtIndex:0]) title];
        
    }   
    
    
    if([self.annotations count] > 0){
        
        [self refreshMapAnnotations];
    }
    
}

    
#pragma mark -
#pragma mark MKMapView

- (void)refreshMapAnnotations{
		
	[self.mapView removeAnnotations:self.mapView.annotations];
	[self.mapView addAnnotations:self.annotations];	
    
    [self centerOnAnnotations];
		
}


#pragma mark -
#pragma mark annotation center


- (void)centerOnAnnotation:(id<MKAnnotation>)annotation{
    
    if(annotation == nil)
        return;
    
    CLLocationCoordinate2D coord = [annotation coordinate];
    
    [self centerOnCoordinate:coord];
    
}

- (void)centerOnCoordinate:(CLLocationCoordinate2D)coord{
	
	MKCoordinateRegion	locationsRegion;
	
	locationsRegion.center.latitude = coord.latitude;
	locationsRegion.center.longitude = coord.longitude;
	
	locationsRegion.span.latitudeDelta = 0.01f;
	locationsRegion.span.longitudeDelta = 0.01f;
	
	[self.mapView setRegion: locationsRegion animated: YES];
    
    
}

- (void)centerOnAnnotations
{
    if(numberOfLocationsToCenterMap < 1)
        numberOfLocationsToCenterMap == 1;
    
    if([[self annotations] count] == 1){
        
        [self centerOnAnnotation:[self.annotations objectAtIndex:0]];
        return;
    }
    
    
	CLLocationCoordinate2D	minCoord;
	CLLocationCoordinate2D	maxCoord;
    
    minCoord.latitude = 90.0f;
	minCoord.longitude = 180.0f;
    maxCoord.latitude = -90.0f;
	maxCoord.longitude = -180.0f;
	
    int i = 1;
    
	for (id<MKAnnotation> annotation in self.annotations)
	{
        
        if(i > numberOfLocationsToCenterMap)
            break;
        
        if(i == 1){
            
            minCoord.latitude = annotation.coordinate.latitude;
            minCoord.longitude = annotation.coordinate.longitude;
            maxCoord.latitude = annotation.coordinate.latitude;
            maxCoord.longitude = annotation.coordinate.longitude;

        }else{
            
            if (annotation.coordinate.latitude < minCoord.latitude)
            {
                minCoord.latitude = annotation.coordinate.latitude;
            }
            
            if (annotation.coordinate.longitude < minCoord.longitude)
            {
                minCoord.longitude = annotation.coordinate.longitude;
            }
            
            if (annotation.coordinate.latitude > maxCoord.latitude)
            {
                maxCoord.latitude = annotation.coordinate.latitude;
            }
            
            if (annotation.coordinate.longitude > maxCoord.longitude)
            {
                maxCoord.longitude = annotation.coordinate.longitude ;
            }
        }
        
        i++;
	}
	
	MKCoordinateRegion	locationsRegion;
	
	locationsRegion.center.latitude = (CLLocationDegrees)((maxCoord.latitude + minCoord.latitude) / 2.0f);
	locationsRegion.center.longitude = (CLLocationDegrees)((maxCoord.longitude + minCoord.longitude) / 2.0f);
	
	locationsRegion.span.latitudeDelta = (maxCoord.latitude - minCoord.latitude) + 0.001;
	locationsRegion.span.longitudeDelta = (maxCoord.longitude - minCoord.longitude) + 0.001f;
	
	
	[self.mapView setRegion: locationsRegion animated: YES];
}


#pragma mark -
#pragma mark Map View Delegate methods

- (MKAnnotationView*)mapView: (MKMapView*)mapView viewForAnnotation: (id <MKAnnotation>)annotation
{
	MKAnnotationView*	annotationView = nil;
	
    annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"locationAnnotation"];
    
    if (annotationView == nil)
    {
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"locationAnnotation"] autorelease];
    }
    else
    {
        annotationView.annotation = annotation;
    }
    
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    ((MKPinAnnotationView*)annotationView).animatesDrop = YES;
    
    
    if([self.annotations count] == 1){
        
        [[self.mapView proxyWithDelay:1] selectAnnotation:[self.annotations objectAtIndex:0] animated:YES];
    }
    
    return annotationView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    id <MKAnnotation> annotation = view.annotation;
    
    if([delegate respondsToSelector:@selector(mapViewController:selectedAnnotation:)])
        [self.delegate mapViewController:self selectedAnnotation:annotation];
    
    
    if([self.annotations count] == 1){
        
        CLLocation* storeLocation = [[CLLocation alloc] initWithLatitude: [annotation coordinate].latitude longitude: [annotation coordinate].longitude];
        
        CLLocation* startLocation = [self.mapView userLocation].location;
        
        openGoogleMapsForDirectionsToLocation(startLocation, storeLocation);
        
    }
}

@end
