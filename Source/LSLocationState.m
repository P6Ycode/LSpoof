#import "LSLocationState.h"

@interface LSLocationState ()
@property (nonatomic, readwrite, getter=isSpoofingEnabled) BOOL spoofingEnabled;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) CLLocationDirection heading;
@property (nonatomic, readwrite) CLLocationSpeed speed;
@property (nonatomic, readwrite) CLLocationDistance altitude;
@property (nonatomic, readwrite) CLLocationAccuracy horizontalAccuracy;
@property (nonatomic, readwrite) CLLocationAccuracy verticalAccuracy;
@property (nonatomic, strong, readwrite) NSDate *timestamp;
@end

@implementation LSLocationState

+ (instancetype)shared {
    static LSLocationState *state;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        state = [[self alloc] init];
        state.coordinate = kCLLocationCoordinate2DInvalid;
        state.horizontalAccuracy = 5.0;
        state.verticalAccuracy = 6.0;
        state.timestamp = [NSDate date];
    });
    return state;
}

- (nullable CLLocation *)currentLocation {
    @synchronized (self) {
        if (!self.spoofingEnabled || !CLLocationCoordinate2DIsValid(self.coordinate)) {
            return nil;
        }
        return [[CLLocation alloc] initWithCoordinate:self.coordinate
                                             altitude:self.altitude
                                   horizontalAccuracy:self.horizontalAccuracy
                                     verticalAccuracy:self.verticalAccuracy
                                               course:self.heading
                                                speed:self.speed
                                            timestamp:self.timestamp ?: [NSDate date]];
    }
}

- (void)updateCoordinate:(CLLocationCoordinate2D)coordinate
                 heading:(CLLocationDirection)heading
                   speed:(CLLocationSpeed)speed
                altitude:(CLLocationDistance)altitude
      horizontalAccuracy:(CLLocationAccuracy)horizontalAccuracy
        verticalAccuracy:(CLLocationAccuracy)verticalAccuracy {
    if (!CLLocationCoordinate2DIsValid(coordinate)) {
        [self clear];
        return;
    }
    @synchronized (self) {
        self.coordinate = coordinate;
        self.heading = heading;
        self.speed = MAX(0.0, speed);
        self.altitude = altitude;
        self.horizontalAccuracy = MAX(0.0, horizontalAccuracy);
        self.verticalAccuracy = MAX(0.0, verticalAccuracy);
        self.timestamp = [NSDate date];
        self.spoofingEnabled = YES;
    }
}

- (void)clear {
    @synchronized (self) {
        self.spoofingEnabled = NO;
        self.coordinate = kCLLocationCoordinate2DInvalid;
        self.heading = 0.0;
        self.speed = 0.0;
        self.altitude = 0.0;
        self.timestamp = [NSDate date];
    }
}
@end
