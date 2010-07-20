//
//  MapViewController.h
//  SoleSearch
//
//  Created by Dan on 11/07/09.
//  Copyright 2009 Bawtree Software Contracting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapViewControllerDelegate;

@class Store;

@interface MapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;

    NSArray* annotations;
        
    CLLocationCoordinate2D currentCcoordinate;
    
    int numberOfLocationsToCenterMap; //default is 100
    
    id delegate;

}
@property(nonatomic,retain)IBOutlet MKMapView *mapView;
@property(nonatomic,retain)NSArray *annotations;
@property(nonatomic,assign)CLLocationCoordinate2D currentCcoordinate;
@property (nonatomic) int numberOfLocationsToCenterMap;
@property (nonatomic, assign) id delegate;

- (id)initWithAnnotations:(NSArray*)someAnnotations;

@end



@protocol MapViewControllerDelegate <NSObject>

@optional
- (void)mapViewController:(MapViewController*)controller selectedAnnotation:(id<MKAnnotation>)anAnnotation;

@end
