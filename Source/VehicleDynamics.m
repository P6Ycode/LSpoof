#import "VehicleDynamics.h"

@interface LSVehicleDynamics ()
@property (nonatomic, assign) double currentSpeedMetersPerSecond;
@property (nonatomic, assign) BOOL isStopped;
@end

@implementation LSVehicleDynamics

- (instancetype)init {
    self = [super init];
    if (self) {
        _targetSpeedMetersPerSecond = 0.0;
        _currentSpeedMetersPerSecond = 0.0;
        _isStopped = YES;
    }
    return self;
}

- (void)setTargetSpeedMetersPerSecond:(double)speed {
    _targetSpeedMetersPerSecond = MAX(0.0, speed);
    if (_targetSpeedMetersPerSecond > 0.0) {
        _isStopped = NO;
    }
}

- (double)advanceWithDeltaTime:(double)deltaTime {
    if (deltaTime <= 0.0) {
        return self.currentSpeedMetersPerSecond;
    }

    double acceleration = 2.5;
    double difference = self.targetSpeedMetersPerSecond - self.currentSpeedMetersPerSecond;
    double change = acceleration * deltaTime;

    if (fabs(difference) <= change) {
        self.currentSpeedMetersPerSecond = self.targetSpeedMetersPerSecond;
    } else {
        self.currentSpeedMetersPerSecond += (difference > 0 ? change : -change);
    }

    return self.currentSpeedMetersPerSecond;
}

- (void)stop {
    self.targetSpeedMetersPerSecond = 0.0;
    self.currentSpeedMetersPerSecond = 0.0;
    self.isStopped = YES;
}

- (void)resume {
    self.isStopped = NO;
}

@end
