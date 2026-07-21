#import "LSLocationState.h"

@implementation LSLocationState

+ (instancetype)shared {
    static LSLocationState *state;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        state = [[self alloc] init];
        state.coordinate = kCLLocationCoordinate2DInvalid;
        state.horizontalAccuracy = 5.0;
        state.timestamp = [NSDate date];
    });
    return state;
}

- (CLLocation *)currentLocation {
    if (!CLLocationCoordinate2DIsValid(self.coordinate)) {
        return nil;
    }

    return [[CLLocation alloc] initWithCoordinate:self.coordinate
                                         altitude:0
                               horizontalAccuracy:self.horizontalAccuracy
                                 verticalAccuracy:10
                                           course:self.heading
                                            speed:self.speed
                                        timestamp:self.timestamp ?: [NSDate date]];
}

- (void)updateCoordinate:(CLLocationCoordinate2D)coordinate
                heading:(CLLocationDirection)heading
                 speed:(CLLocationSpeed)speed {
    self.coordinate = coordinate;
    self.heading = heading;
    self.speed = speed;
    self.timestamp = [NSDate date];
    self.spoofingEnabled = YES;
}

@end
