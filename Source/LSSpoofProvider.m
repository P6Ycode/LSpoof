#import "LSSpoofProvider.h"
#import "LSLocationState.h"
#import "PersistenceManager.h"
#import "RouteSimulator.h"

static CLLocationCoordinate2D LSProviderApplyFluctuation(CLLocationCoordinate2D coordinate,
                                                         CLLocationDistance radiusMeters) {
    if (radiusMeters <= 0.0 || !CLLocationCoordinate2DIsValid(coordinate)) return coordinate;
    double angle = ((double)arc4random_uniform(UINT32_MAX) / (double)UINT32_MAX) * 2.0 * M_PI;
    double distance = sqrt((double)arc4random_uniform(UINT32_MAX) / (double)UINT32_MAX) * radiusMeters;
    double latitude = coordinate.latitude + distance * cos(angle) / 111320.0;
    double cosLatitude = cos(coordinate.latitude * M_PI / 180.0);
    double longitude = coordinate.longitude;
    if (fabs(cosLatitude) > 1e-6) {
        longitude += distance * sin(angle) / (111320.0 * cosLatitude);
    }
    latitude = MIN(90.0, MAX(-90.0, latitude));
    while (longitude > 180.0) longitude -= 360.0;
    while (longitude < -180.0) longitude += 360.0;
    return CLLocationCoordinate2DMake(latitude, longitude);
}

@implementation LSSpoofProvider
+ (instancetype)shared {
    static LSSpoofProvider *provider;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ provider = [[self alloc] init]; });
    return provider;
}

- (nullable CLLocation *)currentLocation {
    PersistenceManager *store = [PersistenceManager shared];
    LSRouteSimulator *simulator = [LSRouteSimulator shared];
    CLLocationCoordinate2D coordinate = kCLLocationCoordinate2DInvalid;
    CLLocationDirection heading = store.heading;
    CLLocationSpeed speed = 0.0;
    CLLocationAccuracy accuracy = 6.0;

    if (simulator.isSimulating) {
        coordinate = simulator.currentCoordinate;
        heading = simulator.currentHeading;
        speed = simulator.isPaused ? 0.0 :
            [LSRouteSimulator speedMetersPerSecondForMode:simulator.transportMode
                                           customSpeedKmh:simulator.customSpeedKmh];
        accuracy = [LSRouteSimulator horizontalAccuracyForMode:simulator.transportMode];
    } else if ([store hasStoredCoordinate]) {
        coordinate = [store spoofCoordinate];
        if (store.fluctuationEnabled) {
            coordinate = LSProviderApplyFluctuation(coordinate, store.fluctuationRadius);
        }
    }

    if (!CLLocationCoordinate2DIsValid(coordinate)) {
        [[LSLocationState shared] clear];
        return nil;
    }

    [[LSLocationState shared] updateCoordinate:coordinate
                                      heading:heading
                                        speed:speed
                                     altitude:store.altitude
                           horizontalAccuracy:accuracy
                             verticalAccuracy:6.0];
    return [[LSLocationState shared] currentLocation];
}

- (void)clear {
    [[LSLocationState shared] clear];
}
@end
