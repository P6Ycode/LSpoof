#import "VehicleDynamics.h"
#import <math.h>

@interface LSVehicleDynamics ()
@property (nonatomic, assign, readwrite) double currentSpeedMetersPerSecond;
@end

@implementation LSVehicleDynamics

@synthesize targetSpeedMetersPerSecond = _targetSpeedMetersPerSecond;
@synthesize currentSpeedMetersPerSecond = _currentSpeedMetersPerSecond;

- (instancetype)init {
    self = [super init];
    if (self) {
        _targetSpeedMetersPerSecond = 0.0;
        _currentSpeedMetersPerSecond = 0.0;
        _accelerationMetersPerSecondSquared = 2.5;
        _brakingMetersPerSecondSquared = 4.5;
    }
    return self;
}

- (double)targetSpeedMetersPerSecond {
    @synchronized (self) {
        return _targetSpeedMetersPerSecond;
    }
}

- (void)setTargetSpeedMetersPerSecond:(double)speed {
    @synchronized (self) {
        _targetSpeedMetersPerSecond = MAX(0.0, speed);
    }
}

- (double)currentSpeedMetersPerSecond {
    @synchronized (self) {
        return _currentSpeedMetersPerSecond;
    }
}

- (double)advanceWithDeltaTime:(NSTimeInterval)deltaTime {
    if (deltaTime <= 0.0) return self.currentSpeedMetersPerSecond;

    @synchronized (self) {
        double difference = _targetSpeedMetersPerSecond - _currentSpeedMetersPerSecond;
        double rate = difference >= 0.0
            ? MAX(0.0, self.accelerationMetersPerSecondSquared)
            : MAX(0.0, self.brakingMetersPerSecondSquared);
        double maximumChange = rate * deltaTime;

        if (fabs(difference) <= maximumChange) {
            _currentSpeedMetersPerSecond = _targetSpeedMetersPerSecond;
        } else {
            _currentSpeedMetersPerSecond += copysign(maximumChange, difference);
        }
        return _currentSpeedMetersPerSecond;
    }
}

- (void)stop {
    @synchronized (self) {
        _targetSpeedMetersPerSecond = 0.0;
        _currentSpeedMetersPerSecond = 0.0;
    }
}

@end
