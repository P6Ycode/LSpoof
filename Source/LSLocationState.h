#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSLocationState : NSObject
@property (class, nonatomic, readonly) LSLocationState *shared;
@property (nonatomic, readonly, getter=isSpoofingEnabled) BOOL spoofingEnabled;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CLLocationDirection heading;
@property (nonatomic, readonly) CLLocationSpeed speed;
@property (nonatomic, readonly) CLLocationDistance altitude;
@property (nonatomic, readonly) CLLocationAccuracy horizontalAccuracy;
@property (nonatomic, readonly) CLLocationAccuracy verticalAccuracy;
@property (nonatomic, strong, readonly) NSDate *timestamp;
- (nullable CLLocation *)currentLocation;
- (void)updateCoordinate:(CLLocationCoordinate2D)coordinate
                 heading:(CLLocationDirection)heading
                   speed:(CLLocationSpeed)speed
                altitude:(CLLocationDistance)altitude
      horizontalAccuracy:(CLLocationAccuracy)horizontalAccuracy
        verticalAccuracy:(CLLocationAccuracy)verticalAccuracy;
- (void)clear;
@end

NS_ASSUME_NONNULL_END
