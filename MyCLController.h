



#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol MyCLControllerDelegate <NSObject>
@required
- (void)locationUpdate:(CLLocation *)location; 
- (void)locationError:(NSError *)error;
@end

@interface MyCLController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	id delegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id <MyCLControllerDelegate> delegate;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

@end