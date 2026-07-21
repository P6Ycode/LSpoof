#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSLocationState : NSObject

@property (class, nonatomic, readonly) LSLocationState *shared;

@property (nonatomic, assign) BOOL spoofingEnabled;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CLLocationDirection heading;
@property (nonatomic, assign) CLLocationSpeed speed;
@property (nonatomic, assign) CLLocationAccuracy horizontalAccuracy;
@property (nonatomic, strong) NSDate *timestamp;

- (CLLocation *)currentLocation;
- (void)updateCoordinate:(CLLocationCoordinate2D)coordinate
                heading:(CLLocationDirection)heading
                 speed:(CLLocationSpeed)speed;

@end

NS_ASSUME_NONNULL_END
